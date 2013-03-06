class UserDashboard.Routers.Dashboard extends Backbone.Router
  routes:
    '': 'home'
    'home': 'home'
    'personality': 'personality'
    'timeline': 'timeline'

  initialize: (options) ->
    @assessments = options.assessments
    @profile = options.profile
    @eventDispatcher = _.extend({}, Backbone.Events)

  home: ->
    @highlightTab("homeTab")
    view = new UserDashboard.Views.HomeTabView(collection: @assessments, profile: @profile, eventDispatcher: @eventDispatcher)
    $('#content').html(view.render().el)

  timeline: ->
    @highlightTab("timelineTab")
    view = new UserDashboard.Views.TimelineTabView(collection: @assessments, eventDispatcher: @eventDispatcher)
    $('#content').html(view.render().el)
    $('#content').find('.timeslot').each ->
      timeslotHeight = $(this).find('.task').outerHeight()
      $(this).css('height',timeslotHeight);

  personality: ->
    @highlightTab("personalityTab")

  highlightTab: (tabName) ->
    $('.main-menu').find('.active').removeClass('active')
    $('.main-menu').find("##{tabName}").addClass('active')