class LodgingsController < ApplicationController
  before_filter :authenticate_user!, except: [:show]
  before_filter :set_trip
  before_filter :set_lodging, except: [:new, :create]
  before_filter :check_for_cancel, :only => [:create, :update]

  def new
    @lodging = @trip.lodgings.build
  end

  def create
    @lodging = @trip.lodgings.build(lodging_params)
    @lodging.user_id = current_user.id
    @lodging.is_active = true
    if @lodging.save
      flash[:notice] = "Your lodging has been created."
      redirect_to @trip
    else
      flash[:alert] = "Your lodging has not been created."
      redirect_to @trip
    end
  end

  def show
    # set_lodging
  end

  def edit
    # set_lodging
    if current_user.id != @lodging.user_id
      flash[:alert] = "You cannot make changes to this lodging."
      redirect_to @trip
    end
  end

  def update
    if current_user.id == @lodging.user_id
      if @lodging.update(lodging_params)
        flash[:notice] = "Your lodging has been updated."
        redirect_to @trip
      else
        flash[:notice] = "Your lodging has not been updated."
        render "edit"
      end
    else
      flash[:alert] = "You cannot make changes to this lodging."
      redirect_to @trip
    end
  end

  def cancel
    if current_user == @lodging.user
      @lodging.update(is_active: false)

      flash[:notice] = "Your lodging plans have been cancelled."
      redirect_to user_path(current_user.id)
    else
      flash[:alert] = "You cannot make changes to this lodging."
      redirect_to trips_path
    end
  end

  def reactivate
    if current_user == @lodging.user
      @lodging.update(is_active: true)

      flash[:notice] = "Your lodging plans have been updated."
      redirect_to user_path(current_user.id)
    else
      flash[:alert] = "You cannot make changes to this lodging."
      redirect_to trips_path
    end
  end
  private
  
    def lodging_params
      params.require(:lodging).permit(:lodging_type, :name, :link, :contact,
                                      :price, :checkin_date, :checkout_date,
                                      :checkin_time, :address, :star_rating, 
                                      :reviews_link, :notes, :cover_photo)

    end

    def set_trip
      @trip = Trip.find(params[:trip_id])
    end

    def set_lodging
      @lodging = @trip.lodgings.find(params[:id])
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