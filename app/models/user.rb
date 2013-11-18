class User < ActiveRecord::Base
  has_many :services # oauth services

  belongs_to :company

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
    end
  end

  def admin?
    user_type == 'admin'
  end

end
