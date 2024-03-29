class TestService.Views.ProgressBarView extends Backbone.View

  template: JST['assessments/components/progress_bar_view']

  initialize: (options) ->
    @numOfStages = options.numOfStages

  render: ->
    width = 100 / @numOfStages
    $(@el).html(@template(numOfStages: @numOfStages, width: width))
    this

  setStageCompleted: (stage) ->
    for i in [0..@numOfStages]
      if i <= stage
        $("#progress_stage#{i}").addClass("complete")
      else
        $("#progress_stage#{i}").removeClass("complete")

