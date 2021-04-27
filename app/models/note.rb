class Note < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true
  validates :slug, presence: true, uniqueness: true
end
