class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.random
    find(pluck(:id).sample)
  end
end
