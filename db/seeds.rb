# This file should contain all the record creation needed to seed the database with its default values.

#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
@admin = Admin.new({:email => 'admin@gmail.com', :password => 'admin', :password_confirmation => 'admin'})
@admin.save