class TestService.Views.ResultsView extends Backbone.View
  template: JST['assessments/assessment/results_view']

  events:
    "click #go_dashboard": "goDashboard"

  initialize: (options) ->
    @eventDispatcher = options.eventDispatcher
    @noResults = options.noResults

  render: ->
    $(@el).html(@template(results: @model, noResults: @noResults))
    $(".login_logout").css("visibility", "visible")
    this

  goDashboard: ->
    window.location.href = "/dash"