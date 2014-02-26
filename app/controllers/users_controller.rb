class UsersController < ApplicationController
  before_action :set_user
  before_action :get_groups, :get_trips, only: [:show, :update]
  before_action :get_active_groups, :get_membership_ids, only: [:edit, :update]
  before_filter :authenticate_user!, except: [:show]
  before_filter :store_return_page, only: [:edit, :cancel, :reactivate, 
                                            :destroy]
  before_filter :check_for_cancel, only: [:update]


  def show
    #set_user
    @web_link = @user.web_links.build(url: '')
    @groups = @memberships.where(:email => @user.email).map {|x| x.group }
  end

  def edit
    #set_user
    if current_user != @user && !current_user.is_admin?
      flash[:alert] = "You cannot make changes to this profile."
      redirect_to root_path
    end
  end

  def update
    #set_user
    if @user.update(user_params)
      # This needs to be fixed to remove unselected group
      puts params[:groups]
      if params[:groups]
        params[:groups].each do |id| 
          @group = Group.find(id)
          @membership = @group.memberships.build(email: @user.email, 
                                                is_admin: false,
                                                is_active: false)
          @membership.save
        end
      end

      @user.update(profile_updated: true)

      flash[:notice] = "Your profile has been updated."
      render "show"
    else
      flash[:alert] = "Your profile has not been updated."
      render "edit"
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:email, :first_name, :last_name,
                                    :gender, :status, :avatar, :zip_code, :mobile_number, 
                                    :skype_id, :dietary_pref, :roommate_pref)
    end
    def set_user
      @user = User.find(params[:id])
   rescue ActiveRecord::RecordNotFound
     flash[:alert] = "The profile you were looking for could not be found."
     redirect_to root_path
    end

    def get_active_groups
      @active_groups = Group.where(is_active: true)
    end

    def get_membership_ids
      @membership_ids = Membership.where(:email => @user.email).map {|x| x.group_id }
    end

    def get_groups
      @memberships = Membership.where(:email => @user.email)
    end

    def get_trips
      @trips = Trip.where(user_id: @user.id)
    end

    def store_return_page
      session[:return_to] ||= request.referer
    end

    def check_for_cancel
      if params[:commit] == "Cancel"
        flash[:notice] = "Your changes have been cancelled."
        if @user.new_record?
          redirect_to root_path
        else
          redirect_to user_path(@user)
        end
      end
    end
end
