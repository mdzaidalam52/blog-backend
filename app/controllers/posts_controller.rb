require 'jwt'

class PostsController < ApplicationController

    skip_before_action :verify_authenticity_token

    def create
        if request.headers["token"] && JWT.decode(request.headers["token"], "SECRET")
            user_id = JWT.decode(request.headers["token"], "SECRET").first["id"]
            user = User.find(user_id)
            post = Post.new("title": params["title"], "topic": params["topic"], "description": params["description"], "body": params["body"], "image": params["image"], "user": user, "likes": [], "comment": [], "commenters": [], "views": 0)
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

    def get_post 
        post = Post.find(params[:id])
        if params[:viewing]
            if request.headers["token"]
                if JWT.decode(requst.headers["token"], "SECRET") != post.user_id
                    post.views = post.views+1
                end
            else
                post.views = post.views+1
            end
        end
        post.save
        render status: 200, json: {post: PostSerializer.new(post).serializable_hash[:data][:attributes]}
    end

    def like 
        if request.headers["token"] && JWT.decode(request.headers["token"], "SECRET")
            user_id = JWT.decode(request.headers["token"], "SECRET").first["id"]
            post = Post.find(params[:id])
            if post && post.likes.none? { |liker| user_id.to_s == liker}
                current_list = post.likes
                current_list << user_id.to_s
                post.likes = current_list
                post.save
            end
        end
    end

    def unlike
        if request.headers["token"] && JWT.decode(request.headers["token"], "SECRET")
            user_id = JWT.decode(request.headers["token"], "SECRET").first["id"]
            post = Post.find(params[:id])
            if post
                current_list = post.likes
                current_list.select! { |liker| user_id.to_s != liker}
                puts current_list
                post.likes = current_list
                post.save
            end
        end
    end

    def comment
        if request.headers["token"] && JWT.decode(request.headers["token"], "SECRET")
            user_id = JWT.decode(request.headers["token"], "SECRET").first["id"]
            user = User.find(user_id)
            post = Post.find(params[:id])
            if post
                commenters_list = post.commenters
                comment_list = post.comment
                commenters_list << user.name
                comment_list << params[:comment]
                post.comment = comment_list
                post.commenters = commenters_list
                post.save
            end
        end
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

    def search_by_user_id
        posts = Post.where(user_id: params[:id])
        render json: {posts: get_serialized_data(posts)}
    end

    def search_by_title
        title = params[:title].downcase
        posts = Post.where("LOWER(title) LIKE ?", "%#{title}%")
        render json: {posts: get_serialized_data(posts)}
    end

    def search_by_topic
        topic = params[:topic].downcase
        posts = Post.where("LOWER(topic) LIKE ?", "%#{topic}%")
        render json: {posts: get_serialized_data(posts)}
    end

    def search_by_name
        users = User.where("LOWER(name) LIKE ?", "%#{params[:name].downcase}%")
        posts = []
        for user in users
            for post in user.posts 
                posts << post
            end
        end

        render json: {posts: get_serialized_data(posts)}
    end

    def get_top_posts
        posts = Post.all
        top_posts = posts.sort_by do |post|
            post_total_points = post.views + post.likes.length*5 + post.commenters.uniq.length*10
            post_total_points
        end
        top_posts.reverse
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
