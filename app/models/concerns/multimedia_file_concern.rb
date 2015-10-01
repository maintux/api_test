module MultimediaFileConcern
  extend ActiveSupport::Concern

  MUTIMEDIA_FILE_CLASSES = ['Video', 'Image']

  included do
    MultimediaFileConcern::MUTIMEDIA_FILE_CLASSES.each do |k|
      base_options = {dependent: :destroy, class_name: "MultimediaFile::#{k}"}
      base_options.merge! self.instance_variable_get(:@extra_multimedia_files_options)||{}
      has_many k.downcase.pluralize.to_sym, base_options
    end

    def multimedia_files
      MultimediaFileConcern::MUTIMEDIA_FILE_CLASSES.map{|k| try(:send, k.downcase.pluralize)}.flatten
    end
  end
end