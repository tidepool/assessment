class UserDashboard.Views.BadgeView extends Backbone.View
  template: JST['dashboard/widgets/badge_view']

  initialize: (options) ->


  render: ->
    $(@el).html(@template())
    @delegateEvents()
    this