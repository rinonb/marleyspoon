require 'net/http'

module Contentful
  # Handles calls to contentful cdn api via the contentful client gem
  class Base
    attr_reader :credentials, :client

    def initialize
      @credentials = AppConfig.instance.contentful_credentials
      @client = Contentful::Client.new(
        space: credentials[:space_id],
        environment: credentials[:environment],
        access_token: credentials[:access_token]
      )
    end

    def entries(content_type)
      puts 'requesting entries'
      client.entries(content_type: content_type)
    end

    def entry(id)
      puts 'requesting entry'
      client.entry(id)
    end
  end
end
