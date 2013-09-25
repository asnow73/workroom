require 'spec_helper'

describe "Admin category" do

  subject { page }

  describe "index" do
    before do
      visit admin_categories_path
    end

    it { should have_title('Admin category') }
    it { should have_selector('h1', text: 'Администрирование категорий') }
    it { should have_link('Новая категория...', href: new_admin_category_path) }

    describe "pagination" do
      before(:all) { 32.times { FactoryGirl.create(:category) } }
      after(:all) { Category.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each category" do
        Category.order('created_at DESC').paginate(page: 1).each do |category|
          page.should have_selector('td', text: category.name)
          page.should have_link('', href: edit_admin_category_path(category))
          page.should have_link('', href: admin_category_path(category))
        end
      end
    end
  end

  describe "deliting category" do
    before do
      FactoryGirl.create(:category, name: "Category1")
      FactoryGirl.create(:category, name: "Category2")
      visit admin_categories_path
    end

    it "should delete category" do
      expect { click_link('', href: admin_category_path(Category.first)) }.to change(Category, :count).by(-1)
      page.should have_selector('div.alert.alert-success')
    end
  end

  describe "edit" do
    let(:category) { FactoryGirl.create(:category) }
    before do
      visit edit_admin_category_path(category)
    end

    it { should have_title('Admin category update') }
    it { should have_selector('h1', text: 'Обновление категории') }
    it { should have_button('Сохранить изменения') }

    describe "with invalid information" do
      before do
        fill_in "Имя", with: ''
        click_button "Сохранить изменения"
      end
      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "new name" }
      before do
        fill_in "Имя", with: new_name
        click_button "Сохранить изменения"
      end
      it { should have_selector('div.alert.alert-success') }
      specify { category.reload.name.should == new_name }
    end
  end

  describe "create" do
    # let(:category) { FactoryGirl.create(:category) }
    before do
      visit new_admin_category_path
    end

    it { should have_title('Admin category create') }
    it { should have_selector('h1', text: 'Создание новой категории') }
    it { should have_button('Создать категорию') }

    describe "with invalid information" do
      before do
        fill_in "Имя", with: ''
        expect { click_button "Создать категорию" }.not_to change(Category, :count)
      end
      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "new name" }
      before do
        fill_in "Имя", with: new_name
        expect { click_button "Создать категорию" }.to change(Category, :count).by(1)
      end
      it { should have_selector('div.alert.alert-success') }
      
    end
  end

end