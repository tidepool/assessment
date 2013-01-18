class TestService.Views.ProgressBarView extends Backbone.View

  template: JST['components/progress_bar_view']

  initialize: (options) ->
    @numOfStages = options.numOfStages

  render: ->
    width = 100 / @numOfStages
    $(@el).html(@template(numOfStages: @numOfStages, width: width))
    this

  setStageCompleted: (stage) ->
    $("#progress_stage#{stage}").addClass("complete")
