class CategoriesController < ApplicationController
  @@title = "Category"

  def index
    id = 0
    id = params[:id] unless params[:id].nil?
    @category = Category.find_or_create_by({:id => id})

    @title = @@title
    @title += ' - ' + @category.name unless @category.name.empty?
  end

  def new
    @category = Category.new
    @category.parent_id = params[:parent_id]
    @category.user_id = 0
    render :layout => false
  end

  def edit
    @category = Category.find(params[:id])
    render :layout => false
  end

  def create
    @category = Category.new(category_params)

    @json = {}
    if @category.save then
      @json['result'] = 'success'
    else
      @json['result'] = 'failed'
      @json['error'] = @category.errors.full_messages
    end

    render json: @json
  end

  def update
    @category = Category.find(params[:id])

    @json = {}
    if @category.update(category_params)
      @json['result'] = 'success'
    else
      @json['result'] = 'failed'
      @json['error'] = @category.errors.full_messages
    end

    render json: @json
  end

  def update_status
    @category = Category.find(params[:id])

    @json = {}
    if params[:field].in? %w(is_public is_locked is_trend is_active)
      value = !@category[params[:field].to_s]
      if @category.update({params[:field].to_s => value})
        @json['result'] = 'success'
      else
        @json['result'] = 'failed'
        @json['error'] = @category.errors.full_messages
      end
    else
      @json['result'] = 'failed'
      @json['error'] = 'Field name is wrong.'
    end

    render json: @json
  end

  def delete
    @category = Category.find(params[:id])

    @json = {}
    if @category.destroy()
      @json['result'] = 'success'
    else
      @json['result'] = 'failed'
      @json['error'] = @category.errors.full_messages
    end

    render json: @json
  end

  def subcategories
    respond_to do |format|
      format.html
      options = {}
      options = {parent_id: params[:id]} unless params[:id].nil?
      format.json { render json: CategoryDatatable.new(view_context, options) }
    end
  end

  def all
    @title = 'All categories'
  end

  private
  #def set_product
  #  @product = Product.find(params[:id])
  #end

  def category_params
    params[:category][:is_public] = to_bool params[:category][:is_public] if params[:category][:is_public].class.name === 'String'
    params[:category][:is_locked] = to_bool params[:category][:is_locked] if params[:category][:is_locked].class.name === 'String'
    params[:category][:is_trend] = to_bool params[:category][:is_trend] if params[:category][:is_trend].class.name === 'String'
    params[:category][:is_active] = to_bool params[:category][:is_active] if params[:category][:is_active].class.name === 'String'

    params.require(:category).permit(:name, :description, :slug, :parent_id, :user_id, :is_public, :is_leaf, :is_trend, :is_active)
  end
end