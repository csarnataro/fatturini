class Client < ActiveRecord::Base

  validates :name, :presence => true
  validates :email, :format => { :with => /\A([A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4})?\z/, :message => 'must be valid email.' }
  validates_uniqueness_of :name
  validates_uniqueness_of :vat_code, :fiscal_code, :allow_blank => true, :allow_nil => true
  
  belongs_to :company
  has_one :footer
  has_many :invoices, :dependent => :restrict_with_exception


  def full_address
    full_address = "#{address} #{zip} #{city}"

    unless province.blank?
      full_address += " (#{province})"
    end

    unless country.blank?
      full_address += " - #{country}"
    end

    full_address
  end

  def full_short_address
    "#{address} #{zip} #{city}"
  end

  # the zip code is after the city
  def english_invoice_address_without_country
    zac = "#{city|''}, #{province} #{zip|''} "
  end

  def english_invoice_address
    english_invoice_address_without_country + country.pref('- ')
  end

  def invoice_address
    zac = "#{zip|''} #{city|''} "
    unless province.blank?
      zac += "(#{province})"
    end
    unless country.blank?
      zac += " - #{country.upcase}"
    end
    zac
  end
end
