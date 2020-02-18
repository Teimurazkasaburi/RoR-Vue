class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user
  
    def index
      if current_user.admin
       return @transactions = Transaction.paginate(:page => params[:page], :per_page => 12).order(created_at: :desc)
      else
        return @transactions = current_user.transactions.paginate(:page => params[:page], :per_page => 12).order(created_at: :desc)
      end

      render :index
    end
  
    def show
    end
  
    def create
      @transaction = current_user.transactions.build(transaction_params)
  
      if @transaction.save
        render :show, status: :created
      else
        render json: @transaction.errors, status: :unprocessable_entity
      end
    end
  
  
    def update
        if @transaction.update(transaction_params)
          render :show
        else
          render json: @transaction.errors, status: :unprocessable_entity
        end
    end
  
  
    def destroy
      @transaction.destroy
    end
  
    private
    def set_transaction
      @transaction = Transaction.find_by_ref_no(params[:id])
    end
  
    def transaction_params
      params.require(:transaction).permit(:ref_no, :amount, :transaction_for, :duration, :status)
    end
end
