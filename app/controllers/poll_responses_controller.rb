class PollResponsesController < ApplicationController
  before_action :set_poll

  def new
    if user_already_responded_responded?
      flash[:alert] = "You have already responded to this poll."
      redirect_to trip_path(@poll.trip_id)
    else
      @poll_response = @poll.poll_responses.build(:user_id => current_user.id,
                                                  :trip_id => @poll.trip_id,
                                                  :choices => {response: params[:choices]})
      if @poll_response.save
        flash[:notice] = "Your response has been recorded."
        redirect_to trip_path(@poll.trip_id)
      else
        flash[:alert] = "Your response has not been recorded."
        redirect_to trip_polls_path(:trip_id => @poll.trip_id,
                                    :id => @poll.id)
      end
    end
  end

  private
    def set_poll
      @poll = Poll.find(params[:poll_id])
    end

    def user_already_responded_responded?
      response = @poll.poll_responses.where(:user_id => current_user.id,
                                            :trip_id => @poll.trip_id).first
      if response
        return true
      else
        return false
      end
    end
end