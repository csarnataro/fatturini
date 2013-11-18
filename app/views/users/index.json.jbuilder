json.array!(@users) do |user|
  json.extract! user, :company_id, :email, :hashed_password, :password_salt, :type
  json.url user_url(user, format: :json)
end
