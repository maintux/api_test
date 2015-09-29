class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /albums
  # GET /albums.json
  def index
    if params[:owner_id] and owner = User.find_by_id(params[:owner_id])
      @albums = owner.albums
    else
      @albums = Album.all
    end
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
    respond_to do |format|
      format.html { redirect_to album_multimedia_files_path(@album) }
      format.json { render :show }
    end
  end

  # GET /albums/new
  def new
    redirect_to albums_path and return if current_user.is_guest?

    @album = Album.new
  end

  # GET /albums/1/edit
  def edit
    redirect_to albums_path and return if current_user.is_guest?

  end

  # POST /albums
  # POST /albums.json
  def create
    redirect_to albums_path and return if current_user.is_guest?

    @album = Album.new(album_params)
    @album.owner = current_user

    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: 'Album was successfully created.' }
        format.json { render :show, status: :created, location: @album }
      else
        format.html { render :new }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /albums/1
  # PATCH/PUT /albums/1.json
  def update
    redirect_to albums_path and return if current_user.is_guest? or (current_user.is_user? and not current_user.eql?(@album.owner))

    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to @album, notice: 'Album was successfully updated.' }
        format.json { render :show, status: :ok, location: @album }
      else
        format.html { render :edit }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    redirect_to albums_path and return if current_user.is_guest? or (current_user.is_user? and not current_user.eql?(@album.owner))

    @album.destroy
    respond_to do |format|
      format.html { redirect_to albums_url, notice: 'Album was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def album_params
      params.require(:album).permit(:title, :description, :owner_id)
    end
end
