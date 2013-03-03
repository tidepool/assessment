class UserDashboard.Views.TimelineView extends Backbone.View
  template: JST['dashboard/widgets/timeline_view']

  initialize: (options) ->


  render: ->
    $(@el).html(@template())
    @delegateEvents()
    this