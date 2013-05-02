Homefinance2::Application.routes.draw do
  devise_for :users do
    get 'logout' => 'devise/sessions#destroy'
  end

  resources :transactions, :except => [:show] do
    get 'switch', :on => :collection
    get 'show_filter', :on => :collection
    get 'load', :on => :collection
  end

  resources :categories, :except => [:show] do
    get 'load', :on => :collection
  end

  resources :accounts, :except => [:show] do
    get 'load', :on => :collection
  end

  resources :statistics, :except => [:show, :new, :edit, :create, :update, :destroy] do
    get 'load_by_category', :on => :collection
    get 'load_by_date', :on => :collection
  end

  match 'edit_user_profile', :to => 'users#edit'
  match 'update_user_profile', :to => 'users#update'
  match 'social_authentification', :to => 'users#social_authentification'

  match 'about', :to => 'application#about'
  match 'contacts', :to => 'application#contacts'

  root :to => 'transactions#index'
end
