Homefinance2::Application.routes.draw do
  devise_for :users do
    get 'logout' => 'devise/sessions#destroy'
  end

  resources :transactions, :except => [:show] do
    get 'load', :on => :collection
  end

  resources :categories, :except => [:show] do
    get 'load', :on => :collection
  end

  resources :accounts, :except => [:show] do
    get 'load', :on => :collection
  end

  resources :statistics, :except => [:index, :show, :new, :edit, :create, :update, :destroy] do
    get 'statistic_date', :on => :collection
    get 'statistic_category', :on => :collection
    post 'show_statistic_by_date', :on => :collection
    post 'show_statistic_by_category', :on => :collection
  end

  match 'edit_user_profile', :to => 'users#edit'
  match 'update_user_profile', :to => 'users#update'
  match 'social_authentification', :to => 'users#social_authentification'

  match 'about', :to => 'application#about'
  match 'contacts', :to => 'application#contacts'

  root :to => 'transactions#index'
end
