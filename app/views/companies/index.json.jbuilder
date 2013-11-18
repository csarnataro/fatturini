json.array!(@companies) do |company|
  json.extract! company, :name, :address
  json.url company_url(company, format: :json)
end
