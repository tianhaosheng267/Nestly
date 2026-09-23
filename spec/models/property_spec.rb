

require 'rails_helper'

RSpec.describe Property, type: :model do
  let(:landlord_1) do
   User.create!(name: Faker::Name.name, email: Faker::Internet.email, password: "cse3901!")
  end

  subject { Property.new(address: "496  Charlotte Street", city: "Columbus", state: "OH", landlord_id: landlord_1.id, zip: "48932", monthly_rent: 3000, num_bathrooms: 3, num_bedrooms: 2)}

  context "basic minimum of correct attributes" do
    it "is valid" do
      expect(subject).to be_valid
    end
  end

  context "one of the required attributes is missing" do
    it "is not valid without address" do
      subject.address = nil
      expect(subject).to_not be_valid
    end
    it "is not valid without zip" do
      subject.zip = nil
      expect(subject).to_not be_valid
    end
    it "is not valid without city" do
      subject.city = nil
      expect(subject).to_not be_valid
    end
    it "is not valid without monthly rent" do
      subject.monthly_rent = nil
      expect(subject).to_not be_valid
    end
    it "is not valid without landlord_id" do
      subject.landlord_id = nil
      expect(subject).to_not be_valid
    end
     it "is not valid without num_bathrooms" do
      subject.num_bathrooms = nil
      expect(subject).to_not be_valid
    end
    it "is not valid without num_bedrooms" do
      subject.num_bedrooms = nil
      expect(subject).to_not be_valid
    end
    
    context "attributes do not pass validation" do
    it "is not valid with negative monthly rent" do
      subject.monthly_rent = -100
      expect(subject).to_not be_valid
    end
    it "is not valid with unreasonable monthly rent" do
      subject.monthly_rent = 50
      expect(subject).to_not be_valid
    end
    it "is not valid with negative number of bedrooms" do
      subject.num_bedrooms = -1
      expect(subject).to_not be_valid
    end
    it "is not valid with negative number of bathrooms" do
      subject.num_bathrooms = -1
      expect(subject).to_not be_valid
    end
    it "is not valid with letters in zip" do
      subject.zip = "9304P"
      expect(subject).to_not be_valid
    end
  end
end
end
