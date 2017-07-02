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

# City and Village halls
# Park Districts
# Hospitals
# Police Departments
# Fire Departments
# Schools
# Other

keywords = {
    police: 4, sheriff: 4,

    hospital: 3, medical: 3, medicine: 3, clinic: 3, health: 3, care: 3, biolog: 3, laborator: 3, nurs: 3, infirmary: 3,

    school: 6, library: 6, libraries: 6, college: 6, university: 6,

    fire: 5, rescue: 5, vfd: 5,

    park: 2,

    hall: 1, courthouse: 1, couthouse: 1, :'county commision' => 1, museum: 1
}

total_count = Broadband.count
i = 0
Broadband.all.each do |broadband|
  found = false
  name = broadband.anchorname.downcase
  keywords.each do |key, value|
    if name.include?(key)
      found = true
      broadband.broadband_type_id = value
      broadband.save!
      break
    end
  end
  i += 1
  puts 'Processed item ' + i + ' from ' + total_count + '. ' + (found ? 'FOUND.' : '')
end
