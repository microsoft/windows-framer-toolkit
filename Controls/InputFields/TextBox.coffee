# TextBox requires these modules. Please include them in your /modules directory
{Type} = require "Type"
{UWPColor} = require "Color"

initalContentStringWidth = 0
textBoxWidth = 296
textBoxHeight = 60

class exports.TextBox extends Layer
	constructor: (@options={}) ->
		@options.width ?= textBoxWidth
		@options.height ?= @setTextBoxHeight()
		@options.backgroundColor ?= UWPColor.transparent
		@options.header ?= "Control header"
		@options.content ?= ""
		@options.hint ?="Hint string"
		@options.focused ?= false
		super @options
		@createLayers()

	@define "header",
		get: ->
			@options.header
		set: (value) ->
			@options.header = value
			if @textBox?
				@createLayers()

	@define "content",
		get: ->
			@options.content
		set: (value) ->
			@options.content = value
			if @textBox?
				@createLayers()

	@define "hint",
		get: ->
			@options.hint
		set: (value) ->
			@options.hint = value
			if @textBox?
				@createLayers()

	@define "focused",
		get: ->
			@options.focused
		set: (value) ->
			@options.focused = value
			if @textBox?
				@createLayers()

	# TEXTBOX LAYERS
	createLayers: ->
		if @textBox?
			@textBox.destroy()

		@textBox = new Layer
			parent: @
			backgroundColor: UWPColor.transparent
			width: textBoxWidth
			height: @setTextBoxHeight()

		@headerType = new Type
			parent: @textBox
			text: @options.header

		@textBoxContent = new Layer
			parent: @textBox
			width: textBoxWidth
			height: 32
			backgroundColor: UWPColor.altMediumLow
			borderColor: UWPColor.chromeDisabledLow
			borderWidth: 2
			y: @headerType.height + 8

		@hintString = new Type
			parent: @textBoxContent
			x: 10
			y: 4
			color: UWPColor.baseMedium
			text: @options.hint

		@contentString = new Type
			parent: @textBoxContent
			x: 10
			y: 4
			color: UWPColor.baseHigh
			text: @options.content
			textOverflow: "clip"
			visible: false
		initalContentStringWidth = @contentString.width

		@pipe = new Type
			parent: @textBoxContent
			x: @contentString.width + @contentString.x
			y: 3
			color: UWPColor.baseHigh
			text: "|"
			visible: false

		@closeButton = new Layer
			parent: @textBoxContent
			width: 30
			height: 30
			x: Align.right
			backgroundColor: UWPColor.transparent
			visible: false

		@closeGlyph = new Type
			parent: @closeButton
			x: Align.right(-8)
			y: 8
			fontSize: 12
			uwpStyle: "glyph"
			text: "\uE10A"
			color: UWPColor.chromeBlackMedium

		@setFocus()
		@setHintVisiblity()
		@updateBoxVisuals()
		@updateCloseBtnVisuals()
		@playPipeAnim()

		# EVENTS
		@textBoxContent.onMouseOver ->
			@.parent.parent.updateBoxVisuals("mouseOver")
		@textBoxContent.onMouseDown ->
			@.parent.parent.updateBoxVisuals("mouseDown")
		@textBoxContent.onMouseOut ->
			@.parent.parent.updateBoxVisuals("mouseOut")

		@closeButton.onMouseOver ->
			@.parent.parent.parent.updateCloseBtnVisuals("mouseOver")
		@closeButton.onMouseOut ->
			@.parent.parent.parent.updateCloseBtnVisuals("mouseOut")

	# FUNCTIONS
	setTextBoxHeight: ->
		if @options.header is "" then 32 else 60
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

		if @focused is true
			@closeButton.visible = if @contentString.text is "" then false else true
			stringMaxWidth = if @contentString.width >= focusedStringMaxWidth then focusedStringMaxWidth else @contentString.width
			@hintString.visible = false
			@pipe.visible = true
			@textBoxContent.borderColor = UWPColor.accent
		else
			@setHintVisiblity()

			stringMaxWidth = if @contentString.width >= unfocusedStringMaxWidth then unfocusedStringMaxWidth else @contentString.width
			@pipe.visible = false
			@closeButton.visible = false
			@textBoxContent.borderColor = UWPColor.chromeDisabledLow

		@contentString.width = stringMaxWidth
		@pipe.x = @contentString.width + @contentString.x

	updateBoxVisuals: (curEvent) ->
		switch curEvent
			when "mouseOver"
				@textBoxContent.borderColor = if @focused then UWPColor.accent else UWPColor.chromeAltLow
			when "mouseDown"
				@focused = true
				@setFocus()
			when "mouseOut"
				@textBoxContent.borderColor = if @focused then UWPColor.accent else UWPColor.chromeDisabledLow

	updateCloseBtnVisuals: (curEvent) ->
		switch curEvent
			when "mouseOver" then @closeGlyph.color = UWPColor.accent
			when "mouseOut" then @closeGlyph.color = UWPColor.chromeBlackMedium

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
