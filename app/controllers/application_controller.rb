class ApplicationController < ActionController::API

  def render_show_error(resource)
    message = "#{resource} with given ID does not exist."
    render_error(resource, message)
  end

  def render_find_error(resource)
    message = "#{resource} with given attributes does not exist."
    render_error(resource, message)
  end

  def render_find_all_error(resource)
    message = "#{resource}s with given attributes do not exist."
    render_error(resource, message)
  end

  def render_relationship_error(resource, dependents)
    message = "#{resource} with given ID has no #{dependents}."
    render_error(resource, message)
  end


  private

  def render_error(resource, message)
    render json: {
      errors: [{
        code: error_code(resource),
        title: message
      }]
    }
  end

  def error_code(resource)
    if resource == 'Merchant'
      '3000'
    end
  end

end
