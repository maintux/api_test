class MultimediaFilesController < ApplicationController

  before_action :check_type, except: [:index]
  before_action :set_multimedia_file, only: [:show, :edit, :update, :destroy]
  before_action :set_albums, only: [:new, :edit, :update, :create]

  # GET /multimedia_files
  # GET /multimedia_files.json
  def index
    @album = Album.find params[:album_id] rescue nil
    owner = User.find params[:owner_id] rescue nil
    if @album
      hash = {album_id: @album.id}
      hash[:owner_id] = owner.id if owner
      _proc = proc {|k| "MultimediaFile::#{k}".constantize.where(hash).includes(:album)}
    else
      if owner
        _proc = proc {|k| "MultimediaFile::#{k}".constantize.where(owner_id: owner.id).includes(:album)}
      else
        _proc = proc {|k| "MultimediaFile::#{k}".constantize.includes(:album).all}
      end
    end
    @multimedia_files = MultimediaFileConcern::MUTIMEDIA_FILE_CLASSES.map(&_proc).flatten
  end

  # GET /multimedia_files/1
  # GET /multimedia_files/1.json
  def show
  end

  # GET /multimedia_files/new
  def new
    redirect_to multimedia_files_path and return if current_user.is_guest?
    @multimedia_file = MultimediaFile::Video.new
    if params[:album_id] and album = @albums.find_by_id(params[:album_id])
      @multimedia_file.album = album
    end
  end

  # GET /multimedia_files/1/edit
  def edit
    redirect_to multimedia_files_path and return if current_user.is_guest?
  end

  # POST /multimedia_files
  # POST /multimedia_files.json
  def create
    redirect_to multimedia_files_path and return if current_user.is_guest?

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
    redirect_to multimedia_files_path and return if current_user.is_guest? or (current_user.is_user? and not current_user.eql?(@multimedia_file.owner))

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
    redirect_to multimedia_files_path and return if current_user.is_guest? or (current_user.is_user? and not current_user.eql?(@multimedia_file.owner))

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
