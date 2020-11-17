# Rendering helpers
module RenderHelpers
  def markdown_render(text)
    return nil unless text

    markdown.render(text)
  end

  private

  def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end
end
