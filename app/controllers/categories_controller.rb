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

  def subcategories_by_json
    @json = {}

    @json['id'] = params[:id]

    @json['draw'] = params[:draw]
    @json['recordsTotal'] = Category.where(:parent_id => params[:id]).count
    @json['recordsFiltered'] = 0
    data = []

    records = Category.where(:parent_id => params[:id])
    records = records.where(" name like ? OR slug like ?", "%#{params[:search][:value]}%", "%#{params[:search][:value]}%") unless params[:search][:value].empty?

    @json['recordsFiltered'] = records.count

    records = records.order(params[:columns][ params[:order]['0'][:column] ][:name] => params[:order]['0'][:dir].to_sym).limit(params[:length]).offset(params[:start])

    records.each do |record|
      user_name = '---'
      user_name = record.user.email unless record.user.nil?
      item = {
          :id => record.id,
          :name => record.name,
          :user_name => user_name,
          :created => record.created_at,
          :subs => record.children.count,
          :is_public => record.is_public,
          :is_leaf => record.is_leaf,
          :is_trend => record.is_trend,
          :is_active => record.is_active
      }
      data << item
    end

    @json['data'] = data

    render json: @json
  end

  def subcategories
    respond_to do |format|
      format.html
      format.json {render json: CategoryDatatable.new(view_context,{parent_id: params[:id]})}
    end
  end

  private
    #def set_product
    #  @product = Product.find(params[:id])
    #end

    def category_params
      params[:category][:is_public] = to_bool params[:category][:is_public]   if params[:category][:is_public].class.name === 'String'
      params[:category][:is_locked] = to_bool params[:category][:is_locked]   if params[:category][:is_locked].class.name === 'String'
      params[:category][:is_trend] = to_bool params[:category][:is_trend]     if params[:category][:is_trend].class.name === 'String'
      params[:category][:is_active] = to_bool params[:category][:is_active]   if params[:category][:is_active].class.name === 'String'

      params.require(:category).permit(:name, :description, :slug, :parent_id, :user_id, :is_public, :is_leaf, :is_trend, :is_active)
    end
end