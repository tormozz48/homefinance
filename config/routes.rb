Homefinance2::Application.routes.draw do

  resources :weights
  resources :eatings

  resources :transactions do
    collection do
      post 'filter'
      get 'load'
    end
  end

  resources :categories do
    collection do
      get 'load'
      post 'sort'
    end
  end

  resources :accounts do
    collection do
      get 'load'
      post 'sort'
    end
  end

  devise_for :users do
    get 'logout' => 'devise/sessions#destroy'
  end

  match 'statistic_date', :to => 'statistics#initStatisticByDate'
  match 'show_statistic_by_date', :to => 'statistics#showStatisticByDate'
  match 'statistic_category', :to => 'statistics#initStatisticByCategory'
  match 'show_statistic_by_category', :to => 'statistics#showStatisticByCategory'

  match 'edit_user_profile', :to => 'users#edit'
  match 'update_user_profile', :to => 'users#update'
  match 'social_authentification', :to => 'users#social_authentification'

  match 'statistic_weight', :to => 'weights#initStatisticWeight'
  match 'show_statistic_weight', :to => 'weights#showStatisticWeight'

  root :to => 'transactions#index'
end
