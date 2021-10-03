class Notification < ApplicationRecord
  belongs_to :visitor, class_name: 'User'
  belongs_to :visited, class_name: 'User'
  
  belongs_to :post, optional: true
  belongs_to :post_comment, optional: true
end
