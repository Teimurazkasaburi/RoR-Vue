class PromoteController < ApplicationController
  before_action :authenticate_user


  def promoter
    max_boost = 4
    max_priority = 1
    post = Post.find_by_permalink(params[:id])
    subscription = current_user.subscription
    boost = params[:promote][:boost].to_i if params[:promote][:boost].present?
    priority = params[:promote][:priority].to_i if params[:promote][:priority].present?
    current_boost = post.boost
    current_priority = post.priority
    remaining_boost = subscription.boost
    remaining_priorities = subscription.priorities
    score = post.score
    message = { priority: "", boost: "" }
    listing = params[:promote][:type]
    


    case 
        when listing == "BOOST"
          boost_listing( boost, max_boost, remaining_boost, current_boost, score, post, subscription, current_priority )
        when listing == "PRIORITY"
          priority_listing( priority, max_priority, remaining_priorities, current_priority, score, post, subscription )
        else
          render "Unknown plan"		
    end
  end


  private

  def priority_listing( priority, max_priority, remaining_priorities, current_priority, score, post, subscription )
    if remaining_priorities > 0
      if ( priority <= max_priority  && ( current_priority + priority  <= max_priority ) )
        new_priority = current_priority + priority
        post.update_attributes(priority: new_priority, score: score + priority, promotion_updated_at: Time.now)
        subscription.update_attributes(priorities: remaining_priorities - priority)
        priority_count = current_user.posts.where("priority > ?", 0).size
        current_user.update_attributes(priority_count: priority_count)
        render json: { message: "Your priority listing was successful",  priority: new_priority }
      else
        render json: { message: "You can only set 1 priority listing for this post" }, status: :forbidden
      end
    else
      render json: { message: "You've ran out priority listings" }, status: :forbidden
    end
  end


  def boost_listing( boost, max_boost, remaining_boost, current_boost, score, post, subscription, current_priority )
    if remaining_boost > 0
      if current_priority > 0
        if ( boost <= max_boost  && ( current_boost + boost  <= max_boost ) )
          new_boost = current_boost + boost
          post.update_attributes(boost: new_boost, score: score + boost, promotion_updated_at: Time.now)
          subscription.update_attributes(boost: remaining_boost - boost)
          boost_count = current_user.posts.where("boost > ?", 0).size
          current_user.update_attributes(boost_count: boost_count)
          render json: { message: "Your priority boost was successful",  boost: new_boost}
        else
          render json: { message: "You can only set 4 priority boosts for this post" }, status: :forbidden
        end
      else
        render json: { message: "You must have priority listing set before you can boost this post" }, status: :forbidden
      end
    else
      render json: { message: "You've ran out priority boosts" }, status: :forbidden
    end
  end


end
