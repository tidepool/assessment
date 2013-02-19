class TestService.Views.CirclesTest extends TestService.Views.BaseView

  template: JST['stages/circles_test']

  events:
    "click #start": "startTest"
    "click #end": "endTest"

  initialize: (options) ->
    @eventDispatcher = options.eventDispatcher
    @nextStage = options.nextStage
    inputCircles = @model.get('circles')
    @circles = ({
      "trait1": circle.trait1,
      "trait2": circle.trait2,
      "size": parseInt(circle.size) - 1,
      "changed": false,
      "moved": false,
      "top": 0,
      "left": 0,
      "width": 0,
      "height": 0
      } for circle, i in inputCircles)
    # This test has to sub stages, currentStage reflects that
    @currentStage = 0

  render: ->
    $(@el).html(@template(stage: @model, circles: @circles, currentStage: @currentStage))
    $("#infobox").css("visibility", "visible")
    $(".login_logout").css("visibility", "hidden")
    this

  startTest: =>
    $("#infobox").css("visibility", "hidden")

    switch @currentStage
      when 0
        # Sizing the circles
        @createUserEvent
          "event_desc": "test_started"
        @setupSliders()
        @toggleVisibility("visible")
      when 1
        # Moving circles to self
        @updateCircleCoordsAndSizes()  
        @createUserEvent
          "event_desc": "move_circles_started"
          "circles": @circles

        @toggleVisibility("hidden")
        @setupDraggableCircles()
        $(".self").css("visibility", "visible")

  endTest: =>
    @updateCircleCoordsAndSizes()
    @createUserEvent
      "event_desc": "test_completed"
      "circles": @circles
      "self_coord": { top: @SELF_COORD_TOP, left: @SELF_COORD_LEFT, size: @SELF_COORD_SIZE }

    Backbone.history.navigate("/stage/#{@nextStage}", true)

  updateCircleCoordsAndSizes: ->
    for circle, i in @circles
      circleSelector = ".circle.c#{i}"
      circle.top = $(circleSelector).offset().top
      circle.left = $(circleSelector).offset().left
      circle.width = $(circleSelector).width()
      circle.height = $(circleSelector).height()

  sliderChanged: (e, ui) =>
    selectedCircleNo = e.target.getAttribute("data-circleid")
    selectedCircle = @circles[selectedCircleNo]
    selectedCircle.changed = true
    delta = (selectedCircle.size - ui.value) * @GROW_BY
    selectedCircle.size = ui.value

    selectedCircle.width = selectedCircle.width - delta
    selectedCircle.height = selectedCircle.height - delta
    selectedCircle.top += delta/2
    selectedCircle.left += delta/2
    selectedCircle.textMarginTop -= delta/2
    selectedCircle.sliderMarginLeft -= delta/2

    circleSelector = ".circle.c#{selectedCircleNo}"
    $(circleSelector + " .text").css("margin-top", String(selectedCircle.textMarginTop) + "px" )
    $(circleSelector + " .slider").css("margin-left", String(selectedCircle.sliderMarginLeft) + "px");
    $(circleSelector).offset({top: selectedCircle.top, left: selectedCircle.left})
    $(circleSelector).width(selectedCircle.width)
    $(circleSelector).height(selectedCircle.height)

    @createUserEvent
      "event_desc": "circle_resized"
      "circle_no": selectedCircleNo
      "new_size": selectedCircle.size
    
    @checkIfAllSlidersMoved()
  
  setupSliders: ->
    @GROW_BY = 12
    # All circles are of equal size in the beginning so use c0
    @CIRCLE_SIZE = $(".circle.c0").width()
    for circle, i in @circles
      circleSelector = ".circle.c#{i}"
      circle.top = $(circleSelector).offset().top
      circle.left = $(circleSelector).offset().left
      circle.width = $(circleSelector).width()
      circle.height = $(circleSelector).height()
      circle.textMarginTop = parseInt($(".circle .text").css("margin-top"))
      circle.sliderMarginLeft = parseInt($(".slider").css("margin-left"))
      $("#slider#{i}").slider({
          orientation: "horizontal",
          range: "min",
          max: 4,
          value: 4,
          change: @sliderChanged,
          slider: @sliderChanged
        });
      $("#slider#{i}").slider("option", "step", 1);

  setupDraggableCircles: ->
    @SELF_COORD_TOP = $(".self").offset().top
    @SELF_COORD_LEFT = $(".self").offset().left
    @SELF_COORD_SIZE = $(".self").width()
    # @SELF_COORD_SIZE = parseInt($(".self").css("width"))
    for circle, i in @circles
      circleSelector = ".circle.c#{i}"
      $(circleSelector).draggable({
        containment: "#characteristics",
        start: @startDrag,
        stop: @stopDrag
        })

  startDrag: (e, ui) =>
    selectedCircleNo = e.target.getAttribute("data-circleid")
    selectedCircle = @circles[selectedCircleNo]
    @createUserEvent
      "event_desc": "circle_start_move"
      "circle_no": selectedCircleNo
      "circle": selectedCircle


  stopDrag: (e, ui) =>
    selectedCircleNo = e.target.getAttribute("data-circleid")
    selectedCircle = @circles[selectedCircleNo]
    selectedCircle.top = ui.offset.top
    selectedCircle.left = ui.offset.left
    selectedCircle.moved = true
    $(e.target).draggable({
      containment: "#characteristics",
      start: @startDrag,
      stop: @stopDrag
      })

    @createUserEvent
      "event_desc": "circle_end_move"
      "circle_no": selectedCircleNo
      "circle": selectedCircle

    @checkIfAllCirclesMoved()

  checkIfAllSlidersMoved: ->
    return false if @currentStage isnt 0
    
    for circle in @circles
      return false if circle.changed is false

    @prepareStage2()

  checkIfAllCirclesMoved: ->
    return false if @currentStage isnt 1

    for circle in @circles
      return false if circle.moved is false

    @prepareEndTest()

  prepareStage2: ->
    @currentStage = 1
    $("#infobox #instructions").html(@model.get('instructions')[@currentStage])
    $("#infobox").css("visibility", "visible")

  prepareEndTest: ->
    @currentStage = 2
    $("#infoboxLeft #instructionsLeft").html(@model.get('instructions')[@currentStage])
    $("#infoboxLeft").css("visibility", "visible")

  toggleVisibility: (visibility)->
    for circle, i in @circles
      $("#slider#{i}").css("visibility", visibility)

  createUserEvent: (newEvent) =>
    record_time = new Date().getTime()
    @eventInfo = 
      "event_type": "0"
      "module": "circles_test"
      "stage": @nextStage - 1 
      "record_time": record_time
    userEvent = _.extend({}, @eventInfo, newEvent)
    @eventDispatcher.trigger("userEventCreated", userEvent)
