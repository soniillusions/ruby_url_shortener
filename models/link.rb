class Link < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence [:original_url]
    validates_unique [:original_url]
    original_url_format
  end

  private

  def original_url_format
    return if original_url.to_s.strip.empty?

    begin
      uri = URI.parse(original_url)
      errors.add(:original_url, 'Invalid url format') if uri.host.nil?
    rescue URI::InvalidURIError
      errors.add(:original_url, 'Invalid url format')
    end
  end
end
