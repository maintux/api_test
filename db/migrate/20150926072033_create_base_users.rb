class CreateBaseUsers < ActiveRecord::Migration
  def up
    admin = {
      name: Faker::Name.first_name,
      surname: Faker::Name.last_name,
      email: 'admin@example.com',
      password: 'passw0rd',
      password_confirmation: 'passw0rd',
      role: 'admin'
    }
    User.create! admin
    user = {
      name: Faker::Name.first_name,
      surname: Faker::Name.last_name,
      email: 'user@example.com',
      password: 'passw0rd',
      password_confirmation: 'passw0rd',
      role: 'user'
    }
    User.create! user
    guest = {
      name: Faker::Name.first_name,
      surname: Faker::Name.last_name,
      email: 'guest@example.com',
      password: 'passw0rd',
      password_confirmation: 'passw0rd',
      role: 'guest'
    }
    User.create! guest
  end

  def down
    User.destroy_all
  end
end
