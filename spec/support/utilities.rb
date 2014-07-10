def sign_in(user)
  visit admin_signin_path
  fill_in "Введите email", with: user.email.upcase
  fill_in "Введите пароль", with: user.password
  click_button "Войти"
  # Вход без Capybara.
  # cookies[:remember_token] = user.remember_token
end