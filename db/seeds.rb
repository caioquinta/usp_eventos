# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(name: 'USP EVENTOS', email: 'caiodaquinta@gmail.com', password: 'testando')

# filter tags
ActsAsTaggableOn::Tag.create(name: 'Exatas')
ActsAsTaggableOn::Tag.create(name: 'Humanas')
ActsAsTaggableOn::Tag.create(name: 'Biológicas')
ActsAsTaggableOn::Tag.create(name: 'Artes')
ActsAsTaggableOn::Tag.create(name: 'Cinema')
ActsAsTaggableOn::Tag.create(name: 'Curso')
ActsAsTaggableOn::Tag.create(name: 'Aula')
ActsAsTaggableOn::Tag.create(name: 'Ciência')
ActsAsTaggableOn::Tag.create(name: 'Festa')
ActsAsTaggableOn::Tag.create(name: 'Teatro')
ActsAsTaggableOn::Tag.create(name: 'Esportes')
ActsAsTaggableOn::Tag.create(name: 'Palestra')
