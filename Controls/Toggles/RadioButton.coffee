# RadioButton requires these modules. Please include them in your /modules directory
{Type} = require "Type"
{Color} = require "Color"

class exports.RadioButton extends Layer
	constructor: (@options={}) ->
		@options.label ?= "Label"
		@options.toggled ?= false
		@options.enabled ?= true
		@options.width ?= undefined
		@options.height ?= 32
		@options.backgroundColor ?= ""
		super @options
		@createLayers()

	@define "label",
		get: ->
			@options.label
		set: (value) ->
			@options.label = value
			if @container?
				@createLayers()

	@define "toggled",
		get: ->
			@options.toggled
		set: (value) ->
			@options.toggled = value
			if @container?
				@createLayers()

	@define "enabled",
		get: ->
			@options.enabled
		set: (value) ->
			@options.enabled = value
			if @container?
				@createLayers()

	@define "width",
		get: ->
			@options.width
		set: (value) ->
			@options.width = value
			if @container?
				@createLayers()

	createLayers: ->
		if @container?
			@container.destroy()

		@outerCircleSize = 20
		@txtOffset = 8

		@outerCircle = new Layer
			name: "Outer Circle"
			width: @outerCircleSize
			height: @outerCircleSize
			borderRadius: 10
			borderWidth: 2
			backgroundColor: Color.transparent
			y: 6

		@innerCircle = new Layer
			parent: @outerCircle
			name: "Inner Circle"
			width: 10
			height: 10
			borderRadius: 5
		@innerCircle.center()

		@labelText = new Type
			name: "Label"
			text: @options.label
			uwpStyle: "body"
			x: @outerCircle.maxX + @txtOffset
			padding:
				top: 6
				bottom: 7

		@container = new Layer
			parent: @
			name: "Container"
			width: @options.width
			backgroundColor: Color.transparent

		@resizeContainer()
		@outerCircle.parent = @container
		@labelText.parent = @container

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
		if !@options.width
			@options.width = @container.width = @outerCircle.width + @txtOffset + @labelText.width

		# radioButton has a minimum width of 120px
		if @options.width < 120
			@options.width = @container.width = 120

		@labelText.width = @options.width - @outerCircle.width - @txtOffset
		@options.height = @container.height = @labelText.height

	updateVisuals: (curEvent) ->
		if @options.toggled
			if @options.enabled
				labelColor = Color.baseHigh

				switch curEvent
					when "mouseup"
						outerCircleBorderColor = Color.accent
						innerCircleBackgroundColor = Color.baseHigh
					when "mousedown"
						outerCircleBorderColor = Color.baseMedium
						innerCircleBackgroundColor = Color.baseMedium
						@options.toggled = false
					when "mouseover"
						outerCircleBorderColor = Color.accent
						innerCircleBackgroundColor = Color.baseHigh
					else
						outerCircleBorderColor = Color.accent
						innerCircleBackgroundColor = Color.baseMediumHigh
			else
				labelColor = Color.baseMediumLow
				outerCircleBorderColor = Color.baseMediumLow
				innerCircleBackgroundColor = Color.baseMediumLow
				@container.off Events.TapStart
		else
			if @options.enabled
				labelColor = Color.baseHigh

				if curEvent == "mouseup"
					outerCircleBorderColor = Color.baseHigh
					innerCircleBackgroundColor = Color.transparent
				else if curEvent == "mousedown"
					outerCircleBorderColor = Color.baseMedium
					innerCircleBackgroundColor = Color.baseMedium
					@options.toggled = true
				else if curEvent == "mouseover"
					outerCircleBorderColor = Color.baseHigh
					innerCircleBackgroundColor = Color.transparent
				else
					outerCircleBorderColor = Color.baseMediumHigh
					innerCircleBackgroundColor = Color.transparent
			else
				labelColor = Color.baseMediumLow
				outerCircleBorderColor = Color.baseMediumLow
				innerCircleBackgroundColor = Color.transparent
				@container.off Events.TapStart

		@labelText.color = labelColor
		@outerCircle.borderColor = outerCircleBorderColor
		@innerCircle.backgroundColor = innerCircleBackgroundColor
