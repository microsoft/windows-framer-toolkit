# Checkbox requires these modules. Please include them in your /modules directory
{Type} = require "Type"
{UWPColor} = require "Color"

class exports.CheckBox extends Layer
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

		@boxSize = 20
		@txtOffset = 8

		@box = new Layer
			name: "Box"
			width: @boxSize
			height: @boxSize
			borderWidth: 2
			backgroundColor: UWPColor.transparent
			y: 6

		@check = new Layer
			parent: @box
			name: "Check"
			html: "&#xE001;"
			style: "fontFamily" : "Segoe MDL2 Assets", "fontSize" : "20px", "lineHeight" : "20px"
			width: 20
			height: 20
			backgroundColor: ""
		@check.center()

		@labelText = new Type
			name: "Label"
			text: @options.label
			uwpStyle: "body"
			x: @box.maxX
			padding:
				left: 8
				top: 6
				bottom: 7

		@container = new Layer
			parent: @
			name: "Container"
			backgroundColor: UWPColor.transparent
			width: @options.width

		@resizeContainer()
		@box.parent = @container
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
			@options.width = @container.width = @box.width + @txtOffset + @labelText.width

		# checkBox has a minimum width of 120px
		if @options.width < 120
			@options.width = @container.width = 120

		@labelText.width = @options.width - @box.width - @txtOffset
		@options.height = @container.height = @labelText.height

	updateVisuals: (curEvent) ->
		if @options.toggled
			if @options.enabled
				labelColor = UWPColor.baseHigh

				switch curEvent
					when "mouseup"
						boxBorderColor = UWPColor.baseHigh
						boxBackgroundColor = UWPColor.accent
						checkColor = UWPColor.chromeWhite
					when "mousedown"
						boxBorderColor = UWPColor.transparent
						boxBackgroundColor = UWPColor.baseMedium
						checkColor = UWPColor.chromeWhite
						@options.toggled = false
					when "mouseover"
						boxBorderColor = UWPColor.baseHigh
						boxBackgroundColor = UWPColor.accent
						checkColor = UWPColor.chromeWhite
					else
						boxBorderColor = UWPColor.transparent
						boxBackgroundColor = UWPColor.accent
						checkColor = UWPColor.chromeWhite
			else
				labelColor = UWPColor.baseMediumLow
				boxBorderColor = UWPColor.baseMediumLow
				boxBackgroundColor = UWPColor.transparent
				checkColor = UWPColor.baseMediumLow
				@container.off Events.TapStart
		else
			if @options.enabled
				labelColor = UWPColor.baseHigh
				checkColor = UWPColor.transparent

				if curEvent == "mouseup"
					boxBorderColor = UWPColor.baseHigh
					boxBackgroundColor = UWPColor.transparent
				else if curEvent == "mousedown"
					boxBorderColor = UWPColor.transparent
					boxBackgroundColor = UWPColor.baseMedium
					@options.toggled = true
				else if curEvent == "mouseover"
					boxBorderColor = UWPColor.baseHigh
					boxBackgroundColor = UWPColor.transparent
				else
					boxBorderColor = UWPColor.baseMediumHigh
					boxBackgroundColor = UWPColor.transparent
			else
				labelColor = UWPColor.baseMediumLow
				boxBorderColor = UWPColor.baseMediumLow
				boxBackgroundColor = UWPColor.transparent
				@container.off Events.TapStart

		@labelText.color = labelColor
		@box.borderColor = boxBorderColor
		@box.backgroundColor = boxBackgroundColor
		@check.color = checkColor
