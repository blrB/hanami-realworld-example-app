class Article < Hanami::Entity

  def self.title_to_slug(title)
    title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

end
