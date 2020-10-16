class UserRepository < Hanami::Repository
  # associations do
  #   has_many :articles
  #   has_many :comments
  #   has_many :articles, as: :favorites, through: :article_favorites
  # end

  def find_by_email(email)
    users.where(email: email).first
  end

  def find_by_username(username)
    users.where(username: username).first
  end

  # def find_with_comments(id)
  #   aggregate(:comments).where(id: id).map_to(User).one
  # end
  #
  # def find_with_articles(id)
  #   aggregate(:articles).where(id: id).map_to(User).one
  # end
  #
  # def articles_for(user)
  #   assoc(:articles, user).to_a
  # end
  #
  # def find_with_favorites(id)
  #   aggregate(:favorites).where(id: id).map_to(User).one
  # end
  #
  # def favorites_for(user)
  #   assoc(:favorites, user).to_a
  # end
  #
  # def followers_for(user)
  #   users
  #     .join(:user_followers, follower_id: :id)
  #     .where(user_id: user.id)
  #     .to_a
  # end
  #
  # def following_for(user)
  #   users
  #     .join(:user_followers, user_id: :id)
  #     .where(follower_id: user.id)
  #     .to_a
  # end

end
