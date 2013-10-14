require 'spec_helper'
# require 'application_helper'
# include ApplicationHelper

describe "Web post" do
  subject { page }

  describe "Index posts" do
    before do
      visit posts_path
    end

    it { should have_title("Web posts") }
    it { should have_selector("h2", text: "Заметки") }
    describe "category links" do
      Post.categories.each do |category|
        page.should have_link(category.name, href: category_posts_path(category))
      end
    end

    describe "pagination" do
      before(:all) do
        35.times { FactoryGirl.create(:post) }
      end
      after(:all) do
        Post.delete_all
        Category.delete_all
        Section.delete_all
      end

      it { should have_selector('div.pagination') }

      it "should list each post" do
        Post.order('created_at DESC').paginate(page: 1).each do |post|
          page.should have_link("#{post.title}", href: post_path(post) )
          # page.should have_content(summary_for_html_text(post.content)) TODO
          page.should have_link(post.category.name, href: category_posts_path(post.category))
        end
      end
    end
  end

  describe "Show post" do
    let!(:post) { FactoryGirl.create(:post) }
    before do
      visit post_path(post)
    end

    it { should have_title("Web post") }
    it { should have_selector("h2", text: post.title) }
    it { should have_content(post.content) }
    it { should have_link("#{post.category.name}", href: posts_path(posts: {category_id: post.category} )) }
  end
end