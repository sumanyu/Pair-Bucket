@focusText = (i) ->
  i.focus()
  i.select()

# Trim left and right
unless String::trim then String::trim = -> @replace /^\s+|\s+$/g, ""

@areElementsNonEmpty = (list) ->
  list.every (input) -> input.length

navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia
@moz = !!navigator.mozGetUserMedia

@playRemoteStream = (remoteStream) ->
  console.log "Remote stream"
  console.log remoteStream
  # Play it locally in the browser
  audio = document.createElement('audio')

  # Mozilla/Chrome specific logic
  unless moz
    audio.src = window.webkitURL.createObjectURL(remoteStream)
  else
    audio.mozSrcObject = remoteStream

  # Auto play
  audio.controls = true
  audio.autoplay = true
  audio.play()

@getCurrentClassroomSession = (_fields) ->
  query = {}

  # Create a query of which fields user wants
  if _fields
    query =
      fields: {}

    _fields.forEach (field) -> query.fields[field] = 1

  console.log query

  ClassroomSession.findOne({_id: Session.get('classroomSessionId')}, query)

@getChatPartner = ->
  currentUser = Meteor.user()
  currentSession = getCurrentClassroomSession(['tutor', 'tutee'])
  tutor = currentSession.tutor
  tutee = currentSession.tutee

  if currentUser._id is tutor.id then tutee else tutor 