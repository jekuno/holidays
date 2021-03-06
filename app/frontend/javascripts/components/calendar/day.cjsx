classnames = require 'classnames'
Tipsy = require 'react-tipsy'

module.exports = React.createClass
  displayName: 'Day'

  getInitialState: ->
    selected: @_belongsToSelectedDates()

  componentWillUpdate: (nextProps, nextState) ->
    return unless nextState.selected != @state.selected

    if nextState.selected
      @props.addDate @props.day.date
    else
      @props.removeDate @props.day.date

  componentWillReceiveProps: (nextProps) ->
    @state.selected = @_belongsToSelectedDates nextProps.selectedDates

  _onClick: (e)->
    e.preventDefault()
    return if @props.day.inThePast or @props.clickable is false

    selected = !@state.selected

    @setState
      selected: selected

  _belongsToSelectedDates: (selectedDates = @props.selectedDates) ->
    return unless selectedDates.length > 0

    index = _.findIndex selectedDates, (date) =>
      @props.day.date.isSame date

    index >= 0

  _isPublicHoliday: ->
    return unless @props.publicHolidays.length > 0

    index = _.findIndex @props.publicHolidays, (date) =>
      @props.day.date.isSame date.day

    index >= 0

  _handleApprovedDay: ->
    avatars = []

    for approvedDay in @props.approvedDays
      if @props.day.date.isSame approvedDay.day
        avatars.push(
          <Tipsy key={approvedDay.id} content={approvedDay.user_full_name} placement="top">
            <img className="avatar" src={approvedDay.user_avatar}/>
          </Tipsy>
        )
    <div className="avatars-wrapper">{avatars}</div>

  render: ->
    day = @props.day.date.format("YYYY-MM-DD")

    dayClasses = classnames
      day: true
      today: @props.day.isToday
      'different-month': not @props.day.isCurrentMonth
      'past': @props.day.inThePast
      selected: @state.selected || @_belongsToSelectedDates()
      'public-holiday': @_isPublicHoliday()

    <div id={day} key={day} className={dayClasses} onClick={@_onClick} onTouchEnd={@_onClick}>
      <span className="day-number">{@props.day.number}</span>
      {@_handleApprovedDay()}
    </div>
