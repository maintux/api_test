class Api::V1::MultimediaFilesController < Api::V1::BaseController

  before_action :check_type, except: [:index]
  before_action :set_multimedia_file, only: [:show, :update, :destroy]
  respond_to :json

  def index
    album = Album.find params[:album_id] rescue nil
    owner = User.find params[:owner_id] rescue nil
    if album
      hash = {album_id: album.id}
      hash[:owner_id] = owner.id if owner
      _proc = proc {|k| "MultimediaFile::#{k}".constantize.where(hash)}
    else
      if owner
        _proc = proc {|k| "MultimediaFile::#{k}".constantize.where(owner_id: owner.id)}
      else
        _proc = proc {|k| "MultimediaFile::#{k}".constantize.all}
      end
    end
    @multimedia_files = paginate MultimediaFileConcern::MUTIMEDIA_FILE_CLASSES.map(&_proc).flatten, per_page: 2
  end

  def show
  end

  def create
    @multimedia_file = @klass.new(multimedia_file_params)
    @multimedia_file.owner = current_user
    if @multimedia_file.save
      render :show, status: :created
    else
      render json: @multimedia_file.errors, status: :unprocessable_entity
    end
  end

  def update
    if @multimedia_file.update(multimedia_file_params)
      render :show, status: :ok
    else
      render json: @multimedia_file.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @multimedia_file.destroy
    head :no_content
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
        params.require(:multimedia_file_image).permit(:title, :description, :attachment, :album_id)
      end
    end
end
