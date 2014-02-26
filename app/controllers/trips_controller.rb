class TripsController < ApplicationController
  before_action :authorize_admin!, only: [:destroy]
  before_action :set_trip, except: [:index, :new, :create]
  before_filter :authenticate_user!, except: [:show, :index]
  before_filter :store_return_page, only: [:edit, :cancel, :reactivate, 
                                            :destroy]
  before_filter :check_for_cancel, :only => [:create, :update]

  def index
    @trips = Trip.order('start_date ASC')
  end

  def new
    @trip = Trip.new
    @trip.assets.build
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user = current_user
    if @trip.save
      @trip.update(is_active: true)
      flash[:notice] = "Your trip has been created."
      redirect_to @trip
    else
      flash[:alert] = "Your trip has not been created."
      render "new"
    end
  end


  def show
    #set_trip
    @invitations = @trip.invitations
    if current_user
      @rsvp = @trip.rsvps.where(:user_id => current_user.id).first
      @post = @trip.posts.build(:user_id => current_user.id)
    end
  end

  def edit
    #set_trip
    @invitations = @trip.invitations
    if current_user != @trip.user && !current_user.is_admin?
      flash[:alert] = "You must be an administrator of this trip to do that."
      redirect_to trips_path
    end
  end

  def update
    #set_trip
    if @trip.update(trip_params)
      flash[:notice] = "Your trip has been updated."
      redirect_to @trip
    else
      flash[:alert] = "Your trip has not been updated."
      render "edit"
    end
  end

  def add_photo
    @trip.assets.build
  end

  def cancel
    if current_user == @trip.user
      @trip.update(is_active: false)

      flash[:notice] = "Your trip has been cancelled."
      redirect_to user_path(current_user.id)
    else
      flash[:alert] = "You must be an administrator of this trip to do that."
      redirect_to trips_path
    end
  end

  def reactivate
    if current_user == @trip.user
      @trip.update(is_active: true)

      flash[:notice] = "Your trip has been reactivated."
      redirect_to user_path(current_user.id)
    else
      flash[:alert] = "You must be an administrator of this trip to do that."
      redirect_to trips_path
    end
  end

  def preview_invitation
    @dates_options = @trip.polls.where(poll_type: 'date')
    @location_options = @trip.polls.where(poll_type: 'location')
  end

  def destroy
    #set_trip
    @trip.destroy

    flash[:notice] = "This trip has been deleted."
    redirect_to trips_path
  end


  def rsvp
    @rsvp = @trip.rsvps.where(:user_id => current_user.id, :response => "").first_or_create
    responses = ['yes','maybe', 'no']
    if ['yes','maybe', 'no'].include? params[:response]
      if @rsvp.update(:response => params[:response])
        flash[:notice] = "Your rsvp has been updated."
        redirect_to @trip
      else
        flash[:alert] = "Your rsvp has not been updated."
        redirect_to @trip
      end
    else
      flash[:alert] = "Your rsvp response was invalid."
      redirect_to @trip
    end
  end

  private
    def trip_params
      params.require(:trip).permit(:title, :hash_tag, :start_date, :end_date, 
                                  :location, :is_private, :hide_guestlist, 
                                   assets_attributes: [:asset])
    end

    def set_trip
      @trip = Trip.find(params[:id])
   rescue ActiveRecord::RecordNotFound
     flash[:alert] = "The trip you were looking for could not be found."
     redirect_to trips_path
    end

    def store_return_page
      session[:return_to] ||= request.referer
    end

    def check_for_cancel
      if params[:commit] == "Cancel"
        flash[:notice] = "Your changes have been cancelled."
        if @trip
          redirect_to trip_path(@trip)
        else
          redirect_to trips_path
        end
      end
    end
end