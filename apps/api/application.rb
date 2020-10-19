require_relative './controllers/authentication'
require_relative './controllers/cors_headers'

module Api
  class Application < Hanami::Application
    configure do

      root __dir__

      load_paths << [
        'controllers'
      ]

      default_request_format :json
      default_response_format :json

      routes 'config/routes'

      controller.prepare do
        include Api::Controllers::Authentication
        include Api::Controllers::CorsHeaders
      end

    end

    ##
    # DEVELOPMENT
    #
    configure :development do
      # Don't handle exceptions, render the stack trace
      handle_exceptions false
    end

    ##
    # TEST
    #
    configure :test do
      # Don't handle exceptions, render the stack trace
      handle_exceptions false
    end

    ##
    # PRODUCTION
    #
    configure :production do
      # scheme 'https'
      # host   'example.org'
      # port   443
    end
  end
end
