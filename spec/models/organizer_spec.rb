require 'rails_helper'

RSpec.describe Organizer, type: :model do
  it "is a subclass of User" do
    organizer = build(:organizer)
    expect(organizer).to be_a(User)
  end

  it "has the correct type" do
    organizer = build(:organizer)
    expect(organizer.type).to eq("Organizer")
  end
  
  it { should have_many(:events) }
end
