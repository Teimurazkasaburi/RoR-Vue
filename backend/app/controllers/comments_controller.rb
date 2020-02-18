class CommentsController < ApplicationController
  before_action :authenticate_user
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  
    def index
      @comments = Comment.all.order(created_at: :desc)
    end
  
    def show
    end
  
    def create
      forum = Forum.find_by_permalink(params[:forum_id])

      @comment= forum.comments.build(comment_params)
      @comment.user = current_user
  
      if @comment.save
        render json: {message: "Created"}, status: :created
      else
        render json: @comment.errors, status: :unprocessable_entity
      end
    end
  
  
    def update
      if @comment.user == current_user || current_user.admin
        if @comment.update(comment_params)
        render json: {message: "Updated"}, status: :accepted
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      else
          render json:   { message: "You're not authorized to carry out this action" }, status: :unauthorized
      end
    end
  
  
    def destroy
      if @comment.user == current_user || current_user.admin
        @comment.destroy
        else
          render json:   { message: "You're not authorized to carry out this action" }, status: :unauthorized
      end
    end
  
    private
    def set_comment
      @comment = Comment.find(params[:id])
    end
  
    def comment_params
      params.require(:comment).permit(:body)
    end
end
