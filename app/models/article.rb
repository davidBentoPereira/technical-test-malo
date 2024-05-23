class Article < ApplicationRecord
  def self.ransackable_associations(auth_object = nil)
    @ransackable_associations ||= reflect_on_all_associations.map { |a| a.name.to_s }
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[title content tags]
  end

  scope :query_on_title_or_content_or_tags_without_hashtag, ->(query) {
    query = "%#{query}%"
    Article.where("title ILIKE :query OR content ILIKE :query", query: query)
           .or(
             Article.where(
               id: Article.select(:id)
                          .from("articles, UNNEST(string_to_array(articles.tags, ', ')) AS tag")
                          .where("tag ILIKE ? AND tag !~ '^#'", query)
             )
           )
  }
end
