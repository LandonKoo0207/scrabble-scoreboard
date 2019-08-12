require "rails_helper"

RSpec.feature "User Sign In", type: :feature do
  before do
    visit new_user_session_path
  end

  let!(:valid_user) { FactoryBot.create(:random_valid_user) }

  scenario "can sign in with correct Email and Password" do
    fill_in "user[email]", with: valid_user.email
    fill_in "user[password]", with: valid_user.password
    
    click_button 'Login'
    expect(page).to have_content("logged in successfully.")
  end

  scenario "can't sign in with an empty password" do
    fill_in "user[password]", with: valid_user.password
    
    click_button 'Login'
    expect(page).to have_content("Invalid Email or password.")
  end

  scenario "can't sign in with an empty password" do
    fill_in "user[email]", with: valid_user.email
    
    click_button 'Login'
    expect(page).to have_content("Invalid Email or password.")
  end

  scenario "can't sign in with non-existing email" do
    fill_in "user[email]", with: valid_user.email + "11"
    fill_in "user[password]", with: valid_user.password
    
    click_button 'Login'
    expect(page).to have_content("Invalid Email or password.")
  end

  scenario "can't sign in with an incorrect password" do
    fill_in "user[email]", with: valid_user.email
    fill_in "user[password]", with: valid_user.password + "zz"
    
    click_button 'Login'
    expect(page).to have_content("Invalid Email or password.")
  end
end