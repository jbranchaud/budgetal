class AnnualBudgetItemsController < AuthenticatedController
  def create
    budget_item = current_user.annual_budgets
                              .find(params[:annual_budget_item][:annual_budget_id])
                              .annual_budget_items
                              .new(budget_item_params)
    if budget_item.save
      render json: budget_item
    else
      render json: { errors: budget_item.errors }, status: 422
    end
  end

  def update
    budget_item = current_user.annual_budget_items.find(params[:annual_budget_item][:id])
    if budget_item.update_attributes(budget_item_params)
      render json: budget_item
    else
      render json: { errors: budget_item.errors }, status: 422
    end
  end

  def destroy
    budget_item = current_user.annual_budget_items.find(params[:id])
    budget_item.destroy
    render json: budget_item
  end

  private

  def budget_item_params
    params.require(:annual_budget_item).permit(:name, :due_date, :paid, :amount)
  end
end
