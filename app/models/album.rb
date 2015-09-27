class Album < ActiveRecord::Base

  validates_presence_of :title, :owner_id

  belongs_to :owner, class_name: "User"
  include MultimediaFileConcern

  attr_readonly :owner_id

end
