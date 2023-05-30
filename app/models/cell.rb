require "open-uri"

class Cell < ApplicationRecord
  belongs_to :image_result
  has_one_attached :photo
  validates_uniqueness_of :image_results, scope: [:col, :row]
after_create :verifi

  def danger?
    @danger = false
    if sexual_activity.to_f > 0.6 || sexual_display.to_f > 0.6 || erotica.to_f > 0.6 || drugs.to_f > 0.6 || gore.to_f > 0.6
      @danger = true
    end
    @danger
  end

  def verifi
    uri = URI('https://api.sightengine.com/1.0/check.json')
    params = {
      'url' => photo_url,
      'models' => 'nudity-2.0,wad,offensive,text-content,gore',
      'api_user' => ENV['API_USER'],
      'api_secret' => ENV['API_SECRET']
    }
    #####
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)
    output = JSON.parse(response.body)
    self.sexual_activity = output["nudity"]["sexual_activity"]
    self.sexual_display = output["nudity"]["sexual_display"]
    self.erotica = output["nudity"]["erotica"]
    self.drugs = output["drugs"]
    self.gore = output["gore"]["prob"]
    if output["text"]["profanity"][0]
      self.profanity_type = output["text"]["profanity"][0]["type"]
      self.profanity_match = output["text"]["profanity"][0]["match"]
      self.profanity_intensity = output["text"]["profanity"][0]["intensity"]
    end
    self.save
  end
end
