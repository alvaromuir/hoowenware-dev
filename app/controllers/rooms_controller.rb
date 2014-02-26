class RoomsController < ApplicationController
  before_action :set_trip, :set_lodging
  before_action :set_room, except: [:new, :create]
  before_filter :check_for_cancel, :only => [:create, :update]


  def new
    # set_lodging
    @room = @lodging.rooms.build
  end

  def create
    # set_lodging
    @room = @lodging.rooms.build(room_params)
    @room.user_id = current_user.id
    @room.is_active = true
    if @room.save
      flash[:notice] = "Your room has been added to this lodging."
      redirect_to trip_lodging_path(:trip_id => @lodging.trip.id,
                                    :id => @lodging.id)
    else
      flash[:alert] = "Your room has not been added to this lodging."
      render "new"
    end
  end

  def show
    # set_room
  end

  def edit
    # set_room
    if current_user != @room.user && !current_user.is_admin?
      flash[:alert] = "You cannot make changes to this room."
      redirect_to trip_lodging_path(:trip_id => @lodging.trip.id,
                                    :id => @lodging.id)
    end
  end

  def update
    # set_room
    if current_user == @room.user
      if @room.update(room_params)
        flash[:notice] = "Your room has been updated."
        redirect_to trip_lodging_path(:trip_id => @lodging.trip.id,
                                    :id => @lodging.id)
      else
        flash[:notice] = "Your roomhas not been updated."
        render "edit"
      end
    else
      flash[:alert] = "You cannot make changes to this room."
      redirect_to @trip
    end
  end

  def cancel
    # set_room
    if current_user == @room.user
      @room.update(is_active: false)

      flash[:notice] = "Your room has been cancelled."
      redirect_to trip_lodging_path(:trip_id => @lodging.trip.id,
                                    :id => @lodging.id)
    else
      flash[:alert] = "You cannot make changes to this room."
      redirect_to trip_lodging_path(:trip_id => @lodging.trip.id,
                                    :id => @lodging.id)
    end
  end

  def reactivate
    # set_room
    if current_user == @room.user
      @room.update(is_active: true)

      flash[:notice] = "Your room has been updated."
      redirect_to trip_lodging_path(:trip_id => @lodging.trip.id,
                                    :id => @lodging.id)
    else
      flash[:alert] = "You cannot make changes to this room."
      redirect_to trip_lodging_path(:trip_id => @lodging.trip.id,
                                    :id => @lodging.id)
    end
  end


  private
    def room_params
      params.require(:room).permit(:name, :price, :min_stay, :room_type,
                                  :amenities, :deadline, :deposit,
                                  :cc_required, :min_age, :room_gender,
                                  :sleeps, :notes)
    end

    def set_trip
      @trip = Trip.find(params[:trip_id])
    end

    def set_lodging
      @lodging = @trip.lodgings.find(params[:lodging_id])
    end

    def set_room
      @room = @lodging.rooms.find(params[:id])
    rescue ActiveRecord::RecordNotFound
     flash[:alert] = "The room you were looking for could not be found."
     redirect_to trips_path
    end

    def store_return_page
      session[:return_to] ||= request.referer
    end

    def check_for_cancel
      if params[:commit] == "Cancel"
        flash[:notice] = "Your changes have been cancelled."
        if @room.new_record?
          redirect_to trip_lodging_path(:trip_id => @lodging.trip.id,
                                      :id => @lodging.id)
        else
          redirect_to session.delete(:return_to)
        end
      end
    end
end