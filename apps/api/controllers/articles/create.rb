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

          slug = Article.title_to_slug(params.get(:article, :title))
          halt 422, ErrorMessageTemplate.errors(['Article with this title already exist']) if @repository.exist_by_slug(slug)

          article = @repository.find_all_with_tags_favorites_author_info(
            current_user_id: current_user.id,
            id: @repository.create_with_tags(
              slug: slug,
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
