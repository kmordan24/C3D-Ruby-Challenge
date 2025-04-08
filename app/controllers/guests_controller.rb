# frozen_string_literal: true

class GuestsController < ApplicationController
  # OBVIOUSLY this would only ever be used for localhost purposes only
  protect_from_forgery with: :null_session
  def index
    @guests = Guest.where(event_id: params[:event_id])
    render json: @guests, status: :ok
  end

  def create
    @guest = Guest.new(guest_params)
    if @guest.save
      render json: @guest, status: :created
    else
      render json: { errors: @guest.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Note - not used in the UI currently (but this is what it could be if webapp needs to edit guests)
  def update
    @guest = Guest.find(params[:id])
    if @guest.update(guest_params)
      render json: @guest, status: :ok
    else
      render json: { errors: @guest.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @guest = Guest.find(params[:id])
    @guest.destroy
    head :ok
  end

  private

  def guest_params
    params.require(:guest).permit(:name, :email).merge(event_id: params[:event_id])
  end
end
