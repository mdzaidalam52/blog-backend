require 'jwt'

class UsersController < ApplicationController

    skip_before_action :verify_authenticity_token

    def signup 
        user = User.new(email: params[:email], password: params[:password], name: params[:name], followed_user_ids: [], followed_by_user_ids: [], saved_posts: [])

        if user.save
            render status: 201, json: {msg: "Account Created Successfully"}
        else
            render status: 409, json: {errors: user.errors}
        end
    end

    def signin
        user = User.find_by(email: params[:email])
        puts user.password_digest
        if user && user.authenticate(params[:password])
            response.headers["token"] = JWT.encode({id: user.id}, "SECRET")
            render status: 200, json: {msg: "Signed In Successfully"}
        else
            render status: 401, json: {errors: "Wrong credentials"}
        end
    end

    def logout
        if request.headers["token"]
            cookies.delete("token")
            render status:200, json: {msg: "Logged Out Successfully"}
        end
    end

    def profile
        user = User.find(params["id"])
        render json: user.as_json(only: [:id, :email, :name, :followed_user_ids, :followed_by_user_ids, :saved_posts])
    end

    def profiles
    
        profiles = []
        ids = params[:ids]
        for i in 0..(ids.length-1)
            profiles[profiles.length] = User.find(params[:ids][i]).as_json(only: [:id, :email, :name, :followed_user_ids, :followed_by_user_ids, :saved_posts])
        end

        render json: {"profiles": profiles}
    end

    def get_profile_by_name
        profiles = []
        name = params[:name].downcase
        puts "hello"
        users = User.where("LOWER(name) LIKE ?", "%#{name}%")
        render json: {"profiles": users}
    end
end
