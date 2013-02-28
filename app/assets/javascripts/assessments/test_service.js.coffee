window.TestService =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: (data) -> 
    @assessment = new TestService.Models.Assessment(data.assessment)
    window.app = new TestService.Routers.Assessments({assessment: @assessment})
    Backbone.history.start()
