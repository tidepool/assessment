class TestService.Views.ResultsView extends Backbone.View
  template: JST['assessments/results_view']

  initialize: (options) ->
    @eventDispatcher = options.eventDispatcher
    @noResults = options.noResults

  render: ->
    $(@el).html(@template(results: @model, noResults: @noResults))
    $(".login_logout").css("visibility", "visible")
    this
