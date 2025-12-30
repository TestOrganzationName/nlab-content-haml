#!/usr/bin/env ruby

require 'html2haml'

# Monkey patch to handle complex XHTML doctypes
module Nokogiri
  module XML
    class DTD
      def to_haml(tabs, options)
        # Handle the complex XHTML doctype used in nLab content
        if external_id =~ /XHTML.*MathML.*SVG/
          # Use XHTML 1.1 doctype which is close enough
          "#{tabulate(tabs)}!!! XML\n#{tabulate(tabs)}!!! 1.1\n"
        else
          # Fallback to HTML5
          "#{tabulate(tabs)}!!!\n"
        end
      end
      
      private
      
      def tabulate(tabs)
        '  ' * tabs
      end
    end
  end
end

html_file = ARGV[0] || 'pages/6/6/6/6/16666/content.html'
html_content = File.read(html_file)

# Convert
haml_content = Html2haml::HTML.new(html_content, erb: false).render

# Output
puts haml_content
