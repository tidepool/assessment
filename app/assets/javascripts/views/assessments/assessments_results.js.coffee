class TestService.Views.AssessmentsResults extends Backbone.View

  template: JST['assessments/results']

  events:
    'submit #new_assessment': 'createAssessment'

  initialize: (options) ->
    @eventDispatcher = options.eventDispatcher
    # @model.on('reset', @render, this)

  render: ->
    $(@el).html(@template(definition: @model))
    this
        