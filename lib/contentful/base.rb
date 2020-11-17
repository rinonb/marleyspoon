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

    # Returns an array of entries from contentful
    # @param [String] content_type
    # @return [Array<Contentful::Entry>]
    def entries(content_type)
      client.entries(content_type: content_type)
    end

    # Fetches and returns a single entry from contentful
    # @param [String] id
    # @return [Contentful::Entry]
    def entry(id)
      client.entry(id)
    end
  end
end
