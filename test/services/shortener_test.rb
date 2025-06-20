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
  end
end