require 'spec_helper'
require 'launchy'

feature "User sees details on meetup page" do
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


  scenario "visit meetups show page" do
    visit '/meetups'
    click_link "Lapidary Society"
    # save_and_open_page
    expect(page).to have_content("My house")
    expect(page).to have_content("Come learn")
    expect(page).to have_content("fred")
  end


end
