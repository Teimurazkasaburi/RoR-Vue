class ForumsController < ApplicationController
  before_action :set_forum, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, except: [:index, :show, :stats]
  
  def index
    args = {}

    args[:category] = params[:category] if params[:category].present?

    query = params[:q].presence || "*"
    @forums = Forum.search query, order: { created_at: :desc }, fields: [:subject, :body],misspellings: {edit_distance: 2, below: 1}, where: args, aggs: { category: {}}, page: params[:page], per_page: 8
    @current_user = current_user
  end

  def filter
    if params[:participating].present? && params[:participating] == "true"
      @forums = Forum.includes(:comments).where( comments: {user_id: current_user.id} ).order(created_at: :desc).paginate(:page => params[:page], :per_page => 8)

    elsif params[:answered].present? && params[:answered] == "true"
      @forums = Forum.where("comments_count > ? AND user_id = ?", 0, current_user.id).order(created_at: :desc).paginate(:page => params[:page], :per_page => 8)

    elsif params[:answered].present? && params[:answered] == "false"
      @forums = Forum.where("comments_count <= ? AND user_id = ?", 0, current_user.id).order(created_at: :desc).paginate(:page => params[:page], :per_page => 8)

    else
      @forums = current_user.forums.order(created_at: :desc).paginate(:page => params[:page], :per_page => 8)
    end

    render :index
  end


  def stats
    @design = Forum.where(category: "DESIGN").size
    @construction = Forum.where(category: "CONSTRUCTION").size
    @sales = Forum.where(category: "SALES").size
    @legal = Forum.where(category: "LEGAL").size
    @investments = Forum.where(category: "INVESTMENTS").size
    @agents = Forum.where(category: "AGENTS").size
    @questions = Forum.where(category: "QUESTIONS").size
  end

  def show
    @current_user = current_user
  end

  def create
    @forum = current_user.forums.build(forum_params)

    if @forum.save
      render :show, status: :created
    else
      render json: @forum.errors, status: :unprocessable_entity
    end
  end


  def update
    if @forum.user == current_user || current_user.admin
      if @forum.update(forum_params)
        render :show
      else
        render json: @forum.errors, status: :unprocessable_entity
      end
    else
      render json:   { message: "You're not authorized to carry out this action" }, status: :unauthorized
    end
  end


  def destroy
    if @forum.user == current_user || current_user.admin
      @forum.destroy
    else
        render json:   { message: "You're not authorized to carry out this action" }, status: :unauthorized
    end
  end

  private
  def set_forum
    @forum = Forum.find_by_permalink(params[:id])
  end

  def forum_params
    params.require(:forum).permit(:body, :subject, :category)
  end
end
