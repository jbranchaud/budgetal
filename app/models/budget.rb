class Budget < ActiveRecord::Base
  belongs_to :user
  has_many :budget_categories, dependent: :destroy
  has_many :budget_items, through: :budget_categories
  has_many :budget_item_expenses, through: :budget_items
  has_many :allocation_plans, dependent: :destroy

  validates_presence_of :monthly_income

  validates_numericality_of :month,
    only_integer: true,
    less_than_or_equal_to: 12,
    greater_than_or_equal_to: 1

  validates_numericality_of :year,
    only_integer: true,
    less_than_or_equal_to: 2020,
    greater_than_or_equal_to: 2013

  scope :ordered, -> { order('year::integer desc, month::integer desc') }

  def total_expenses
    total_expense = ActiveRecord::Base.connection.select_all(<<-SQL)
      select sum(bie.amount)
      from budgets b
      join budget_categories bc on bc.budget_id=b.id
      join budget_items bi on bi.budget_category_id=bc.id
      join budget_item_expenses bie on bie.budget_item_id=bi.id
      where b.id = #{id}
    SQL
    total_expense.first['sum'].to_f
  end

  def difference
    monthly_income-total_expenses
  end

  def self.create_template(month, year, user_id)
    budget = Budget.create(month: month, year: year, user_id: user_id, monthly_income: 4000.00)
    budget.budget_categories.create(name: 'Charity', percentage: '10-15%')
    budget.budget_categories.create(name: 'Saving', percentage: '10-15%')
    budget.budget_categories.create(name: 'Housing', percentage: '25-35%')
    budget.budget_categories.create(name: 'Utilities', percentage: '5-10%')
    budget.budget_categories.create(name: 'Food', percentage: '5-15%')
    budget.budget_categories.create(name: 'Clothing', percentage: '2-7%')
    budget.budget_categories.create(name: 'Transportation', percentage: '10-15%')
    budget.budget_categories.create(name: 'Medical/Health', percentage: '5-10%')
    budget.budget_categories.create(name: 'Insurance', percentage: '10-25%')
    budget.budget_categories.create(name: 'Personal', percentage: '5-10%')
    budget.budget_categories.create(name: 'Recreation', percentage: '5-10%')
    budget.budget_categories.create(name: 'Debts', percentage: '0%')
    budget
  end

  def pretty_date
    Date.new(1, month.to_i).strftime("%B")
  end

  def amount_budgeted
    Budget.where(id: id).joins(:budget_items).sum(:amount_budgeted).to_f
  end

  def budget_remaining
    amount_budgeted - total_expenses
  end

  def amount_remaining
    monthly_income.to_f - amount_budgeted
  end

  def percent_spent
    spent = (total_expenses / amount_budgeted * 100).round(3)
    spent > 100 ? 100 : spent
  end

  def percent_used
    used = (100 - (amount_remaining / monthly_income.to_f * 100))
    used > 100 ? 100 : used
  end
end
