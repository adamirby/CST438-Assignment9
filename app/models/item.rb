class Item
    include HTTParty
    
    base_uri "http:localhost:8082"
    format :json
    
    def self.getById(id)
        response = get "/items/#{id}",
                   headers: {"ACCEPT" => "application/json"}
        code = response.code
        item = JSON.parse response.body, symbolize_names: true
        return code, item
    end
    
    def self.order(order)
        response = put "/items/order",
                   headers: {"CONTENT_TYPE" => "application/json"}
        return response.code
    end
end