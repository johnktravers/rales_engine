class ApplicationController < ActionController::API

  def render_show_error(resource)
    message = "#{resource} with given ID does not exist."
    render_error(message)
  end

  def render_find_error(resource)
    message = "#{resource} with given attributes does not exist."
    render_error(message)
  end

  def render_find_all_error(resource)
    message = "#{resource}s with given attributes do not exist."
    render_error(message)
  end

  def render_relationship_error(resource, dependents)
    message = "#{resource} with given ID has no #{dependents}."
    render_error(message)
  end


  private

  def render_error(message)
    render json: {
      errors: [{
        status: '404 Not Found',
        title: message
      }]
    }
  end

end
