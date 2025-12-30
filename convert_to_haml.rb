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

# Counter for tracking progress
converted = 0
failed = 0
total = 0

# Find all content.html files
html_files = Dir.glob(File.join(pages_dir, '**/content.html'))
total = html_files.length

puts "Found #{total} HTML files to convert"

html_files.each_with_index do |html_file, index|
  begin
    # Read the HTML content
    html_content = File.read(html_file)
    
    # Create the output HAML file path (replace .html with .haml)
    haml_file = html_file.sub(/\.html$/, '.haml')
    
    # Convert HTML to HAML using Html2haml
    haml_content = Html2haml::HTML.new(html_content, erb: false).render
    
    # Write the HAML content to file
    File.write(haml_file, haml_content)
    
    converted += 1
    
    # Print progress every 100 files
    if (index + 1) % 100 == 0
      puts "Progress: #{index + 1}/#{total} files processed (#{converted} converted, #{failed} failed)"
    end
    
  rescue => e
    failed += 1
    puts "Failed to convert #{html_file}: #{e.message}"
  end
end

puts "\nConversion complete!"
puts "Total: #{total}"
puts "Converted: #{converted}"
puts "Failed: #{failed}"
