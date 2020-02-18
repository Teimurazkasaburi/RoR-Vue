task :expire_subscription => :environment do
  Subscription.expired.each do |subs|
    puts "Expirings - #{subs.user.f_name}'s #{subs.plan} subscription"
    subs.update_attributes( plan: "FREE", expiring_date: '', boost: 0, priorities: 0 )
  end


  subs = Post.where("score > ?", 0 )
  subs.each do |post|
    puts "#{subs.size}"
    if post.user.subscription && post.user.subscription.expiring_date == nil
      puts "Clearing - #{post.user.f_name}'s priority and boosted listings with post_id: #{post.id}"
      post.update_attributes( boost: 0, priority: 0, promotion_updated_at: Time.now.beginning_of_year, score: 0 )
    end
  end
  
end