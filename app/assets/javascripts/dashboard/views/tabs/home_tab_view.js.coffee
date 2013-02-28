class UserDashboard.Views.HomeTabView extends Backbone.View

  template: JST['dashboard/tabs/home_tab_view']

  initialize: (options) ->


  render: ->
    $(@el).html(@template())
    this
