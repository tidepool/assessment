class TestService.Views.AssessmentsStart extends Backbone.View

  template: JST['assessments/start']

  events:
    'submit #new_assessment': 'createAssessment'

  initialize: (options) ->
    @eventDispatcher = options.eventDispatcher

  render: ->
    $(@el).html(@template(definition: @model))
    this
    
  createAssessment: (event) ->
    @eventDispatcher.trigger("createAssessment")    
    event.preventDefault()

