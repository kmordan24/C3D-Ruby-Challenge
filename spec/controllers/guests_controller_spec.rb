# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GuestsController, type: :controller do
  let(:event) { create(:event) }
  let(:guest) { create(:guest, event: event) }

  describe 'GET #index' do
    before do
      create_list(:guest, 3, event: event)
    end

    it 'returns a successful response' do
      get :index, params: { event_id: event.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to have_attributes(size: 3)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) { { event_id: event.id, guest: attributes_for(:guest) } }

      it 'creates a new guest' do
        expect {
          post :create, params: valid_params
        }.to change(Guest, :count).by(1)
      end

      it 'returns the created guest as JSON with a 201 status' do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['name']).to eq(valid_params[:guest][:name])
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { event_id: event.id, guest: { name: '', email: '' } } }

      it 'does not create a new guest' do
        expect {
          post :create, params: invalid_params
        }.not_to change(Guest, :count)
      end

      it 'returns validation errors as JSON with a 422 status' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Name can't be blank", "Email can't be blank")
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:valid_params) { { event_id: event.id, id: guest.id, guest: { name: 'Updated Name' } } }

      it 'updates the guest' do
        patch :update, params: valid_params
        expect(guest.reload.name).to eq('Updated Name')
      end

      it 'returns the updated guest as JSON with a 200 status' do
        patch :update, params: valid_params
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['name']).to eq('Updated Name')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { event_id: event.id, id: guest.id, guest: { name: '' } } }

      it 'does not update the guest' do
        patch :update, params: invalid_params
        expect(guest.reload.name).not_to eq('')
      end

      it 'returns validation errors as JSON with a 422 status' do
        patch :update, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Name can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the guest' do
      guest # Ensure the guest is created
      expect {
        delete :destroy, params: { event_id: event.id, id: guest.id }
      }.to change(Guest, :count).by(-1)
    end

    it 'returns a 200 OK status' do
      delete :destroy, params: { event_id: event.id, id: guest.id }
      expect(response).to have_http_status(:ok)
    end
  end
end
