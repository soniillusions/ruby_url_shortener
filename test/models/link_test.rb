require_relative '../test_helper'
require_relative '../../models/link'

describe Link do
  let(:valid_url)   { 'https://example.com/path?x=1' }
  let(:invalid_url) { 'not a url' }
  let(:blank_url)   { '' }

  describe '#valid?' do
    it 'is valid with a well-formed URL' do
      link = Link.new(original_url: valid_url)
      _(link.valid?).must_equal true
      _(link.errors[:original_url]).must_be_nil
    end

    it 'is invalid with a malformed URL' do
      link = Link.new(original_url: invalid_url)
      _(link.valid?).must_equal false
      _(link.errors[:original_url]).must_include 'Invalid url format'
    end

    it 'is invalid with a blank URL' do
      link = Link.new(original_url: blank_url)
      _(link.valid?).must_equal false
      _(link.errors[:original_url]).must_include 'is not present'
    end
  end
end