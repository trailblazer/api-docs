# Nested unique header generation
require 'middleman-core/renderers/redcarpet'

class NestingUniqueHeadCounter < Middleman::Renderers::MiddlemanRedcarpetHTML
  def initialize
    super

    # @headers = {}
    # Fuck, this filter is instantiated per physical template, this sucks.
    @@headers_history = {} if !defined?(@@headers_history)
  end

  def header(text, header_level)
    @@headers_history[header_level]          = text # this is such bad programming.
    anchor = text.parameterize

    if header_level > 1
      # let's assume @headers is sorting 1,2,3,4.
      segments = @@headers_history.values[0..header_level-1]
      anchor   = segments.collect { |header| header.parameterize }.join("-")
    end

    # {1=>"activity",
    #  2=>"path",
    #  3=>"subprocess",
    #  4=>"composition-subprocess-automatic-wiring"}

    path       = @@headers_history

    breadcrumb = ""
    breadcrumb = %{<div><span>#{path[2]} /</span> #{path[3]}</div>} if header_level == 4
    breadcrumb = %{<div><span>#{path[2]}</span></div>}              if header_level == 3

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
