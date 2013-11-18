json.array!(@invoices) do |invoice|
  json.extract! invoice, :notes, :term, :status, :client_id
  json.url invoice_url(invoice, format: :json)
end
