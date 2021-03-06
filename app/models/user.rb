class User < ActiveRecord::Base
  ROLES = %w{ admin user guest }.freeze

  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  validates_presence_of :name, :surname, :role, :api_key

  validates_inclusion_of :role, in: ROLES
  validates_uniqueness_of :email

  attr_readonly :api_key, :email

  before_validation :generate_api_key, on: :create

  has_many :albums, foreign_key: :owner_id, dependent: :destroy
  has_many :videos, foreign_key: :owner_id, dependent: :destroy, class_name: "MultimediaFile::Video"

  @extra_multimedia_files_options = {foreign_key: :owner_id}
  include MultimediaFileConcern

  # Define helper methods for user role
  # This make three metods:
  # 1. admin?
  # 2. user?
  # 3. guest?
  ROLES.each do |_role|
    define_method "is_#{_role}?" do
      self.role.eql? _role
    end
  end

  def full_name
    "#{name} #{surname}"
  end

  private

    def generate_api_key
      begin
        self.api_key = SecureRandom.hex
      end while self.class.exists?(api_key: api_key)
    end


end
