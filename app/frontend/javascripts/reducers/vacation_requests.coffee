constants = require '../constants'

initalState =
  vacationRequests: []
  meta:
    current_page: 1

module.exports = (state = initalState, action) ->
  switch action.type
    when constants.VACATION_REQUESTS_RECEIVED
      vacationRequests = _.cloneDeep state.vacationRequests
      newVacationRequests = _.uniq vacationRequests.concat(action.vacationRequests), 'id'

      _.assign {}, state, vacationRequests: newVacationRequests, meta: action.meta

    when constants.VACATION_REQUEST_REPLACE
      vacationRequests = _.cloneDeep state.vacationRequests

      index = _.findIndex vacationRequests, (request) ->
        action.vacationRequest.id == request.id

      vacationRequests[index] = action.vacationRequest

      _.assign {}, state, vacationRequests: vacationRequests
    else
      state
