require "rails_helper"

RSpec.feature "New User Sign Up", type: :feature do
  before { visit new_user_registration_path }

  scenario "can sign up with correct Email and Password" do
    fill_in "user[email]", with: "landonkoo0207@gmail.com"
    fill_in "user[password]", with: "kpk47503"
    fill_in "user[password_confirmation]", with: "kpk47503"

    click_button 'Sign Up'
    expect(page).to have_content("Welcome! You have signed up successfully.")
  end

  context "can't sign up with incorrect inputs" do
    scenario "can't sign up with incorrect email" do
      
      fill_in "user[email]", with: "landonkoo0207"
      fill_in "user[password]", with: "kpk47503"
      fill_in "user[password_confirmation]", with: "kpk47503"

      click_button 'Sign Up'

      expect(page).to have_content("Email is invalid")
    end

    scenario "can't sign up with invalid password" do
      fill_in "user[email]", with: "landonkoo0207@gmail.com"
      fill_in "user[password]", with: "kpk47"
      fill_in "user[password_confirmation]", with: "kpk47"

      click_button 'Sign Up'

      expect(page).to have_content("Password is too short")
    end

  end
end