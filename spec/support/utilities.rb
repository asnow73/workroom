def sign_in(user)
  visit admin_signin_path
  fill_in "e-mail", with: user.email.upcase
  fill_in "Пароль", with: user.password
  click_button "Войти"
  # Вход без Capybara.
  cookies[:remember_token] = user.remember_token
end