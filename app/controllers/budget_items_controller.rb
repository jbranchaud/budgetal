class BudgetItemsController < ApplicationController
  
  def create
    bi = BudgetItem.new params[:budget_item]
    if bi.save
      respond_to do |format|
        format.html { redirect_to root_path(budget_id: bi.budget_category.budget.id), notice: 'Created Budget Item' }
        format.json { flash[:notice] = "Created Budget Item" }
      end
    else
      respond_to do |format|
        format.html { flash[:error] = "Something went wrong!"; redirect_to root_path(budget_id: bi.budget_category.budget.id) }
        format.json { flash[:error] = "Something went wrong!"; }
      end
    end
  end

  def update
    bi = BudgetItem.find params[:id]
    if bi.update_attributes params[:budget_item]
      respond_to do |format|
        format.html { redirect_to root_path(budget_id: budget_id), notice: 'Updated Budget Item' }
        format.json { flash[:notice] = "Updated Budget Item"; }
      end
    else
      respond_to do |format|
        format.html { flash[:error] = "Something went wrong!"; redirect_to root_path(budget_id: budget_id) }
        format.json { flash[:error] = "Something went wrong!"; }
      end
    end
  end

  def destroy
    bi = BudgetItem.find params[:id]
    b_id = budget_id
    bi.budget_item_expenses.each {|bie| bie.destroy }
    bi.destroy

    respond_to do |format|
      format.html { flash[:notice] = "Deleted Budget Item"; redirect_to root_path(budget_id: b_id) }
      format.json { flash[:notice] = "Deleted Budget Item"; }
    end
  end

  def budget_id
    BudgetItem.find(params[:id]).budget_category.budget.id
  end
end