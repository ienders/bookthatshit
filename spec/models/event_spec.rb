require 'spec_helper'

describe Event do
  describe "a collection of events" do
    ian = Event.create!(
      starts_at: '2013-01-01',
      ends_at: '2013-01-03',
      description: 'Party Time!',
      booked_by_email: 'ian@example.com',
      booked_by_name: 'Ian'
    )
    paco = Event.create!(
      starts_at: '2013-03-01',
      ends_at: '2013-03-03',
      description: 'BBQ!',
      booked_by_email: 'paco@example.com',
      booked_by_name: 'Paco McTaco'
    )

    it "orders by start date" do
      expect(Event.ordered).to eq([ ian, paco ])
    end

    it "gets filtered by owner email" do
      expect(Event.owned_by('ian@example.com')).to eq([ ian ])
    end
  end

  it "should merge in email and name from the session" do
    event = Event.new_with_session({ starts_at: Date.today }, { email: 'ian@example.com', name: 'Ian' })
    expect(event.booked_by_email).to eq('ian@example.com')
    expect(event.booked_by_name).to eq('Ian')
  end

  it "should not be possible to update booked by email or name" do
    event = Event.new(
      starts_at: Date.today,
      ends_at: Date.today + 1.day,
      booked_by_email: 'ian@example.com',
      booked_by_name: 'Ian'
    )
    event.update_safe_attributes booked_by_email: 'paco@example.com', booked_by_name: 'Paco McTaco'
    expect(event.booked_by_email).to eq('ian@example.com')
    expect(event.booked_by_name).to eq('Ian')
  end

end
