require 'spec_helper'

describe TransactionsController do
  describe 'routing' do

    it 'index' do
      get('/transactions').should route_to('transactions#index')
    end

    it 'filter' do
      post('/transactions/filter').should route_to('transactions#filter')
    end

    it 'new' do
      get('/transactions/new').should route_to('transactions#new')
    end

    it 'edit' do
      get('/transactions/1/edit').should route_to('transactions#edit', :id => '1')
    end

    it 'create' do
      post('/transactions').should route_to('transactions#create')
    end

    it 'update' do
      put('/transactions/1').should route_to('transactions#update', :id => '1')
    end

    it 'destroy' do
      delete('/transactions/1').should route_to('transactions#destroy', :id => '1')
    end
  end
end
