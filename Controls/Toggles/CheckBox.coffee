# Checkbox requires these modules. Please include them in your /modules directory
{Type} = require "Type"
{SystemColor} = require "SystemColor"

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
			backgroundColor: SystemColor.transparent
			y: 6

		@check = new Layer
			parent: @box
			name: "Check"
			html: "&#xE001;"
			style: "fontFamily" : "Segoe MDL2 Assets", "fontSize" : "20px", "lineHeight" : "20px"
			width: 20
			height: 20
			backgroundColor: ""
		@check.centerY(+2)

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
			backgroundColor: SystemColor.transparent
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
				labelColor = SystemColor.baseHigh

				switch curEvent
					when "mouseup"
						boxBorderColor = SystemColor.baseHigh
						boxBackgroundColor = SystemColor.accent
						checkColor = SystemColor.chromeWhite
					when "mousedown"
						boxBorderColor = SystemColor.transparent
						boxBackgroundColor = SystemColor.baseMedium
						checkColor = SystemColor.chromeWhite
						@options.toggled = false
					when "mouseover"
						boxBorderColor = SystemColor.baseHigh
						boxBackgroundColor = SystemColor.accent
						checkColor = SystemColor.chromeWhite
					else
						boxBorderColor = SystemColor.transparent
						boxBackgroundColor = SystemColor.accent
						checkColor = SystemColor.chromeWhite
			else
				labelColor = SystemColor.baseMediumLow
				boxBorderColor = SystemColor.baseMediumLow
				boxBackgroundColor = SystemColor.transparent
				checkColor = SystemColor.baseMediumLow
				@container.off Events.TapStart
		else
			if @options.enabled
				labelColor = SystemColor.baseHigh
				checkColor = SystemColor.transparent

				if curEvent == "mouseup"
					boxBorderColor = SystemColor.baseHigh
					boxBackgroundColor = SystemColor.transparent
				else if curEvent == "mousedown"
					boxBorderColor = SystemColor.transparent
					boxBackgroundColor = SystemColor.baseMedium
					@options.toggled = true
				else if curEvent == "mouseover"
					boxBorderColor = SystemColor.baseHigh
					boxBackgroundColor = SystemColor.transparent
				else
					boxBorderColor = SystemColor.baseMediumHigh
					boxBackgroundColor = SystemColor.transparent
			else
				labelColor = SystemColor.baseMediumLow
				boxBorderColor = SystemColor.baseMediumLow
				boxBackgroundColor = SystemColor.transparent
				@container.off Events.TapStart

		@labelText.color = labelColor
		@box.borderColor = boxBorderColor
		@box.backgroundColor = boxBackgroundColor
		@check.color = checkColor
