class Link < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence [:original_url]

    return if original_url.blank?

    begin
      uri = URI.parse(original_url)
      if uri.host.nil?
        errors.add(:original_url, "Invalid url format")
      end
    rescue URI::InvalidURIError
      errors.add(:original_url, "Invalid url format")
    end
  end
end