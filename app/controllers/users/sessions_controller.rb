class Users::SessionsController < Devise::SessionsController
  # ゲストユーザーのメゾット
  def guest_sign_in
    # ゲストユーザーを作成・特定している
    user = User.guest
    # ここで新規登録とログインしている(deviseのメゾット)
    sign_in user
    flash[:notice] = "ゲストユーザーとしてログインしました！！"
    redirect_to user_path(user.id)
  end

  # ログイン後の遷移先
  def after_sign_in_path_for(resource)
    user_path(resource)
  end
end
