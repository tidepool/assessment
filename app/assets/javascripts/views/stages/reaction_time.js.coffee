class TestService.Views.ReactionTime extends TestService.Views.BaseView

  template: JST['stages/reaction_time']

  events:
    "click #start": "startTest",
    "click #circle": "circleClicked"

  initialize: (options) ->
    @eventDispatcher = options.eventDispatcher
    @nextStage = options.nextStage
    @colorSequence = @model.get('color_sequence')
    @sequenceNo = -1
    @numOfSequences = @colorSequence.length

  render: ->
    $(@el).html(@template(stage: @model))
    $("#infobox").css("visibility", "visible")
    this

  waitAndShow: =>
    min = 300
    max = 1500
    interval = Math.floor(Math.random() * (max - min + 1)) + min
    setTimeout @showCircle, interval

  startTest: =>
    @createUserEvent({"event_desc": "testStarted"})
    $("#infobox").css("visibility", "hidden")
    @waitAndShow()

  showCircle: => 
    @sequenceNo += 1
    if @sequenceNo < @numOfSequences
      @createUserEvent({"event_desc": "circleShown", "circle_color": @colorSequence[@sequenceNo]})
      $("#circle").css("background-color", @colorSequence[@sequenceNo])
      next_seq = @sequenceNo + 1
      if next_seq < @numOfSequences
        @waitAndShow()

  circleClicked: =>
    if (@numOfSequences == 1) or (@sequenceNo > 1 and (@colorSequence[@sequenceNo - 1] is "yellow") and (@colorSequence[@sequenceNo] is "red"))
      @createUserEvent({"event_desc": "correctCircleClicked", "sequenceNo": @sequenceNo})
      Backbone.history.navigate("/stage/#{@nextStage}", true)
    else
      @createUserEvent({"event_desc": "wrongCircleClicked", "sequenceNo": @sequenceNo})

  createUserEvent: (newEvent) =>
    record_time = new Date().getTime()
    @eventInfo = {"event_type": "0", "module": "reaction_time", "record_time": record_time}
    userEvent = _.extend({}, @eventInfo, newEvent)
    @eventDispatcher.trigger("userEventCreated", userEvent)
