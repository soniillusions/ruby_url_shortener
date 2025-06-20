require_relative '../test_helper'
require_relative '../../services/shortener'

describe Shortener do
  before do
    @user = User.create(telegram_id: '123')
    @url = 'example.com/foo'
  end

  describe '#find_or_create_for_user' do
    it 'creates a Link with normalized URL and 7-char code, and a UserLink' do
      link = Shortener.new(@user, @url).find_or_create_for_user

      _(link).must_be_instance_of Link
      _(link.original_url).must_equal 'http://example.com/foo'
      _(link.short_url.size).must_equal Shortener::CODE_LENGTH

      ul = UserLink.first(user_id: @user.id, link_id: link.id)
      _(ul).wont_be_nil
    end

    it 'idempotent for same user and url' do
      first  = Shortener.new(@user, @url).find_or_create_for_user
      second = Shortener.new(@user, @url).find_or_create_for_user

      _(first.id).must_equal second.id
      _(first.short_url).must_equal second.short_url

      count = UserLink.where(user_id: @user.id, link_id: first.id).count
      _(count).must_equal 1
    end

    it 'creates one short link when two users share same link' do
      user2 = User.create(telegram_id: '456')

      link1 = Shortener.new(@user, @url).find_or_create_for_user
      link2 = Shortener.new(user2, @url).find_or_create_for_user

      _(link1.id).must_equal link2.id
      _(UserLink.where(user_id: @user.id, link_id: link1.id)).must_be :any?
      _(UserLink.where(user_id: user2.id, link_id: link2.id)).must_be :any?
    end
  end
end