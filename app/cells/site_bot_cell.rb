class SiteBotCell < Cell::ViewModel
  def new
    render
  end

  def show
    render
  end

  def show_errors(field_name)
    content_tag(:i, @model.errors.messages[field_name].join(', '), class: 'form-error') if
      @model.errors.messages[field_name].present?
  end
end
