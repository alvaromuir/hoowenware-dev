class PollReponsesController < ApplicationController
  before_action :set_poll

  def new
    @response = @poll.poll_responses.build
  end

  private
    def poll_response_params
      params.require(:poll_response).permit(:choices)
    end

    def set_poll
      @poll = Poll.find(params[:id])
    end
end