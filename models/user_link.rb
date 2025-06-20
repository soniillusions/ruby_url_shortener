class UserLink < Sequel::Model(:user_links)
  many_to_one :user
  many_to_one :link
end