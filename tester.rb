require 'pry'

User.delete_all
Meetup.delete_all
Membership.delete_all

user = User.create(
  provider: "x",
  uid: "yz",
  username: "z",
  email: "jarlax1@.com",
  avatar_url: "a")
binding.pry
# user2 = User.create(
#   provider: "w",
#   uid: "e",
#   username: "r",
#   email: "jarlax2@t.com",
#   avatar_url: "https://avatars2.y.com/u/174824?v=3&s=400"
# )

meetup2  =  Meetup.create(
  name: "Audio Society",
  description: "Come learn about sounds",
  location: "s",
  creator: user
)

# meetup  =  Meetup.create(
#   name: "Lapidary Society",
#   description: "Come learn about gems",
#   location: "ser",
#   creator: user2
# )

# membership = Membership.new(
#   user: user,
#   meetup: meetup2
# )

# membership2 = Membership.new(
#   user: user2,
#   meetup: meetup
# )
