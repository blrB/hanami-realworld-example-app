module Api
  module Controllers
    module Articles
      class Update
        include Api::Action

        params do
          required(:article).schema do
            optional(:title) { str? }
            optional(:description) { str? }
            optional(:body) { str? }
          end
        end

        def initialize(repository: ArticleRepository.new)
          @repository = repository
        end

        def call(params)
          halt 422, ErrorMessageTemplate.errors(['Params not valide']) unless params.valid?

          article = @repository.find_by_slug(params.get(:slug))
          halt 404, ErrorMessageTemplate.errors(['Article not exist']) unless article
          halt 403, ErrorMessageTemplate.errors(['Only author can updated article']) if article.author_id != current_user.id

          article_params = params.get(:article)
          if params.get(:article, :title)
            new_slug = Article.title_to_slug(params.get(:article, :title))
            new_slug_article = @repository.find_by_slug(new_slug)
            halt 422, ErrorMessageTemplate.errors(['Article with new title already exist']) if new_slug_article && article.id != new_slug_article.id

            article_params.merge!(slug: new_slug)
          end

          article = @repository.update(article.id, article_params)

          if article
            article = @repository.find_all_with_tags_favorites_author_info(current_user_id: current_user.id, id: article.id).first
            status 200, ArticleTemplate.article(article)
          else
            status 422, ErrorMessageTemplate.errors(['Article not updated'])
          end
        end

      end
    end
  end
end
