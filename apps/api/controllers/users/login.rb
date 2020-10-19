module Api
  module Controllers
    module Users
      class Login
        include Api::Action

        params do
          required(:user).schema do
            required(:email).filled
            required(:password).filled
          end
        end

        def call(params)
          halt 422, ErrorMessageTemplate.errors(['Params not valide']) unless params.valid?

          email = params.get(:user, :email)
          password = params.get(:user, :password)
          user = UserRepository.new.find_by_email(email)

          if user && PasswordHelper.valid_password?(password, user)
            status 201, UserTemplate.user(user)
          else
            status 401, ErrorMessageTemplate.errors(['Unauthorized requests'])
          end
        end

        private

        def authenticate!
        end

      end
    end
  end
end
