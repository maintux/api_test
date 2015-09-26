class Api::V1::AlbumsController < Api::V1::BaseController

  before_action :set_album, only: [:show, :update, :destroy]
  respond_to :json

  def index
    @albums = Album.all
  end

  def show
  end

  def create
    @album = Album.new(album_params)
    @album.owner = current_user

    if @album.save
      render :show, status: :ok, location: @album
    else
      render json: @album.errors, status: :unprocessable_entity
    end
  end

  def update
    if @album.update(album_params)
      render :show, status: :ok, location: @album
    else
      render json: @album.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @album.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params[:id])
      @resource = @album
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def album_params
      params.require(:album).permit(:title, :description)
    end
end
