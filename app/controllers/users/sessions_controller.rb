class Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    # ゲストユーザーを作成・特定している
    user = User.guest
    # ここで新規登録とログインしている(deviseのメゾット)
    sign_in user
    flash[:notice] = "ゲストユーザーとしてログインしました！！"
    redirect_to user_path(user.id)
  end
end