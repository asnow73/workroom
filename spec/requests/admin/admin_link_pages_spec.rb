require 'spec_helper'

# def print_db
#   puts "Category " << Category.all.count.to_s
#   puts "Link " << Link.all.count.to_s
#   puts "Section " << Section.all.count.to_s
# end

describe "Admin link" do
  # after(:each) { print_db }
  subject { page }

  describe "index" do
    before do
      visit admin_links_path
    end

    it { should have_title('Admin link') }
    it { should have_selector('h1', text: 'Администрирование ссылок') }
    it { should have_link('Новая ссылка...', href: new_admin_link_path) }

    describe "pagination" do
      before(:all) do 
        32.times { FactoryGirl.create(:link) }
      end
      after(:all) do
        Section.delete_all
        Category.delete_all
        Link.delete_all
      end

      it { should have_selector('div.pagination') }

      it "should list each link" do
        Link.order('created_at DESC').paginate(page: 1).each do |link|
          page.should have_selector('td', text: link.url)
          page.should have_link('', href: edit_admin_link_path(link))
          page.should have_link('', href: admin_link_path(link))
        end
      end
    end
  end

  describe "deleting link" do
    let!(:link_for_delete) { FactoryGirl.create(:link) }
    before do
      visit admin_links_path
    end

    it "should delete link" do
      expect { click_link('', href: admin_link_path(link_for_delete)) }.to change(Link, :count).by(-1)
      page.should have_selector('div.alert.alert-success')
    end
  end

  describe "edit" do
    let!(:section_links) { FactoryGirl.create(:section, name: "links") }
    let!(:category_links) { FactoryGirl.create(:category, section: section_links) }
    let!(:link) { FactoryGirl.create(:link, category: category_links) }

    let!(:another_category) { FactoryGirl.create(:category) }

    before do
      visit edit_admin_link_path(link)
    end

    it { should have_title('Admin link update') }
    it { should have_selector('h1', text: 'Обновление ссылки') }
    it { should have_button('Сохранить изменения') }
    it { find_field('link_category_id').value.should eq link.category.id.to_s }
    it { should_not have_selector('option', text: another_category.name) }

    describe "with invalid information" do
      describe "without url" do
        before do
          fill_in "URL", with: ''
          click_button "Сохранить изменения"
        end
        it { should have_content('error') }
      end

      describe "without description" do
        before do
          fill_in "Описание", with: ''
          click_button "Сохранить изменения"
        end
        it { should have_content('error') }
      end      

    end

    describe "with valid information" do
      let(:new_url)  { "new url" }
      before do
        fill_in "URL", with: new_url
        click_button "Сохранить изменения"
      end
      it { should have_selector('div.alert.alert-success') }
      specify { link.reload.url.should == new_url }
    end
  end

  describe "create" do
    let!(:section_links) { FactoryGirl.create(:section, name: "links") }
    let!(:category_links) { FactoryGirl.create(:category, section: section_links) }

    let!(:another_category) { FactoryGirl.create(:category) }

    before do
      visit new_admin_link_path
    end

    it { should have_title('Admin link create') }
    it { should have_selector('h1', text: 'Создание новой ссылки') }
    it { should have_button('Создать ссылку') }
    it { find_field('link_category_id').value.should eq category_links.id.to_s }
    it { should_not have_selector('option', text: another_category.name) }

    describe "with invalid information" do
      before do
        fill_in "URL", with: ''
        expect { click_button "Создать ссылку" }.not_to change(Link, :count)
      end
      it { should have_content('error') }
    end

    describe "with valid information" do
      before do
        fill_in "URL", with: "new url"
        fill_in "Описание", with: "desc"
        select category_links.name, :from => "Категория"
        expect { click_button "Создать ссылку" }.to change(Link, :count).by(1)
      end
      it { should have_selector('div.alert.alert-success') }      
    end
  end
end