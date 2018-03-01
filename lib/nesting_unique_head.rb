# Nested unique header generation
require 'middleman-core/renderers/redcarpet'

class NestingUniqueHeadCounter < Middleman::Renderers::MiddlemanRedcarpetHTML
  def initialize
    super
    @@headers_history = {} if !defined?(@@headers_history)
  end

  def header(text, header_level)
    anchor = text.parameterize
    @@headers_history[header_level] = text.parameterize

    # pp @@headers_history
    if header_level > 1
      # always have two levels, only: operation-call, instead of operation-api-call

      anchor = [ @@headers_history[1], anchor ].join("-")
      # for i in (header_level - 1).downto(1)
        # anchor.prepend("#{@@headers_history[0]}-") if @@headers_history.key?(0)
      # end
    end

    # pp @@headers_history
    # {1=>"activity",
    #  2=>"path",
    #  3=>"subprocess",
    #  4=>"composition-subprocess-automatic-wiring"}

    path = @@headers_history.values

    breadcrumb = ""
    breadcrumb = %{<div><span>#{path[1]} /</span> #{path[2]}</div>} if header_level == 4
    breadcrumb = %{<div><span>#{path[1]}</span></div>} if header_level == 3



    return %{<h#{header_level} id="#{anchor}">
  #{breadcrumb}
  #{text}
</h#{header_level}>}
  end

  def triple_emphasis(text)
    css_class, text = text[0] == "!" ? ["warning", text[1..-1]] : ["notice", text]
    %{<aside class="#{css_class}">#{text}</aside>}
  end
end
