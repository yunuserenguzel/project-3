class ErrorController < ApplicationController

  def index
    @error_code = params[:error_code]
    @error_description = params[:description].to_s
    @error_title = ErrorDescriptionTable[params[:error_code].to_i]
  end
end
