json.array!(@memos) do |memo|
  json.extract! memo, :vendor, :goods, :amount, :company_id
  json.url memo_url(memo, format: :json)
end
