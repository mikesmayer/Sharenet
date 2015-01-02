class CategoryDatatable < AjaxDatatablesRails::Base
  # uncomment the appropriate paginator module,
  # depending on gems available in your project.
  include AjaxDatatablesRails::Extensions::Kaminari
  # include AjaxDatatablesRails::Extensions::WillPaginate
  include AjaxDatatablesRails::Extensions::SimplePaginator

  def_delegators :@view, :truncate, :link_to, :h, :boolean_ajax_link_to, :link_with_icon, :category_path, :edit_category_path, :delete_category_path, :update_category_status_path

  def build_conditions_for(query)
    criteria = searchable_columns.map { |col| " #{col} like '%#{query}%' " }
    condition = criteria.join('OR')
    condition
  end

  def sortable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'
    @sortable_columns ||= [
        'categories.id',
        'categories.name',
        'categories.slug',
        'categories.created_at',
        'user_name',
        'parent_name',
        'children_count',
        'categories.is_public',
        'categories.is_locked',
        'categories.is_trend',
        'categories.is_active'
    ]
  end

  def searchable_columns
    # list columns inside the Array in string dot notation.
    # Example: 'users.email'
    @searchable_columns ||= %w(categories.name categories.slug categories.description parent.name)
  end

  private

  def data

    records.map do |record|
      [
          # comma separated list of the values for each cell of a table row
          # example: record.attribute,
          "<small class='pull-right'>#{record.id}</small>",
          link_to(record.name, category_path(record.id), :class => 'ajax-content-link', :title => "#{truncate(record.description, :ommision => '...', :length => 50)}"),
          "#{record.slug}&nbsp;&nbsp;&nbsp;&nbsp;<small><i class='fa fa-info-circle text-success' title='#{record.uri}'></i></small>",
          "<small class='pull-right'>#{record.created_at.strftime("%b %d, %Y")}</small>",
          record.user_name,
          record.parent_name,
          record.children.count,
          boolean_ajax_link_to(record.is_public, update_category_status_path(record.id, 'is_public')),
          boolean_ajax_link_to(record.is_locked, update_category_status_path(record.id, 'is_locked')),
          boolean_ajax_link_to(record.is_trend, update_category_status_path(record.id, 'is_trend')),
          boolean_ajax_link_to(record.is_active, update_category_status_path(record.id, 'is_active')),
          link_with_icon('edit', edit_category_path(record.id), 'ajax-partial-link') +
              link_with_icon('delete', delete_category_path(record.id), 'ajax-link needs-confirmation') +
              link_with_icon('view', category_path(record.id), 'ajax-content-link')
      ]
    end
  end

  def get_raw_records
    records = Category.all
    records = records.where(parent_id: options[:parent_id]) unless options[:parent_id].nil?
    records = records.joins("LEFT JOIN categories parent ON categories.parent_id = parent.id")
                  .joins("LEFT JOIN users ON categories.user_id = users.id")
                  .select("categories.id, categories.name, categories.slug, categories.description, categories.created_at, categories.user_id, categories.parent_id,
                  categories.is_public, categories.is_locked, categories.is_trend, categories.is_active,
                  parent.name as parent_name,
                  users.email as user_name,
                  (SELECT COUNT(children.id) FROM categories children WHERE children.parent_id = categories.id) as children_count ")
    records
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
