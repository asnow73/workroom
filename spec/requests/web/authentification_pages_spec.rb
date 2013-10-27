require 'spec_helper'

describe "Authentification" do
  subject { page }

  describe "signin page" do
    before { visit admin_signin_path }

    it { should have_content('Вход в административную панель') }
    it { should have_title('Sign in') }

    describe "with invalid information" do
      before { click_button "Войти" }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Домой" }
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
end