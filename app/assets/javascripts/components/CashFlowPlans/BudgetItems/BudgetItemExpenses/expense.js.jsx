var Expense = React.createClass({
  propTypes: {
    expense: React.PropTypes.object.isRequired,
    save: React.PropTypes.func.isRequired,
    update: React.PropTypes.func.isRequired,
    delete: React.PropTypes.func.isRequired
  },
  getInitialState: function() {
    return {predictions: []}
  },
  componentWillMount: function() {
    this.predict = _.debounce(this.predict, 500)
  },
  predict: function() {
    var self = this
    var word = this.props.expense.name
    if (word.length > 2) {
      ExpenseController.predictions(word)
        .done(function(list) {
          self.setState({predictions: list})
        })
        .fail(function() {
          self.setState({predictions: []})
        })
    } else {
      self.setState({predictions: []})
    }
  },
  save: function(e) {
    e.preventDefault()
    var expense = this.props.expense
    expense.index = this.props.index
    this.props.save(this.props.expense)
  },
  update: function(expense,e) {
    expense[e.target.name] = e.target.value
    this.props.update(this.props.index, expense)
    // Predict expense
    if (e.target.name === 'name') { this.predict() }
  },
  select: function(word) {
    var expense = this.props.expense
    expense.name = word
    this.props.update(this.props.index, expense)
  },
  delete: function(e) {
    e.preventDefault()
    this.props.delete(this.props.expense, this.props.index)
  },
  removePredictions: function(e) {
    this.setState({predictions: []})
  },
  render: function() {
    let expense = this.props.expense
    return (
      <form onSubmit={this.save} data-abide>
        <div className='row'>
          <div className="large-2 medium-2 columns">
            <InputField type='text' name='date' readOnly placeholder='2015-07-01' onChange={this.update.bind(this, expense)} value={expense.date} className='get-date' errors={expense.errors} />
          </div>
          <div className="large-2 medium-2 columns">
            <InputField type='text' onBlur={this.removePredictions} name='name' placeholder='(Rent Payment)' onChange={this.update.bind(this, expense)} value={expense.name} className='expense-item-field' errors={expense.errors} />
            <PredictedExpenses select={this.select} predictions={this.state.predictions} />
          </div>
          <div className="large-2 medium-2 columns">
            <InputField type='number' name='amount' placeholder='0.00' onChange={this.update.bind(this, expense)} defaultValue={numberToCurrency(expense.amount,'')} value={expense.amount} step='any' min='0.00' className='expense-item-field' errors={expense.errors} />
          </div>
          <div className='large-6 medium-6 columns'>
            <button type='submit' title='Save Expense' className='tiny success radius button'><i className='fi-icon fi-check'></i> Save</button>
            &nbsp;
            <a href='#' onClick={this.delete} title='Delete Expense' className='tiny alert radius button'><i className='fi-icon fi-trash'></i> Delete</a>
          </div>
        </div>
      </form>
    )
  }
});


