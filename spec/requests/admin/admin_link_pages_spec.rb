require 'spec_helper'

describe "Admin link" do

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
        category = FactoryGirl.create(:category)
        32.times { FactoryGirl.create(:link, category: category) }
      end
      after(:all) do
        Link.delete_all
        Category.delete_all
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

  describe "deliting link" do
    before do
      FactoryGirl.create(:link, url: "url1")
      FactoryGirl.create(:link, url: "url2")
      visit admin_links_path
    end

    it "should delete link" do
      expect { click_link('', href: admin_link_path(Link.first)) }.to change(Link, :count).by(-1)
      page.should have_selector('div.alert.alert-success')
    end
  end

  describe "edit" do
    let(:link) { FactoryGirl.create(:link) }
    before do
      visit edit_admin_link_path(link)
    end

    it { should have_title('Admin link update') }
    it { should have_selector('h1', text: 'Обновление ссылки') }
    it { should have_button('Сохранить изменения') }

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

      # describe "without category" do
      #   before do
      #     select '', :from => "Категория"
      #     click_button "Сохранить изменения"
      #   end
      #   it { should have_content('error') }
      # end

      # describe "submitting to the update action" do
      #   before do
      #     put admin_link_path(link, params: {link: {url: "aaa", description: "bbb", category_id: ""}} )
      #   end
      #   it { should have_selector('div.alert.alert-error') }
      # end

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
    let!(:category) { FactoryGirl.create(:category) }
    before do
      visit new_admin_link_path
    end

    it { should have_title('Admin link create') }
    it { should have_selector('h1', text: 'Создание новой ссылки') }
    it { should have_button('Создать ссылку') }
    it { find_field('link_category_id').value.should eq category.id.to_s }

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
        select category.name, :from => "Категория"
        expect { click_button "Создать ссылку" }.to change(Link, :count).by(1)
      end
      it { should have_selector('div.alert.alert-success') }
      
    end
  end


end