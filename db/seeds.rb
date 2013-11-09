# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
def create_new_user(username, password)
  u = User.new(
    :username => username,
    :password => password,
    :password_confirmation => password
    )

  u.set_session_token
  u.save!
  u
end

users = []
100.times do
  users << create_new_user(
    Faker::Name.name,
    SecureRandom.urlsafe_base64(16)
    )
end

users.each do |user|
  num = rand(5000)
  user.add_points(num)
end