require "rails_helper"

RSpec.feature "Create Scrabble", type: :feature do
  let!(:valid_user) { FactoryBot.create(:random_valid_user) }

  before do
    visit new_user_session_path

    fill_in "user[email]", with: valid_user.email
    fill_in "user[password]", with: valid_user.password
    
    click_button 'Login'

    click_link 'Start New Scrabble'

    click_button 'Create Scrabble'

    fill_in "player[name]", with: "Landon"
    click_button 'Create Player'

    fill_in "player[name]", with: "Claudia"
    click_button 'Create Player'
  end

  context "Can create words for players under normal situations" do
    scenario "can create the first word of the game without checking any existing letter." do
      page.find("#word-input", visible: false).set("WALK")
      click_button 'Create Word'
    end

   scenario "can create a word after the first word of the game with existing letters." do
      page.find("#word-input", visible: false).set("WALK")
      click_button 'Create Word'
      
      page.find("#existing-letter-checkbox-0").click
      page.find("#word-input", visible: false).set("WALL")
      click_button 'Create Word'
    end
  end

  context "Can't create a word for impossible situations" do
    scenario "can't create a word without entering any letter" do
      click_button 'Create Word'
      expect(page).to have_content("Word must be at least 2 characters long.")
    end

    scenario "can't create a word of the game without any existing letter unless it's the first word for the game" do

      page.find("#word-input", visible: false).set("HELLO")
      click_button 'Create Word'

      page.find("#word-input", visible: false).set("ON")
      click_button 'Create Word'

      expect(page).to have_content("At least 1 \"Alreay Exists?\" letter must be checked. A new word cannot be created on its own unless it's the first word of the scrabble game")
    end

    scenario "can't create a word of the game using more letters than remaining letters" do

      page.find("#word-input", visible: false).set("ZZZ")
      click_button 'Create Word'

      expect(page).to have_content("There are not enough letters remaining to make up the word. Try again.")
    end
  end

  scenario "can pass a turn without entering any letter" do
    page.find("#word-input", visible: false).set("WALK")
    click_button 'Create Word'

    click_button 'Pass'

    expect(page).to have_content("New Word has been entered successfully.
")
  end
end