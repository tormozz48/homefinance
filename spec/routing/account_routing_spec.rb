require 'spec_helper'

describe AccountsController do
  describe 'routing' do

    it 'index' do
      get('/accounts').should route_to('accounts#index')
    end

    it 'sort' do
      post('/accounts/sort').should route_to('accounts#sort')
    end

    it 'new' do
      get('/accounts/new').should route_to('accounts#new')
    end

    it 'edit' do
      get('/accounts/1/edit').should route_to('accounts#edit', :id => '1')
    end

    it 'create' do
      post('/accounts').should route_to('accounts#create')
    end

    it 'update' do
      put('/accounts/1').should route_to('accounts#update', :id => '1')
    end

    it 'destroy' do
      delete('/accounts/1').should route_to('accounts#destroy', :id => '1')
    end
  end
end
