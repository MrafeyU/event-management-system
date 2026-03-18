# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Seed users
User.destroy_all


puts "Creating users..."

admin = User.find_or_create_by!(email: "admin@gmail.com") do |u|
	u.password = "12341234"
	u.type = "admin"
	u.name = "admin"
end

organizer = User.find_or_create_by!(email: "organizer@gmail.com") do |u|
	u.password = "12341234"
	u.type = "organizer"
	u.name = "organizer"
end

attendee = User.find_or_create_by!(email: "attendee@gmail.com") do |u|
	u.password = "12341234"
	u.type = "attendee"
	u.name = "attendee"
end
