class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  after_action :allow_iframe, only: :social_login

  def test_facebook
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['twitter_app_id']
      config.consumer_secret     = ENV['twitter_secret']
    end
    res = client.verify_credentials
    return render json: true
    return render json: Algolia.list_indexes
    index = Algolia::Index.new('Broadband')
    settings = index.get_settings
    return render json: settings.to_json
    # Thread.start { parse_broadband_types }
    # Thread.start { Broadband.reindex }
    # count = Broadband.where('broadband_type_id IS NULL').count
    # return render json: count
    render 'test_facebook'
  end

  def social_login
    render 'social_login'
  end

  private

  def parse_nonprofits
    Broadband.where('broadband_type_id = ?', 7).destroy_all
    new_broadbands = []
    i = 0
    File.open('public/nonprofits/data-download-pub78.txt', 'r') do |f|
      f.each_line do |line|
        next if line.length <= 2
        i += 1
        puts i.to_s
        parts = line.split('|')
        broadband = Broadband.new
        broadband.anchorname = parts[1]
        broadband.city = parts[2]
        broadband.state_code = parts[3]
        broadband.broadband_type_id = 7
        new_broadbands << broadband
        if (i % 1000).zero?
          Broadband.import new_broadbands
          new_broadbands.clear
        end
      end
    end
  end

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

  def parse_broadband_types
    keywords = {
        'fire'=> 5, 'rescue' => 5, 'vfd'=> 5, 'battalion' => 5,

        'park'=> 2, 'forest' => 2, 'mountain' => 2, 'boulevard' => 2,

        'police' => 4, 'sheriff' => 4, 'task force' => 4, 'law enforcement' => 4, 'patrol' => 4, 'narcotic' => 4, 'public safety' => 4, 'criminal' => 4, 'investigation' => 4, 'force' => 4, 'crime' => 4, 'violent' => 4, 'jail' => 4,

        'hospital'=> 3, 'medical'=> 3, 'medicine'=> 3, 'clinic'=> 3, 'health'=> 3, 'care'=> 3, 'biolog'=> 3, 'laborator'=> 3, 'nurs'=> 3, 'infirmary'=> 3, 'psychiatry' => 3, 'pharmacy' => 3, 'therapy' => 3, 'heart' => 3, 'vascular' => 3,

        'school'=> 6, 'library'=> 6, 'libraries'=> 6, 'college'=> 6, 'university'=> 6, 'learn' => 6, 'hs' => 6, 'elementary' => 6, 'es' => 6, 'is' => 6, 'ms' => 6, 'book' => 6, 'education' => 6, 'high' => 6, 'middle' => 6, 'studies' => 6, 'study' => 6, 'universit' => 6, 'universid' => 6, 'campus' => 6, 'academy' => 6, 'academic' => 6,

        'hall'=> 1, 'courthouse'=> 1, 'couthouse'=> 1, 'county commision' => 1, 'museum'=> 1, 'heritage' => 1, 'technology center'=>1, 'sports academy' => 1, 'technology' => 1, 'county' => 1, 'center for technology' => 1, 'government' => 1, 'village' => 1, 'city' => 1, 'airport' => 1, 'housing authority' => 1, 'chamber of commerce' => 1, 'community association' => 1, 'court' => 1, 'council' => 1, 'association' => 1, 'community' => 1, 'tribe' => 1, 'municipal' => 1, 'guidance center' => 1, 'state' => 1, 'economic security' => 1
    }

    all = Broadband.where('broadband_type_id IS NULL').to_a
    total_count = all.count
    i = 0
    Parallel.each(all, in_threads: 4) { |broadband|
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
      logger.info 'Processed item ' + i.to_s + ' from ' + total_count.to_s + '. ' + (found ? 'FOUND.' : '')
    }
    logger.info 'finished'
  end

end
