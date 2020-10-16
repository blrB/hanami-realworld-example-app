class ArticleRepository < Hanami::Repository
  associations do
   belongs_to :users, as: :author
   has_one :article_favorites, as: :favorited
   has_many :tags, through: :article_tags
   has_many :users, as: :favorites, through: :article_favorites
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

  def find_all_with_tags_favorites_author(id: nil, slug: nil, tag: nil, author: nil, favorited: nil, limit: 20, offset: 0)
    dataset = articles.select(:id).qualified.limit(limit).offset(offset)
    dataset = dataset.where(Sequel[:articles][:id] => id) if id
    dataset = dataset.where(Sequel[:articles][:slug] => slug) if slug
    dataset = dataset.join(:article_tags, Sequel[:article_tags][:article_id] => Sequel[:articles][:id]).join(:tags, Sequel[:tags][:id] => Sequel[:article_tags][:tag_id]).where(name: tag) if tag
    dataset = dataset.join(:users, Sequel[:users][:id] => Sequel[:articles][:author_id]).where(Sequel[:users][:username] => author) if author
    dataset = dataset.join(:article_favorites, article_id: :id).join(:users, { Sequel[:favorit_user][:id] => :favorit_id }, { table_alias: :favorit_user }).where(Sequel[:favorit_user][:username] => favorited) if favorited

    aggregate(:tags, :favorites, :author).where(id: dataset.to_a.map(&:id)).map_to(Article).to_a
  end

end
