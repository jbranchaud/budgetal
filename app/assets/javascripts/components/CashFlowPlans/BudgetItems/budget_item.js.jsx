var BudgetItem = React.createClass({
  propTypes: {
    budgetItem: React.PropTypes.object.isRequired,
    expenseFunctions: React.PropTypes.object.isRequired,
    save: React.PropTypes.func.isRequired,
    update: React.PropTypes.func.isRequired,
    delete: React.PropTypes.func.isRequired
  },
  getInitialState: function() {
    return {
      hideExpenses: true
    }
  },
  spent: function() {
    let expenses = this.props.budgetItem.budget_item_expenses
    return _.reduce(expenses, function(total, expense, index) {
      return parseFloat(total) + parseFloat(expense.amount);
    }, 0.00);
  },
  remaining: function() {
    let amount_budgeted = this.props.budgetItem.amount_budgeted
    return amount_budgeted - this.spent()
  },
  update: function(item,e) {
    item[e.target.name] = e.target.value
    this.props.update(this.props.index, item)
  },
  save: function(e) {
    e.preventDefault()
    var item = this.props.budgetItem
    item.index = this.props.index
    this.props.save(this.props.budgetItem)
  },
  delete: function(e) {
    e.preventDefault()
    this.props.delete(this.props.budgetItem, this.props.index)
  },
  toggleExpenses: function(e) {
    e.preventDefault();
    if (this.props.budgetItem.budget_item_expenses) {
      this.setState({hideExpenses: !this.state.hideExpenses});
    }
  },
  remainingClass: function() {
    var item = this.props.budgetItem;
    return classNames({
      'success-color': this.remaining() > 0,
      'alert-color': this.remaining() < 0,
      'blue': Math.abs(numberToCurrency(this.remaining(), '')) == 0
    });
  },
  drag: function(e) {
    e.dataTransfer.setData('budget_item_id', this.props.budgetItem.id)
    e.dataTransfer.setData('original_category_id', this.props.budgetItem.budget_category_id)
  },
  render: function() {
    let item = this.props.budgetItem;
    var expensesClasses = classNames('expense-list', {hide: this.state.hideExpenses, fadeIn: !this.state.hideExpenses})
    var toggleClasses = classNames('fi-play move-cursor', {'expanded-list': !this.state.hideExpenses})
    return (
      <div>
        <div className='row'>
          <form onSubmit={this.save} data-abide>
            <div className="large-4 medium-4 columns budget-item-name">
              <a href='#' onClick={this.toggleExpenses} className='show-expenses'><i draggable onDragStart={this.drag} className={toggleClasses}></i></a>
              <InputField onChange={this.update.bind(this, item)} type='text' name='name' placeholder='Name' value={item.name} errors={item.errors} />
            </div>
            <div className="large-1 medium-1 columns text-right budget-item-amount-spent">
              {numberToCurrency(this.spent())}
            </div>
            <div className="large-2 medium-2 columns text-right budget-item-amount-budgeted">
              <InputField onChange={this.update.bind(this, item)} type='number' name='amount_budgeted' step='any' min='0.00' required placeholder='0.00' defaultValue={numberToCurrency(this.amount_budgeted, '')} value={item.amount_budgeted} errors={item.errors} />
            </div>
            <div className="large-1 medium-1 columns text-right">
              <span className={this.remainingClass()}>{numberToCurrency(this.remaining())}</span>
            </div>
            <div className='large-4 medium-4 columns'>
              <button type='submit' title='Save Budget Item' className='tiny success radius button'><i className='fi-icon fi-check'></i> Save</button>
              &nbsp;
              <a href='#' onClick={this.delete} title='Delete Budget Item' className='tiny alert radius button'><i className='fi-icon fi-trash'></i> Delete</a>
            </div>
          </form>
        </div>
        <ExpenseList className={expensesClasses} expenses={item.budget_item_expenses} budgetItemId={this.props.budgetItem.id} functions={this.props.expenseFunctions} />
        <ul data-dropdown-content className="f-dropdown"></ul>
      </div>
    )
  }
});