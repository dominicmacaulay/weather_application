require "rails_helper"

class LocationTest < ActiveSupport::TestCase
  RSpec.describe Location, :type => :model do
    it "is valid with valid attributes" do
      location = Location.new(name: "Home", ip: "8.8.8.8")
      expect(location).to be_valid
    end
  
    it "is not valid without a name" do
      location = Location.new(name: nil, ip: "8.8.8.8")
      expect(location).not_to be_valid
    end
    it "is not valid without an IP Address" do
      location = Location.new(name: "Home", ip: nil)
      expect(location).not_to be_valid
    end
    it "is not valid without a valid IP" do 
      location = Location.new(name: "Home", ip: "8.8.8")
      expect(location).not_to be_valid
    end
  end
end
