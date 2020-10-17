module Api
  module Controllers
    module Profiles
      class Show
        include Api::Action

        def call(params)
          user = UserRepository.new.find_by_username(params.get(:username))
          halt 404, ErrorMessageTemplate.errors(['User not exist']) unless user

          status 200,  UserTemplate.profile(user, current_user)
        end

        private

        def authenticate!
        end

      end
    end
  end
end
