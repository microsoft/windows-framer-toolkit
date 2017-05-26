# Button requires these modules. Please include them in your /modules directory
{Type} = require "Type"
{SystemColor} = require "SystemColor"

class exports.Button extends Layer
	constructor: (@options={}) ->
		@options.label ?= "Label"
		@options.enabled ?= true
		@options.width ?= undefined
		@options.height ?= 32
		@options.backgroundColor ?= SystemColor.transparent
		super @options
		@createLayers()

	@define "label",
		get: ->
			@options.label
		set: (value) ->
			@options.label = value
			if @labelText?
				@createLayers()

	@define "enabled",
		get: ->
			@options.enabled
		set: (value) ->
			@options.enabled = value
			if @labelText?
				@createLayers()

	@define "width",
		get: ->
			@options.width
		set: (value) ->
			@options.width = value
			if @labelText?
				@createLayers()

	createLayers: ->
		if @labelText?
			@labelText.destroy()

		@labelText = new Type
			parent: @
			name: "Label"
			text: @options.label
			textAlign: "center"
			borderWidth: 2
			padding:
				left: 10
				top: 4
				right: 10
				bottom: 5

		@resizeContainer()
		@updateVisuals()

		# EVENTS
		@labelText.onMouseUp ->
			@.parent.updateVisuals("mouseup")

		@labelText.onMouseDown ->
			@.parent.updateVisuals("mousedown")

		@labelText.onMouseOver ->
			@.parent.updateVisuals("mouseover")

		@labelText.onMouseOut ->
			@.parent.updateVisuals("mouseout")

	resizeContainer: ->
		if !@options.width
			@options.width = @labelText.width

		# button has a minimum width of 120px
		if @options.width < 120
			@options.width = @labelText.width = 120

		@labelText.width = @options.width
		@options.height = @labelText.height

	updateVisuals: (curEvent) ->
		if @options.enabled
			labelColor = SystemColor.baseHigh

			switch curEvent
				when "mouseup"
					buttonBackgroundColor = SystemColor.baseLow
					buttonBorderColor = SystemColor.baseMediumLow
				when "mousedown"
					buttonBackgroundColor = SystemColor.baseMediumLow
					buttonBorderColor = SystemColor.transparent
				when "mouseover"
					buttonBackgroundColor = SystemColor.baseLow
					buttonBorderColor = SystemColor.baseMediumLow
				else
					buttonBackgroundColor = SystemColor.baseLow
					buttonBorderColor = SystemColor.transparent
		else
			labelColor = SystemColor.baseMediumLow
			buttonBackgroundColor = SystemColor.baseLow
			buttonBorderColor = SystemColor.transparent
			@labelText.off Events.TapStart

		@labelText.color = labelColor
		@labelText.backgroundColor = buttonBackgroundColor
		@labelText.borderColor = buttonBorderColor
