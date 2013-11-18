json.array!(@clients) do |client|
  json.extract! client, :name, :email, :address, :city, :province, :state, :country, :zip, :fiscal_code, :vat_code
  json.url client_url(client, format: :json)
end
