# TimePicker requires these modules. Please include them in your /modules directory
{Type} = require "Type"
{UWPColor} = require "Color"

class exports.TimePicker extends Layer
	constructor: (@options={}) ->
		@options.header ?= "Control header"
		@options.hour ?= "9"
		@options.minute ?= "26"
		@options.ampm ?= "AM"
		@options.enabled ?= true
		@options.width ?= 242
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

	@define "hour",
		get: ->
			@options.hour
		set: (value) ->
			@options.hour = value
			if @container?
				@createLayers()

	@define "minute",
		get: ->
			@options.minute
		set: (value) ->
			@options.minute = value
			if @container?
				@createLayers()

	@define "ampm",
		get: ->
			@options.ampm
		set: (value) ->
			@options.ampm = value
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

		@hourText = new Type
			parent: @box
			name: "Hour Text"
			textAlign: "center"
			x: 2
			width: 78
			text: @options.hour
			padding:
				top: 4
				bottom: 9

		@divider1 = new Layer
			parent: @box
			name: "Divider"
			height: @box.height - 4
			width: 2
			x: @hourText.maxX
			backgroundColor: UWPColor.baseLow

		@minuteText = new Type
			parent: @box
			name: "Hour Text"
			textAlign: "center"
			width: 78
			x: @divider1.maxX
			text: @options.minute
			padding:
				top: 4
				bottom: 9

		@divider2 = new Layer
			parent: @box
			name: "Divider"
			height: @box.height - 4
			width: 2
			x: @minuteText.maxX
			backgroundColor: UWPColor.baseLow

		@ampmText = new Type
			parent: @box
			name: "AM/PM Text"
			textAlign: "center"
			width: 78
			x: @divider2.maxX
			text: @options.ampm
			padding:
				top: 4
				bottom: 9

		timePickerItems = [
			["5", "22", ""],
			["6", "23", ""],
			["7", "24", ""],
			["8", "25", ""],
			["9", "26", "AM"],
			["10", "27", "PM"],
			["11", "28", ""],
			["12", "29", ""],
			["1", "30", ""]
		]

		@picker = new Layer
			parent: @
			name: "Picker"
			width: @box.width
			height: (timePickerItems.length - 1) * 44 + 46
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
			height: (timePickerItems.length - 1) * 44
			backgroundColor: UWPColor.baseLow
			x: 81

		@divider2 = new Layer
			parent: @picker
			name: "Divider"
			width: 2
			height: (timePickerItems.length - 1) * 44
			backgroundColor: UWPColor.baseLow
			x: 161

		@items = new Layer
			parent: @picker
			name: "Items"
			width: @picker.width
			height: (timePickerItems.length - 1) * 44
			backgroundColor: UWPColor.transparent
			clip: true

		for i in [0..timePickerItems.length - 1]
			itemContainer = new Layer
				parent: @items
				name: "Item Container"
				backgroundColor: UWPColor.transparent
				width: @picker.width
				height: 44
				y: (i * 44) - 22

			hourText = new Type
				parent: itemContainer
				name: "Hour Text"
				text: timePickerItems[i][0]
				width: 80
				height: 44
				x: 2
				textAlign: "center"
				padding:
					top: 12
					bottom: 12

			minuteText = new Type
				parent: itemContainer
				name: "Minute Text"
				text: timePickerItems[i][1]
				width: 78
				height: 44
				textAlign: "center"
				x: hourText.maxX + 1
				padding:
					top: 12
					bottom: 12

			ampmText = new Type
				parent: itemContainer
				name: "AM/PM Text"
				text: timePickerItems[i][2]
				width: 80
				height: 44
				textAlign: "center"
				x: minuteText.maxX + 1
				padding:
					top: 12
					bottom: 12

			if i is 0 or i is timePickerItems.length - 1
				hourText.color = minuteText.color = ampmText.color = UWPColor.baseMediumLow
			else if i is 4
				hourText.color = minuteText.color = ampmText.color = UWPColor.baseHigh
				itemContainer.backgroundColor = UWPColor.listAccentLow
			else
				hourText.color = minuteText.color = ampmText.color = UWPColor.baseMedium

		@bottomDivider = new Layer
			parent: @picker
			name: "Bottom Divider"
			width: @picker.width - 2
			height: 2
			backgroundColor: UWPColor.baseLow
			y: (timePickerItems.length - 1) * 44

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
			timeColor = UWPColor.baseHigh
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
			timeColor = UWPColor.baseMediumLow
			boxBorderColor = UWPColor.transparent
			boxBackgroundColor = UWPColor.baseLow

		@headerText.color = headerColor
		@hourText.color = @minuteText.color = @ampmText.color = timeColor
		@box.backgroundColor = boxBackgroundColor
		@box.borderColor = boxBorderColor
