json.array!(@updates) do |update|
  json.extract! update, :id, :message, :active
  json.url update_url(update, format: :json)
end
