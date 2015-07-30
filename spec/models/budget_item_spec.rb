require 'rails_helper'

describe BudgetItem do
  let(:user)   { FactoryGirl.create :user }
  let(:budget) { FactoryGirl.create :budget, :with_budget_items, user: user }
  let(:budget_item) { budget.budget_items.first }
  let(:plan) { budget.allocation_plans.create }

  describe '#past_expenses' do
    it 'returns a list of expense names that have been used more than twice' do
      FactoryGirl.create :budget_item_expense, name: 'My Gift', budget_item: budget_item
      FactoryGirl.create :budget_item_expense, name: 'My Gift', budget_item: budget_item
      FactoryGirl.create :budget_item_expense, name: 'My Gift', budget_item: budget_item
      expect(budget_item.past_expenses).to eq(['Add a new item', 'My Gift'])
    end

    it 'returns nothing for expense names that have not been used more than twice' do
      expect(budget_item.past_expenses).to eq(['Add a new item'])
    end
  end

  describe '#amount_allocated' do
    it 'returns the amount allocated to allocation plans' do
      plan.allocation_plan_budget_items.create(amount_budgeted: 25.00, budget_item: budget_item)
      expect(budget_item.amount_allocated).to eq(25.00)
    end
  end

  describe '#remaining_allocations' do
    it 'returns the amount left to allocate in an allocation plan' do
      plan.allocation_plan_budget_items.create(amount_budgeted: 25.00, budget_item: budget_item)
      expect(budget_item.remaining_allocations).to eq(375.00)
    end
  end
end
