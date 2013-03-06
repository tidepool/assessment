class UserDashboard.Views.BaseTabView extends Backbone.View

  initialize: (options) ->
    @eventDispatcher = options.eventDispatcher
    @childViews = {}
    for viewName, viewClassName of @views
      viewClass = @stringToFunction(viewClassName)
      view = new viewClass(options)
      @childViews[viewName] = view


  stringToFunction: (str) ->
    namespace = str.split(".")
    func = (window || this)
    for newFunc in namespace
      func = func[newFunc]
    if (typeof func isnt "function")
      throw new Error("function not found")
    func

  render: ->
    $(@el).html(@template())
    for viewName, childView of @childViews
      $badgeView = $(@el).find("##{viewName}")
      $badgeView.html(childView.render().el)
    this
