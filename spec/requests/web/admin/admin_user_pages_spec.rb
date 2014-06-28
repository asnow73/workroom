require 'spec_helper'

describe "Admin user" do
  subject { page }
  
  let!(:user_admin) { FactoryGirl.create(:user) }
  before { sign_in(user_admin) }

  describe "index" do
    
    before do
      visit admin_users_path
    end

    it { should have_title("Admin user") }
    it { should have_selector("div", text: "Администрирование пользователей") }
    it { should have_link("Новый пользователь...", href: new_admin_user_path) }

    describe "pagination" do
      before(:all) do
        35.times { FactoryGirl.create(:user) }
      end
      after(:all) do
        User.delete_all
      end

      it { should have_selector('div.pagination') }

      it "should list each post" do
        User.order('created_at DESC').paginate(page: 1).each do |user|
          page.should have_selector('td', text: user.name)
          page.should have_link('', href: edit_admin_user_path(user))
          page.should have_link('', href: admin_user_path(user))
        end
      end

    end
  end  

  describe "deleting user" do
    let!(:user_for_delete) { FactoryGirl.create(:user) }
    before do
      visit admin_users_path
    end

    it "should delete user" do
      expect { click_link('', href: admin_user_path(user_for_delete)) }.to change(User, :count).by(-1)
      page.should have_selector('div.alert.alert-success')
    end

    it "should not delete current user" do
      expect { click_link('', href: admin_user_path(user_admin)) }.to_not change(User, :count)
      page.should have_selector('div.alert.alert-danger')
    end
  end

  describe "edit" do
    let!(:user) { FactoryGirl.create(:user) }

    before do
      visit edit_admin_user_path(user)
    end

    it { should have_title('Admin user update') }
    it { should have_selector('div', text: 'Обновление пользователя') }
    it { should have_button('Сохранить изменения') }

    describe "with invalid information" do
      describe "without name" do
        before do
          fill_in "Имя", with: ''
          click_button "Сохранить изменения"
        end
        it { should have_content('error') }
      end

      describe "without email" do
        before do
          fill_in "e-mail", with: ''
          click_button "Сохранить изменения"
        end
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      let(:new_name)  { "new name" }
      before do
        fill_in "Имя", with: new_name
        fill_in "Пароль", with: "password"
        fill_in "Подтверждение пароля", with: "password"
        click_button "Сохранить изменения"
      end
      it { should have_selector('div.alert.alert-success') }
      specify { user.reload.name.should == new_name }
    end
  end

  describe "create" do
    before do
      visit new_admin_user_path
    end

    it { should have_title('Admin user create') }
    it { should have_selector('div', text: 'Создание нового пользователя') }
    it { should have_button('Создать пользователя') }

    describe "with invalid information" do
      describe "without name" do     
        before do
          fill_in "Имя", with: ''
          expect { click_button "Создать пользователя" }.not_to change(User, :count)
        end
        it { should have_content('error') }
      end

      describe "without email" do     
        before do
          fill_in "e-mail", with: ''
          expect { click_button "Создать пользователя" }.not_to change(User, :count)
        end
        it { should have_content('error') }
      end

    end

    describe "with valid information" do
      before do
        fill_in "Имя", with: "new name"
        fill_in "e-mail", with: "email@email.ru"
        fill_in "Пароль", with: "password"
        fill_in "Подтверждение пароля", with: "password"
        expect { click_button "Создать пользователя" }.to change(User, :count).by(1)
      end
      it { should have_selector('div.alert.alert-success') }      
    end
  end

end