class FollowsController < ApplicationController

    skip_before_action :verify_authenticity_token

    def follow 
        if request.headers["token"] && JWT.decode(request.headers["token"], 'SECRET')
            followed_user = User.find(params["id"])
            following_user = User.find(JWT.decode(request.headers["token"], 'SECRET').first["id"])
            followed_user_following_list = followed_user.followed_by_user_ids
            if not followed_user_following_list.include?(following_user.id)
                followed_user_following_list << following_user.id
                followed_user.followed_by_user_ids = followed_user_following_list
            end


            following_user_followed_list = following_user.followed_user_ids
            if not following_user_followed_list.include?(following_user.id)
                following_user_followed_list << followed_user.id
                following_user.followed_user_ids = following_user_followed_list
            end

            followed_user.save
            following_user.save
            
        end
    end

    def unfollow
        if request.headers["token"] && JWT.decode(request.headers["token"], 'SECRET')

            followed_user = User.find(params["id"])
            following_user = User.find(JWT.decode(request.headers["token"], 'SECRET').first["id"])

            followed_user_following_list = followed_user.followed_by_user_ids
            followed_user_following_list.reject! { |id| id == following_user.id}
            followed_user.followed_by_user_ids = followed_user_following_list


            following_user_followed_list = following_user.followed_user_ids
            following_user_followed_list.reject! { |id| id == followed_user.id }
            following_user.followed_user_ids = following_user_followed_list

            followed_user.save
            following_user.save
            
        end
    end
end
