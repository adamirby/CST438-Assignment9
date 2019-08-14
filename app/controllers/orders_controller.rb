class OrdersController < ApplicationController
    
    # POST /orders
    # create an order
    def create
        @order = Order.new
        @email = params[:email]
        @id = params[:itemId]
        
        #get a customer by passing in their email
        #returns an error if it's not found
        @code, @customer = Customer.getByEmail(@email)
        if @code == 404
           render json: {error: "Email not found for customer"}, status: 400
           return
        end
        
        #see above, same thing, but for getting an item
        @code, @item = Item.getById(@id)
        if @code == 404
            render json: {error: "Item ID not found"}, status: 400
            return
        end
        
        #logic for disallowing an order if the item isn't in stock
        if @item[:stockQty] <= 0
            render json: {error: "Item is not available to order"}, status: 400
            return
        end
        
        #initializing a new order item as a hybrid of values
        #from customer and item.
        @order.itemId = params[:itemId]
        @order.description = item[:description]
        @order.customerID = customer[:id]
        @order.price = item[:price]
        @order.award = customer[:award]
        @order.total = @order.price - @order.award
        
        if @order.save
            Item.order(@order)
            Customer.order(@order)
            render json: @order, status: 201
        else
            render json: {error: "Error saving order"}, status: 400
        end
    end
    
    # GET /orders
    # return array of orders
    # retrieve orders by customerId
    # retrieve orders by customer email
    def retrieveByCust
        @id = params[:customerId]
        @email = params[:email]
        
        if params[:email].present?
            @code, @customer = Customer.getByEmail(@email)
            if @code == 200
                @id = @customer[:id]
            end
        end
        @orders = Order.where(customerID: @id)
        render json: @orders, status:200
    end
    
    # GET /orders/:id
    # return order data by id
    def retrieveById
        @id = params[:id]
        @order = Order.find_by(id: @id)
        
        if @order.nil?
            head 404 
        else
            render json: @order, status:200
        end
    end
end
