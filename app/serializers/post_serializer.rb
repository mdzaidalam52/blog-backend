class PostSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :created_at,  :updated_at, :image_url, :topic, :description, :body, :comment, :commenters, :likes, :user_id
end
