require 'spec_helper'

describe CategoriesController do
  describe 'routing' do

    it 'index' do
      get('/categories').should route_to('categories#index')
    end

    it 'sort' do
      get('/categories/load').should route_to('categories#load')
    end

    it 'new' do
      get('/categories/new').should route_to('categories#new')
    end

    it 'edit' do
      get('/categories/1/edit').should route_to('categories#edit', :id => '1')
    end

    it 'create' do
      post('/categories').should route_to('categories#create')
    end

    it 'update' do
      put('/categories/1').should route_to('categories#update', :id => '1')
    end

    it 'destroy' do
      delete('/categories/1').should route_to('categories#destroy', :id => '1')
    end
  end
end


