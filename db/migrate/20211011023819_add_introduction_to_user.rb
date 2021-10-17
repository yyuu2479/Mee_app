class AddIntroductionToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :introduction, :text, null: false, default: "自己紹介を設定しよう"
  end
end
