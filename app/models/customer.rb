class Customer
    include HTTParty
    
    base_uri "localhost:8081"
    format :json
    
    def self.getByEmail(email)
        response = get "/customers?email=#{email}",
                   headers: {"ACCEPT" => "application/json"}
        code = response.code
        customer = JSON.parse response.body, symbolize_names: true
        return code, customer
    end
    
    def self.order(order)
        response = put "/customers/order",
                   body: order.to_json,
                   headers: {"CONTENT_TYPE" => "application/json"}
        return response.code
    end
end