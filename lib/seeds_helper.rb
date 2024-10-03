# frozen_string_literal: true

require 'net/http'

module SeedsHelper
  class << self
    include Seeds::Tests
    include Seeds::CustomQuestions

    def fetch_gist_content(gist_id)
      uri = URI("https://api.github.com/gists/#{gist_id}")

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri)
      request['Accept'] = 'application/vnd.github.v3+json'

      response = http.request(request)

      raise "Failed to fetch gist: #{response.code} #{response.message}" unless response.is_a?(Net::HTTPSuccess)

      gist_data = JSON.parse(response.body)
      file_content = gist_data['files'].values.first['content']
      JSON.parse(file_content)
    end
  end
end
