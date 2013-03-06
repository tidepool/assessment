window.UserDashboard =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: (data) ->
    @assessments = new UserDashboard.Collections.Assessments(data.assessments)
    @profile = new UserDashboard.Models.Profile(data.profile)
    window.app = new UserDashboard.Routers.Dashboard({assessments: @assessments, profile: @profile})
    Backbone.history.start()