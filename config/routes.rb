Homefinance2::Application.routes.draw do

  resources :weights do
    resources :eatings
  end

  resources :transactions
  resources :categories
  resources :accounts
  devise_for :users

  match 'statistic_date', :to => 'statistics#initStatisticByDate'
  match 'show_statistic_by_date', :to => 'statistics#showStatisticByDate'
  match 'statistic_category', :to => 'statistics#initStatisticByCategory'
  match 'show_statistic_by_category', :to => 'statistics#showStatisticByCategory'


  root :to => 'transactions#index'
end
