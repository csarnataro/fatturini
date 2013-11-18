require 'test_helper'

class InvoicesHelperTest < ActionView::TestCase

  test "get custom data I18n'd" do
  data = <<EOF
Christian Sarnataro
Via Antonio Sacchini, 1
20131 Milano {en: - Italy|it:}
Email: christian.sarnataro@gmail.com
{en:VAT ID|it:P. IVA}: {en:IT|it:}07661970067
{en:F. C.|it:C. F.}: SRNCRS71A21E507C    
EOF

  # puts data.inspect
    locale = 'en'
    res = data.to_enum(:scan, /{(.*?)}/).map { Regexp.last_match(1) }
    temp = data
    res.each do |found| 

      
      temp = temp.gsub("{#{found}}", found.split(/\|/).find { |x| x[0,2] == locale}.split(/:/)[1]||='')

      # data.gsub!(found, found.split(/\|/).find { |x| x[0,2] == locale}.split(/:/)[1])


    end
    puts
    puts temp


    # puts res.inspect
  end

end
