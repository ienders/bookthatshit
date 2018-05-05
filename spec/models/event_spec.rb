require 'spec_helper'

describe Event do
  describe "a collection of events" do
    before :each do
      @ian = Event.create!(
        date: '2013-01-01',
        description: 'Party Time!',
        booked_by_email: 'ian@example.com',
        booked_by_name: 'Ian'
      )
      @paco = Event.create!(
        date: '2013-03-01',
        description: 'BBQ!',
        booked_by_email: 'paco@example.com',
        booked_by_name: 'Paco McTaco'
      )
    end

    it "orders by start date" do
      expect(Event.ordered).to eq([ @ian, @paco ])
    end

    it "gets filtered by owner email" do
      expect(Event.owned_by('ian@example.com')).to eq([ @ian ])
    end
  end

end
