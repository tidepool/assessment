class TestService.Views.CirclesTest extends TestService.Views.BaseView

  template: JST['stages/circles_test']

  events:
    "click #start": "startTest"

  initialize: (options) ->
    @eventDispatcher = options.eventDispatcher
    @nextStage = options.nextStage
    inputCircles = @model.get('circles')
    @circles = ({
      "trait1": circle.trait1,
      "trait2": circle.trait2,
      "size": parseInt(circle.size),
      "distance_x": parseFloat(circle.distance.split(',')[0]),
      "distance_y": parseFloat(circle.distance.split(',')[1]),
      "changed": false,
      "top": 0,
      "left": 0,
      "width": 0,
      "height": 0
      } for circle, i in inputCircles)
    # This test has to sub stages, currentStage reflects that
    @currentStage = 0
    @numOfCircles = @circles.length
    @eventLog = []

  render: ->
    $(@el).html(@template(stage: @model, circles: @circles, currentStage: @currentStage))
    $("#infobox").css("visibility", "visible")
    this

  startTest: =>
    $("#infobox").css("visibility", "hidden")

    if @currentStage is 0
      @createUserEvent({"event_desc": "testStarted"})
      @setupSliders()
      @toggleVisibility("visible")
    else
      @toggleVisibility("hidden")
      @setupDraggableCircles()
      $(".self").css("visibility", "visible")

  sliderChanged: (e, ui) =>
    selectedCircleNo = e.target.getAttribute("data-circleid")
    selectedCircle = @circles[selectedCircleNo]
    selectedCircle.changed = true
    selectedCircle.size = ui.value

    delta = (@NUM_OF_LEVELS - 1 - selectedCircle.size) * @GROW_BY
    newWidth = @CIRCLE_SIZE - delta
    newHeight = newWidth
    newTop = selectedCircle.top + delta/2
    newLeft = selectedCircle.left + delta/2
    newMarginTop = @TEXT_MARGIN_TOP - delta/2
    newMarginLeft = @SLIDER_MARGIN_LEFT - delta/2

    circleSelector = ".circle.c#{selectedCircleNo}"
    $(circleSelector + " .text").css("margin-top", String(newMarginTop) + "px" )
    $(circleSelector + " .slider").css("margin-left", String(newMarginLeft) + "px");
    $(circleSelector).css("top", String(newTop) + "px")      
    $(circleSelector).css("left", String(newLeft) + "px")
    $(circleSelector).css("width", String(newWidth) + "px")
    $(circleSelector).css("height", String(newHeight) + "px")

    @checkIfAllSlidersMoved()
  
  setupSliders: ->
    @NUM_OF_LEVELS = 5
    @GROW_BY = 16
    @TEXT_MARGIN_TOP = parseInt($(".circle .text").css("margin-top"))
    @SLIDER_MARGIN_LEFT = parseInt($(".slider").css("margin-left"))
    # All circles are of equal size in the beginning so use c0
    @CIRCLE_SIZE = parseInt($(".circle.c0").css("width"))
    for circle, i in @circles
      circleSelector = ".circle.c#{i}"
      circle.top = parseInt($(circleSelector).css("top"))
      circle.left = parseInt($(circleSelector).css("left"))
      circle.width = parseInt($(circleSelector).css("width"))
      circle.height = parseInt($(circleSelector).css("height"))
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
    for circle, i in @circles
      circleSelector = ".circle.c#{i}"
      $(circleSelector).draggable({
        containment: "#characteristics",
        start: @startDrag,
        stop: @stopDrag
        });

  startDrag: (e, ui) =>

  stopDrag: (e, ui) =>
    selectedCircleNo = e.target.getAttribute("data-circleid")
    selectedCircle = @circles[selectedCircleNo]
    selectedCircle.top = ui.position.top
    selectedCircle.left = ui.position.left

  checkIfAllSlidersMoved: ->
    return false if @currentStage isnt 0
    
    for circle in @circles
      return false if circle.changed is false

    @prepareStage2()

  prepareStage2: ->
    @currentStage = 1
    $("#infobox #instructions").html(@model.get('instructions')[@currentStage])
    $("#infobox").css("visibility", "visible")

  toggleVisibility: (visibility)->
    for circle, i in @circles
      $("#slider#{i}").css("visibility", visibility)

  createUserEvent: (newEvent) =>
    record_time = new Date().getTime()
    @eventInfo = {"event_type": "0", "module": "circles_test", "record_time": record_time}
    userEvent = _.extend({}, @eventInfo, newEvent)
    @eventDispatcher.trigger("userEventCreated", userEvent)
