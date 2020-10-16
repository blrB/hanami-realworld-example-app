module Api
  module Controllers
    module Users
      class Create
        include Api::Action

        params do
          required(:user).schema do
            required(:username).filled
            required(:email).filled
            required(:password).filled
          end
        end

        def initialize(repository: UserRepository.new)
          @repository = repository
        end

        def call(params)
          halt 401, ErrorMessageTemplate.errors(['Params not valide']) unless params.valid?
          halt 401, ErrorMessageTemplate.errors(['Email already registered']) if @repository.find_by_email(params.get(:user, :email))
          halt 401, ErrorMessageTemplate.errors(['Username already registered']) if @repository.find_by_username(params.get(:user, :username))

          user = @repository.create(
            username: params.get(:user, :username),
            email: params.get(:user, :email),
            password: PasswordHelper.create_password(params.get(:user, :password))
          )

          if user
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
