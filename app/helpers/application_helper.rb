module ApplicationHelper
  def application_name
    Rails.application.class.parent_name
  end

  def to_bool(str)
    str.downcase == 'true'
  end

  def boolean_ajax_link_to (value, link)
    result = '<a class="btn btn-warning btn-xs btn-outline btn-flat ajax-link" type="button" href="' + link + '"><i class="fa fa-times"></i></a>'
    result = '<a class="btn btn-primary btn-xs btn-outline btn-flat ajax-link" type="button" href="' + link + '"><i class="fa fa-check"></i></a>' if value
    result
  end

  def link_with_icon(type, link, classname)
    result = '<a class="' + classname + '" type="button" href="' + link + '">'
    if type == 'edit' then
      result += "<i class='fa fa-edit fa-fw' title='Edit'></i>"
    elsif type == 'delete'
      result += "<i class='fa fa-trash-o fa-fw text-danger' title='Delete'></i>"
    elsif type == 'view'
      result += "<i class='fa fa-list-alt fa-fw' title='View'></i>"
    else
      result += "<i class='fa fa-#{type} fa-fw' title='#{type}'></i>"
    end
    result += '</a>'
    result
  end
end