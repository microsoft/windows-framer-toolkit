# Dialog requires these modules. Please include them in your /modules directory
{Type} = require "Type"
{SystemThemeColor} = require "SystemThemeColor"
{Button} = require "Button"

topPadding = 18
leftRightPadding = 24
bottomPadding = 24

buttonSpacing = 4
buttonHeight = 32
titleBottomMargin = 12
contentBottomMargin = 24

heightWithoutText =
	topPadding +
	titleBottomMargin +
	contentBottomMargin +
	buttonHeight +
	bottomPadding

minDialogWidth = 320
maxDialogWidth = 548
minDialogHeight = 184
maxDialogHeight = 756

class exports.Dialog extends Layer
	constructor: (@options={}) ->
		@options.title ?= "Dialog title"
		@options.content ?= "Message text. This is where the message dialog text goes. The text can wrap."
		@options.button1Text ?= "Button"
		@options.button2Text ?= undefined
		@options.button3Text ?= undefined
		@options.width ?= 320
		@options.height ?= 184
		@options.backgroundColor ?= SystemThemeColor.altHigh
		super @options
		@createLayers()

	@define "title",
		get: ->
			@options.title
		set: (value) ->
			@options.title = value
			if @container?
				@createLayers()

	@define "content",
		get: ->
			@options.content
		set: (value) ->
			@options.content = value
			if @container?
				@createLayers()

	@define "button1Text",
		get: ->
			@options.button1Text
		set: (value) ->
			@options.button1Text = value
			if @container?
				@createLayers()

	@define "button2Text",
		get: ->
			@options.button2Text
		set: (value) ->
			@options.button2Text = value
			if @container?
				@createLayers()

	@define "button3Text",
		get: ->
			@options.button3Text
		set: (value) ->
			@options.button3Text = value
			if @container?
				@createLayers()

	createLayers: ->
		if @container?
			@container.destroy()

		@titleText = new Type
			name: "Title Text"
			text: @options.title
			uwpStyle: "subtitle"
			y: topPadding
			x: leftRightPadding

		@contentText = new Type
			name: "Content Text"
			text: @options.content
			uwpStyle: "body"
			y: @titleText.maxY + titleBottomMargin
			x: leftRightPadding

		@container = new Layer
			parent: @
			name: "Dialog Background"
			backgroundColor: SystemThemeColor.altHigh
			borderColor: SystemThemeColor.accent
			borderWidth: 1
			width: @contentText.width + leftRightPadding * 2
			height: heightWithoutText + @titleText.height + @contentText.height

		@contentText.parent = @container
		@titleText.parent = @container

		@button1 = new Button
			parent: @container
			name: "First Button"
			label: @options.button1Text

		@button2 = new Button
			parent: @container
			name: "Second Button"
			label: @options.button2Text

		@button3 = new Button
			parent: @container
			name: "Third Button"
			label: @options.button3Text

		@resizeContainer()
		@setUpButtons()

	resizeContainer: ->
		# use @titleText to determine width if it's longer than @contentText
		if @titleText.width > @contentText.width
			width = leftRightPadding * 2 + @titleText.width
		else
			width = leftRightPadding * 2 + @contentText.width

		height = heightWithoutText + @titleText.height + @contentText.height

		if width < minDialogWidth
			width = minDialogWidth

		if height < minDialogHeight
			height = minDialogHeight

		if width > maxDialogWidth
			width = maxDialogWidth

			# resize @titleText and @contentText to fit in the max available space
			@titleText.width = maxDialogWidth - leftRightPadding * 2
			@contentText.width = maxDialogWidth - leftRightPadding * 2

			# reset the y value of @contentText in case @titleText has grown taller after having its width constrained
			@contentText.y = @titleText.maxY + titleBottomMargin

			# recalculate the height now that we've changed the width of @contentText
			height = heightWithoutText + @titleText.height + @contentText.height

			if height > maxDialogHeight
				height = maxDialogHeight

		@options.width = @container.width = width
		@options.height = @container.height = height

	setUpButtons: ->
		# set button visibility
		@button2.visible = if !@options.button2Text then false else true
		@button3.visible = if !@options.button3Text then false else true

		# set button width
		availableWidth = @container.width - leftRightPadding * 2

		if @options.button2Text and @options.button3Text
			buttons = 3
			buttonWidth = (availableWidth - buttonSpacing * 2) / 3
		else if @options.button2Text and !@options.button3Text
			buttons = 2
			buttonWidth = (availableWidth - buttonSpacing) / 2
		else
			buttons = 1
			buttonWidth = (availableWidth - buttonSpacing) / 2

		@button1.width = @button2.width = @button3.width = buttonWidth

		# set button position
		buttonVerticalPos = @container.maxY - bottomPadding - buttonHeight
		@button1.y = @button2.y = @button3.y = buttonVerticalPos

		singleButtonPos = @container.maxX - leftRightPadding - @button1.width
		@button1.x = if buttons is 1 then singleButtonPos else leftRightPadding

		@button2.x = @button1.maxX + buttonSpacing
		@button3.x = @button2.maxX + buttonSpacing
