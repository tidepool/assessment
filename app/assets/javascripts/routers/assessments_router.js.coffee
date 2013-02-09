class TestService.Routers.Assessments extends Backbone.Router
  routes:
    '': 'start'
    'stage/:stageNo': 'nextStage'
    'result': 'showResult'

  views:
    'ReactionTime': 'TestService.Views.ReactionTime'
    'ImageRank': 'TestService.Views.ImageRank'
    'CirclesTest': 'TestService.Views.CirclesTest'

  initialize: (options) ->
    @eventDispatcher = _.extend({}, Backbone.Events)
    @eventDispatcher.bind("createAssessment", @createAssessment)
    # @eventDispatcher.bind("assessmentChanged", @assessmentChanged)
    @eventDispatcher.bind("userEventCreated", @userEventCreated)
    @definition = options["definition"]
    @currentStageNo = 0

  stringToFunction: (str) ->
    namespace = str.split(".")
    func = (window || this)
    for newFunc in namespace
      func = func[newFunc]
    if (typeof func isnt "function")
      throw new Error("function not found")
    func

  createAssessment: =>
    @assessment = new TestService.Models.Assessment()
    assessmentId = $.cookie('assessment_id')
    if not assessmentId or assessmentId is -1
      # Create a new assessment on the server
      attributes = {}
      @assessment.save attributes,
        success: @handleAssessmentCreate
        error: @handleUnsuccessfulCreate
    else
      # Load assessment from the server
      @assessment.id = assessmentId
      @assessment.fetch 
        success: @handleAssessmentCreate
        error: @handleUnsuccessfulCreate

  handleAssessmentCreate: (model, response, options) =>
    @stages = new TestService.Collections.Stages(@assessment.get('stages'))
    @progressBarView = new TestService.Views.ProgressBarView({numOfStages: @stages.length})
    $('#progressbarcontainer').html(@progressBarView.render().el)
    @nextStage(@currentStageNo)
    # @navigate("/stage/#{@currentStageNo}", {trigger: true, replace: true})
    # Backbone.history.navigate("/stage/#{@currentStageNo}", true)

  handleUnsuccessfulCreate: (model, xhr, options) =>
    # TODO: Error Handling for failed assessment creation
    if xhr.status is 401
      # the assessment id does not belong to the user
      # create a new assessment
      $.removeCookie('assessment_id')
      @createAssessment()

  userEventCreated: (userEvent) =>
    newUserEvent = _.extend({}, userEvent, {"assessment_id": @assessment.get('id'), "user_id": @assessment.get('user_id')})
    eventModel = new TestService.Models.UserEvent(newUserEvent)
    eventModel.save {},
      error:@handleError

  handleError: (model, xhr, options) =>
    # TODO: Error handling for failed event saves

  start: ->
    view = new TestService.Views.AssessmentsStart({model: @definition, eventDispatcher: @eventDispatcher})
    $('#content').html(view.render().el)

  tryResult: (assessmentId) =>
    setTimeout =>
      @assessment.id = assessmentId
      @assessment.fetch 
        data: { results: true },
        success: @handleAssessmentResults
        error: @handleFailedAssessmentResults
    , 2000

  handleAssessmentResults: (model, response, options) =>
    if response.status is 206
      @tryResult(@assessment.id)
      return
    $.removeCookie('assessment_id')
    view = new TestService.Views.ResultsView({model: @assessment.get('profile_description'), eventDispatcher: @eventDispatcher})
    $('#content').html(view.render().el)

  handleFailedAssessmentResults: (model, xhr, options) =>
    # TODO: Error handling for failed results

  nextStage: (stageNo) =>
    stageNo = parseInt(stageNo)
    @currentStageNo = stageNo
    $.cookie('current_stage', "#{@currentStageNo}")
    return @createAssessment() if not @assessment?

    if stageNo >= @stages.length
      # Final stage
      @userEventCreated({"event_type": "1"})
      isAnonymous = $.cookie('user_anonymous') == "true"
      if (isAnonymous)
        window.location.href = "identities/new?show_results=1"
      else
        view = new TestService.Views.ResultsProgressBarView()
        $('#content').html(view.render().el)
        @tryResult(@assessment.id)
    else
      priorStage = stageNo - 1
      if priorStage >= 0 
        @progressBarView.setStageCompleted(priorStage)
        
      @stage = @stages.at(stageNo)
      viewClass = @stringToFunction(@views[@stage.get('view_name')])
      view = new viewClass({model: @stage, eventDispatcher: @eventDispatcher, nextStage: stageNo + 1})
      $('#content').html(view.render().el)
