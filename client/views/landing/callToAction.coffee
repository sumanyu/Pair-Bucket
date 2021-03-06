Template.landingCallToAction.helpers
  helpOthers: ->
    Session.get('helpOthers?')

  askQuestion: ->
    Session.get('askQuestion?')

  showBoth: ->
    Session.get('showBoth?')

logSession = ->
  ['askQuestion?', 'helpOthers?', 'showBoth?'].forEach (vars) ->
    console.log vars, Session.get(vars)

Template.landingCallToAction.events =
  'click .ask-question-btn': (e, s) ->
    Session.set('askQuestion?', true)

    Session.set('helpOthers?', false)
    Session.set('showBoth?', false)

  'click .help-others-btn': (e, s) ->
    Session.set('helpOthers?', true)

    Session.set('askQuestion?', false)
    Session.set('showBoth?', false)

Template.landingHelpOthers.rendered = ->
  focusText($('.help-others-wrapper .name'))

Template.landingHelpOthers.events =
  'submit': (e, s) ->
    e.preventDefault()

    # Clean input
    name = $('.help-others-wrapper .name').val().trim()
    school = $('.help-others-wrapper .school').val().trim()
    email = $('.help-others-wrapper input[type=email]').val().trim()
    password = $('.help-others-wrapper input[type=password]').val().trim()

    # Validate inputs - for now just check if all inputs were entered
    isInputValid = areElementsNonEmpty([email, password, name, school])

    if isInputValid

      profile =
        'name': name
        'school': school

      # Create meteor account, on client will log-in upon successful completion
      Accounts.createUser {email: email, password: password, profile: profile}, (err) ->
        if err
          console.log err
        else
          # Success, account was created
          Router.go('dashboard')
    else
      # Throw some message
      console.log "invalid input"

Template.landingAskQuestion.rendered = ->
  focusText($('.ask-question-wrapper textarea'))

Template.landingAskQuestion.events =
  'submit': (e, s) ->
    e.preventDefault()

    # Clean input
    name = $('.ask-question-wrapper .name').val().trim()
    school = $('.ask-question-wrapper .school').val().trim()
    email = $('.ask-question-wrapper input[type=email]').val().trim()
    password = $('.ask-question-wrapper input[type=password]').val().trim()
    question = $('.ask-question-wrapper textarea.question').val().trim()

    # Validate inputs - for now just check if all inputs were entered
    isInputValid = areElementsNonEmpty([email, password, question, name, school])

    if isInputValid

      profile =
        'name': name
        'school': school

      # Create meteor account, on client will log-in upon successful completion
      Accounts.createUser {email: email, password: password, profile: profile}, (err) ->
        if err
          console.log err
        else
          # Success, account was created
          Session.set('questionFromLandingPrompt', question)
          Session.set('askingQuestion?', true)
          Router.go('dashboard')
    else
      # Throw some message
      console.log "invalid input"