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
    response = send(action)
    @method_response = response.is_a?(Hash) ? response : {}
    self.status = method_response[:status] || 200
    self.headers = build_headers
    self.content = build_response
    self
  end

  private

  def json?
    return @json unless @json.nil?

    @json = (
      !method_response[:json].nil? ||
      method_response.dig(:headers, 'Content-Type') == 'application/json'
    )
  end

  def build_headers
    content_type = json? ? 'application/json' : 'text/html'
    { 'Content-Type' => content_type }.merge(method_response[:headers] || {})
  end

  def build_response
    json? ? ([method_response[:json] || {}]) : render_template
  end

  def render_template
    unless File.exists? template_path
      raise ViewNotFoundError.new("View not found #{template_path}")
    end

    contents = File.read(template_path)
    [ERB.new(contents).result(binding)]
  end

  def template_path
    return @template_path if @template_path

    template = File.join(templates_directory, "#{action}.html.erb")
    @template_path = File.expand_path(File.join('../../views', template), __FILE__)
  end

  def templates_directory
    self.class.name.downcase.sub('controller', '')
  end
end
