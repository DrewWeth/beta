json.array!(@posts) do |post|
  json.extract! post, :id, :content, :latlon, :views, :ups, :downs, :radius, :device_id
  json.url post_url(post, format: :json)
end
