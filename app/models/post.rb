class Post < ActiveRecord::Base
	has_many :replies
  validates :body, presence: true
  validates :body, length: {maximum: 300}
  after_initialize :defaults, unless: :persisted?

  def defaults
    self.vote ||= 0
  end
end
