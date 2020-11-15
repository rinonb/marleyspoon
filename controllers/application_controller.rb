# All other controllers must extend this class
class ApplicationController
  class << self
    def call(action)
      new(action).call
    end
  end

  attr_reader :action, :method_response
  attr_accessor :status, :headers, :content

  def initialize(action)
    @action = action
  end

  def call
    puts action
    @method_response = send(action)
    self.status = method_response[:status] || 200
    self.headers = build_headers
    self.content = build_response
    self
  end

  private

  def json?
    return @json unless @json.nil?

    @json = method_response.dig(:headers, 'Content-Type') == 'application/json'
  end

  def build_headers
    content_type = json? ? 'application/json' : 'text/html'
    { 'Content-Type' => content_type }.merge(method_response[:headers] || {})
  end

  def build_response
    json? ? ([method_response[:json] || {}]) : render_template
  end

  def render_template
    ['wow']
  end
end
