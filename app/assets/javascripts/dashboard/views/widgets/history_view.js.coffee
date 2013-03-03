class UserDashboard.Views.HistoryView extends Backbone.View
  template: JST['dashboard/widgets/history_view']

  initialize: (options) ->


  render: ->
    $(@el).html(@template())
    @delegateEvents()
    this