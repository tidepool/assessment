class TestService.Views.ImageRank extends TestService.Views.BaseView

  template: JST['stages/image_rank']

  events:
    "click #start": "startTest"
    "dragstart .photo": "dragStart"
    "dragend .photo": "dragEnd"
    "dragover .frame": "dragOver"
    "dragenter .frame": "dragEnter"
    "dragleave .frame": "dragLeave"
    "drop .frame": "drop"
    "dragover .photos": "dragOver"
    "dragenter .photos": "dragEnter"
    "dragleave .photos": "dragLeave"    
    "drop .photos": "dropOutside"

  initialize: (options) ->
    @eventDispatcher = options.eventDispatcher
    @nextStage = options.nextStage
    imageSequence = @model.get('image_sequence')
    @images = ( { url: image["url"], elements: image["elements"], image_id: image["image_id"], rank: -1 } for image in imageSequence)
    @frames = ({content: -1} for i in [0..4])
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

  dragStart: (e) =>
    e = e.originalEvent if e.originalEvent
    #e.preventDefault() if e.preventDefault
      
    # Ensure we are dragging the image
    srcElement = e.srcElement
    imageId = srcElement.getAttribute("data-imageid")
    return false if not imageId
  
    imageNo = parseInt imageId
    image = @images[imageNo]
    if image and not image.initialized
      image.initialized = true
      image.width = srcElement.width
      image.height = srcElement.height
      image.order = imageNo

    @dragSrcElement = srcElement
    e.dataTransfer.setData('text/plain', imageId) 

    @createUserEvent
      "image_no": imageId 
      "event_desc": "image_drag_start"

  dragOver: (e) =>
    e = e.originalEvent if e.originalEvent
    e.preventDefault() if e.preventDefault
   
    e.dataTransfer.dropEffect = "move"
    false

  dragEnter: (e) =>
    e = e.originalEvent if e.originalEvent  
    e.target.style.opacity = '0.8'

  dragLeave: (e) =>
    e.target.style.opacity = '1.0'

  dragEnd: (e) =>
    e.target.style.opacity = '1.0'

  drop: (e) =>
    e = e.originalEvent if e.originalEvent
    e.stopPropogation() if (e.stopPropogation)
      
    container = e.target
    return false if not container
    
    frame = @findFrame container
    return false if frame is -1
    
    contentImage = @frames[frame].content
    return false if contentImage isnt -1

    imageNo = parseInt e.dataTransfer.getData('text/plain')
    @frames[frame].content = imageNo
    oldFrame = @images[imageNo].rank
    if oldFrame isnt -1
      @frames[oldFrame].content = -1
    @images[imageNo].rank = frame

    originalParent = @dragSrcElement.parentNode
    srcElement = originalParent.removeChild(@dragSrcElement)
    srcElement.classList.remove('span2')
    container.innerHTML = srcElement.outerHTML
    container.style.opacity = '1.0'

    @createUserEvent
      "image_no": String(imageNo) 
      "rank": String(frame) 
      "event_desc": "image_ranked"
    
    @determineEndOfTest()
    # rect = container.getBoundingClientRect()
    # img = srcElement.firstChild
    # img.width = rect.width
    # img.height = rect.height

  dropOutside: (e) =>
    e = e.originalEvent if e.originalEvent
    e.stopPropogation() if (e.stopPropogation)

    imageNo = parseInt e.dataTransfer.getData('text/plain')
    oldFrame = @images[imageNo].rank
    return if oldFrame is -1

    @frames[oldFrame].content = -1
    @images[imageNo].rank = -1

    originalParent = @dragSrcElement.parentNode
    srcElement = originalParent.removeChild(@dragSrcElement)
    srcElement.classList.add('span2')
    originalParent.innerHTML = String(oldFrame + 1)

    found = false
    container = e.target
    while (not found) and container
      if container.className is 'photos'
        found = true
      else
        container = container.parentNode

    container.appendChild srcElement

    @createUserEvent
      "image_no": String(imageNo)
      "rank": String(oldFrame)
      "event_desc": "image_rank_cleared"

  findFrame: (container) ->
    found = false
    frame = -1
    while (not found) and container      
      frameId = container.getAttribute("data-frameid")
      if frameId 
        frame = parseInt frameId
        found = true
      else
        container = container.parentNode
    return frame

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
