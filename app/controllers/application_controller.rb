class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception
  # ログイン後の遷移先変更
  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  # /adminと直打ちした場合、閲覧権限がなかった際のリダイレクト先の設定
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path
    flash[:alert] = "閲覧権限がありません！！"
  end

  protected
  # 新規登録する際に新しく追加したカラムの操作をdeviseに許可するメゾット
  def configure_permitted_parameters
     devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :nickname])
  end
end
