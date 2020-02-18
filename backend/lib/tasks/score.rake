task :score => :environment do
  Post.scorable.each do |post|
    score = post.score
    score_in_integer = score.to_f.round()
    dilation_rate = 0.0005555555555555556 * score_in_integer


    post.update_attributes(score: score - dilation_rate)
    puts "New score #{post.score}, post id: #{post.id}"
  end
end