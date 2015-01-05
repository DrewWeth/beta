json.array!(@reports) do |report|
  json.extract! report, :id, :device_id, :post_id, :why, :action
  json.url report_url(report, format: :json)
end
