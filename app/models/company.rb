class Company < ActiveRecord::Base

  has_many :users
  has_many :clients
  has_many :memos

end
