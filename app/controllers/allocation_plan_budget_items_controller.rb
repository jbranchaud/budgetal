class AllocationPlanBudgetItemsController < AuthenticatedController
  before_filter :find_allocation_plan, except: %w{create}
  before_filter :authorize_params, only: %w{create}

  def create    
    flash[:notice] = @apbi.update_attributes(apbi_params) ? 'Updated!' : 'Something went wrong.'    
    render 'allocation_plans/update'
  end

  private

  def authorize_params
    plan_id = params[:allocation_plan_budget_item][:allocation_plan_id].to_i
    item_id = params[:allocation_plan_budget_item][:budget_item_id].to_i

    flash[:notice] = 'You are not authorized! This incident will be reported!'
    redirect_to root_path and return unless AllocationPlan.exists?(id: plan_id) && AllocationPlan.find(plan_id).budget.user_id == current_user.id
    redirect_to root_path and return unless BudgetItem.exists?(id: item_id) && BudgetItem.find(item_id).budget_category.budget.user_id == current_user.id
    
    @apbi = AllocationPlanBudgetItem.where(allocation_plan_id: params[:allocation_plan_budget_item][:allocation_plan_id], budget_item_id: params[:allocation_plan_budget_item][:budget_item_id]).first_or_create
  end

  def find_allocation_plan
    @apbi = current_user.budgets.find(params[:budget_id]).allocation_plans.find(params[:id]).allocation_plan_budget_items.where(allocation_plan_id: params[:id], budget_item_id: params[:budget_item_id]).first || AllocationPlanBudgetItem.new(allocation_plan_id: params[:id], budget_item_id: params[:budget_item_id])
  end

  def apbi_params
    params.require(:allocation_plan_budget_item).permit(:budget_item_id, :allocation_plan_id, :amount_budgeted)
  end
end
