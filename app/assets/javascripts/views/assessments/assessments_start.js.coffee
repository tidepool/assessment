class TestService.Views.AssessmentsStart extends Backbone.View

  template: JST['assessments/start']

  events:
    'submit #new_assessment': 'startAssessment'

  initialize: (options) ->
    @eventDispatcher = options.eventDispatcher

  render: ->
    $(@el).html(@template(definition: @model.get('definition')))
    $(".login_logout").css("visibility", "visible")
    this
    
  startAssessment: (event) ->
    @eventDispatcher.trigger("startAssessment")
    event.preventDefault()

