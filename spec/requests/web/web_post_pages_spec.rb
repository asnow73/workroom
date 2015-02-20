require 'spec_helper'
require './app/helpers/application_helper'
include ApplicationHelper


describe "Web post" do
  def prepare_data
    section = FactoryGirl.create(:section, name: "posts")
    @category_1 = FactoryGirl.create(:category, section: section)
    @category_2 = FactoryGirl.create(:category, section: section)

    36.times do
      FactoryGirl.create(:post, category: @category_1)
      FactoryGirl.create(:post, category: @category_2)
    end
  end

  def clear_data
    Section.delete_all
    Category.delete_all
    Post.delete_all
  end

  before(:all) { prepare_data }
  after(:all) { clear_data }

  subject { page }

  describe "Index posts" do
    before do
      visit posts_path
    end
    
    it "should have search box" do
      #should have_selector("div", search-widget widget)
      #raise page.find("div")[:class].include?("search-widget")
      #page.should have_css('div#search-widget')

      #expect(page).to have_content('div#search-widget')
    end

    #it { should have_title("Web posts") }
    it { should have_selector("div", text: "Заметки") }
    it "category posts" do
      Post.categories.each do |category|
        should have_link(category.name, href: category_posts_path(category))
      end
    end

    describe "type of preview" do
      let!(:empty_preview) { FactoryGirl.create(:post, title: "summary post preview", preview: "") }
      let!(:nil_preview) { FactoryGirl.create(:post, title: "summary post preview", preview: nil) }
      let!(:preview_post) { FactoryGirl.create(:post, title: "post preview", preview: "some preview") }
      before do
        visit posts_path
      end
      it { should have_content(summary_for_html_text(empty_preview.content)) }
      it { should have_content(summary_for_html_text(nil_preview.content)) }
      it { should have_content(preview_post.preview) }
    end

    describe "not show unpublished posts" do
      let!(:published_post) { FactoryGirl.create(:post, title: "published post") }
      let!(:unpublished_post) { FactoryGirl.create(:post, title: "unpublished post", published: false) }
      before do
        visit posts_path
      end

      it { should have_link("#{published_post.title}", href: post_path(published_post) ) }
      it { should_not have_link("#{unpublished_post.title}", href: post_path(unpublished_post) ) }
    end

    describe "pagination" do
      it { should have_selector('div.pagination') }

      it "should list each post" do
        Post.order('created_at DESC').paginate(page: 1).each do |post|
          should have_link("#{post.title}", href: post_path(post) )
          should have_content(summary_for_html_text(post.content))
          should have_link(post.category.name, href: category_posts_path(post.category))
        end
      end
    end
  end

  describe "Show post" do
    let!(:post) { FactoryGirl.create(:post) }
    before do
      visit post_path(post)
    end

    #it { should have_title("Web post") }
    it { should have_selector("div", text: post.title) }
    it { should have_content(post.content) }
    it { should have_link("#{post.category.name}", href: posts_path(posts: {category_id: post.category} )) }


    let!(:unpublished_post) { FactoryGirl.create(:post, published: false) }
    it "unpublished post for user" do
      expect {
        visit post_path(unpublished_post)
      }.to raise_error
    end

    let!(:user_admin) { FactoryGirl.create(:user) }
    it "unpublished post for admin" do
      sign_in(user_admin)
      visit post_path(unpublished_post)
      
      # should have_title("Web post")
      should have_selector("div", text: unpublished_post.title)
      should have_content(unpublished_post.content)
      should have_link("#{unpublished_post.category.name}", href: posts_path(posts: {category_id: unpublished_post.category} ))
    end

  end
end