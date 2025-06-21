require 'minitest/autorun'
require 'sequel'
require_relative '../../models/user'
require_relative '../../models/link'

describe User do
  it 'is valid with a telegram_id' do
    user = User.new(telegram_id: '12345')
    _(user.valid?).must_equal true
  end

  it 'is invalid without a telegram_id' do
    user = User.new
    refute user.valid?
    _(user.errors[:telegram_id]).must_include 'is not present'
  end

  it 'is invalid with a duplicate telegram_id' do
    User.create(telegram_id: '12345')
    duplicate = User.new(telegram_id: '12345')

    refute duplicate.valid?
    _(duplicate.errors[:telegram_id]).must_include 'is already taken'
  end

  it 'has a user_links association' do
    user = User.create(telegram_id: '111')
    _(user.user_links).must_equal []
  end

  it 'has a links many-to-many association through user_links' do
    user = User.create(telegram_id: '222')
    link = Link.create(original_url: 'https://example.com')

    user.add_link(link)
    _(user.links).must_include link
  end
end
