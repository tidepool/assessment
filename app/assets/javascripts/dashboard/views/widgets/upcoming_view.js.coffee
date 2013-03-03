class UserDashboard.Views.UpcomingView extends Backbone.View
  template: JST['dashboard/widgets/upcoming_view']

  initialize: (options) ->


  render: ->
    $(@el).html(@template())
    @delegateEvents()
    this