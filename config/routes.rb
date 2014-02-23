HoowenwareDev::Application.routes.draw do
  root "pages#index"
  
  resources :files
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :trips do    
    member do
      get 'add_photo', as: 'add_photo_to'
      get 'rsvp', as: 'rsvp_to'
      get 'cancel'
      get 'reactivate'
      get 'preview_invitation'
    end

    resources :invitations, only: [:new, :create]
    get "invitations/facebook" => 'invitations#facebook',
        :as => 'facebook_invitation'
    get "invitations/google" => 'invitations#google',
        :as => 'google_invitation'


    resources :polls do
      member do
        get 'dates'
        get 'locations'
      end
    end
    
    resources :posts

  end

  resources :groups do
    member do
      get 'deactivate'
      get 'reactivate'
    end

    resources :memberships, only: [:new, :create]
    
    get "memberships/:email/approve" => 'memberships#approve', 
        :controller => 'memberships',
        :constraints => { :email => /[^\/]+/},
        :as => 'approve_membership'

    get "memberships/:email/pend" => 'memberships#pend', 
        :controller => 'memberships',
        :constraints => { :email => /[^\/]+/ },
        :as => 'pend_membership'

    get "memberships/:email/promote" => 'memberships#promote', 
        :controller => 'memberships',
        :constraints => { :email => /[^\/]+/ },
        :as => 'promote_membership'

    get "memberships/:email/demote" => 'memberships#demote', 
        :controller => 'memberships',
        :constraints => { :email => /[^\/]+/ },
        :as => 'demote_membership'

    delete "memberships/:email/remove" => 'memberships#remove', 
        :controller => 'memberships',
        :constraints => { :email => /[^\/]+/ },
        :as => 'remove_membership'
  end
  
  resources :users, only: [:create, :show, :edit, :update] do
    resources :web_links, only: [:new, :create, :destroy]
  end
end
