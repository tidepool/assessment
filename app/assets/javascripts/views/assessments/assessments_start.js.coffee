class TestService.Views.AssessmentsStart extends Backbone.View

  template: JST['assessments/start']

  events:
    'submit #new_assessment': 'createAssessment'

  initialize: (options) ->
    @eventDispatcher = options.eventDispatcher
    # @model.on('reset', @render, this)

  render: ->
    $(@el).html(@template(definition: @model))
    this
    
  createAssessment: (event) ->
    @eventDispatcher.trigger("createAssessment")    
    # @assessment = new TestService.Models.Assessment()
    # attributes = {}
    # @assessment.save attributes,
    #   success: @start
    #   error: @handleError
    event.preventDefault()

  # start: =>
  #   @eventDispatcher.trigger("assessmentChanged", @assessment)
  #   Backbone.history.navigate("/stage/0", true)

  # handleError: ->
