require 'httparty'

class OrderClient
    include HTTParty
    format :json
    base_uri 'http://localhost:8080'
    
    def OrderClient.create(newOrder)
       post '/orders',
       body: newOrder.to_json,
       headers: { 'Content-Type' => 'application/json',
                   'ACCEPT' => 'application/json' }
    end
    
    def OrderClient.custOrdersByEmail(email)
       get "/orders?email=#{email}"
    end
    
    def OrderClient.custOrderById(id)
        get "/orders?id=#{id}"
    end
    
    def OrderClient.id(id)
       get "orders/#{id}" 
    end
end

class CustomerClient
    include HTTParty
    format :json
    base_uri 'http://localhost:8081'
    

    
    def CustomerClient.register(customer)
        post '/customers',
        body: customer.to_json,
        headers: { 'Content-Type' => 'application/json',
                    'ACCEPT' => 'application/json' }
    end
    
    def CustomerClient.email(email)
        get "/customers?email=#{email}"
    end
    
    def CustomerClient.id(id)
        get "/customers?id=#{id}"
    end
end

class ItemClient
    include HTTParty
    format :json
    base_uri 'http://localhost:8082'
    
    def ItemClient.add(item)
        post '/items',
        body: item.to_json,
        headers: { 'Content-Type' => 'application/json',
                  'ACCEPT' => 'application/json'}
    end
    
    def ItemClient.updateItem(item)
        put '/items',
        body: item.to_json,
        headers: { 'Content-Type' => 'application/json',
                  'ACCEPT' => 'application/json'}
    end
    
    def ItemClient.id(id)
        get "/items?id=#{id}"
    end
end

quit = false

while !quit

    puts "What do you want to do: CreateOrder, RetrieveOrder, RegisterCustomer, LookupCustomer, CreateItem, LookupItem, or Quit"
    input = gets.chomp!
    
    if input == 'CreateOrder'
        arr = Array.new
        puts "Enter Item id"
        arr[0] = gets.chomp!
        puts "Enter Customer Email"
        arr[1] = gets.chomp!
        response = OrderClient.create itemId: arr[0], email: arr[1]
        puts "status code #{response.code}"
        puts response.body
    elsif input == 'RetrieveOrder'
        puts "Would you like to retrieve the order by OrderID, CustomerID, or CustomerEmail"
        input = gets.chomp!
        if input == "OrderID"
            puts "Enter OrderID"
            input = gets.chomp!
            response = OrderClient.id(input)
            puts "status code #{response.code}"
            puts response.body
        elsif input == "CustomerID"
            puts "Enter CustomerID"
            input = gets.chomp!
            response = OrderClient.custOrderById(input)
            puts "status code #{response.code}"
            puts response.body
        elsif input == "CustomerEmail"
            puts "Enter CustomerEmail"
            input = gets.chomp!
            response = OrderClient.custOrdersByEmail(input)
            puts "status code #{response.code}"
            puts response.body
        end
    elsif input == 'RegisterCustomer'
        puts 'enter lastName, firstName and email for new customer'
        register = gets.chomp!
        check = register.split(' ')
        response = CustomerClient.register lastName: check[0], firstName: check[1], email: check[2]
        puts "status code #{response.code}"
        puts response.body
    elsif input == 'LookupCustomer'
        puts "lookup by ID or email?"
        input = gets.chomp!
        if input == 'ID'
            puts "enter customer ID"
            input = gets.chomp!
            response = CustomerClient.id(id)
            puts "status code #{response.code}"
            puts response.body
        elsif input == 'email'
            puts "enter customer Email"
            response = CustomerClient.email(email)
            puts "status code #{response.code}"
            puts response.body
        end
    elsif input == 'CreateItem'
        arr = Array.new
        puts 'enter item description'
        arr[1] = gets.chomp!
        puts 'enter item price'
        arr[2] = gets.chomp!
        puts 'enter item stockQty'
        arr[3] = gets.chomp!
        response = ItemClient.add id: arr[0], description: arr[1], price: arr[2], stockQty: arr[3]
        puts "status code #{response.code}"
        puts response.body
    elsif input == 'LookupItem'
        puts 'enter id of item to lookup'
        id = gets.chomp!
        response = ItemClient.id(id)
        puts "status code #{response.code}"
        puts response.body
    elsif input == 'Quit'
        quit = true
    end
end