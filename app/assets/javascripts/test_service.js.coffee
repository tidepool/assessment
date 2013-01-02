window.TestService =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: (data) -> 
    @definition = new TestService.Models.Definition(data.definition)
    window.app = new TestService.Routers.Assessments({definition: @definition})
    Backbone.history.start()

# $(document).ready ->
#   TestService.initialize()
