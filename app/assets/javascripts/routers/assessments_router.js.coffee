class TestService.Routers.Assessments extends Backbone.Router
  routes:
    '': 'start',
    'stage/:stageNo': 'nextStage',

  views:
    'ReactionTime': 'TestService.Views.ReactionTime'

  initialize: (options) ->
    @eventDispatcher = _.extend({}, Backbone.Events)
    @eventDispatcher.bind("assessmentChanged", @assessmentChanged)
    @eventDispatcher.bind("userEventCreated", @userEventCreated)
    @definition = options["definition"]
    jsonStages = JSON.parse(@definition.get('stages'))
    @stages = new TestService.Collections.Stages(jsonStages.stages)

  stringToFunction: (str) ->
    namespace = str.split(".")
    func = (window || this)
    for newFunc in namespace
      func = func[newFunc]
    if (typeof func isnt "function")
      throw new Error("function not found")
    func

  assessmentChanged: (assessment) =>
    @assessment = assessment

  userEventCreated: (userEvent) =>
    newUserEvent = _.extend({}, userEvent, {"assessment_id": @assessment.get('id'), "user_id": @assessment.get('user_id')})
    eventModel = new TestService.Models.UserEvent(newUserEvent)
    eventModel.save {},
      error:@handleError

  handleError: =>

  start: ->
    view = new TestService.Views.AssessmentsStart({model: @definition, eventDispatcher: @eventDispatcher})
    $('#content').html(view.render().el)

  nextStage: (stageNo) =>
    stageNo = parseInt(stageNo)
    $(".s#{stageNo}").addClass("complete")
    if stageNo >= @stages.length
      # Final stage
      @userEventCreated({"event_type": "1"})
      isAnonymous = @assessment.anonymous
      if (isAnonymous is 'true')
        window.location.href = "identities/new"
      else
        window.location.href = "assessments/#{@assessment.get('id')}/result/show"
    else
      @stage = @stages.at(stageNo)
      viewClass = @stringToFunction(@views[@stage.get('view_name')])
      view = new viewClass({model: @stage, eventDispatcher: @eventDispatcher, nextStage: stageNo + 1})
      $('#content').html(view.render().el)
