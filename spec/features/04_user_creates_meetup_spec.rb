require 'spec_helper'
require 'launchy'

feature "User can create a new meetup" do
  let!(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "fred",
      email: "fred@dead.com",
      avatar_url: "http://yo.com"
    )
  end
  let!(:meetup) do
    Meetup.create(
      name: "Lapidary Society",
      description: "Come learn about gems and stuff",
      location: "My house",
      creator_id: "#{user.id}"
    )
  end

  let!(:membership) do
    Membership.create(
      user: user,
      meetup: meetup
    )
  end


  scenario "visit meetups page and click link" do
    visit '/meetups'
    expect(page).to have_link('Create Meetup')
  end

  scenario "visit new meetups page and find form" do
    # save_and_open_page
    visit '/meetups'
    sign_in_as user
    click_link "Create Meetup"
    expect(page).to have_content('Enter meetup details:')
    expect(page).to have_selector("input[placeholder='Name']")
    expect(page).to have_selector("input[placeholder='Location']")
    expect(page).to have_selector("input[placeholder='Description']")
  end

  scenario "user fills in form with correct values" do
    visit '/meetups'
    sign_in_as user
    click_link "Create Meetup"
    fill_in "Name", with: "Bowling"
    fill_in "Location", with: "Downtown"
    fill_in "Description", with: "Roll some balls!"
    click_button 'Submit'
    expect(page).to have_content("Meetup created!")
    expect(page).to have_content("Bowling")
    expect(page).to have_content("Downtown")
    expect(page).to have_content("Roll")
  end
  scenario "user enters invalid form" do
    visit '/meetups'
    sign_in_as user
    click_link "Create Meetup"
    fill_in "Name", with: "Bowling"
    fill_in "Description", with: "Roll some balls!"
    click_button 'Submit'
    expect(page).to have_content("can't be blank")
    
  end
end
