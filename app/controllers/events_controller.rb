# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    sort_column = safe_sort_column
    sort_direction = safe_sort_direction
    @events = Event.order("#{sort_column} #{sort_direction}").page(params[:page]).per(10)
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to @event, notice: 'Event created'
    else
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to @event, notice: 'Event updated'
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path, notice: 'Event deleted'
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :place_id, :starts_at, :ends_at)
  end

  def safe_sort_column
    %w[name starts_at].include?(params[:sort]) ? params[:sort] : 'starts_at'
  end

  def safe_sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
