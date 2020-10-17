module Api
  module Controllers
    module Users
      class Show
        include Api::Action

        def call(params)
          status 200, UserTemplate.user(current_user, token)
        end
      end
    end
  end
end
