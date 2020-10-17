module Api
  module Controllers
    module Articles
      class Create
        include Api::Action

        params do
          required(:article).schema do
            required(:title).filled
            required(:description).filled
            required(:body).filled
            optional(:tagList) { array? { each { str? } } }
          end
        end

        def initialize(repository: ArticleRepository.new)
          @repository = repository
        end

        def call(params)
          halt 422, ErrorMessageTemplate.errors(['Params not valide']) unless params.valid?

          article = @repository.find_all_with_tags_favorites_author(
            id: @repository.create_with_tags(
              slug: Article.title_to_slug(params.get(:article, :title)),
              title: params.get(:article, :title),
              description: params.get(:article, :description),
              body: params.get(:article, :body),
              author_id: current_user.id,
              tags: params.get(:article, :tagList)
            ).id
          ).first
          status 200, ArticleTemplate.article(article)
        end

      end
    end
  end
end
