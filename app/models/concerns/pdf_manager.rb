# app/models/concerns/pdf_manager.rb
# notice that the file name has to match the module name 
# (applying Rails conventions for autoloading)
module PdfManager
  extend ActiveSupport::Concern
  
  
  # inner class for showing invoices versions
  class Version
    attr_accessor :date, :file, :id, :latest
  end

  # inner class for payment info in
  class PaymentInfo
    attr_accessor :payment_mode # e.g. 'bank transfer', should be always present
    attr_accessor :payment_term # e.g. '30 days net date invoice', it should be always present
    attr_accessor :payment_info # present only for bank transfer. e.g. the bank account data, in the form of an hashmap 
                                # with 'BANK NAME' =>  company.bank_name
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
  
  
  def get_pdf(current_user, file_id)
    right_file = nil
    dir = "#{APP_CONFIG['data_dir']}/#{current_user.company.id}/#{id}/"
    
    files =[]
    begin
      # if the directory doesn't exist yet
      Dir.foreach(dir) { |path| files << path }
    rescue
      # do nothing
    end
    
    files.each do |file|
      next if file == '.' || file == '..' || File.extname(file) != '.pdf'
      puts "FILE: => #{file}"
      right_file = file if file.starts_with? file_id
    end
    puts " ****** RIGHT FILE: => #{right_file}"
    
    dir + "/" + right_file
  end

  def get_versions(current_user)
    # [{:date => '20/09/2013 13:12:00', :file => 'Abc.pdf' }]

    dir = "#{APP_CONFIG['data_dir']}/#{current_user.company.id}/#{self.id}/"
    versions = []
    files = []

    begin
      # if the directory doesn't exist yet
      Dir.foreach(dir) { |path| files << path }
    rescue
      # do nothing
    end

    idx = 0
    files.sort.reverse.each do |file|
      next if file == '.' || file == '..' || File.extname(file) != '.pdf'

      version = Version.new

      version.latest = true if idx == 0
      
      idx = idx + 1
      
      date_as_string = file.split(/-/).first #'20/09/2013 13:12:00'
      
      date = DateTime.strptime(date_as_string,"%Y%m%d%H%M%S")

      version.date = date.strftime("%d/%m/%Y %H:%M:%S")
      version.file = file
      version.id = date_as_string
      versions << version

    end

    versions

  end


  def delete_pdf(current_user, file_id)
    right_file = nil
    dir = "#{APP_CONFIG['data_dir']}/#{current_user.company.id}/#{id}/"

    files =[]
    begin
      # if the directory doesn't exist yet
      Dir.foreach(dir) { |path| files << path }
    rescue
      # do nothing
    end


    files.each do |file|
      next if file == '.' || file == '..' || File.extname(file) != '.pdf'
      File.delete("#{dir}#{file}") if file.starts_with? file_id
    end

    update_attributes(:status => :draft)

  end


  def get_latest_pdf(current_user)
    right_file = nil
    dir = "#{APP_CONFIG['data_dir']}/#{current_user.company.id}/#{id}/"
    
    files =[]
    begin
      # if the directory doesn't exist yet
      Dir.foreach(dir) { |path| files << path }
    rescue
      # do nothing
      return nil
    end
    
    idx = 0
    files.sort.reverse.each do |file|
      next if file == '.' || file == '..' || File.extname(file) != '.pdf'
        
      return dir + "/" + file
    end
    
  end

end