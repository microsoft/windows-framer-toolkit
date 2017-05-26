# DatePicker requires these modules. Please include them in your /modules directory
{Type} = require "Type"
{UWPColor} = require "Color"

class exports.DatePicker extends Layer
	constructor: (@options={}) ->
		@options.header ?= "Control header"
		@options.month ?= "January"
		@options.date ?= "11"
		@options.year ?= "2014"
		@options.enabled ?= true
		@options.width ?= 296
		@options.height ?= 60
		@options.backgroundColor ?= UWPColor.transparent
		super @options
		@createLayers()

	@define "header",
		get: ->
			@options.header
		set: (value) ->
			@options.header = value
			if @container?
				@createLayers()

	@define "month",
		get: ->
			@options.month
		set: (value) ->
			@options.month = value
			if @container?
				@createLayers()

	@define "date",
		get: ->
			@options.date
		set: (value) ->
			@options.date = value
			if @container?
				@createLayers()

	@define "year",
		get: ->
			@options.year
		set: (value) ->
			@options.year = value
			if @container?
				@createLayers()

	@define "enabled",
		get: ->
			@options.enabled
		set: (value) ->
			@options.enabled = value
			if @container?
				@createLayers()

	createLayers: ->
		if @container?
			@container.destroy()

		if @picker?
			@picker.destroy()

		@container = new Layer
			parent: @
			name: "Container"
			backgroundColor: UWPColor.transparent
			width: @options.width
			height: @options.height

		@headerText = new Type
			parent: @container
			name: "Header"
			text: @options.header
			whiteSpace: "nowrap"
			padding:
				top: 3
				bottom: 6

		@box = new Layer
			parent: @container
			name: "Box"
			width: @options.width
			height: 32
			y: @headerText.maxY
			backgroundColor: UWPColor.altMediumLow
			borderColor: UWPColor.baseMediumLow
			borderWidth: 2

		@monthText = new Type
			parent: @box
			name: "Month Text"
			textAlign: "center"
			x: 2
			width: 132
			text: @options.month
			padding:
				top: 4
				bottom: 9

		@divider1 = new Layer
			parent: @box
			name: "Divider"
			height: @box.height - 4
			width: 2
			x: @monthText.maxX
			backgroundColor: UWPColor.baseLow

		@dateText = new Type
			parent: @box
			name: "Date Text"
			textAlign: "center"
			width: 78
			x: @divider1.maxX
			text: @options.date
			padding:
				top: 4
				bottom: 9

		@divider2 = new Layer
			parent: @box
			name: "Divider"
			height: @box.height - 4
			width: 2
			x: @dateText.maxX
			backgroundColor: UWPColor.baseLow

		@yearText = new Type
			parent: @box
			name: "Year Text"
			textAlign: "center"
			width: 78
			x: @divider2.maxX
			text: @options.year
			padding:
				top: 4
				bottom: 9

		datePickerItems = [
			["September", "7", "2010"],
			["October", "8", "2011"],
			["November", "9", "2012"],
			["December", "10", "2013"],
			["January", "11", "2014"],
			["February", "12", "2015"],
			["March", "13", "2016"],
			["April", "14", "2017"],
			["May", "15", "2018"]
		]

		@picker = new Layer
			parent: @
			name: "Picker"
			width: @box.width
			height: (datePickerItems.length - 1) * 44 + 46
			backgroundColor: UWPColor.chromeMediumLow
			borderColor: UWPColor.chromeHigh
			borderWidth: 1
			visible: false
			clip: true
		@picker.centerX()
		@picker.centerY(36)

		if @picker.screenFrame.y < Framer.Device.screen.y
			@picker.y = Framer.Device.screen.y - @container.screenFrame.y

		@divider1 = new Layer
			parent: @picker
			name: "Divider"
			width: 2
			height: (datePickerItems.length - 1) * 44
			backgroundColor: UWPColor.baseLow
			x: 135

		@divider2 = new Layer
			parent: @picker
			name: "Divider"
			width: 2
			height: (datePickerItems.length - 1) * 44
			backgroundColor: UWPColor.baseLow
			x: 215

		@items = new Layer
			parent: @picker
			name: "Items"
			width: @picker.width
			height: (datePickerItems.length - 1) * 44
			backgroundColor: UWPColor.transparent
			clip: true

		for i in [0..datePickerItems.length - 1]
			itemContainer = new Layer
				parent: @items
				name: "Item Container"
				backgroundColor: UWPColor.transparent
				width: @picker.width
				height: 44
				y: (i * 44) - 22

			monthText = new Type
				parent: itemContainer
				name: "Month Text"
				text: datePickerItems[i][0]
				width: 134
				height: 44
				x: 2
				textAlign: "center"
				padding:
					top: 12
					bottom: 12

			dateText = new Type
				parent: itemContainer
				name: "Date Text"
				text: datePickerItems[i][1]
				width: 78
				height: 44
				textAlign: "center"
				x: monthText.maxX + 1
				padding:
					top: 12
					bottom: 12

			yearText = new Type
				parent: itemContainer
				name: "Year Text"
				text: datePickerItems[i][2]
				width: 80
				height: 44
				textAlign: "center"
				x: dateText.maxX + 1
				padding:
					top: 12
					bottom: 12

			if i is 0 or i is datePickerItems.length - 1
				monthText.color = dateText.color = yearText.color = UWPColor.baseMediumLow
			else if i is 4
				monthText.color = dateText.color = yearText.color = UWPColor.baseHigh
				itemContainer.backgroundColor = UWPColor.listAccentLow
			else
				monthText.color = dateText.color = yearText.color = UWPColor.baseMedium

		@bottomDivider = new Layer
			parent: @picker
			name: "Bottom Divider"
			width: @picker.width - 2
			height: 2
			backgroundColor: UWPColor.baseLow
			y: (datePickerItems.length - 1) * 44

		@bottomButtons = new Layer
			parent: @picker
			name: "Bottom Buttons"
			width: @picker.width - 2
			height: 44
			backgroundColor: UWPColor.transparent
			y: @bottomDivider.maxY

		@acceptButton = new Type
			parent: @bottomButtons
			name: "Accept Button"
			text: "\uE0E7"
			uwpStyle: "glyph"
			fontSize: 16
			textAlign: "center"
			width: @bottomButtons.width / 2
			padding:
				top: 14
				bottom: 14

		@cancelButton = new Type
			parent: @bottomButtons
			name: "Cancel Button"
			text: "\uE10A"
			uwpStyle: "glyph"
			fontSize: 16
			textAlign: "center"
			width: @bottomButtons.width / 2
			x: @bottomButtons.width / 2
			padding:
				top: 14
				bottom: 14

		@updateVisuals()

		# EVENTS
		@box.onMouseUp ->
			@.parent.parent.updateVisuals("mouseup")

		@box.onMouseDown ->
			@.parent.parent.updateVisuals("mousedown")

		@box.onMouseOver ->
			@.parent.parent.updateVisuals("mouseover")

		@box.onMouseOut ->
			@.parent.parent.updateVisuals("mouseout")

		@bottomButtons.onClick ->
			@.parent.visible = false

	updateVisuals: (curEvent) ->
		if @options.enabled
			dateColor = UWPColor.baseHigh
			headerColor = UWPColor.baseHigh

			switch curEvent
				when "mouseup"
					boxBorderColor = UWPColor.baseMedium
					boxBackgroundColor = UWPColor.altMedium
					@picker.visible = @picker.visible is false ? true : false
				when "mousedown"
					boxBorderColor = UWPColor.baseMediumLow
					boxBackgroundColor = UWPColor.baseLow
				when "mouseover"
					boxBorderColor = UWPColor.baseMedium
					boxBackgroundColor = UWPColor.altMedium
				else
					boxBorderColor = UWPColor.baseMediumLow
					boxBackgroundColor = UWPColor.altMediumLow
		else
			headerColor = UWPColor.baseMediumLow
			dateColor = UWPColor.baseMediumLow
			boxBorderColor = UWPColor.transparent
			boxBackgroundColor = UWPColor.baseLow

		@headerText.color = headerColor
		@monthText.color = @dateText.color = @yearText.color = dateColor
		@box.backgroundColor = boxBackgroundColor
		@box.borderColor = boxBorderColor
