# spec/controllers/places_controller_spec.rb
require 'rails_helper'

RSpec.describe PlacesController, type: :controller do
  let!(:place_a) { create(:place, name: 'Place A') }
  let!(:place_b) { create(:place, name: 'Place B') }

  describe 'GET #index' do
    it 'assigns @places' do
      get :index
      expect(assigns(:places)).to contain_exactly(place_a, place_b)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested place to @place' do
      get :show, params: { id: place_a.id }
      expect(assigns(:place)).to eq(place_a)
    end

    it 'renders the show template' do
      get :show, params: { id: place_a.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns a new place to @place' do
      get :new
      expect(assigns(:place)).to be_a_new(Place)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested place to @place' do
      get :edit, params: { id: place_a.id }
      expect(assigns(:place)).to eq(place_a)
    end

    it 'renders the edit template' do
      get :edit, params: { id: place_a.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new place' do
        expect {
          post :create, params: { place: attributes_for(:place) }
        }.to change(Place, :count).by(1)
      end

      it 'redirects to the new place' do
        post :create, params: { place: attributes_for(:place) }
        expect(response).to redirect_to(Place.last)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new place' do
        expect {
          post :create, params: { place: attributes_for(:place, name: nil) }
        }.not_to change(Place, :count)
      end

      it 're-renders the new template' do
        post :create, params: { place: attributes_for(:place, name: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the place' do
        patch :update, params: { id: place_a.id, place: { name: 'Updated Place' } }
        place_a.reload
        expect(place_a.name).to eq('Updated Place')
      end

      it 'redirects to the updated place' do
        patch :update, params: { id: place_a.id, place: { name: 'Updated Place' } }
        expect(response).to redirect_to(place_a)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the place' do
        patch :update, params: { id: place_a.id, place: { name: nil } }
        place_a.reload
        expect(place_a.name).to eq('Place A')
      end

      it 're-renders the edit template' do
        patch :update, params: { id: place_a.id, place: { name: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the place' do
      expect {
        delete :destroy, params: { id: place_a.id }
      }.to change(Place, :count).by(-1)
    end

    it 'redirects to places#index' do
      delete :destroy, params: { id: place_a.id }
      expect(response).to redirect_to(places_path)
    end
  end
end
