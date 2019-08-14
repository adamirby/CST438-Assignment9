require 'rails_helper'

RSpec.describe OrdersController, type: :request do
  
  
  it "retrieveByCust using Id" do
    headers = {"CONTENT_TYPE" => "application/json",
               "ACCEPT" => "application/json"}
    Order.create(id: 100, itemId: 100, description: "salsa", customerId: 100, price: 10, award: 0, total: 10)
    Order.create(id: 200, itemId: 200, description: "beans", customerId: 100, price: 8, award: 0, total: 8)
    
    get '/orders?customerId=100', :headers => headers
    expect(response).to have_http_status(200)
    expect((JSON.parse(response.body)).size).to eq 2
    
    get '/orders?customerId=200', :headers => headers
    expect(response).to have_http_status(200)
    expect((JSON.parse(response.body)).size).to eq 0
  end
  
  it "retrieveByCust using Email" do
    headers = {"CONTENT_TYPE" => "application/json",
               "ACCEPT" => "application/json"}
    expect(Customer).to receive(:getByEmail).with('bob@dole.com')
    get '/orders?email=bob@dole.com', :headers => headers
    expect(response).to have_http_status(200)
  end 
  
  it "retrieveById" do
    headers = {"CONTENT_TYPE" => "application/json",
               "ACCEPT" => "application/json"}
    Order.create(id: 100, itemId: 100, description: "salsa", customerId: 100, price: 10, award: 0, total: 10)
    get '/orders/100', :headers => headers
    expect(response).to have_http_status(200)
    
    get '/orders/200', :headers => headers
    expect(response).to have_http_status(404)
    
    Order.create(id: 200, itemId: 200, description: "beans", customerId: 200, price: 8, award: 0, total: 8)
    get '/orders/200', :headers => headers
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)['description']).to eq "beans"
    expect(JSON.parse(response.body)['customerId']).to eq 200
    
    get '/orders/100', :headers => headers
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)['description']).to eq "salsa"
    expect(JSON.parse(response.body)['customerId']).to eq 100
  end
  
  it 'Create Order' do
    headers = {"CONTENT_TYPE" => "application/json",
               "ACCEPT" => "application/json"}
  end
end
