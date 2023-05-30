class VerifiCellsJob < ApplicationJob
  queue_as :default

  def perform(result)
    # Do something later
    verifi(result)
  end
# Not using this currently #
  def verifi(result)
    result.cells.each do |cell|
      ######
      uri = URI('https://api.sightengine.com/1.0/check.json')
      params = {
        'url' => cell.photo_url,
        'models' => 'nudity-2.0,wad,offensive,text-content,gore',
        'api_user' => ENV['API_USER'],
        'api_secret' => ENV['API_SECRET']
      }
      #####
      uri.query = URI.encode_www_form(params)
      response = Net::HTTP.get_response(uri)
      output = JSON.parse(response.body)
      cell.sexual_activity = output["nudity"]["sexual_activity"]
      cell.sexual_display = output["nudity"]["sexual_display"]
      cell.erotica = output["nudity"]["erotica"]
      cell.drugs = output["drugs"]
      cell.gore = output["gore"]["prob"]
      if output["text"]["profanity"][0]
        cell.profanity_type = output["text"]["profanity"][0]["type"]
        cell.profanity_match = output["text"]["profanity"][0]["match"]
        cell.profanity_intensity = output["text"]["profanity"][0]["intensity"]
      end
      cell.save
    end
  end
end
