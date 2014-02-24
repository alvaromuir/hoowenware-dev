class TransportationsController < ApplicationController
  before_filter :authenticate_user!, except: [:show]
  before_filter :set_trip
  before_filter :set_transportation, except: [:new, :create]

  def new
    @transportation = @trip.transportations.build
  end

  def create
    @transportation = @trip.transportations.build(transportation_params)
    @transportation.user_id = current_user.id
    @transportation.is_active = true
    if @transportation.save
      flash[:notice] = "Your travel arrangements have been submitted."
      redirect_to @trip
    else
      flash[:alert] = "Your travel arrangements have not been created."
      redirect_to @trip
    end
  end

  def show
  end

  def edit
    # set_transportation
    if current_user.id != @transportation.user_id
      flash[:alert] = "You cannot make changes to this trip."
      redirect_to @trip
    end
  end

  def update
    if current_user.id == @transportation.user_id
      if @transportation.update(transportation_params)
        flash[:notice] = "Your travel arrangements have been updated."
        redirect_to @trip
      else
        flash[:notice] = "Your travel arrangements have not been updated."
        render "edit"
      end
    else
      flash[:alert] = "You cannot make changes to this trip."
      redirect_to @trip
    end
  end

  def cancel
    if current_user == @transportation.user
      @transportation.update(is_active: false)

      flash[:notice] = "Your transportation plans have been cancelled."
      redirect_to user_path(current_user.id)
    else
      flash[:alert] = "You cannot make changes to this transportation plan."
      redirect_to trips_path
    end
  end

  def reactivate
    if current_user == @transportation.user
      @transportation.update(is_active: true)

      flash[:notice] = "Your transportation plans have been updated."
      redirect_to user_path(current_user.id)
    else
      flash[:alert] = "You cannot make changes to this transportation plan."
      redirect_to trips_path
    end
  end
  private
  
    def transportation_params
      params.require(:transportation).permit(:transportation_type, :service_number,
                                              :seat_number, :price, 
                                              :desposit_required,:notes, 
                                              :departure_city, :departure_date,
                                              :departure_time, :arrival_city,
                                              :arrival_date, :arrival_time)

    end

    def set_trip
      @trip = Trip.find(params[:trip_id])
    end

    def set_transportation
      @transportation = @trip.transportations.find(params[:id])
    rescue ActiveRecord::RecordNotFound
     flash[:alert] = "The travel arrangements you were looking for could not be found."
     redirect_to @trip
    end

    def check_for_cancel
      if params[:commit] == "Cancel"
        flash[:notice] = "Your changes have been cancelled."
        redirect_to @trip
      end
    end
end