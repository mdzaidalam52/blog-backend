require 'jwt'

class PostsController < ApplicationController

    skip_before_action :verify_authenticity_token

    def create
        if request.headers["token"] && JWT.decode(request.headers["token"], "SECRET")
            user_id = JWT.decode(request.headers["token"], "SECRET").first["id"]
            user = User.find(user_id)
            post = Post.new("title": params["title"], "topic": params["topic"], "description": params["description"], "body": params["body"], "image": params["image"], "user": user, "likes": ["hello"], "comment": ["hello"], "commenters": ["hello"])
            if post.save
                render status: 201, json: {msg: "Post Created Successfully"}
            else
                render json: @post.errors, status: :unprocessable_entity
            end
        else
            render status: 401, json: {errors: "User not signed in"}
        end
    end

    def get_all_posts
        posts = Post.all
        render json: {"posts": get_serialized_data(posts)}
    end

    def edit
        post = Post.find(params[:id])
        if (post && JWT.decode(request.headers["token"], "SECRET").first["id"] == post.user_id)
            post.body = params["body"] ? params["body"] : post.body
            post.title = params["title"] ? params["title"] : post.title
            post.topic = params["topic"] ? params["topic"] : post.topic
            post.description = params["description"] ? params["description"] : post.description
            post.image = params["image"] ? params["image"]: post.image
            post.save
            render status: 200, json: {"msg": "Edited Successfully"}
        else
            render status: 401, json: {"error": "The post does not exist or you are not the author"}
        end
    end

    def delete
        if JWT.decode(request.headers["token"], "SECRET").first["id"] == Post.find(params[:id]).user_id
            Post.delete(params[:id])
        end
    end

    def search_by_author
        users = User.where("name": params[:author])
        posts = []
        for user in users
            for post in Post.find_by("user_id": user.id)
                posts << PostSerializer.new(post).serializable_hash[:data][:attributes]
            end
        end
        render status: 200, json: {"posts": posts}
    end

    private

    def get_serialized_data(posts)
        list = []
        for post in posts
            list << PostSerializer.new(post).serializable_hash[:data][:attributes]
        end
        list
    end
end