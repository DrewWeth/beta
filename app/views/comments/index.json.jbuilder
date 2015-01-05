json.array!(@comments) do |comment|
  json.extract! comment, :id, :comment, :device_id, :post_id, :ups, :downs
  json.url comment_url(comment, format: :json)
end
