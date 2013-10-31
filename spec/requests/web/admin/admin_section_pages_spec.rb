require 'spec_helper'

describe "Admin section" do
  subject { page }

  let!(:user_admin) { FactoryGirl.create(:user) }
  before { sign_in(user_admin) }  

  describe "index" do
    before do
      visit admin_sections_path
    end

    it { should have_title('Admin section') }
    it { should have_selector('div', text: 'Администрирование разделов') }
    it { should have_link('Новый раздел...', href: new_admin_section_path) }

    describe "pagination" do
      before(:all) { 32.times { FactoryGirl.create(:section) } }
      after(:all) { Section.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each section" do
        Section.order('created_at DESC').paginate(page: 1).each do |section|
          page.should have_selector('td', text: section.name)
          page.should have_link('', href: edit_admin_section_path(section))
          page.should have_link('', href: admin_section_path(section))
        end
      end
    end
  end

  describe "deliting section" do
    let!(:section_for_delete) { FactoryGirl.create(:section) }
    before do
      visit admin_sections_path
    end

    it "should delete section" do
      expect { click_link('', href: admin_section_path(section_for_delete)) }.to change(Section, :count).by(-1)
      page.should have_selector('div.alert.alert-success')
    end
  end

  describe "edit" do
    let(:section) { FactoryGirl.create(:section) }
    before do
      visit edit_admin_section_path(section)
    end

    it { should have_title('Admin section update') }
    it { should have_selector('div', text: 'Обновление раздела') }
    it { should have_button('Сохранить изменения') }

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
      specify { section.reload.name.should == new_name }
    end
  end

  describe "create" do
    # let(:category) { FactoryGirl.create(:category) }
    before do
      visit new_admin_section_path
    end

    it { should have_title('Admin section create') }
    it { should have_selector('div', text: 'Создание нового раздела') }
    it { should have_button('Создать раздел') }

    describe "with invalid information" do
      before do
        fill_in "Название", with: ''
        expect { click_button "Создать раздел" }.not_to change(Section, :count)
      end
      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "new name" }
      before do
        fill_in "Название", with: new_name
        expect { click_button "Создать раздел" }.to change(Section, :count).by(1)
      end
      it { should have_selector('div.alert.alert-success') }
      
    end
  end

end