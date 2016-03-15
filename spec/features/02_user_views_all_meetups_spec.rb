require 'spec_helper'
require 'launchy'

feature "User visits meetup page" do
  # user = FactoryGirl.create(:user)
  # meetup = FactoryGirl.create(:meetup)
  let!(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    ) 
  end
  let!(:meetup) do
    Meetup.create(
      name: "Lapidary Society",
      description: "Come learn about gems and stuff",
      location: "My house",
      creator_id: "1"
    )
  end

  let!(:membership) do
    Membership.create(
      user: user,
      meetup: meetup
    )
  end


  scenario "visit meetups page" do
    visit '/meetups'
    expect(page).to have_content("Meetups")
    expect(page).to have_content("Lapidary")
  end

  
end
