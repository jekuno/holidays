PublicHolidaysList = require './list'
PublicHolidaysEditor = require './editor'
moment = require 'moment'

PublicHolidaysSection = React.createClass
  displayName: 'PublicHolidaysSection'

  _renderList: ->
    return if @props.publicHolidays.length == 0 and @props.newPublicHolidays.length == 0

    <PublicHolidaysList publicHolidays={@props.publicHolidays} newPublicHolidays={@props.newPublicHolidays} editMode={@props.editMode}/>

  _handleEditClick: (e) ->
    e.preventDefault()
    @app.actionCreators.publicHolidays.setEditMode true

  _handleCancelEditClick: (e) ->
    e.preventDefault()
    @app.actionCreators.publicHolidays.setEditMode false

  _renderHeaderActions: ->
    return if @props.publicHolidays.length == 0

    if @props.editMode is false
      <a href="#" onClick={@_handleEditClick}><i className="fa fa-pencil"/> edit</a>

  _handleAddNewClick: (e)->
    e.preventDefault()
    @app.actionCreators.publicHolidays.addNew()

  _renderActions: ->
    return if @props.publicHolidays.length == 0 and @props.newPublicHolidays.length == 0

    if @props.editMode is true
      <div>
        <a href="#" onClick={@_handleCancelEditClick}><i className="fa fa-cancel"/> cancel edit</a>
        <a href="#" className="btn" onClick={@_handleOnUpdateClick}>Save holidays</a>
      </div>
    else
      <div>
        <a href="#" onClick={@_handleAddNewClick}><i className="fa fa-plus"/> add new public holiday</a>
        {@_renderSaveButton()}
      </div>

  _renderSaveButton: ->
    return if @props.newPublicHolidays.length is 0

    <a href="#" className="btn" onClick={@_handleOnSaveClick}>Save holidays</a>

  _renderValidationError: ->
    return if @props.validationSucceed is true

    <div className="message error-message">Please fill correctly all days</div>

  _renderSuccessMessage: ->
    return if @props.successMessage is undefined or @props.successMessage == null

    <div className="message success-message">{@props.successMessage}</div>

  _handleOnUpdateClick: (e) ->
    e.preventDefault()

    if @_validHolidays(@props.newPublicHolidays) then @_updateHolidays() else @_setValidationError()

  _handleOnSaveClick: (e) ->
    e.preventDefault()

    if @_validHolidays(@props.newPublicHolidays) then @_saveHolidays() else @_setValidationError()

  _saveHolidays: ->
    @app.actionCreators.publicHolidays.save @props.newPublicHolidays

  _updateHolidays: ->
    @app.actionCreators.publicHolidays.update @props.publicHolidays

  _setValidationError: ->
    @app.actionCreators.publicHolidays.invalidateHolidays()

  _validHolidays: (holidays)->
    valid = true

    for holiday in holidays
      if holiday.day == '' or holiday.name == ''
        valid = false
        break

    valid

  _onDuplicateClick: (e) ->
    e.preventDefault()
    @app.queries.publicHolidays.duplicateForYear(moment().subtract(1, 'year').format())

  _renderDuplicateLastYear: ->
    return unless @props.publicHolidays.length == 0 and @props.newPublicHolidays.length == 0

    <div>
      <p>There are no public holidays registered for the current year. </p>
      <a className="btn" href="#" onClick={@_onDuplicateClick}>
        <i className="fa fa-copy"></i> Duplicate last year
      </a>
    </div>

  render: ->
    <section>
      <div className="container">
        <header>
          <h2>Public holidays</h2>
        </header>
        <div className="box">
          <header>
            <h4>Current public holidays</h4>
            <div className="actions">
              {@_renderHeaderActions()}
            </div>
          </header>
          {@_renderValidationError()}
          {@_renderSuccessMessage()}
          {@_renderList()}
          {@_renderActions()}
          {@_renderDuplicateLastYear()}
        </div>
      </div>
    </section>

module.exports = Marty.createContainer PublicHolidaysSection,
  listenTo: 'stores.publicHolidays'

  fetch:
    publicHolidays: ->
      @app.stores.publicHolidays.getPublicHolidays()
    newPublicHolidays: ->
      @app.stores.publicHolidays.getState().newPublicHolidays
    editMode: ->
      @app.stores.publicHolidays.getState().editMode
    validationSucceed: ->
      @app.stores.publicHolidays.getState().validationSucceed
    successMessage: ->
      @app.stores.publicHolidays.getState().successMessage
