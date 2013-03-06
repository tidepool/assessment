class UserDashboard.Views.HistoryView extends Backbone.View
  template: JST['dashboard/widgets/history_view']

  initialize: (options) ->
    @eventDispatcher = options.eventDispatcher

  render: ->
    $(@el).html(@template(assessments: @collection))
    @delegateEvents()
    this