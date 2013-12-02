class Invoice < ActiveRecord::Base
  include SessionsHelper
  include PdfManager
  
  self.per_page = 10

  belongs_to :client
  has_many :items, -> { order("id") }, :dependent => :destroy
  belongs_to :footer
  accepts_nested_attributes_for :items, :allow_destroy => true
  validates_uniqueness_of :number
  after_initialize :initialize_suggested_values
  # validates :status, :inclusion => { :in => ['draft', 'sent', 'paid'] }


  validate :invoice_number_format
  validates :number, :client, :presence => true
 

  def Invoice.fake 
    i = Invoice.new
    i.id = -1
    return i
  end

  def invoice_number_format
    unless /\d\d\d\d\/\d\d\d\d/.match(number)
      errors.add(:number, "invalid format")
    end
  end
 


  def base_amount  
    partial = 0
    self.items.each do |item|
      partial += item.total unless item.total.nil?
    end
    
    partial
  end

  def total
    ret = base_amount

    footer_items.each do |footer_item|
      ret = ret + footer_item[:calculated_value].to_f if footer_item[:summable]
    end

    ret
  end

  def self.valid_years
    
    min_year = Invoice.minimum('substr(number, 6, 9)').to_i

    max_year = Date.today.year + 1
    
    return min_year..max_year

  end

  def initialize_suggested_values
    if self.new_record?
      self.status = :draft

      # first day of next month - 1
      self.invoice_date||= Date.new((Date.today>>1).year, (Date.today>>1).month,1) - 1

      # the maximum year saved in the database, if exists, otherwise the current year
      begin
        suggested_year = Invoice.maximum('substr(number, 6, 9)').to_i
      rescue
        suggested_year = Date.today.year
      end

      # find all invoices for the suggested year
      current_year_invoices = Invoice.by_year(suggested_year)

      max_number = 0

      # find the maximum number of that year
      current_year_invoices.each do |invoice|  
        current_number = invoice.number.split('/')[0].to_i 
        if current_number > max_number
          max_number=current_number
        end
      end
      max_number = "%04d" % (max_number += 1)
      self.number||= "#{max_number}/#{suggested_year}"
      # puts current_year_invoices.inspect

    end
  end

  def self.by_year(year)
    p "*********** by_year is #{year}"
    dt = DateTime.new(year.to_i)
    boy = dt.beginning_of_year
    eoy = dt.end_of_year
    where("invoice_date >= ? and invoice_date <= ?", boy, eoy)
  end


  def footer_items

    ret = []
    unless footer.nil?
      # prepare evaluated formulas
      footer.footer_items.each do |footer_item| 
        # description = footer_item.description
        # percentage_label = footer_item.percentage_label
        instanced_formula = footer_item.formula % {:TOT => base_amount}

        # evaluating 
        calculated_value = Proc.new {
          $SAFE = 4  # change level only inside this proc
          begin
            eval(instanced_formula)
          rescue SecurityError
            0
          end
        }.call

        ret << {
          :percentage_label => footer_item.percentage_label,
          :description => footer_item.description, 
          :calculated_value => calculated_value, 
          :summable => footer_item.summable
        }
      end

    end
    ret
  end

  def payment_status
    return 'expired' if payment_date && payment_date.past? && status != 'paid'
    return status
  end

  def available_statuses
    if new_record? || status == 'draft'
      ['draft']
    else
      ['sent', 'paid']
    end
  end

  def generate_pdf(current_user, view_context)

    # pdf = Prawn::Document.new
    # pdf.text "Hello There"
    # pdf.render_file "example.pdf"

    update_attributes(:status => 'sent')

    dir = "#{APP_CONFIG['data_dir']}/#{current_user.company.id}/#{self.id}/"

    unless File.directory?(dir)
      FileUtils.mkdir_p(dir)
    end
    client_name = client.name.gsub(/\W/, "").gsub(/\d/,"").camelize
    company_name = current_user.company.name.gsub(/\W/, "").gsub(/\d/,"").camelize
    invoice_number_for_file_system = self.number.split('/').first + "-" + self.number.split('/').last
    timestamp = DateTime.now.strftime('%Y%m%d%H%M%S')

    pdf_file_name = "#{timestamp}-#{company_name}-#{invoice_number_for_file_system}-#{client_name}.pdf"
    pdf_full_path = "#{dir}/#{pdf_file_name}"

    # companyName is used also for the pdf template
    company_name += 'Pdf'

    begin
      pdf = company_name.constantize.new(self, view_context)

    rescue => e
      pdf = InvoicePdf.new(self, view_context)
      puts e.inspect
    end


    pdf.render_file pdf_full_path

    # return the pdf_full_path to the controller, which can send it back to the browser
    pdf_full_path
  end


end
