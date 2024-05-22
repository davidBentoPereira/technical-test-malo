class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]

  # GET /articles or /articles.json
  def index
    @q = Article.ransack(params[:q])
    @articles = @q.result(distinct: true)

    if params[:q] && params[:q][:title_or_content_or_tags_cont]
      query = params[:q][:title_or_content_or_tags_cont]
      @articles = filter_articles_with_tags_only_having_hash_tags(@articles, query)
    end
  end

  # GET /articles/1 or /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def filter_articles_with_tags_only_having_hash_tags(articles, query)
    articles.select do |article|
      tags = reject_tags_with_hash_tags(article.tags)
      tags.any? { |tag| tag.include?(query) } || article.title.include?(query) || article.content.include?(query)
    end
  end

  def reject_tags_with_hash_tags(tags_string)
    tags_string.split(", ").reject { |tag| tag.start_with?("#") }
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def article_params
    params.require(:article).permit(:title, :content, :feature_image, :tags)
  end
end
