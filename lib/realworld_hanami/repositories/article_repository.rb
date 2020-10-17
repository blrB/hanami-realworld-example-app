class ArticleRepository < Hanami::Repository
  associations do
   belongs_to :users, as: :author
   #has_one :article_favorites, as: :favorited
   has_many :tags, through: :article_tags
   #has_many :users, as: :favorites, through: :article_favorites
  end

  def create_with_tags(data)
    article = create(data)
    if data[:tags]
      tag_repository = TagRepository.new
      tag_repository.create_new_tags_for_article(tags: data[:tags], article: article)
    end
    article
  end

  # def find_with_author(id)
  #   aggregate(:author).where(id: id).map_to(Article).one
  # end
  #
  # def find_with_comments(id)
  #   aggregate(:comments).where(id: id).map_to(Article).one
  # end
  #
  # def find_with_tags(id)
  #   aggregate(:tags).where(id: id).map_to(Article).one
  # end
  #
  # def find_with_favorites(id)
  #   aggregate(:favorites).where(id: id).map_to(Article).one
  # end
  #
  # def find_with_tags_favorites_author(id)
  #   aggregate(:tags, :favorites, :author).where(id: id).map_to(Article).one
  # end

  def find_with_tags_favorites_author(id)
    aggregate(:tags, :favorites, :author).where(id).map_to(Article).first
  end

  def find_with_tags_favorites_author_by_slug(slug)
    aggregate(:tags, :favorites, :author).where(slug: slug).map_to(Article).first
  end

  # TODO - try to make this code beautifier :)
  def find_all_with_tags_favorites_author(id: nil, slug: nil, author_ids: nil, tag: nil, author: nil, favorited: nil, current_user_id: nil, limit: 20, offset: 0)
    dataset = articles.select(:id).qualified.limit(limit).offset(offset)
    dataset = dataset.where(Sequel[:articles][:id] => id) if id
    dataset = dataset.where(Sequel[:articles][:slug] => slug) if slug
    dataset = dataset.where(Sequel[:articles][:author_id] => author_ids) if author_ids
    dataset = dataset.join(:article_tags, Sequel[:article_tags][:article_id] => Sequel[:articles][:id]).join(:tags, Sequel[:tags][:id] => Sequel[:article_tags][:tag_id]).where(name: tag) if tag
    dataset = dataset.join(:users, Sequel[:users][:id] => Sequel[:articles][:author_id]).where(Sequel[:users][:username] => author) if author
    dataset = dataset.join(:article_favorites, article_id: :id).join(:users, { Sequel[:favorit_user][:id] => :favorit_id }, { table_alias: :favorit_user }).where(Sequel[:favorit_user][:username] => favorited) if favorited

    # I don't need all favorites users, only count
    #aggregate(:tags, :favorites, :author).where(id: dataset.to_a.map(&:id)).order { created_at.desc }.map_to(Article).to_a

    ids = dataset.to_a.map(&:id)
    articles_array = aggregate(:tags, :author).qualified.where(id: dataset.to_a.map(&:id)).order { created_at.desc }.map_to(Article).to_a
    articles_info = articles.dataset. # I use Seqyel, due to NoMethodError: undefined method `primary_key?' for #<Sequel::SQL::AliasedExpression:0x0000000004769978> for select_append
      select(articles[:id]).
      select_append(Sequel[:active_relationships][:follower_id].as(:author_following)).
      select_append(Sequel[:user_favorited][:favorit_id].as(:favorited)).
      select_append{ Sequel.as(count(Sequel[:article_favorites][:favorit_id]), :favorites_count) }.
      left_join(:article_favorites, Sequel[:article_favorites][:article_id] => articles[:id]).
      left_join(:article_favorites, { Sequel[:user_favorited][:favorit_id] => current_user_id, Sequel[:user_favorited][:article_id] => articles[:id] }, { table_alias: :user_favorited }).
      left_join(:active_relationships, { Sequel[:active_relationships][:follower_id] => current_user_id, Sequel[:active_relationships][:followed_id] => articles[:author_id] }, {}).
      where(articles[:id] => ids).
      group(articles[:id]).
      to_a.
      map { |attributes| UserWithInfo.new(attributes) }

    articles_array.map do |articles|
      info = articles_info.find { |a| articles.id == a.id}
      author_with_info = articles.author.to_h.merge(following: !!info.author_following)
      article_with_info = articles.to_h.merge( favorited: !!info.favorited, favorites_count: info.favorites_count, author: UserWithInfo.new(author_with_info))
      ArticleWithStats.new(article_with_info)
    end
  end

end
