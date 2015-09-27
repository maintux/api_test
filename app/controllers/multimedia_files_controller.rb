class MultimediaFilesController < ApplicationController

  before_action :check_type, except: [:index]
  before_action :set_multimedia_file, only: [:show, :edit, :update, :destroy]
  before_action :set_albums, only: [:new, :edit, :update, :create]

  # GET /multimedia_files
  # GET /multimedia_files.json
  def index
    @album = Album.find params[:album_id] rescue nil
    if @album
      _proc = proc {|k| "MultimediaFile::#{k}".constantize.where(album_id: params[:album_id]).includes(:album)}
    else
      _proc = proc {|k| "MultimediaFile::#{k}".constantize.includes(:album).all}
    end
    @multimedia_files = MultimediaFileConcern::MUTIMEDIA_FILE_CLASSES.map(&_proc).flatten
  end

  # GET /multimedia_files/1
  # GET /multimedia_files/1.json
  def show
  end

  # GET /multimedia_files/new
  def new
    @multimedia_file = MultimediaFile::Video.new
    if params[:album_id] and album = @albums.find_by_id(params[:album_id])
      @multimedia_file.album = album
    end
  end

  # GET /multimedia_files/1/edit
  def edit
  end

  # POST /multimedia_files
  # POST /multimedia_files.json
  def create
    @multimedia_file = @klass.new(multimedia_file_params)
    @multimedia_file.owner = current_user

    respond_to do |format|
      if @multimedia_file.save
        format.html { redirect_to album_path(@multimedia_file.album), notice: 'MultimediaFile was successfully created.' }
        format.json { render :show, status: :created }
      else
        format.html { render :new }
        format.json { render json: @multimedia_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /multimedia_files/1
  # PATCH/PUT /multimedia_files/1.json
  def update
    respond_to do |format|
      if @multimedia_file.update(multimedia_file_params)
        format.html { redirect_to album_path(@multimedia_file.album), notice: 'MultimediaFile was successfully updated.' }
        format.json { render :show, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @multimedia_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /multimedia_files/1
  # DELETE /multimedia_files/1.json
  def destroy
    @multimedia_file.destroy
    respond_to do |format|
      format.html { redirect_to multimedia_file_videos_url, notice: 'MultimediaFile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def check_type
      request_error and return if params[:type].nil?
      @klass = "multimedia_file/#{params[:type]}".classify.constantize rescue nil
      request_error and return if @klass.nil?
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_multimedia_file
      @multimedia_file = @klass.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def multimedia_file_params
      if params[:type].eql?"video"
        params.require(:multimedia_file_video).permit(:title, :description, :provider, :url, :album_id)
      else
        {}
      end
    end

    def set_albums
      if current_user.is_admin?
        @albums = Album.all
      elsif current_user.is_user?
        @albums = current_user.albums
      end
    end
end
