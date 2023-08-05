class FollowsController < ApplicationController

    skip_before_action :verify_authenticity_token

    def follow 
        if cookies[]
        following_user = User.find()
        follower_user = User.find(params[:id])
    end
end
