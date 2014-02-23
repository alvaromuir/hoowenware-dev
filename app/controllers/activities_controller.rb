class ActivitiesController < ApplicationController
  before_action :set_trip
  before_action :set_activity, except: [:new, :create]
  before_filter :authenticate_user!
  before_filter :check_for_cancel, :only => [:create, :update]

  def new
    @activity = @trip.activities.build
  end


  def create
    @activity = @trip.activities.build(activity_params)
    @activity.user_id = current_user.id
    if @activity.save
      flash[:notice] = "Your activity request has been receieved and is awaiting approval."
      redirect_to @trip
    else
      flash[:alert] = "Your activity request has not been created."
      redirect_to @trip
    end
  end

  def show
  end

  private
    def activity_params
      params.require(:activity).permit(:activity_type, :name, :link, :venue,
                                      :address, :contact, :price, :date, 
                                      :start_time, :end_time, :notes,
                                      :deadline, :tickets_available, 
                                      :deposit_require, :cc_required,
                                      :min_age)
    end

    def set_trip
      @trip = Trip.find(params[:trip_id])
    end

    def set_activity
      @activity = Activity.find(params[:id])
    rescue ActiveRecord::RecordNotFound
     flash[:alert] = "The activity you were looking for could not be found."
     redirect_to @trip
    end

    def check_for_cancel
      if params[:commit] == "Cancel"
        flash[:notice] = "Your request have been cancelled."
        redirect_to @trip
      end
    end
end