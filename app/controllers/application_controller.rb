class ApplicationController < ActionController::Base
  before_action :basic_auth, if: :production?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :category
  protect_from_forgery with: :exception


  private

  def production?
    Rails.env.production?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up, keys: [:nickname, :first_name, :last_name, :first_name_hurigana, :last_name_hurigana, :birth_year, :birth_month, :birth_day]
    )
    devise_parameter_sanitizer.permit(
      :account_update, keys: [:nickname, :first_name, :last_name, :first_name_hurigana, :last_name_hurigana, :birth_year, :birth_month, :birth_day]
    )
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end

  def category
    @parents = Category.where(ancestry: nil)
  end

end
