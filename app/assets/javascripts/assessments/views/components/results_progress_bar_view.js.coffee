class TestService.Views.ResultsProgressBarView extends Backbone.View

  template: JST['assessments/components/results_progress_bar_view']

  initialize: (options) ->

  render: ->
    $(@el).html(@template())
    this
