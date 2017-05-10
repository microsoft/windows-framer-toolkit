# ContextMenu requires these modules. Please include them in your /modules directory
{Type} = require "Type"
{Color} = require "Color"

totalVerticalPadding = 16

class exports.ContextMenu extends Layer
	constructor: (@options={}) ->
		@options.width ?= 136
		@options.height ?= 32 + totalVerticalPadding
		@options.backgroundColor ?= Color.transparent
		@options.items ?= undefined
		@options.disabledItems ?= undefined
		super @options
		@createLayers()

	@define "items",
		get: ->
			@options.items
		set: (value) ->
			@options.items = value
			if @container?
				@createLayers()

	@define "disabledItems",
		get: ->
			@options.disabledItems
		set: (value) ->
			@options.disabledItems = value
			if @container?
				@createLayers()

	createLayers: ->
		if @container?
			@container.destroy()

		@container = new Layer
			name: "Container"
			parent: @
			backgroundColor: Color.chromeMediumLow
			borderColor: Color.chromeHigh
			borderWidth: 1
			width: @options.width
			height: @options.height

		@itemsContainer = new Layer
			name: "Items Container"
			parent: @container
			width: @options.width
			height: @options.height - totalVerticalPadding
			backgroundColor: Color.transparent

		@itemsContainer.centerY()

		@resizeContainer()

		for item, i in @options.items
			currentItem = i
			itemEnabled = true

			if @options.disabledItems
				for disabledItem in @options.disabledItems
					if disabledItem == currentItem
						itemEnabled = false

			itemBackground = new Layer
				parent: @itemsContainer
				name: "Item Background"
				width: @options.width - 2
				height: 32
				y: 32 * i

			itemText = new Type
				parent: itemBackground
				name: "Item Text " + i
				text: @options.items[i]
				uwpStyle: "body"
				whiteSpace: "nowrap"
				textOverflow: "clip"
				padding:
					left: 12
					top: 6
					right: 12
					bottom: 7

			@.updateVisuals("", itemBackground, itemText, itemEnabled)

			# EVENTS
			do (itemText, itemEnabled) ->
				itemBackground.on Events.MouseUp, (sender, event) ->
					@.parent.parent.parent.updateVisuals("mouseup", @, itemText, itemEnabled)

				itemBackground.on Events.MouseDown, (sender, event) ->
					@.parent.parent.parent.updateVisuals("mousedown", @, itemText, itemEnabled)

				itemBackground.on Events.MouseOver, (sender, event) ->
					@.parent.parent.parent.updateVisuals("mouseover", @, itemText, itemEnabled)

				itemBackground.on Events.MouseOut, (sender, event) ->
					@.parent.parent.parent.updateVisuals("mouseout", @, itemText, itemEnabled)

	resizeContainer: ->
		for item, i in @options.items
			# spell out the style explicitly so that Utils.textSize has properties
			# from the uwpStyle and the propeties applied directly to the Type layer
			style =
				fontSize: "15px"
				fontFamily: "Segoe UI"
				lineHeight: "1.333"
				fontWeight: "400"
				whiteSpace: "nowrap"
				textOverflow: "clip"
				paddingLeft: "12px"
				paddingRight: "12px"

			currentTextSize = Utils.textSize(@options.items[i], style)

			if currentTextSize.width > @options.width
				@options.width = currentTextSize.width

			@options.height = @container.height = (@options.items.length * 32) + totalVerticalPadding

	updateVisuals: (curEvent, itemBackground, itemText, itemEnabled) ->
		if itemEnabled
			labelColor = Color.baseHigh

			switch curEvent
				when "mouseup"
					itemBackgroundColor = Color.listLow
				when "mousedown"
					itemBackgroundColor = Color.listMedium
				when "mouseover"
					itemBackgroundColor = Color.listLow
				else
					itemBackgroundColor = Color.transparent
		else
			labelColor = Color.baseMediumLow
			itemBackgroundColor = Color.transparent

		itemBackground.backgroundColor = itemBackgroundColor
		itemText.color = labelColor
