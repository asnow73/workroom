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
      before(:all) do
        32.times { FactoryGirl.create(:category) }
      end
      after(:all) do
        Category.delete_all
        Section.delete_all
      end

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
    let!(:category_for_delete) { FactoryGirl.create(:category) }
    before do
      visit admin_categories_path
    end

    it "should delete category" do
      expect { click_link('', href: admin_category_path(category_for_delete)) }.to change(Category, :count).by(-1)
      page.should have_selector('div.alert.alert-success')
    end
  end

  describe "edit" do
    let!(:category) { FactoryGirl.create(:category) }
    before do
      visit edit_admin_category_path(category)
    end

    it { should have_title('Admin category update') }
    it { should have_selector('h1', text: 'Обновление категории') }
    it { should have_button('Сохранить изменения') }
    it { find_field('category_section_id').value.should eq category.section.id.to_s }

    describe "with invalid information" do
      before do
        fill_in "Название", with: ''
        click_button "Сохранить изменения"
      end
      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "new name" }
      before do
        fill_in "Название", with: new_name
        click_button "Сохранить изменения"
      end
      it { should have_selector('div.alert.alert-success') }
      specify { category.reload.name.should == new_name }
    end
  end

  describe "create" do
    let!(:section) { FactoryGirl.create(:section) }
    before do
      visit new_admin_category_path
    end

    it { should have_title('Admin category create') }
    it { should have_selector('h1', text: 'Создание новой категории') }
    it { should have_button('Создать категорию') }
    it { find_field('category_section_id').value.should eq section.id.to_s }

    describe "with invalid information" do
      before do
        fill_in "Название", with: ''
        expect { click_button "Создать категорию" }.not_to change(Category, :count)
      end
      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "new name" }
      before do
        fill_in "Название", with: new_name
        select section.name, :from => "Раздел"
        expect { click_button "Создать категорию" }.to change(Category, :count).by(1)
      end
      it { should have_selector('div.alert.alert-success') }
      
    end
  end

end