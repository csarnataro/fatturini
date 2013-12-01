# app/models/concerns/pdf_manager.rb
# notice that the file name has to match the module name 
# (applying Rails conventions for autoloading)
module PdfManager
  extend ActiveSupport::Concern
  
  
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


  # inner class for showing invoices versions
  class Version
    attr_accessor :date, :file, :id, :latest

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