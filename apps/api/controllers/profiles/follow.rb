module Api
  module Controllers
    module Profiles
      class Follow
        include Api::Action

        def call(params)
          user = UserRepository.new.find_by_username(params.get(:username))
          halt 404, ErrorMessageTemplate.errors(['User not exist']) unless user

          ActiveRelationshipRepository.new.find_or_create(follower_id: current_user.id, followed_id: user.id)
          status 200,  UserTemplate.profile(user, current_user)
        end
      end
    end
  end
end
