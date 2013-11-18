class FooterItem < ActiveRecord::Base

  belongs_to :footer
  after_initialize :initialize_suggested_values



  def initialize_suggested_values
    if self.new_record?
      summable = 1
    end
  end
end
