require 'spec_helper'

describe "Admin post" do
  subject { page }

  let!(:user_admin) { FactoryGirl.create(:user) }
  before { sign_in(user_admin) }    

  describe "index" do
    before do
      visit admin_posts_path
    end

    it { should have_title("Admin post") }
    it { should have_selector("div", text: "Администрирование заметок") }
    it { should have_link("Новая заметка...", href: new_admin_post_path) }

    describe "published test" do
      before(:all) do
        FactoryGirl.create(:post, title: "published_post", published: true)
        FactoryGirl.create(:post, title: "unpublished_post", published: false)
      end

      after(:all) do
        Post.delete_all
        Category.delete_all
        Section.delete_all
      end
      it { should have_selector('td', text: "published_post") }
      it { should have_selector('td.public-content') }
      it { should have_selector('td', text: "unpublished_post") }
      it { should have_selector('td.unpublic-content') }      
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
          page.should have_selector('td', text: post.title)
          page.should have_link('', href: edit_admin_post_path(post))
          page.should have_link('', href: admin_post_path(post))
        end
      end

    end
  end  

  describe "deleting post" do
    let!(:post_for_delete) { FactoryGirl.create(:post) }
    before do
      visit admin_posts_path
    end

    it "should delete post" do
      expect { click_link('', href: admin_post_path(post_for_delete)) }.to change(Post, :count).by(-1)
      page.should have_selector('div.alert.alert-success')
    end
  end

  describe "with modification" do
    let!(:section_posts) { FactoryGirl.create(:section, name: "posts") }
    let!(:category_posts) { FactoryGirl.create(:category, section: section_posts) }
    let!(:another_category) { FactoryGirl.create(:category) }

    describe "edit" do
      let!(:post) { FactoryGirl.create(:post, category: category_posts) }

      before do
        visit edit_admin_post_path(post)
      end

      it { should have_title('Admin post update') }
      it { should have_selector('div', text: 'Обновление заметки') }
      it { should have_button('Сохранить изменения') }
      it { find_field('post_category_id').value.should eq post.category.id.to_s }
      it { should_not have_selector('option', text: another_category.name) }

      describe "with invalid information" do
        describe "without title" do
          before do
            fill_in "Заглавие", with: ''
            click_button "Сохранить изменения"
          end
          it { should have_content('error') }
        end

=begin
TODO проблема с невозможностью обращения к полё ввода контента редактора TinyMCE 
        describe "without content" do
          before do
            fill_in "Содержимое", with: ''
            click_button "Сохранить изменения"
          end
          it { should have_content('error') }
        end
=end

      end

      describe "with valid information" do
        let(:new_title)  { "new title" }
        before do
          fill_in "Заглавие", with: new_title
          click_button "Сохранить изменения"
        end
        it { should have_selector('div.alert.alert-success') }
        specify { post.reload.title.should == new_title }
      end
    end
 
    describe "create" do
      before do
        visit new_admin_post_path
      end

      it { should have_title('Admin post create') }
      it { should have_selector('div', text: 'Создание новой заметки') }
      it { should have_button('Создать заметку') }
      it { find_field('post_category_id').value.should eq category_posts.id.to_s }
      it { should_not have_selector('option', text: another_category.name) }

      describe "with invalid information" do
        before do
          fill_in "Заглавие", with: ''
          expect { click_button "Создать заметку" }.not_to change(Post, :count)
        end
        it { should have_content('error') }
      end


=begin
TODO проблема с невозможностью обращения к полё ввода контента редактора TinyMCE 
      describe "with valid information" do
        before do
          fill_in "Заглавие", with: "new title"
          fill_in "Содержимое", with: "content"
          select category_posts.name, :from => "Категория"
          expect { click_button "Создать заметку" }.to change(Post, :count).by(1)
        end
        it { should have_selector('div.alert.alert-success') }      
      end
=end
    end
  end

end