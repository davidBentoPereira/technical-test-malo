require 'rails_helper'

RSpec.describe Article, type: :model do
  describe "scopes" do
    describe "scope :query_on_title_or_content_or_tags_without_hashtag" do
      subject { Article.query_on_title_or_content_or_tags_without_hashtag(query) }

      context "when there are no articles" do
        let(:query) { "bébé" }

        it "returns nothing" do
          expect(subject).to be_empty
        end
      end

      context "when there are articles" do
        let!(:article_with_query_in_title) {
          Article.create!(
            title: "Bébé à 8 mois : l'angoisse de la séparation",
            content: "<p>Content</p>",
            feature_image: "https://bonjourmalo.fr/content/images/2021/05/a--partir-de-7---8-mois-un-be-be--se-de-place-au-sol--comprendre-le-de-veloppement-d-un-enfant-2.jpg",
            tags: "8 mois, motricité, développement et éveil, #nl, #api-8-9months, #week32, #week33, #week34, #week35, #feed, 0-12 mois, #api-child"
          )
        }
        let!(:article_with_query_in_content) do
          Article.create!(
            title: "Bébé à 8 mois : l'angoisse de la séparation",
            content: "<p>Content</p>",
            feature_image: "https://bonjourmalo.fr/content/images/2021/05/a--partir-de-7---8-mois-un-be-be--se-de-place-au-sol--comprendre-le-de-veloppement-d-un-enfant-2.jpg",
            tags: "8 mois, motricité, développement et éveil, #nl, #api-8-9months, #week32, #week33, #week34, #week35, #feed, 0-12 mois, #api-child"
          )
        end
        let!(:article_with_query_in_tag_with_hashtag) do
          Article.create!(
            title: "Bébé à 8 mois : l'angoisse de la séparation",
            content: "<p>Content</p>",
            feature_image: "https://bonjourmalo.fr/content/images/2021/05/a--partir-de-7---8-mois-un-be-be--se-de-place-au-sol--comprendre-le-de-veloppement-d-un-enfant-2.jpg",
            tags: "8 mois, motricité, développement et éveil, #nl, #api-8-9months, #week32, #week33, #week34, #week35, #feed, 0-12 mois, #api-child"
          )
        end

        context "when the query is included in the title of an article" do
          let(:query) { "angoisse" }

          it "returns the article" do
            expect(subject).to include(article_with_query_in_title)
          end
        end


        context "when the query is included in the content of an article" do
          let(:query) { "content" }

          it "returns the article" do
            expect(subject).to include(article_with_query_in_content)
          end
        end

        context "when the query is included in a tag WITH a hashtag" do
          let(:query) { "8-9" }

          it "returns nothing" do
            expect(subject).to be_empty
          end
        end

        context "when the query is included in a tag WITHOUT any hashtag" do
          let(:query) { "8-9" }

          let!(:article_with_query_in_tag_without_hashtag) do
            Article.create!(
              title: "Bébé à 8 mois : l'angoisse de la séparation",
              content: "<p>Content</p>",
              feature_image: "https://bonjourmalo.fr/content/images/2021/05/a--partir-de-7---8-mois-un-be-be--se-de-place-au-sol--comprendre-le-de-veloppement-d-un-enfant-2.jpg",
              tags: "8 mois, motricité, développement et éveil, 8-9 mois, #nl, #api-8-9months, #week32, #week33, #week34, #week35, #feed, 0-12 mois, #api-child"
            )
          end

          it "returns the article" do
            expect(subject).to include(article_with_query_in_tag_without_hashtag)
          end
        end
      end
    end
  end
end
