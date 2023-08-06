class Post < ApplicationRecord
    has_one_attached :image
    serialize :likes, JSON
    serialize :comment, JSON
    serialize :commenters, JSON

    belongs_to(
        :user,
        class_name: 'User',
        foreign_key: 'user_id',
        inverse_of: :posts
    )
  
    def likes=(value)
        super(value.is_a?(String) ? JSON.parse(value) : value)
    end

    def likes
        super || []
    end

    def comment=(value)
        super(value.is_a?(String) ? JSON.parse(value) : value)
    end

    def comment
        super || []
    end

    def commenters=(value)
        super(value.is_a?(String) ? JSON.parse(value) : value)
    end

    def commenters
        super || []
    end

    def image_url
        Rails.application.routes.url_helpers.url_for(image) if image.attached?
    end

end
