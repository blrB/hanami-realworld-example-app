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

        def initialize(repository: UserRepository.new)
          @repository = repository
        end

        def call(params)
          halt 401, ErrorMessageTemplate.errors(['Params not valide']) unless params.valid?

          email = params.get(:user, :email)
          password = params.get(:user, :password)
          user = @repository.find_by_email(email)

          if user && PasswordHelper.valid_password?(password, user)
            status 201, UserTemplate.user(user, JWTHelper.decode(user))
          else
            status 401, ErrorMessageTemplate.errors(['Authentication failure'])
          end
        end

        private

        def authenticate!
        end

      end
    end
  end
end
