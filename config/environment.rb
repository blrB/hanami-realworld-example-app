require 'bundler/setup'
require 'hanami/setup'
require 'hanami/model'
require_relative '../lib/realworld_hanami'
require_relative '../apps/api/application'

require "hanami/middleware/body_parser"

Hanami.configure do
  mount Api::Application, at: '/api'

  middleware.use Hanami::Middleware::BodyParser, :json

  model do
    ##
    # Database adapter
    #
    # Available options:
    #
    #  * SQL adapter
    #    adapter :sql, 'sqlite://db/realworld_hanami_development.sqlite3'
    #    adapter :sql, 'postgresql://localhost/realworld_hanami_development'
    #    adapter :sql, 'mysql://localhost/realworld_hanami_development'
    #
    adapter :sql, ENV.fetch('DATABASE_URL')

    ##
    # Migrations
    #
    migrations 'db/migrations'
    schema     'db/schema.sql'
  end

  mailer do
    root 'lib/realworld_hanami/mailers'

    # See https://guides.hanamirb.org/mailers/delivery
    delivery :test
  end

  environment :development do
    # See: https://guides.hanamirb.org/projects/logging
    logger level: :debug
  end

  environment :production do
    logger level: :info, formatter: :json, filter: []

    mailer do
      delivery :smtp, address: ENV.fetch('SMTP_HOST'), port: ENV.fetch('SMTP_PORT')
    end
  end
end
