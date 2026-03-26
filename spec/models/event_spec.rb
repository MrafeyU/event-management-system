require 'rails_helper'

RSpec.describe Event, type: :model do
  it "has none to begin with" do
    expect(Event.count).to eq 0
  end
  
  it "creates a valid event" do
    event = build(:event)
    puts "Organizer type: #{event.organizer.type}"
    expect(event).to be_valid
  end

  it "Must not validate if no date" do 
     expect(Event.new(event_date: nil)).not_to be_valid
  end

  it "must have a date ahead of today" do
    event = build(:event)
    puts "Organizer type: #{event.organizer.type}"
    expect(event.event_date).to be > Date.today
  end


  # testing associations
  it { should belong_to(:organizer) }

end