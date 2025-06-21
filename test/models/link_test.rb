require_relative '../test_helper'
require_relative '../../models/link'

describe Link do
  let(:valid_url)   { 'https://example.com/path?x=1' }
  let(:invalid_url) { 'not a url' }
  let(:blank_url)   { '' }

  describe 'validation' do
    describe 'URL format validation' do
      it 'accepts valid URL' do
        link = Link.new(original_url: valid_url)
        _(link.valid?).must_equal true
        _(link.errors[:original_url]).must_be_nil
      end

      it 'rejects invalid URL format' do
        link = Link.new(original_url: invalid_url)
        _(link.valid?).must_equal false
        _(link.errors[:original_url]).must_include 'Invalid url format'
      end

      it 'requires URL to be present' do
        link = Link.new(original_url: blank_url)
        _(link.valid?).must_equal false
        _(link.errors[:original_url]).must_include 'is not present'
      end
    end

    describe 'uniqueness validation' do
      it 'cannot create two identical original urls' do
        link1 = Link.new(original_url: valid_url)
        link1.short_url = 'abcdefg'
        saved = link1.save

        _(saved).must_be_instance_of Link
        _(saved.id).wont_be_nil

        link2 = Link.new(original_url: valid_url)
        link2.short_url = 'abcdefg'
        _(link2.valid?).must_equal false
      end
    end
  end
end
