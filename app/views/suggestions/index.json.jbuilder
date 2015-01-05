json.array!(@suggestions) do |suggestion|
  json.extract! suggestion, :id, :device_id, :user_id, :message
  json.url suggestion_url(suggestion, format: :json)
end
