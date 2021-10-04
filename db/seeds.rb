# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10.times{|i| User.create(first_name: "yuu#{i}", last_name: "yama#{i}", nickname: "yamayuu#{i}", email: "yyuu#{i}@gmail.com", password: "123456#{i}")}