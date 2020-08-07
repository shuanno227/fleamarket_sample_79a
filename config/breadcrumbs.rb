#ルート
crumb :root do
  link "フリマ", root_path
end

#マイページ
crumb :mypage do
  link "マイページ", user_path(current_user)
  parent :root
end

# クレジットカード情報
crumb :mypage_cards_index do
  link '支払い方法', credit_cards_path
  parent :mypage
end

# # クレジットカード情報登録後の表示
# crumb :mypage_cards_show do
#   link 'クレジットカード情報', credit_cards_path
#   parent :mypage_cards_index
# end

crumb :item do
  link Item.find(params[:id]).name, item_path
  parent :root
end