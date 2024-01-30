class Location < ApplicationRecord
    validates :name, presence: true
    validates :ip, presence: true
end
