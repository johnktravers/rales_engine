class ApplicationController < ActionController::API

  def render_show_error(resource)
    render json: {
      errors: [{
        code: error_code(resource),
        title: "#{resource} with given ID does not exist."
      }]
    }
  end

  def render_find_error(resource)
    render json: {
      errors: [{
        code: error_code(resource),
        title: "#{resource} with given attributes does not exist."
      }]
    }
  end

  def error_code(resource)
    if resource == 'Merchant'
      '3000'
    end
  end

end
