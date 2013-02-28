class UserDashboard.Routers.Dashboard extends Backbone.Router
  routes:
    '': 'home'
    'home': 'home'
    'personality': 'personality'
    'timeline': 'timeline'

  initialize: (options) ->
    @eventDispatcher = _.extend({}, Backbone.Events)


  home: ->
