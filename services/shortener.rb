class Shortener
  CODE_LENGTH = 7

  def initialize(user, original_url, link_model: Link, user_link_model: UserLink)
    @user = user
    @original_url = original_url
    @link_model = link_model
    @user_link_model = user_link_model
  end

  def find_or_create_for_user
    url = normalize_url(original_url)

    link = link_model.find_or_create(original_url: url) do |l|
      l.short_url = generate_unique_code
    end

    user_link_model.find_or_create(user_id: user.id, link_id: link.id)

    link
  end

  private

  attr_reader :user, :original_url, :link_model, :user_link_model

  def generate_unique_code
    loop do
      code = SecureRandom.uuid[0, CODE_LENGTH]
      break code unless link_model.first(original_url: code)
    end
  end

  def normalize_url(str)
    uri = URI.parse(str.strip)
    uri = URI.parse("http://#{str.strip}") unless uri.scheme
    uri.path = uri.path.chomp('/')
    uri.to_s
  rescue URI::InvalidURIError
    raise ArgumentError, "Invalid URL: #{str}"
  end
end
