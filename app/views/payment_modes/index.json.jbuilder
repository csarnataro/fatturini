json.array!(@payment_modes) do |payment_mode|
  json.extract! payment_mode, :name, :full_description, :is_default
  json.url payment_mode_url(payment_mode, format: :json)
end
