require "torture/snippet"

module TortureHelper
  def snippet(component, section, hide:nil, file:nil)
    config = current_page.data["torture"]
    config = config[component]

    file ||= config[:default_file]
    root = config[:root] or raise "No root found for #{component}"

    Torture::Snippet.extract_from(file: file, root: root, marker: section, hide: hide, unindent: true)
  end
end
