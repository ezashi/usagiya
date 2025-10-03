
puts "データベースをクリーニング中..."
Product.destroy_all
Notice.destroy_all
CalendarEvent.destroy_all

puts "ダミー商品を作成中..."

# ダミー商品データ
products_data = [
  { name: "豆大福", price: 180, description: "北海道産の小豆を使用した自慢の豆大福です。", featured: true },
  { name: "草餅", price: 150, description: "よもぎの香り豊かな草餅です。", featured: true },
  { name: "うさぎまんじゅう", price: 130, description: "可愛いうさぎの形をしたおまんじゅうです。", featured: true },
  { name: "もちパイ", price: 200, description: "サクサクのパイ生地にもちもちの求肥が入った人気商品です。", featured: true },
  { name: "みたらし団子", price: 150, description: "甘辛いタレが絶品のみたらし団子です。", featured: true },
  { name: "どら焼き", price: 180, description: "ふんわり生地に粒あんがたっぷり。", seasonal: false },
  { name: "桜餅", price: 160, description: "春限定の桜餅です。", seasonal: true },
  { name: "柏餅", price: 160, description: "端午の節句に最適な柏餅です。", seasonal: true },
  { name: "水ようかん", price: 250, description: "夏にぴったりの水ようかんです。", seasonal: true },
  { name: "栗まんじゅう", price: 200, description: "秋の味覚、栗を使ったまんじゅうです。", seasonal: true },
  { name: "花びら餅", price: 220, description: "お正月の上生菓子です。", seasonal: true }
]

products_data.each_with_index do |data, index|
  product = Product.create!(
    name: data[:name],
    price: data[:price],
    description: data[:description],
    featured: data[:featured] || false,
    seasonal: data[:seasonal] || false,
    featured_order: data[:featured] ? index + 1 : nil,
    seasonal_order: data[:seasonal] ? index + 1 : nil,
    visible: true,
    display_order: index + 1,
    published_at: Time.current
  )

  puts "✓ #{product.name} を作成しました"
end

puts "\nダミーお知らせを作成中..."

notices_data = [
  {
    title: "年末年始の営業について",
    content: "<p>年末年始の営業時間についてお知らせいたします。</p><p>12月31日: 9:00〜15:00<br>1月1日〜3日: 休業<br>1月4日より通常営業</p><p>よろしくお願いいたします。</p>"
  },
  {
    title: "新商品のご案内",
    content: "<p>季節限定の新商品「桜餅」が入荷いたしました。</p><p>春の訪れを感じる、優しい甘さの桜餅をぜひお試しください。</p>"
  },
  {
    title: "臨時休業のお知らせ",
    content: "<p>誠に勝手ながら、3月15日(水)は臨時休業とさせていただきます。</p><p>ご迷惑をおかけいたしますが、何卒よろしくお願いいたします。</p>"
  }
]

notices_data.each do |data|
  notice = Notice.create!(
    title: data[:title],
    content: data[:content],
    published_at: Time.current
  )

  puts "✓ #{notice.title} を作成しました"
end

puts "\n✨ シード完了!"
puts "商品数: #{Product.count}"
puts "お知らせ数: #{Notice.count}"

# 管理者ユーザーの作成は後で実装
# puts "管理者数: #{AdminUser.count}"
