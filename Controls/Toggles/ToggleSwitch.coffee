# ToggleSwitch requires these modules. Please include them in your /modules directory
m = require "motionCurves"
{Type} = require "Type"
{SystemColor} = require "SystemColor"

class exports.ToggleSwitch extends Layer
	constructor: (@options={}) ->
		@options.header ?= "Control header"
		@options.onText ?= "On"
		@options.offText ?= "Off"
		@options.width ?= undefined
		@options.height ?= 56
		@options.backgroundColor ?= SystemColor.transparent
		@options.enabled ?= true
		@options.toggled ?= false
		super @options
		@createLayers()

	@define 'header',
		get: ->
			@options.header
		set: (value) ->
			@options.header = value
			if @container?
				@createLayers()

	@define 'onText',
		get: ->
			@options.onText
		set: (value) ->
			@options.onText = value
			if @container?
				@createLayers()

	@define 'offText',
		get: ->
			@options.offText
		set: (value) ->
			@options.offText = value
			if @container?
				@createLayers()

	@define 'enabled',
		get: ->
			@options.enabled
		set: (value) ->
			@options.enabled = value
			if @container?
				@createLayers()

	@define 'toggled',
		get: ->
			@options.toggled
		set: (value) ->
			@options.toggled = value
			if @container?
				@createLayers()

	createLayers: ->
		if @headerText?
			@headerText.destroy()

		if @container?
			@container.destroy()

		@toggleTime = .1
		@toggleCurve = m.curve("Exponential")
		@txtOffset = 12

		@headerText = new Type
			parent: @
			name: "Header"
			text: @options.header
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
		@thumb.centerY()

		@onOffText = new Type
			name: "On/Off Text"
			x: @toggle.maxX + @txtOffset
			y: @toggle.y
			height: @toggle.height
			text: @offText
			whiteSpace: "nowrap"

		@container = new Layer
			parent: @
			name: "Container"
			height: 32
			width: @options.width
			y: @headerText.maxY
			backgroundColor: SystemColor.transparent

		@resizeContainer()
		@toggle.parent = @container
		@onOffText.parent = @container

		@updateVisuals()

		# EVENTS
		@container.onMouseUp ->
			@.parent.updateVisuals("mouseup")

		@container.onMouseDown ->
			@.parent.updateVisuals("mousedown")

		@container.onMouseOver ->
			@.parent.updateVisuals("mouseover")

		@container.onMouseOut ->
			@.parent.updateVisuals("mouseout")

	resizeContainer: ->
		if @headerText.width > (@toggle.width + @txtOffset + @onOffText.width)
			@options.width = @headerText.width
			@container.width = @toggle.width + @txtOffset + @onOffText.width
		else
			@options.width = @container.width = @toggle.width + @txtOffset + @onOffText.width

		@options.height = @headerText.height + @container.height

	thumbPosition = 3
	thumbBackgroundColor = SystemColor.baseMediumHigh
	toggleBackgroundColor = SystemColor.transparent
	toggleBorderColor = SystemColor.baseMediumHigh

	updateVisuals: (curEvent) ->
		if @options.toggled
			thumbPosition = 27
			@onOffText.text = @options.onText

			if @options.enabled
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
						@options.toggled = false
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
			thumbPosition = 3
			@onOffText.text = @offText

			if @options.enabled
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
					@options.toggled = true
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
