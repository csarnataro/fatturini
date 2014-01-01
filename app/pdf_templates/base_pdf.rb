# encoding: utf-8
class BasePdf < Prawn::Document

  def initialize(invoice, view)
    super(:page_size => "A4")
    # super()
    @invoice = invoice
    @view = view
    @address_x = 0

    helvetica_file = "font/Helvetica.dfont"

    font_families.update(
      "Arial" => {
        :bold        => "font/Arial Bold.ttf",
        :italic      => "font/Arial Italic.ttf",
        :bold_italic => "font/Arial Bold Italic.ttf",
        :normal      => "font/Arial.ttf"
      }
      # ,
      # "Helvetica" => {
      #   :normal      => { :file => helvetica_file, :font => "Helvetica" },
      #   :italic      => { :file => helvetica_file, :font => "Helvetica Oblique" },
      #   :bold        => { :file => helvetica_file, :font => "Helvetica Bold" },
      #   :bold_italic => { :file => helvetica_file, :font => "Helvetica Bold Italic" }
      # }      
    )

    font "Helvetica"

    info = { :Title => "Invoice",
             :Author => "Fatturini - Invoicing application",
             :Subject => "Invoice",
             :CreationDate => Time.now }

    build_pdf
  end

  def build_pdf  
    default_locale = I18n.locale

    unless @invoice.client.nil?
      country = @invoice.client.country
      puts "CCCCCCCCCCCCCC Country [#{country}] CCCCCCCCCCCCCC"
      if !country.blank?
        if country.strip.downcase[0,2] != 'it'
          I18n.locale = 'en'
        end
      end

    end

    begin
      #_build_pdf is defined in childs
      _build_pdf 
    rescue => e
      I18n.locale = default_locale
      Rails.logger.error e.message
      e.backtrace.each { |line| Rails.logger.error line }
    end
  end


  ##
  # in a line which contains one or more patterns of the form {en:VAT ID|it:P. IVA}, 
  # replace the pattern with the corresponding value
  # 
  # apply_locale_inline('{en:VAT ID|it:P. IVA} 1234', 'en') results in:
  # 'VAT ID 1234'
  #
  # while
  # apply_locale_inline('{en:VAT ID|it:P. IVA} 1234', 'it') results in:
  # 'P. IVA 1234'
  #
  # useful for user inserted strings
  #
  def enhanced_text_box(string, options={})
    defaults = {:at => [@address_x,  cursor]}
    options = defaults.merge(options)

    text_box apply_locale_inline(string), options

  end


  def current_user
    @view.current_user
  end

  def t(key)
    @view.t("invoices#{key}")
  end

  ##
  # in a line which contains one or more patterns of the form {en:VAT ID|it:P. IVA}, 
  # replace the pattern with the corresponding value
  # 
  # apply_locale_inline('{en:VAT ID|it:P. IVA} 1234', 'en') results in:
  # 'VAT ID 1234'
  #
  # while
  # apply_locale_inline('{en:VAT ID|it:P. IVA} 1234', 'it') results in:
  # 'P. IVA 1234'
  #
  # useful for user inserted strings
  #
  def apply_locale_inline(line)
    begin
      matches = line.to_enum(:scan, /{(.*?)}/).map { Regexp.last_match(1) }

      return line if matches.length == 0

      temp = line
      matches.each do |found| 
        temp = temp.gsub("{#{found}}", found.split(/\|/).find { |x| x[0,2] == I18n.locale.to_s}.split(/=>/)[1]||='')
      end
      temp
    rescue
      line
    end
  end  



end