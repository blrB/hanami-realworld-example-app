module Api
  module Controllers
    module Profiles
      class Show
        include Api::Action

        def call(params)
          user = UserRepository.new.find_by_username(params.get(:username))
          halt 404, ErrorMessageTemplate.errors(['User not exist']) unless user

          following = ActiveRelationshipRepository.new.user_is_following?(follower_id: current_user&.id, followed_id: user.id)
          status 200,  UserTemplate.profile(user, following)
        end

        private

        def authenticate!
        end

      end
    end
  end
end
