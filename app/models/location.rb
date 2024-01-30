class Location < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    validates :ip, presence: true, ipaddr: true, uniqueness: true
end
