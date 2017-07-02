require 'csv'

namespace :broadband_data do
  desc "Impord data from broadband file 'All-NBM-CAI-June-2014.csv'"
  task import: :environment do
    keepers = %w(anchorname address bldgnbr predir streetname streettype suffdir city state_code zip5 latitude longitude publicwifi url)

    puts '#######'
    puts 'Columns to save: ' + keepers.to_s
    puts '#######'
    puts 'This action will take some time to execute. Please wait ... '

    Broadband.without_auto_index do
      OpeningHour.destroy_all
      Broadband.destroy_all
    end

    Broadband.without_auto_index do
      puts 'start'
      csv_text = File.read(File.join(Rails.root, 'public', 'All-NBM-CAI-June-2014.csv'))
      csv = CSV.parse(csv_text, :headers => true, :col_sep => '|')
      puts 'Length: ' + csv.length.to_s
      hashes = []
      i = 0
      csv.each do |row|
        r_hash = row.to_hash.keep_if {|k,_| keepers.include? k }
        r_hash[:broadband_type_id] = 7
        hashes << r_hash
        i += 1
        if i == 100
          Broadband.create!(hashes)
          hashes = []
          i = 0
        end
      end
    end

    puts '#######'
    puts "Done. Please see table 'Broadband'"
    puts '#######'
  end

  desc "Impord TEST data from broadband file 'TEST-NBM-CAI-June-2014.csv' --- NOT TO USE IN PRODUCTION"
  task TESTimport: :environment do
    keepers = %w(anchorname address bldgnbr predir streetname streettype suffdir city state_code zip5 latitude longitude publicwifi url)

    puts '#######'
    puts 'TEST DATA - NOT TO USE IN PRODUCTION'
    puts 'Columns to save: ' + keepers.to_s
    puts '#######'
    puts 'This action will take some time to execute. Please wait ... '

    Broadband.without_auto_index do
      csv_text = File.read(File.join(Rails.root, 'public', 'TEST-NBM-CAI-June-2014.csv'))
      csv = CSV.parse(csv_text, :headers => true, :col_sep => '|')
      csv.each do |row|
        r_hash = row.to_hash.keep_if {|k,_| keepers.include? k }
        Broadband.create!(r_hash)
      end
    end

    puts '#######'
    puts "Done. Please see table 'Broadband'"
    puts '#######'
  end

  desc "Impord ONLY for IL state, data from broadband file 'IL-TEST-NBM-CAI-June-2014.csv' --- NOT TO USE IN PRODUCTION"
  task IL_TESTimport: :environment do
    keepers = %w(anchorname address bldgnbr predir streetname streettype suffdir city state_code zip5 latitude longitude publicwifi url)

    puts '#######'
    puts 'TEST DATA - NOT TO USE IN PRODUCTION'
    puts 'Columns to save: ' + keepers.to_s
    puts '#######'
    puts 'This action will take some time to execute. Please wait ... '

    Broadband.without_auto_index do
      csv_text = File.read(File.join(Rails.root, 'public', 'IL-TEST-NBM-CAI-June-2014.csv'))
      csv = CSV.parse(csv_text, :headers => true, :col_sep => '|')
      csv.each do |row|
        r_hash = row.to_hash.keep_if {|k,_| keepers.include? k }
        Broadband.create!(r_hash)
      end
    end

    puts '#######'
    puts "Done. Please see table 'Broadband'"
    puts '#######'
  end

  desc "Delete all records from Broadband table"
  task delete: :environment do
    Broadband.delete_all
    puts 'Data from Broadband table is deleted'
  end

end
