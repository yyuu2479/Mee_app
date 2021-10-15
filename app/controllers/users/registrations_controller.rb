class Users::RegistrationsController < Devise::RegistrationsController
  #新規登録後のリダイレクト先
  def after_sign_up_path_for(resource)
    user_explanation_path(current_user.id)
  end
end