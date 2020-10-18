module Api
  module Controllers
    module Articles
      module Favorites
        class Create
          include Api::Action

          def initialize(article_repository: ArticleRepository.new)
            @article_repository = article_repository
          end

          def call(params)
            article = @article_repository.find_by_slug(params.get(:slug))
            halt 404, ErrorMessageTemplate.errors(['Article not exist']) unless article

            ArticleFavoriteRepository.new.find_or_create(article_id: article.id, favorit_id: current_user.id)

            article = @article_repository.find_all_with_tags_favorites_author_info(
              current_user_id: current_user&.id,
              id: article.id
            ).first
            status 200, ArticleTemplate.article(article)
          end
        end
      end
    end
  end
end
