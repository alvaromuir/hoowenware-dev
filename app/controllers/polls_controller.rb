class PollsController < ApplicationController
  before_action :set_trip
  before_action :set_poll, :only => [:edit, :show, :update, :destroy]
  before_filter :authenticate_user!
  before_filter :check_for_cancel, :only => [:create, :update]

  def dates
    #set_trip
    @poll = @trip.polls.build
  end

  def locations
    # set_trip
    @poll = @trip.polls.build
  end

  def generic
    # set_trip
    @poll = @trip.polls.build
  end

  def create
    @poll = @trip.polls.build(poll_params)
    @poll.user = current_user
    if @poll.save
      @poll.update(is_active: true)
      flash[:notice] = "Your poll has been created."
      if @poll.poll_type == 'generic'
        redirect_to trip_path(@trip)
      else
        redirect_to edit_trip_path(@trip)
      end
    else
      flash[:alert] = "Your poll has not been created."
      render "new"
    end
  end

  def edit
    # set_poll
  end

  def show
  end

  def update
    # set_poll
    if @trip.user_id == current_user.id or current_user.is_admin?
      if @poll.update(poll_params)
        flash[:notice] = "Your poll has been updated."
        redirect_to edit_trip_path(@trip)
      else
        flash[:alert] = "Your poll has not been updated."
        render "edit"
      end
    else
      flash[:alert] = "You must be an administrator of this trip to do that."
      redirect_to edit_trip_path(@trip)
    end
  end

  def destroy
    # set_poll
    if @trip.user_id == current_user.id or current_user.is_admin?
      @poll.destroy
      flash[:alert] = "Your poll has been deleted."
      redirect_to edit_trip_path(@trip)
    else
      flash[:alert] = "You must be an administrator of this trip to do that."
      redirect_to edit_trip_path(@trip)
    end
  end

  private
    def poll_params
      params.require(:poll).permit(:poll_type, :title, :start_date, :end_date, 
                                    :location, :generic_question, :notes, :expires)
    end

    def set_trip
      @trip = Trip.find(params[:trip_id])
    end

    def set_poll
      @poll = @trip.polls.find(params[:id])
   rescue ActiveRecord::RecordNotFound
     flash[:alert] = "The poll you were looking for could not be found."
     redirect_to edit_trip_path(@trip)
    end

    def check_for_cancel
      if params[:commit] == "Cancel"
        flash[:notice] = "Your changes have been cancelled."
        redirect_to edit_trip_path(@trip)
      end
    end
end
