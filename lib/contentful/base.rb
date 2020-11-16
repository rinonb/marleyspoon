require 'net/http'

module Contentful
  class Base
    attr_reader :credentials, :endpoint

    def initialize
      @credentials = AppConfig.instance.contentful_credentials
      @endpoint = "https://cdn.contentful.com/spaces/#{credentials[:space_id]}/environments/#{credentials[:environment]}"
    end

    def entries(content_type)
      JSON.parse(
        get(
          path: 'entries',
          params: { content_type: content_type }
        )
      )
    end

    def entry(id)
      JSON.parse(
        get(
          path: "entries/#{id}"
        )
      )
    end

    private

    def get(path:, params: {})
      uri = build_request_uri(path, params)
      puts uri.to_s
      Net::HTTP.get(uri)
    end

    def build_request_uri(path, params = {})
      uri = URI("#{endpoint}/#{path}")
      uri.query =
        URI.encode_www_form(
          params.merge(
            access_token: credentials[:access_token]
          )
        )
      uri
    end
  end
end
