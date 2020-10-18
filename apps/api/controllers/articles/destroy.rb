module Api
  module Controllers
    module Articles
      class Destroy
        include Api::Action

        def initialize(repository: ArticleRepository.new)
          @repository = repository
        end

        def call(params)
          article = @repository.find_by_slug(params.get(:slug))
          halt 404, ErrorMessageTemplate.errors(['Article not exist']) unless article
          halt 403, ErrorMessageTemplate.errors(['Only author can delete article']) if article.author_id != current_user.id

          @repository.delete(article.id)
          status 200, {}.to_json
        end
      end
    end
  end
end
