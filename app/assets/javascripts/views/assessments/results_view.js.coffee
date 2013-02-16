class TestService.Views.ResultsView extends Backbone.View
  template: JST['assessments/results_view']

  initialize: (options) ->
    @eventDispatcher = options.eventDispatcher

  render: ->
    $(@el).html(@template(results: @model))
    $(".login_logout").css("visibility", "visible")
    this
