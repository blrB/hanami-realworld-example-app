class ArticleRepository < Hanami::Repository
  associations do
   belongs_to :users, as: :author
   has_many :tags, through: :article_tags
  end

  def exist_by_slug(slug)
    articles.where(slug: slug).exist?
  end

  def find_by_slug(slug)
    articles.where(slug: slug).one
  end

  def create_with_tags(data)
    article = create(data)
    if data[:tags]
      tag_repository = TagRepository.new
      tag_repository.create_new_tags_for_article(tags: data[:tags], article: article)
    end
    article
  end

  def find_all_with_tags_favorites_author_info(id: nil, slug: nil, author_ids: nil, tag: nil, author: nil, favorited: nil, current_user_id: nil, limit: 20, offset: 0)
    dataset = articles.select(:id).qualified.limit(limit).offset(offset).order { articles[:created_at].desc }
    dataset = dataset.where(Sequel[:articles][:id] => id) if id
    dataset = dataset.where(Sequel[:articles][:slug] => slug) if slug
    dataset = dataset.where(Sequel[:articles][:author_id] => author_ids) if author_ids
    dataset = dataset.join(:article_tags, Sequel[:article_tags][:article_id] => Sequel[:articles][:id]).join(:tags, Sequel[:tags][:id] => Sequel[:article_tags][:tag_id]).where(name: tag) if tag
    dataset = dataset.join(:users, Sequel[:users][:id] => Sequel[:articles][:author_id]).where(Sequel[:users][:username] => author) if author
    dataset = dataset.join(:article_favorites, article_id: :id).join(:users, { Sequel[:favorit_user][:id] => :favorit_id }, { table_alias: :favorit_user }).where(Sequel[:favorit_user][:username] => favorited) if favorited

    ids = dataset.to_a.map(&:id)
    articles_array = aggregate(:tags, :author).qualified.where(id: ids).order { created_at.desc }.map_to(Article).to_a

    following_author_articles = articles_ids_with_author_following_by_ids(ids: ids, current_user_id: current_user_id)
    favorited_articles = articles_ids_favorited_by_ids(ids: ids, current_user_id: current_user_id)
    favorites_count_articles = articles_ids_with_favorites_count_by_ids(ids: ids)

    articles_array.map do |article|
      author_with_info = article.author.to_h.merge(following: following_author_articles.include?(article.id))
      article_with_info = article.to_h.merge(favorited: favorited_articles.include?(article.id), favorites_count: favorites_count_articles[article.id], author: UserWithInfo.new(author_with_info))
      ArticleWithInfo.new(article_with_info)
    end
  end

  private

  def articles_ids_with_author_following_by_ids(ids:, current_user_id: nil)
    articles.
      select(:id).
      left_join(:active_relationships, follower_id: current_user_id, followed_id: :author_id).
      where(id: ids).
      exclude(follower_id: nil).
      to_a.
      map(&:id)
  end

  def articles_ids_favorited_by_ids(ids:, current_user_id: nil)
    articles.
      select(:id).
      left_join(:article_favorites, favorit_id: current_user_id, article_id: :id).
      where(id: ids).
      exclude(favorit_id: nil).
      to_a.
      map(&:id)
  end

  def articles_ids_with_favorites_count_by_ids(ids:)
    results = articles.dataset.
      select(:id).
      left_join(:article_favorites, article_id: :id).
      where(id: ids).
      exclude(favorit_id: nil).
      group_and_count(:id).
      as_hash(:id, :count)
    Hash[ids.sort.map { |id| [id, results[id] || 0] }]
  end

end
