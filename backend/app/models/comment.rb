class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :forum, :counter_cache => true
end
