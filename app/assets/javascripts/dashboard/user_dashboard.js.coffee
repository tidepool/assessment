window.UserDashboard =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: (data) ->
    @assessment = new UserDashboard.Models.Assessment(data.assessment)
    window.app = new UserDashboard.Routers.Dashboard({assessment: @assessment})
    Backbone.history.start()