# nLab Content HAML Conversion

This repository contains nLab content pages converted from HTML to HAML format using the [html2haml](https://github.com/haml/html2haml) tool.

## Conversion Summary

- **Total Files Converted**: 20,384
- **Success Rate**: 100%
- **Format**: HTML → HAML
- **Tool Used**: html2haml 2.3.0

## Structure

The repository maintains the same directory structure as the original:

```
pages/
├── 0/
├── 1/
├── 2/
...
└── 9/
    └── [hierarchical page storage]
        ├── content.html (original HTML)
        ├── content.haml (converted HAML)
        ├── name (page name)
        └── revision_id (revision identifier)
```

## Conversion Process

The conversion was performed using a Ruby script (`convert_to_haml.rb`) that:

1. **Handles Complex Doctypes**: The nLab content uses XHTML 1.1 with MathML and SVG doctypes, which required a custom monkey patch to the html2haml library.

2. **Preserves Structure**: All HTML structural elements, attributes, CSS, and JavaScript are faithfully converted to HAML format.

3. **Maintains Quality**: The conversion maintains semantic equivalence with the original HTML.

## Technical Details

### Custom Doctype Handling

The nLab pages use a complex doctype:
```html
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1 plus MathML 2.0 plus SVG 1.1//EN" "http://www.w3.org/2002/04/xhtml-math-svg/xhtml-math-svg-flat.dtd" >
```

This is converted to HAML as:
```haml
!!! XML
!!! 1.1
```

### Running the Conversion

To run the conversion script:

```bash
# Install the required gem
gem install html2haml

# Run the conversion
ruby convert_to_haml.rb
```

## Files

- `convert_to_haml.rb` - Main conversion script for batch processing
- `test_conversion.rb` - Script for testing individual file conversions
- `test_sample_conversion.rb` - Script for testing on a sample of files

## HAML Format Benefits

HAML (HTML Abstraction Markup Language) offers several advantages:

- **Cleaner Syntax**: More readable and maintainable than HTML
- **Less Verbose**: Reduced code volume compared to HTML
- **Automatic Closing**: No need for closing tags
- **Better Structure**: Indentation-based hierarchy

## License

Content follows the original nLab licensing terms.
