class Item < ApplicationRecord
  belongs_to :todo

  validates_presence_of :name

  enum state: { in_progress: 0, on_hold: 1, deleted: 2 }
end
