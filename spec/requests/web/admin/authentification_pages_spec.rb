require 'spec_helper'

describe "Authentification" do
  subject { page }

  describe "signin page" do
    before { visit admin_signin_path }

    it { should have_content('Вход в административную панель') }
    it { should have_title('Sign in') }

    describe "with invalid information" do
      before do
        fill_in "e-mail", with: "user@user.ru"
        fill_in "Пароль", with: "wrongpassword"
        click_button "Войти"
      end
      it { should have_selector('div.alert.alert-error') }

      describe "after visiting another page" do
        before { click_link "Главная" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "e-mail", with: user.email.upcase
        fill_in "Пароль", with: user.password
        click_button "Войти"
      end

      it { should have_link('Выйти',    href: admin_signout_path) }
      it { should_not have_link('Войти', href: admin_signin_path) }

      describe "followed by signout" do
        before { click_link "Выйти" }
        it { should have_button('Войти') }
      end
    end
  end

  describe "authorization" do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      let!(:post_1) { FactoryGirl.create(:post) }

      describe "in the posts controller" do
        describe "submitting to the create action" do
          before { post admin_posts_path }
          specify { expect(response).to redirect_to(admin_signin_path) }
        end

        describe "submitting to the destroy action" do
          # before { delete admin_posts_path(post_1) }
          before { delete "admin/posts/" << post_1.id.to_s }
          specify { expect(response).to redirect_to(admin_signin_path) }
        end
      end
    end
  end
end