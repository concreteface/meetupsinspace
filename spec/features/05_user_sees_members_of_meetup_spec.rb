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
      uid: "1",
      username: "fred2",
      email: "fred2@dead.com",
      avatar_url: "http://yo.com"
    )
  end
  let!(:user3) do
    User.create(
      provider: "github",
      uid: "1",
      username: "fred3",
      email: "fred3@dead.com",
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
      user: user2,
      meetup: meetup
    )
  end


  scenario "visit meetup show page" do
    visit '/meetups/1'
    expect(page).to have_content('fred2')
    have_css("img[src*='http://yo.com']")
  end

  scenario "visit meetup show page while not signed in" do
    visit '/meetups/1'
    click_button 'Join'
    expect(page).to have_content('You must sign in first')
  end

  scenario "visit meetup show page while signed in" do
    visit '/meetups/1'
    sign_in_as user3
    click_button 'Join'
    expect(page).to have_content('You joined the meetup')
    expect(page).to have_content('fred3')
  end
end
