json.array!(@devices) do |device|
  json.extract! device, :id, :auth_key, :parse_token, :profile_url
  json.url device_url(device, format: :json)
end
