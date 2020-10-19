module Api
  module Controllers
    module Profiles
      class Unfollow
        include Api::Action

        def call(params)
          user = UserRepository.new.find_by_username(params.get(:username))
          halt 404, ErrorMessageTemplate.errors(['User not exist']) unless user

          ActiveRelationshipRepository.new.delete_by_ids(follower_id: current_user.id, followed_id: user.id)
          status 200,  UserTemplate.profile(user, false)
        end
      end
    end
  end
end
