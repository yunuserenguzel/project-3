class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token

  before_filter :check_params

  before_action :authenticate

  def authenticate
    if params.has_key?("token")
      @authenticated_user = Authentication.get_user_by_token(params[:token])
    else
      @authenticated_user = nil
    end
  end

  def is_authenticated?
    return @authenticated_user.is_a?(User) ? true : false
  end

  def require_authentication
    if is_authenticated? == false
      show_error ErrorCodeAuthenticationRequired, "token required or invalid token error"
      return false
    end
  end

  def show_error error_code, description
    redirect_to :controller => "error", :error_code => error_code, :description => description, :format => params[:format]
  end

  def self.prepare_params_for action, *params_to_check
    PARAMS_FOR_ACTIONS["#{self.to_s}##{action}"] = params_to_check
  end


  def check_params
    @params_for_actions = PARAMS_FOR_ACTIONS
    action = params[:action]
    if action != nil && @params_for_actions["#{self.class.to_s}##{action}"] != nil
      @params_for_actions["#{self.class.to_s}##{action}"].each do |param_options|
        #param_options = param_options.is_a?(Hash) ? param_options : {param_options}
        param_options.each do |key,value|
          result = check_param key, value
          if result == false
            return false
          end
        end
      end
    end
    return true
  end

  private
  def check_param param, options
    options.each do |option|
      if option == :required && params[param] == nil
        show_error ErrorCodeMissingParameter, "parameter '#{param.to_s}' is missing"
        return false
      elsif option == :not_empty && params[param] == "" && params.has_key?(param)
        show_error ErrorCodeInvalidParameter, "parameter '#{param.to_s}' cannot be empty"
        return false
      elsif option.is_a?(Hash) && option.has_key?(:type) && params.has_key?(param)
        type = option[:type]
        if type < ActiveRecord::Base
          if !type.exists?(params[param])
            show_error ErrorCodeActiveRecordNotFound, "given "+param.to_s+" = " + params[param].to_s+" is not found"
            return false
          end
        elsif type <= Array && !params[param].is_a?(type)
          show_error ErrorCodeInvalidParameter, "given #{param.to_s} is not #{type.to_s}"
          return false
        end
      end
    end
    return true
  end


end
