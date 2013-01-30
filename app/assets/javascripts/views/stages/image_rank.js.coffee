class TestService.Views.ImageRank extends TestService.Views.BaseView

  template: JST['stages/image_rank']

  events:
    "click #start": "startTest"

  initialize: (options) ->
    @eventDispatcher = options.eventDispatcher
    @nextStage = options.nextStage
    imageSequence = @model.get('image_sequence')
    @images = ( { url: image["url"], elements: image["elements"], image_id: image["image_id"], rank: -1 } for image in imageSequence)
    @frames = ({image: -1} for i in [0..4])
    @numOfImages = @images.length
    @eventLog = []

  render: ->
    $(@el).html(@template(stage: @model, images: @images))
    $("#infobox").css("visibility", "visible")
    this

  startTest: =>
    @createUserEvent
      "event_desc": "test_started"
      "image_sequence": @images
    $("#infobox").css("visibility", "hidden")
    @setDraggables()
    @setDroppables()

  setDraggables: ->
    for image,i in @images
      @setImageDraggable(i)

  setImageDraggable: (imageNo)->
    image_selector = ".photo.p#{imageNo}"
    $(image_selector).draggable
      containment: "#images"
      helper: "clone"
      cursor: "move"
      revert: "invalid"
      start: @startDrag

  setDroppables: ->
    for frame, i in @frames
      frame_selector = ".frame.f#{i}"
      $(frame_selector).droppable
        drop: @imageDropInFrame

    $(".photos").droppable
      drop: @imageDroppedOutside

  startDrag: (e, ui) =>
    # DONOT use ui.helper, it is the clone element
    # Instead use the e.target
    itemDragged = $(e.target)
    imageStr = itemDragged.attr("data-image")
    return false if not imageStr

    imageNo = parseInt imageStr
    image = @images[imageNo]
    if image and not image.initialized
      image.initialized = true
      image.width = itemDragged.width()
      image.height = itemDragged.height()
      image.order = imageNo

    @createUserEvent
      "image_no": imageNo 
      "event_desc": "image_drag_start"

  imageDropInFrame: (e, ui) =>
    $itemDropped = ui.draggable
    $dropTarget = $(e.target)

    rankStr = $dropTarget.attr("data-rank")
    return false if not rankStr

    rank = parseInt rankStr
    existingImageNoInFrame = @frames[rank].image 
    # Do not allow dropping into a frame with existing image
    return false if existingImageNoInFrame isnt -1

    imageStr = $itemDropped.attr("data-image")
    return false if not imageStr
    imageNo = parseInt imageStr

    @handleDropUI(imageNo, @images[imageNo].rank, $itemDropped, $dropTarget)
    @handleDropData(imageNo, rank)
    @createUserEvent
      "image_no": String(imageNo) 
      "rank": String(rank) 
      "event_desc": "image_ranked"
    @determineEndOfTest()

  handleDropData: (imageNo, rank) ->      
    # Insert image in frame
    @frames[rank].image = imageNo

    # Remove image from old frame if it was in another frame before
    oldRank = @images[imageNo].rank
    if oldRank isnt -1
      @frames[oldRank].image = -1
    @images[imageNo].rank = rank

  handleDropUI: (imageNo, oldRank, $itemDropped, $dropTarget) ->    
    $itemDropped.fadeOut "easeIn", =>
      $dropTarget.html("")
      if oldRank isnt -1
        $itemDropped.parent().html(String(oldRank + 1))

      $itemDropped.appendTo($dropTarget)
      frameWidth = $itemDropped.parent().width() - 20
      frameHeight = $itemDropped.parent().width() - 20
      $image = $itemDropped.find("img")
      imageWidth = @images[imageNo].width
      imageHeight = @images[imageNo].height
      aspectRatio = imageWidth/imageHeight
      newImageWidth = imageWidth
      newImageHeight = imageHeight
      if imageWidth > frameWidth
        newImageWidth = frameWidth
        newImageHeight = newImageWidth / aspectRatio
        if newImageHeight > frameHeight
          newImageHeight = frameHeight
          newImageWidth = newImageHeight * aspectRatio
      if imageHeight > frameHeight
        newImageHeight = frameHeight
        newImageWidth = newImageHeight * aspectRatio
        if newImageWidth > frameWidth
          newImageWidth = frameWidth
          newImageHeight = newImageWidth / aspectRatio
      marginHorizontal = 10
      marginVertical = 10
      marginHorizontal += (frameWidth - newImageWidth)/2 if newImageWidth < frameWidth
      marginVertical += (frameHeight - newImageHeight)/2 if newImageHeight < frameHeight
      $itemDropped.css("margin-top", marginVertical)
      $itemDropped.css("margin-bottom", marginVertical)
      $itemDropped.css("margin-left", marginHorizontal)
      $itemDropped.css("margin-right", marginHorizontal)
      $itemDropped.removeClass("span2")

      $image.width(newImageWidth)
      $image.height(newImageHeight)    
      $itemDropped.fadeIn "easeIn", => 
        @setImageDraggable(imageNo)

  imageDroppedOutside: (e, ui) =>
    $itemDropped = ui.draggable
    $dropTarget = $(e.target)

    imageStr = $itemDropped.attr("data-image")
    return false if not imageStr
    imageNo = parseInt imageStr

    oldRank = @images[imageNo].rank
    return if oldRank is -1

    @frames[oldRank].image = -1
    @images[imageNo].rank = -1

    @handleDropOutsideUI(imageNo, oldRank, $itemDropped, $dropTarget)
    @createUserEvent
      "image_no": String(imageNo)
      "rank": String(oldRank)
      "event_desc": "image_rank_cleared"

  handleDropOutsideUI: (imageNo, rank, $itemDropped, $dropTarget) ->
    $itemDropped.fadeOut "easeIn", =>
      $itemDropped.parent().html(String(rank + 1))
      $itemDropped.appendTo($dropTarget)
      $image = $itemDropped.find("img")
      imageWidth = @images[imageNo].width
      imageHeight = @images[imageNo].height
      $image.width(imageWidth)
      $image.height(imageHeight)        

      $itemDropped.css("margin-top", 0)
      $itemDropped.css("margin-bottom", 0)
      $itemDropped.css("margin-left", 25)
      $itemDropped.css("margin-right", 25)
      $itemDropped.addClass("span2")
      $itemDropped.fadeIn "easeIn", => 
        @setImageDraggable(imageNo)

  determineEndOfTest: =>
    finalRank = []
    for image, i in @images
      finalRank[i] = image.rank
      return false if image.rank is -1
    
    @createUserEvent
      "final_rank": finalRank
      "event_desc": "test_completed"
    Backbone.history.navigate("/stage/#{@nextStage}", true)

  createUserEvent: (newEvent) =>
    record_time = new Date().getTime()
    @eventInfo = 
      "event_type": "0"
      "module": "image_rank"
      "stage": @nextStage - 1 
      "record_time": record_time
    userEvent = _.extend({}, @eventInfo, newEvent)
    @eventDispatcher.trigger("userEventCreated", userEvent)
