# Slider requires these modules. Please include them in your /modules directory
{Type} = require 'Type'
{SystemColor} = require 'SystemColor'

class exports.Slider extends Layer
	constructor: (@options={}) ->
		@options.header ?= "Control header"
		@options.width ?= 336
		@options.height ?= 64
		@options.value ?= 25
		@options.min ?= 0
		@options.max ?= 50
		@options.backgroundColor ?= ''
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

	@define 'value',
		get: ->
			@options.value
		set: (value) ->
			@options.value = value
			if @container?
				@createLayers()

	@define 'min',
		get: ->
			@options.min
		set: (value) ->
			@options.min = value
			if @container?
				@createLayers()

	@define 'max',
		get: ->
			@options.max
		set: (value) ->
			@options.max = value
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
		if @container?
			@container.destroy()

		@container = new Layer
			parent: @
			name: "Container"
			backgroundColor: SystemColor.transparent
			width: @options.width
			height: @options.height

		@headerText = new Type
			parent: @container
			name: "Header"
			uwpStyle: "body"
			text: @options.header

		@sliderComp = new SliderComponent
			parent: @container
			name: "Slider"
			x: 0
			y: @headerText.maxY + 20
			originY: 0
			min: @options.min
			max: @options.max
			value: @.value
			height: 2
			width: @options.width
			borderRadius: 0

		@sliderComp.knob.width = 8
		@sliderComp.knob.height = 24
		@sliderComp.knob.draggable.momentum = false
		@sliderComp.sliderOverlay.height = 44
		@sliderComp.sliderOverlay.width = @.width
		@sliderComp.sliderOverlay.x = 0
		@sliderComp.sliderOverlay.y = -20

		@toolTip = new Type
			parent: @container
			name: "Tooltip"
			text: Math.round(@sliderComp.value)
			uwpStyle: "body"
			textAlign: "center"
			borderColor: SystemColor.chromeHigh
			borderWidth: 1
			backgroundColor: SystemColor.chromeMediumLow
			y: -10
			x: @sliderComp.knob.x - (@.width / 2) + 4
			padding:
				left: 8
				top: 5
				right: 8
				bottom: 7

		@updateVisuals()

		# EVENTS
		@sliderComp.on "change:value", ->
			# spell out the style explicitly so that Utils.textSize has properties
			# from the uwpStyle and the properties applied directly to the Type layer
			style =
				fontSize: "15px"
				fontFamily: "Segoe UI"
				lineHeight: "1.333"
				fontWeight: "400"
				paddingLeft: "8px"
				paddingRight: "8px"

			@.parent.parent.toolTip.text = Math.round(this.value)
			@.parent.parent.toolTip.width = Utils.textSize(@.parent.parent.toolTip.text, style).width
			@.parent.parent.toolTip.x = @.knob.x - (@.parent.parent.toolTip.width / 2) + 4

		@sliderComp.onMouseUp ->
			@.parent.parent.updateVisuals("mouseup")

		@sliderComp.onMouseDown ->
			@.parent.parent.updateVisuals("mousedown")

		@sliderComp.onMouseOver ->
			@.parent.parent.updateVisuals("mouseover")

		@sliderComp.onMouseOut ->
			@.parent.parent.updateVisuals("mouseout")

		@sliderComp.knob.onDrag ->
			@.parent.parent.parent.updateVisuals("drag")

		@sliderComp.knob.onDragEnd ->
			@.parent.parent.parent.updateVisuals("dragend")

	updateVisuals: (curEvent) ->
		headerColor = SystemColor.baseHigh
		sliderBackgroundColor = SystemColor.baseMediumLow
		sliderFillColor = SystemColor.accent

		if @options.enabled
			switch curEvent
				when "mouseup"
					sliderKnobColor = SystemColor.chromeAltLow
					toolTipVisible = false
				when "mousedown"
					sliderKnobColor = SystemColor.chromeHigh
					toolTipVisible = true
				when "mouseover"
					sliderKnobColor = SystemColor.chromeAltLow
					toolTipVisible = false
				when "drag"
					sliderKnobColor = SystemColor.chromeHigh
					toolTipVisible = true
				else
					sliderKnobColor = SystemColor.accent
					toolTipVisible = false
		else
			headerColor = SystemColor.baseMediumLow
			sliderKnobColor = SystemColor.chromeDisabledHigh
			sliderFillColor = SystemColor.transparent
			sliderBackgroundColor = SystemColor.baseLow

			@sliderComp.knob.draggable = false
			@sliderComp.off Events.TapStart

		@headerText.color = headerColor
		@sliderComp.backgroundColor = sliderBackgroundColor
		@sliderComp.fill.backgroundColor = sliderFillColor
		@sliderComp.knob.backgroundColor = sliderKnobColor
		@toolTip.visible = toolTipVisible
