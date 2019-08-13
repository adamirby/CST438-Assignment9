Rails.application.routes.draw do
    post '/orders' => 'orders#create'
    get '/orders' => 'orders#retrieveByCust'
    get '/orders/:id' => 'orders#retrieveById'
end
