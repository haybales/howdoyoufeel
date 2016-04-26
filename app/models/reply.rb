class Reply < ActiveRecord::Base
	belongs_to :post
  validates :body, presence: true
  validates :body, length: {maximum: 300}
end
