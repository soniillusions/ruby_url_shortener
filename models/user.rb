class User < Sequel::Model
  plugin :validation_helpers
  one_to_many :user_links
  many_to_many :links, join_table: :user_links

  def validate
    super
    validates_presence :telegram_id
    validates_unique :telegram_id
  end
end
