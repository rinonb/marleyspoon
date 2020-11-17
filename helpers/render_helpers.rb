# Rendering helpers
module RenderHelpers
  # Parses a string from markdown to html
  # @param [String] text
  # @return [String] parsed text
  def markdown_render(text)
    return nil unless text

    markdown.render(text)
  end

  private

  def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end
end
