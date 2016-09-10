class CategoriesController < ApplicationController
    before_action :require_admin, except: [:index, :show]
    

    def index
        @categories = Category.paginate(page: params[:page], per_page: 5)
    end
    
    def new
        @category = Category.new
    end
    
    def create
        @category = Category.new(category_params)
        if @category.save
            flash[:success] = "Category succfully created"
            redirect_to categories_path
        else
            render 'new'
        end
    end

    def show
        setup_category
        @category_articles = @category.articles.order("created_at DESC").paginate(page: params[:page], per_page: 5)
    end
    
    private
    
        def category_params
            params.require(:category).permit(:name)
        end
        
        def setup_category
            @category = Category.find(params[:id])
        end
        
        def require_admin
           if !logged_in? || (logged_in? && !current_user.admin?)
               flash[:danger] = "Admin?... Is that you? Log in."
               redirect_to categories_path
           end
        end

end