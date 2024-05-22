require 'json'

namespace :import_articles do
  desc "Import a list of articles"
  task import: :environment do
    file_path = Rails.root.join('lib', 'data', 'articles_simplified.json')
    file_content = File.read(file_path)
    articles = JSON.parse(file_content, object_class: OpenStruct).posts

    articles.each do |article_data|
      # puts article_data.title
      # puts article_data.html
      # puts article_data.feature_image
      # puts article_data.tags.map { |tag| tag.name }.join(', ')
      # puts "-----------------------------------------------------"

      Article.create!(
        title: article_data.title,
        content: article_data.html,
        feature_image: article_data.feature_image,
        tags: article_data.tags.map { |tag| tag.name }.join(', ')
      )
    end

    puts "Imported #{articles.size} articles."
  end
end
