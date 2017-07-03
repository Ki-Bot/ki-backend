# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Broadband.algolia_reindex!

# puts Broadband.find(347724).inspect
# AdminUser.destroy_all
# puts AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')


Broadband.without_auto_index do
  Broadband.destroy_all
  BroadbandType.destroy_all
  BroadbandType.connection.execute('ALTER SEQUENCE broadband_type_id_seq RESTART WITH 1')
  BroadbandType.create!(name: 'City and Village halls')
  BroadbandType.create!(name: 'Park Districts')
  BroadbandType.create!(name: 'Hospitals')
  BroadbandType.create!(name: 'Police Departments')
  BroadbandType.create!(name: 'Fire Departments')
  BroadbandType.create!(name: 'Schools')
  BroadbandType.create!(name: 'Other')

  array = Array(0..370)
  idx = 0
  array.each do |i|
    File.open('public/broadbands/testt_' + i.to_s + '.txt', 'r') do |f|
      f.each_line do |line|
        idx += 1
        puts 'idx: ' + idx.to_s
        hash = JSON.parse(line).except('id')
        if hash[:broadband_type_id].blank?
          hash[:broadband_type_id] = 7
        end
        Broadband.create!(hash)
      end
    end
  end
end




# keywords = {
#     'fire'=> 5, 'rescue' => 5, 'vfd'=> 5, 'battalion' => 5,
#
#     'park'=> 2, 'forest' => 2, 'mountain' => 2, 'boulevard' => 2,
#
#     'police' => 4, 'sheriff' => 4, 'task force' => 4, 'law enforcement' => 4, 'patrol' => 4, 'narcotic' => 4, 'public safety' => 4, 'criminal' => 4, 'investigation' => 4, 'force' => 4, 'crime' => 4, 'violent' => 4, 'jail' => 4,
#
#     'hospital'=> 3, 'medical'=> 3, 'medicine'=> 3, 'clinic'=> 3, 'health'=> 3, 'care'=> 3, 'biolog'=> 3, 'laborator'=> 3, 'nurs'=> 3, 'infirmary'=> 3, 'psychiatry' => 3, 'pharmacy' => 3, 'therapy' => 3, 'heart' => 3, 'vascular' => 3,
#
#     'school'=> 6, 'library'=> 6, 'libraries'=> 6, 'college'=> 6, 'university'=> 6, 'learn' => 6, 'hs' => 6, 'elementary' => 6, 'es' => 6, 'is' => 6, 'ms' => 6, 'book' => 6, 'education' => 6, 'high' => 6, 'middle' => 6, 'studies' => 6, 'study' => 6, 'universit' => 6, 'universid' => 6, 'campus' => 6, 'academy' => 6, 'academic' => 6,
#
#     'hall'=> 1, 'courthouse'=> 1, 'couthouse'=> 1, 'county commision' => 1, 'museum'=> 1, 'heritage' => 1, 'technology center'=>1, 'sports academy' => 1, 'technology' => 1, 'county' => 1, 'center for technology' => 1, 'government' => 1, 'village' => 1, 'city' => 1, 'airport' => 1, 'housing authority' => 1, 'chamber of commerce' => 1, 'community association' => 1, 'court' => 1, 'council' => 1, 'association' => 1, 'community' => 1, 'tribe' => 1, 'municipal' => 1, 'guidance center' => 1, 'state' => 1, 'economic security' => 1
# }
#
# all = Broadband.where('broadband_type_id IS NULL').to_a
# total_count = all.count
# i = 0
# Parallel.each(all, in_threads: 4) { |broadband|
#   found = false
#   name = broadband.anchorname.downcase
#   keywords.each do |key, value|
#     if name.include?(key)
#       found = true
#       broadband.broadband_type_id = value
#       broadband.save!
#       break
#     end
#   end
#   i += 1
#   Rails.logger.info 'Processed item ' + i.to_s + ' from ' + total_count.to_s + '. ' + (found ? 'FOUND.' : '')
# }
# Rails.logger.info 'finished'
