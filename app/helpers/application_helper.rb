module ApplicationHelper

  def has_errors?(object,attribute)
    object.respond_to?(:errors) && !(attribute.nil? || object.errors[attribute].empty?)
  end

  def get_errors_for(object,attribute)
    object.errors[attribute].try(:join, ', ') || object.errors[attribute].try(:to_s)
  end

end
