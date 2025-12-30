#!/usr/bin/env ruby

require 'fileutils'
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

# Directory containing the HTML files
pages_dir = File.join(__dir__, 'pages')

# Get a sample of files
sample_files = Dir.glob(File.join(pages_dir, '**/content.html')).first(5)

puts "Testing conversion on #{sample_files.length} files..."

sample_files.each_with_index do |html_file, index|
  begin
    html_content = File.read(html_file)
    haml_content = Html2haml::HTML.new(html_content, erb: false).render
    
    haml_file = html_file.sub(/\.html$/, '.haml')
    File.write(haml_file, haml_content)
    
    puts "✓ [#{index + 1}/#{sample_files.length}] Converted: #{html_file}"
    
  rescue => e
    puts "✗ [#{index + 1}/#{sample_files.length}] Failed: #{html_file}"
    puts "  Error: #{e.message}"
  end
end

puts "\nTest conversion complete!"
