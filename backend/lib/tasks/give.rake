task :give => :environment do
  Subscription.where(plan: "FREE", expiring_date: nil) do |subs|
    puts "Giving - #{subs.user.f_name} free 3 Max post"
    subs.update_attributes( max_post: 3 )
  end
end