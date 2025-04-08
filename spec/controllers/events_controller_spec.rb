# spec/controllers/events_controller_spec.rb
require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let!(:place) { create(:place) }
  let!(:event_a) { create(:event, name: 'Event A', starts_at: 1.day.from_now, place: place) }
  let!(:event_b) { create(:event, name: 'Event B', starts_at: 2.days.from_now, place: place) }

  describe 'GET #index' do
    it 'assigns @events sorted by starts_at ascending by default' do
      get :index
      expect(assigns(:events)).to eq([event_a, event_b])
    end

    it 'sorts events by name in ascending order' do
      get :index, params: { sort: 'name', direction: 'asc' }
      expect(assigns(:events)).to eq([event_a, event_b])
    end

    it 'sorts events by starts_at in descending order' do
      get :index, params: { sort: 'starts_at', direction: 'desc' }
      expect(assigns(:events)).to eq([event_b, event_a])
    end

    it 'handles invalid sort column gracefully' do
      get :index, params: { sort: 'invalid_column', direction: 'asc' }
      expect(assigns(:events)).to eq([event_a, event_b])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested event to @event' do
      get :show, params: { id: event_a.id }
      expect(assigns(:event)).to eq(event_a)
    end
  end

  describe 'GET #new' do
    it 'assigns a new event to @event' do
      get :new
      expect(assigns(:event)).to be_a_new(Event)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new event' do
        expect do
          post :create, params: { event: attributes_for(:event).merge(place_id: place.id) }
        end.to change(Event, :count).by(1)
      end

      it 'redirects to the new event' do
        post :create, params: { event: attributes_for(:event).merge(place_id: place.id) }
        expect(response).to redirect_to(Event.last)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new event' do
        expect do
          post :create, params: { event: attributes_for(:event, name: nil) }
        end.not_to change(Event, :count)
      end

      it 're-renders the new template' do
        post :create, params: { event: attributes_for(:event, name: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the event' do
        patch :update, params: { id: event_a.id, event: { name: 'Updated Event' } }
        event_a.reload
        expect(event_a.name).to eq('Updated Event')
      end

      it 'redirects to the updated event' do
        patch :update, params: { id: event_a.id, event: { name: 'Updated Event' } }
        expect(response).to redirect_to(event_a)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the event' do
        patch :update, params: { id: event_a.id, event: { name: nil } }
        event_a.reload
        expect(event_a.name).to eq('Event A')
      end

      it 're-renders the edit template' do
        patch :update, params: { id: event_a.id, event: { name: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the event' do
      expect do
        delete :destroy, params: { id: event_a.id }
      end.to change(Event, :count).by(-1)
    end

    it 'redirects to events#index' do
      delete :destroy, params: { id: event_a.id }
      expect(response).to redirect_to(events_path)
    end
  end
end
