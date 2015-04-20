Constants = require '../constants/constants'
VacationRequestsAPI = require '../state_sources/vacation_requests_source'

module.exports = Marty.createActionCreators
  id: 'RequestFormActionCreators'

  setDatesValidated: (areValid) ->
    @dispatch Constants.requestForm.SET_DATES_VALIDATED, areValid

  create: (vacationRequest) ->
    VacationRequestsAPI.create(vacationRequest)
    .then (res) =>
      switch res.status
        when 200
          @dispatch Constants.requestForm.VACATION_REQUEST_CREATED, res.body
          @dispatch Constants.modal.HIDE
        when 422
          @dispatch Constants.requestForm.SET_ERROR, res.body
    .catch (err) =>
      @dispatch Constants.requestForm.SET_ERROR, 'An error ocurred while creating vacation request'
      console.log 'Error creating Vacation request'
      console.log err