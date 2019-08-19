require "rails_helper"

RSpec.feature "Create Scrabble", type: :feature do
  let!(:valid_user) { FactoryBot.create(:random_valid_user) }

  before do
    visit new_user_session_path

    fill_in "user[email]", with: valid_user.email
    fill_in "user[password]", with: valid_user.password
    
    click_button 'Login'

    click_link 'Start New Scrabble'
  end

  scenario "Can create a scrabble" do
    click_button 'Create Scrabble'
    expect(page).to have_content("Let's play Scrabble!")

    fill_in "player[name]", with: "Landon"
    click_button 'Create Player'
    expect(page).to have_content("New Player has been created successfully")

    fill_in "player[name]", with: "Claudia"
    click_button 'Create Player'
    
    expect(page).to have_content("New Player has been created successfully")

    expect(page).to have_content("Turn 1: Enter a New Word, " + Player.first.name)
  end
end