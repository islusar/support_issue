def t(*args)
  I18n.t(*args)
end

def real_sign_in(admin)
  visit '/admins'
  fill_in 'admin[email]', with: admin.email
  fill_in 'admin[password]', with: '12341234'
  click_on "Log in"
end

def click_and_wait(selector)
  click_on(selector)
  sleep 0.2
end