module Api
  module Controllers
    module CorsHeaders

      def self.included(action)
        action.class_eval do
          before :include_cors_headers
        end
      end

      private

      def include_cors_headers
        self.headers.merge!(cors_headers)
      end

      def cors_headers
        {
          'Access-Control-Allow-Origin' => ENV['CORS_ALLOW_ORIGIN'],
          'Access-Control-Allow-Methods' => ENV['CORS_ALLOW_METHODS'],
          'Access-Control-Allow-Headers' => ENV['CORS_ALLOW_HEADERS']
        }
      end
    end
  end
end
