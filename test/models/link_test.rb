require_relative '../test_helper'
require_relative '../../models/link'

describe Link do
  before do
    DB.tables.each { |t| DB[t].truncate(cascade: true) }
  end

  let(:valid_url)   { 'https://example.com/path?x=1' }
  let(:invalid_url) { 'not a url' }
  let(:blank_url)   { '' }

  describe '#valid?' do
    it 'is valid with a well-formed URL' do
      link = Link.new(original_url: valid_url)
      _(link.valid?).must_equal true
      _(link.save).must_be_instance_of Link
    end

    it 'is invalid with a malformed URL' do
      link = Link.new(original_url: invalid_url)
      _(link.valid?).must_equal false
      link.errors[:original_url].must_include 'Invalid url format'
    end
  end
end