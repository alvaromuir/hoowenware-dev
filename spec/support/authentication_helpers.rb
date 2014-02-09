# integration testing authentication helpers

module AuthenticationHelpers
	def sign_in_as!(user)
	visit '/users/sign_in'
	within ('header') do
		fill_in "Email", with: user.email
		fill_in "Password", with: user.password
	end
	within '#signIn' do
		click_button 'Log In'
	end
	expect(page).to have_content("Signed in successfully.")
	end
end

module AuthHelpers
	def sign_in(user)
		session[:user_id] = user.id
	end
end


RSpec.configure do |c|
	c.include AuthenticationHelpers, type: :feature
	c.include AuthHelpers, type: :controller
end