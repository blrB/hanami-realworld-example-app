module Api
  module Controllers
    module Articles
      class Feed
        include Api::Action

        params do
          optional(:limit) { int? & lteq?(1024) }
          optional(:offset) { int? }
        end

        def call(params)
          halt 422, ErrorMessageTemplate.errors(['Params not valide']) unless params.valid?

          articles = ArticleRepository.new.find_all_with_tags_favorites_author(
            author_ids: UserRepository.new.following(current_user).map(&:id),
            current_user_id: current_user.id,
            limit: params.get(:limit),
            offset: params.get(:offset)
          )
          status 200, ArticleTemplate.list(articles)
        end
      end
    end
  end
end
