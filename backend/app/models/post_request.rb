class PostRequest < ApplicationRecord
  belongs_to :user, :counter_cache => true
  searchkick
end
