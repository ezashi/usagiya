# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create admin user
AdminUser.find_or_create_by!(email: "admin@usagiya-fukui.jp") do |admin|
  admin.password = "password123"
  admin.password_confirmation = "password123"
end

puts "Admin user created: admin@usagiya-fukui.jp / password123"

# Create sample notices
unless Notice.exists?
  Notice.create!([
    {
      title: "ホームページをリニューアルしました",
      content: "この度、うさぎやのホームページをリニューアルいたしました。今後ともよろしくお願いいたします。",
      published_at: Time.current
    },
    {
      title: "年末年始の営業のお知らせ",
      content: "誠に勝手ながら、12月31日から1月3日までお休みさせていただきます。よろしくお願いいたします。",
      published_at: Time.current
    }
  ])

  puts "Sample notices created"
end

# Create calendar events for Sundays (regular holidays)
current_month = Date.today.beginning_of_month
next_month = current_month.next_month

[ current_month, next_month ].each do |month|
  (month..month.end_of_month).select(&:sunday?).each do |sunday|
    CalendarEvent.find_or_create_by!(event_date: sunday) do |event|
      event.event_type = :regular_holiday
      event.description = "定休日"
    end
  end
end

puts "Calendar events created for Sundays"

puts "\n=== Seed data creation completed ==="
puts "Please run: rails db:migrate"
puts "Then run: rails db:seed"
