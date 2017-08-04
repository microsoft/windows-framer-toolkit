# TextBox requires these modules. Please include them in your /modules directory
{Type} = require "Type"
{SystemColor} = require "SystemColor"

initalContentStringWidth = 0
textBoxWidth = 296
textBoxHeight = 60

class exports.TextBox extends Layer
	_header = "My header"
	@define "header",
		get: ->
			return @_header
		set: (value) ->
			@_header = value

	_content = null
	@define "content",
		get: ->
			return @_content
		set: (value) ->
			@_content = value

	_hint = null
	@define "hint",
		get: ->
			return @_hint
		set: (value) ->
			@_hint = value

	_focused = true
	@define "focused",
		get: ->
			return @_focused
		set: (value) ->
			@_focused = value

	constructor: (options) ->
		super _.defaults options,
			width: textBoxWidth
			height: @setTextBoxHeight()
			backgroundColor: SystemColor.transparent

		@createLayers()


	# TEXTBOX LAYERS
	createLayers: ->
		@headerType = new Type
			parent: @
			text: @_header

		@textBoxContent = new Layer
			parent: @
			width: textBoxWidth
			height: 32
			backgroundColor: SystemColor.altMediumLow
			borderColor: SystemColor.chromeDisabledLow
			borderWidth: 2
			y: @headerType.height + 8

		@hintString = new Type
			parent: @textBoxContent
			x: 10
			y: 6
			color: SystemColor.baseMedium
			text: @_hint

		@contentString = new Type
			parent: @textBoxContent
			x: 10
			y: 6
			color: SystemColor.baseHigh
			text: @_content
			textOverflow: "clip"
			visible: false
		initalContentStringWidth = @contentString.width

		@pipe = new Type
			parent: @textBoxContent
			x: @contentString.width + @contentString.x
			y: 3
			color: SystemColor.baseHigh
			text: "|"
			visible: false

		@closeButton = new Layer
			parent: @textBoxContent
			width: 30
			height: 30
			x: Align.right()
			backgroundColor: SystemColor.transparent
			visible: false

		@closeGlyph = new Type
			parent: @closeButton
			x: Align.right(-8)
			y: 10
			fontSize: 12
			uwpStyle: "glyph"
			text: "\uE10A"
			color: SystemColor.chromeBlackMedium

		@setFocus()
		@setHintVisiblity()
		@updateBoxVisuals()
		@updateCloseBtnVisuals()
		@playPipeAnim()

		# EVENTS
		@textBoxContent.onMouseOver =>
			@updateBoxVisuals("mouseOver")
		@textBoxContent.onMouseDown =>
			@updateBoxVisuals("mouseDown")
		@textBoxContent.onMouseOut =>
			@updateBoxVisuals("mouseOut")

		@closeButton.onMouseOver =>
			@updateCloseBtnVisuals("mouseOver")
		@closeButton.onMouseOut =>
			@updateCloseBtnVisuals("mouseOut")

	# FUNCTIONS
	setTextBoxHeight: ->
		if @_header is "" then 32 else 60

	setHintVisiblity: ->
		if @contentString.text is ""
			@hintString.visible = true
			@contentString.visible = false
		else
			@hintString.visible = false
			@contentString.visible = true

	setFocus: ->
		focusedStringMaxWidth = textBoxWidth - (12 + @closeButton.width)
		unfocusedStringMaxWidth = textBoxWidth - 22

		# Resetting contentString width
		@contentString.width = initalContentStringWidth

		if @_focused is true
			@closeButton.visible = if @contentString.text is "" then false else true
			stringMaxWidth = if @contentString.width >= focusedStringMaxWidth then focusedStringMaxWidth else @contentString.width
			@hintString.visible = false
			@pipe.visible = true
			@textBoxContent.borderColor = SystemColor.accent
		else
			@setHintVisiblity()

			stringMaxWidth = if @contentString.width >= unfocusedStringMaxWidth then unfocusedStringMaxWidth else @contentString.width
			@pipe.visible = false
			@closeButton.visible = false
			@textBoxContent.borderColor = SystemColor.chromeDisabledLow

		@contentString.width = stringMaxWidth
		@pipe.x = @contentString.width + @contentString.x

	updateBoxVisuals: (curEvent) ->
		switch curEvent
			when "mouseOver"
				@textBoxContent.borderColor = if @focused then SystemColor.accent else SystemColor.chromeAltLow
			when "mouseDown"
				@focused = true
				@setFocus()
			when "mouseOut"
				@textBoxContent.borderColor = if @focused then SystemColor.accent else SystemColor.chromeDisabledLow

	updateCloseBtnVisuals: (curEvent) ->
		switch curEvent
			when "mouseOver" then @closeGlyph.color = SystemColor.accent
			when "mouseOut" then @closeGlyph.color = SystemColor.chromeBlackMedium

	# ANIMATIONS
	playPipeAnim: ->
		animTime = 0.6

		pipeOutAnim = new Animation
			layer: @pipe
			properties:
				opacity: 0.0
			curve: "ease-out"
			time: animTime

		pipeInAnim = new Animation
			layer: @pipe
			properties:
				opacity: 1.0
			curve: "ease-In"
			time: animTime

		pipeOutAnim.start()

		pipeOutAnim.onAnimationEnd ->
			pipeInAnim.start()

		pipeInAnim.onAnimationEnd ->
			pipeOutAnim.start()
