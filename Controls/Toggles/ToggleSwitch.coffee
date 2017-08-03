# ToggleSwitch requires these modules. Please include them in your /modules directory
m = require "motionCurves"
{Type} = require "Type"
{SystemColor} = require "SystemColor"

class exports.ToggleSwitch extends Layer
	_header: "Control header"
	@define 'header',
		get: ->
			return @_header
		set: (value) ->
			@_header = value

	_onText: "On"
	@define 'onText',
		get: ->
			return @_onText
		set: (value) ->
			@_onText = value

	_offText: "Off"
	@define 'offText',
		get: ->
			return @_offText
		set: (value) ->
			@_offText = value

	_enabled: true
	@define 'enabled',
		get: ->
			return @_enabled
		set: (value) ->
			@_enabled = value

	_toggled: false
	@define 'toggled',
		get: ->
			return @_toggled
		set: (value) ->
			@_toggled = value
			
	constructor: (options) ->
		super _.defaults options,
			width: undefined
			height: 56
			backgroundColor: SystemColor.transparent

		@createLayers()

	createLayers: ->
		@toggleTime = .1
		@toggleCurve = m.curve("Exponential")
		@txtOffset = 12

		@headerText = new Type
			parent: @
			name: "Header"
			text: @_header
			whiteSpace: "nowrap"
			padding:
				bottom: 6

		@toggle = new Layer
			name: "Toggle"
			height: 20
			width: 44
			y: 5
			borderWidth: 2
			borderRadius: 22

		@thumb = new Layer
			parent: @toggle
			name: "Thumb"
			width: 10
			height: 10
			borderRadius: 5
		@thumb.centerY(+0)

		@onOffText = new Type
			name: "On/Off Text"
			x: @toggle.maxX + @txtOffset
			y: @toggle.y
			height: @toggle.height
			text: @_offText
			whiteSpace: "nowrap"

		@container = new Layer
			parent: @
			name: "Container"
			height: 32
			width: @width
			y: @headerText.maxY
			backgroundColor: SystemColor.transparent

		@resizeContainer()
		@toggle.parent = @container
		@onOffText.parent = @container

		@updateVisuals()

		# EVENTS
		@container.onMouseUp =>
			@updateVisuals("mouseup")

		@container.onMouseDown =>
			@updateVisuals("mousedown")

		@container.onMouseOver =>
			@updateVisuals("mouseover")

		@container.onMouseOut =>
			@updateVisuals("mouseout")

	resizeContainer: ->
		if @headerText.width > (@toggle.width + @txtOffset + @onOffText.width)
			@width = @headerText.width
			@container.width = @toggle.width + @txtOffset + @onOffText.width
		else
			@width = @container.width = @toggle.width + @txtOffset + @onOffText.width

		@height = @headerText.height + @container.height

	thumbPosition = Align.left(3)
	thumbBackgroundColor = SystemColor.baseMediumHigh
	toggleBackgroundColor = SystemColor.transparent
	toggleBorderColor = SystemColor.baseMediumHigh

	updateVisuals: (curEvent) ->
		if @_toggled
			thumbPosition = Align.right(-2)
			@onOffText.text = @_onText

			if @_enabled
				headerColor = SystemColor.baseHigh
				onOffTextColor = SystemColor.baseHigh

				switch curEvent
					when "mouseup"
						thumbBackgroundColor = SystemColor.chromeWhite
						toggleBackgroundColor = SystemColor.listAccentHigh
						toggleBorderColor = SystemColor.transparent
					when "mousedown"
						thumbBackgroundColor = SystemColor.chromeWhite
						toggleBackgroundColor = SystemColor.baseMedium
						toggleBorderColor = SystemColor.transparent
						@_toggled = false
					when "mouseover"
						thumbBackgroundColor = SystemColor.chromeWhite
						toggleBackgroundColor = SystemColor.listAccentHigh
						toggleBorderColor = SystemColor.transparent
					else
						thumbBackgroundColor = SystemColor.chromeWhite
						toggleBackgroundColor = SystemColor.accent
						toggleBorderColor = SystemColor.accent
			else
				thumbBackgroundColor = SystemColor.baseLow
				toggleBackgroundColor = SystemColor.baseLow
				toggleBorderColor = SystemColor.baseLow
				headerColor = SystemColor.baseMediumLow
				onOffTextColor = SystemColor.baseMediumLow
		else
			thumbPosition = Align.left(3)
			@onOffText.text = @_offText

			if @_enabled
				headerColor = SystemColor.baseHigh
				onOffTextColor = SystemColor.baseHigh

				if curEvent == "mouseup"
					thumbBackgroundColor = SystemColor.baseHigh
					toggleBackgroundColor = SystemColor.transparent
					toggleBorderColor = SystemColor.baseHigh
				else if curEvent == "mousedown"
					thumbBackgroundColor = SystemColor.chromeWhite
					toggleBackgroundColor = SystemColor.baseMedium
					toggleBorderColor = SystemColor.transparent
					@_toggled = true
				else if curEvent == "mouseover"
					thumbBackgroundColor = SystemColor.baseHigh
					toggleBackgroundColor = SystemColor.transparent
					toggleBorderColor = SystemColor.baseHigh
				else
					thumbBackgroundColor = SystemColor.baseMediumHigh
					toggleBackgroundColor = SystemColor.transparent
					toggleBorderColor = SystemColor.baseMediumHigh
			else
				thumbBackgroundColor = SystemColor.baseMediumLow
				toggleBackgroundColor = SystemColor.transparent
				toggleBorderColor = SystemColor.baseMediumLow
				headerColor = SystemColor.baseMediumLow
				onOffTextColor = SystemColor.baseMediumLow

		@headerText.color = headerColor
		@onOffText.color = onOffTextColor
		@toggleAnimate()

	toggleAnimate: ->
		@thumb.animate
			properties:
				x: thumbPosition
				backgroundColor: thumbBackgroundColor
			options:
				colorModel: "rgb"
			time: @toggleTime
			curve: @toggleCurve
		@toggle.animate
			properties:
				backgroundColor: toggleBackgroundColor
				borderColor: toggleBorderColor
			options:
				colorModel: "rgb"
			time: @toggleTime
			curve: @toggleCurve
