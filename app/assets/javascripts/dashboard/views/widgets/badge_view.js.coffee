class UserDashboard.Views.BadgeView extends Backbone.View
  template: JST['dashboard/widgets/badge_view']

  initialize: (options) ->
    @profile = options.profile

  render: ->
    $(@el).html(@template(profile: @profile.get('profile_description')))
    @delegateEvents()
    this