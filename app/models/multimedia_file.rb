class MultimediaFile < ActiveRecord::Base
  self.abstract_class = true
  self.table_name_prefix = "multimedia_file_"

  belongs_to :owner, class_name: "User"
  belongs_to :album

  validates_presence_of :title, :owner, :album
  validate :album_owner


  protected
    def album_owner
      if owner.is_user? and not album.owner.eql?(owner)
        errors.add(:album_id)
      end
    end


end