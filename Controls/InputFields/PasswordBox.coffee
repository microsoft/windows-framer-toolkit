# PasswordBox requires these modules. Please include them in your /modules directory
{Type} = require "Type"
{SystemThemeColor} = require "SystemThemeColor"

textBoxWidth = 296
textBoxHeight = 60
wrapBorderWidth = 2

class contentElem extends Type
	constructor: (@options) ->
		@options.x = 10
		@options.y = 4
		@options.color ?= SystemThemeColor.baseHigh
		super(@options)

class exports.PasswordBox extends Layer
	constructor: (@options={}) ->
		@options.width ?= textBoxWidth
		@options.height ?= @setPasswordBoxHeight()
		@options.backgroundColor ?= SystemThemeColor.transparent
		@options.header ?= "Password"
		@options.content ?= ""
		@options.hint ?="Enter password"
		@options.focused ?= false
		@options.disabled ?= false
		super @options
		@createLayers()

	@define "header",
		get: ->
			@options.header
		set: (value) ->
			@options.header = value
			if @passwordBox?
				@createLayers()

	@define "content",
		get: ->
			@options.content
		set: (value) ->
			@options.content = value
			if @passwordBox?
				@createLayers()

	@define "hint",
		get: ->
			@options.hint
		set: (value) ->
			@options.hint = value
			if @passwordBox?
				@createLayers()

	@define "focused",
		get: ->
			@options.focused
		set: (value) ->
			@options.focused = value
			if @passwordBox?
				@createLayers()

	@define "disabled",
		get: ->
			@options.disabled
		set: (value) ->
			@options.disabled = value
			if @passwordBox?
				@createLayers()

	# PASSWORDBOX LAYERS
	createLayers: ->
		if @passwordBox?
			@passwordBox.destroy()

		@passwordBox = new Layer
			parent: @
			backgroundColor: SystemThemeColor.transparent
			width: textBoxWidth
			height: @setPasswordBoxHeight()

		@headerType = new Type
			parent: @passwordBox
			text: @options.header

		@contentWrap = new Layer
			parent: @passwordBox
			width: textBoxWidth
			height: 32
			y: @headerType.height + 8
			backgroundColor: SystemThemeColor.altMediumLow
			borderColor: SystemThemeColor.chromeDisabledLow
			borderWidth: wrapBorderWidth

		@hintString = new contentElem
			parent: @contentWrap
			text: @options.hint
			color: SystemThemeColor.baseMedium
			visible: true

		@contentString = new contentElem
			parent: @contentWrap
			text: @options.content
			visible: false

		@contentGlyph = new contentElem
			parent: @contentWrap
			text: if @options.content is "" then "" else Array(@options.content.length + 1).join "\u2022"
			visible: false

		@pipe = new Type
			parent: @contentWrap
			x: @contentString.width + @contentString.x
			y: 3
			color: SystemThemeColor.baseHigh
			text: "|"
			visible: false

		@previewButton = new Layer
			parent: @passwordBox
			width: 28
			height: 28
			y: @contentWrap.y + 2
			x: @contentWrap.x + @contentWrap.width - (28 + wrapBorderWidth)
			backgroundColor: SystemThemeColor.transparent
			visible: false

		@previewGlyph = new Type
			parent: @previewButton
			x: Align.right(- 6)
			y: 6
			fontSize: 16
			uwpStyle: "glyph"
			text: "\uE052"
			color: SystemThemeColor.chromeBlackMedium

		@setFocus()
		@updateBoxVisuals()
		@updateCloseBtnVisuals()
		@playPipeAnim()

		# EVENTS
		@contentWrap.onMouseOver ->
			@.parent.parent.updateBoxVisuals("mouseOver")
		@contentWrap.onMouseDown ->
			@.parent.parent.updateBoxVisuals("mouseDown")
		@contentWrap.onMouseOut ->
			@.parent.parent.updateBoxVisuals("mouseOut")

		@previewButton.onMouseOver ->
			@.parent.parent.updateCloseBtnVisuals("mouseOver")
		@previewButton.onMouseOut ->
			@.parent.parent.updateCloseBtnVisuals("mouseOut")
		@previewButton.onMouseDown ->
			@.parent.parent.updateCloseBtnVisuals("mouseDown")
		@previewButton.onMouseUp ->
			@.parent.parent.updateCloseBtnVisuals("mouseUp")

	# FUNCTIONS
	setPasswordBoxHeight: ->
		if @options.header is "" then 32 else 60

	setFocus: ->
		if @focused
			@previewButton.visible = if @options.content is "" then false else true
			@hintString.visible = false
			@contentGlyph.visible = true
			@pipe.visible = true
			@contentWrap.borderColor = SystemThemeColor.accent
		else
			@pipe.visible = false
			@previewButton.visible = false
			@contentWrap.borderColor = SystemThemeColor.chromeDisabledLow

		@pipe.x = @contentGlyph.width + @contentGlyph.x

	updateBoxVisuals: (curEvent) ->
		if @disabled
			@headerType.color = SystemThemeColor.baseMediumLow
			@contentWrap.backgroundColor = SystemThemeColor.baseLow
			@contentWrap.borderWidth = 0
			@hintString.color = SystemThemeColor.baseMediumLow
		else
			@header.color = SystemThemeColor.baseHigh
			@contentWrap.backgroundColor = SystemThemeColor.transparent
			@contentWrap.borderWidth = wrapBorderWidth
			@hintString.color = SystemThemeColor.baseMedium

			switch curEvent
				when "mouseOver"
					@contentWrap.borderColor = if @focused then SystemThemeColor.accent else SystemThemeColor.chromeAltLow
				when "mouseDown"
					@focused = true
					@setFocus()
				when "mouseOut"
					@contentWrap.borderColor = if @focused then SystemThemeColor.accent else SystemThemeColor.chromeDisabledLow

	updateCloseBtnVisuals: (curEvent) ->
		switch curEvent
			when "mouseOver" then @previewGlyph.color = SystemThemeColor.accent
			when "mouseDown"
				@previewButton.backgroundColor = SystemThemeColor.accent
				@previewGlyph.color = SystemThemeColor.altHigh
				@contentString.visible = true
				@contentString.textOverflow = "clip"
				@contentGlyph.visible = false
				@pipe.x = @contentString.width + @contentString.x
			when "mouseOut" then @previewGlyph.color = SystemThemeColor.chromeBlackMedium
			when "mouseUp"
				@previewButton.backgroundColor = SystemThemeColor.transparent
				@previewGlyph.color = SystemThemeColor.accent
				@contentString.visible = false
				@contentGlyph.visible = true
				@contentGlyph.textOverflow = "clip"
				@pipe.x = @contentGlyph.width + @contentGlyph.x

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
