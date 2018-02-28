# Nested unique header generation
require 'middleman-core/renderers/redcarpet'

class NestingUniqueHeadCounter < Middleman::Renderers::MiddlemanRedcarpetHTML
  def initialize
    super
    @@headers_history = {} if !defined?(@@headers_history)
  end

  def header(text, header_level)
    friendly_text = text.parameterize
    @@headers_history[header_level] = text.parameterize

    # pp @@headers_history
    if header_level > 1
      # always have two levels, only: operation-call, instead of operation-api-call

      friendly_text = [ @@headers_history[1], friendly_text ].join("-")
      # for i in (header_level - 1).downto(1)
        # friendly_text.prepend("#{@@headers_history[0]}-") if @@headers_history.key?(0)
      # end
    end

    return "<h#{header_level} id='#{friendly_text}'>#{text}</h#{header_level}>"
  end

  def triple_emphasis(text)
    css_class = text[0] == "!" ? "warning" : "notice"
    %{<aside class="#{css_class}">#{text}</aside>}
  end
end
