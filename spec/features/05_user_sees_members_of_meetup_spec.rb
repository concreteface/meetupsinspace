require 'spec_helper'
require 'launchy'

feature "User can see the members of a meetup and join" do
  let!(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "fred",
      email: "fred@dead.com",
      avatar_url: "http://yo.com"
    )
  end
  let!(:user2) do
    User.create(
      provider: "github",
      uid: "2",
      username: "fred2",
      email: "fred2@dead.com",
      avatar_url: "http://yo.com"
    )
  end
  let!(:user3) do
    User.create(
      provider: "github",
      uid: "3",
      username: "fred3",
      email: "fred3@dead.com",
      avatar_url: "http://yo3.com"
    )
  end
  let!(:user4) do
    User.create(
      provider: "github",
      uid: "4",
      username: "fred4",
      email: "fred4@dead.com",
      avatar_url: "http://yo4.com"
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
      user: user2,
      meetup: meetup
    )
  end


  scenario "visit meetup show page" do
    visit "/meetups/#{meetup.id}"
    expect(page).to have_content('fred2')
    expect(page).to have_css("img[src*='http://yo.com']")
  end

  scenario "visit meetup show page while signed in" do
    visit "/meetups"
    sign_in_as user3
    visit "/meetups/#{meetup.id}"
    click_button 'Join Meetup'
    expect(page).to have_content('You joined the meetup')
    expect(page).to have_css("img[src*='http://yo3.com']")
    click_link "Sign Out"
    visit "/meetups"
    sign_in_as user4
    visit "/meetups/#{meetup.id}"
    click_button 'Join Meetup'
    expect(page).to have_content('You joined the meetup')
    expect(page).to have_css("img[src*='http://yo4.com']")
  end

  scenario "user tries to join meetup when already a member" do
    visit "/meetups"
    sign_in_as user3
    visit "/meetups/#{meetup.id}"
    click_button 'Join'
    click_button 'Join'
    expect(page).to have_content('You are already a member')
  end

  scenario "visit meetup show page while not signed in" do
    visit "/meetups/#{meetup.id}"
    click_button 'Join'
    expect(page).to have_content('You must sign in first')
  end


end
