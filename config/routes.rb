Homefinance2::Application.routes.draw do

  resources :weights
  resources :eatings

  resources :transactions
  resources :categories
  resources :accounts
  devise_for :users

  match 'statistic_date', :to => 'statistics#initStatisticByDate'
  match 'show_statistic_by_date', :to => 'statistics#showStatisticByDate'
  match 'statistic_category', :to => 'statistics#initStatisticByCategory'
  match 'show_statistic_by_category', :to => 'statistics#showStatisticByCategory'

  match 'edit_user_profile', :to => 'application#edit'
  match 'update_user_profile', :to => 'application#update'
  match 'sign_with_social', :to => 'application#sign_with_social'

  match 'statistic_weight', :to => 'weights#initStatisticWeight'
  match 'show_statistic_weight', :to => 'weights#showStatisticWeight'

  root :to => 'transactions#index'
end
