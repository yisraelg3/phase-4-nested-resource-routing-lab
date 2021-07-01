class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  before_action :find_item, only:[:show]
  before_action :find_user, only:[:create]

  def index
    if params[:user_id]
      find_user
      items = @user.items
    else
      items = Item.all
    end
      render json: items, include: :user
  end

    def show
      render json: @item, include: :user
    end

    def create
      new_item = @user.items.create(item_params)
      render json: new_item, include: :user, status: :created
    end


    private
    def item_params
      params.permit(:name, :description, :price, :user_id)
    end
    
    def find_user
      @user = User.find(params[:user_id])
    end

    def find_item
      @item = Item.find(params[:id])
    end

    def record_not_found
      render json: {error: "Item not found"}, status: :not_found
    end
end


# class ItemsController < ApplicationController
#   rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

#   def index
#     if params[:user_id]
#       user = find_user
#       items = user.items
#     else
#       items = Item.all
#     end
#     render json: items, include: :user
#   end

#   def show
#     item = find_item
#     render json: item
#   end

#   def create
#     user = find_user
#     item = user.items.create(item_params)
#     render json: item, status: :created
#   end

#   private

#   def find_item
#     Item.find(params[:id])
#   end

#   def find_user
#     User.find(params[:user_id])
#   end

#   def item_params
#     params.permit(:name, :description, :price)
#   end

#   def render_not_found_response(exception)
#     render json: { error: "#{exception.model} not found" }, status: :not_found
#   end

# end
