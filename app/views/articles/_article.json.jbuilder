json.extract! article, :id, :title, :content, :feature_image, :tags, :created_at, :updated_at
json.url article_url(article, format: :json)
