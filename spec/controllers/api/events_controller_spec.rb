require 'spec_helper'

describe Api::EventsController, type: :controller do

  before :each do
    request.accept = "application/json"
  end

  describe "an unauthenticated user" do
    describe "GET index" do
      it "should return a 401" do
        get :index
        expect(response.status).to eq(401)
      end
    end
  end

  describe "a logged in user" do
    
    before :each do
      session[:email] = 'ian@example.com'
      session[:name] = 'Ian'
    end

    describe "GET index" do
      let(:events) { [ double('event') ] }

      before :each do
        allow(Event).to receive(:ordered).and_return events  
      end

      it "responds with a nice 200" do
        get :index
        expect(response.status).to eq(200)
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end

      it "loads events into @events" do
        get :index
        expect(assigns[:events]).to eq(events)
      end
    end

    describe "GET show" do
      it "tosses a 404 if a bad ID is presented" do
        allow(Event).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
        get :show, params: { id: 1 }
        expect(response.status).to eq(404)
      end

      describe "with a good ID" do
        let(:event) { double('event', id: 1) }

        before :each do
          allow(Event).to receive(:find).and_return event
        end

        it "responds with a 200 if the ID is good" do
          get :show, params: { id: event.id }
          expect(response.status).to eq(200)
        end

        it "renders the show template" do
          get :show, params: { id: event.id }
          expect(response).to render_template('show')
        end

        it "loads the event into @event" do
          get :show, params: { id: event.id }
          expect(assigns(:event)).to eq(event)
        end
      end
    end

    describe "POST create" do
      describe "with bad data" do
        it "responds with a 422" do
          allow_any_instance_of(Event).to receive(:save).and_return(false)
          post :create, params: { event: {} }
          expect(response.status).to eq(422)
        end
      end

      describe "with good data" do
        before :each do
          allow_any_instance_of(Event).to receive(:save).and_return(true)
        end

        it "responds with a 200" do
          post :create, params: { event: { description: 'hey' } }
          expect(response.status).to eq(200)
        end

        it "renders the show template" do
          post :create, params: { event: { description: 'yo' } }
          expect(response).to render_template('show')
        end

        it "loads the created event into @event" do
          post :create, params: { event: { description: 'cool' } }
          expect(assigns(:event)).to be_an_instance_of(Event)
        end
      end
    end

    describe "PUT update" do
      it "tosses a 404 if a bad ID is presented" do
        allow(Event).to receive_message_chain(:owned_by, :find).and_raise(ActiveRecord::RecordNotFound)
        put :update, params: { id: 1, event: {} }
      end

      describe "with good data" do
        let(:event) { double('event', update: true) }

        before :each do
          allow(Event).to receive_message_chain(:owned_by, :find).and_return(event)
        end

        it "responds with a 200" do
          put :update, params: { id: 1, event: { description: 'yo' } }
          expect(response.status).to eq(200)
        end

        it "renders the show template" do
          put :update, params: { id: 1, event: { description: 'hey' } }, format: :json
          expect(response).to render_template('show')
        end

        it "loads the updated event into @event" do
          put :update, params: { id: 1, event: {} }
          expect(assigns(:event)).to eq(event)
        end
      end
    end

    describe "DELETE destroy" do
      it "will check for events owned by logged in user" do
        allow(Event).to receive(:owned_by).with('ian@example.com') do
          double('owned_events').tap do |proxy|
            allow(proxy).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
          end
        end

        delete :destroy, params: { id: 1 }

        expect(response.status).to eq(404)
      end

      it "renders an empty body on success" do
        allow(Event).to receive_message_chain(:owned_by, :find).and_return(double('event', destroy: true ))

        delete :destroy, params: { id: 1 }

        expect(response.status).to eq(204)
        expect(response.body).to eq('')
      end
    end
  end

end
