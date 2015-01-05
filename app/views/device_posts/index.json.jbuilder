json.array!(@device_posts) do |device_post|
  json.extract! device_post, :id, :device_id, :post_id, :action_id
  json.url device_post_url(device_post, format: :json)
end
