class UserDashboard.Views.TimelineView extends Backbone.View
  template: JST['dashboard/widgets/timeline_view']

  initialize: (options) ->
    @eventDispatcher = options.eventDispatcher

  render: ->
    $(@el).html(@template(assessments: @collection))
    @delegateEvents()
    this