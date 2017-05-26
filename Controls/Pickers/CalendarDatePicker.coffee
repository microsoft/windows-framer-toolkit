# MonthCalendar requires these modules. Please include them in your /modules directory
{Type} = require "Type"
{UWPColor} = require "Color"

class exports.CalendarDatePicker extends Layer
	constructor: (@options={}) ->
		@options.header ?= "Control header"
		@options.date ?= "mm/dd/yyyy"
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
			@createLayers()

	@define "date",
		get: ->
			@options.date
		set: (value) ->
			@options.date = value
			@createLayers()

	@define "enabled",
		get: ->
			@options.enabled
		set: (value) ->
			@options.enabled = value
			@createLayers()

	createLayers: ->
		if @container?
			@container.destroy()

		if @calendar?
			@calendar.destroy()

		@container = new Layer
			parent: @
			name: "Container"
			backgroundColor: UWPColor.transparent
			width: @options.width
			height: @options.height

		@headerText = new Type
			parent: @container
			name: "header"
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

		@dateText = new Type
			parent: @box
			name: "Date Text"
			text: @options.date
			padding:
				left: 10
				top: 4
				bottom: 9

		@glyph = new Type
			parent: @box
			name: "Glyph"
			text: "\uE787"
			uwpStyle: "glyph"
			fontSize: 16
			padding:
				left: 6
				top: 6
				right: 10
				bottom: 8
		@glyph.maxX = @box.maxX

		@calendar = new Layer
			parent: @
			name: "Calendar"
			width: 296
			height: 334
			backgroundColor: UWPColor.altHigh
			borderColor: UWPColor.chromeMedium
			borderWidth: 2
			y: @box.maxY + 2
			visible: false
		@calendar.centerX()

		@monthText = new Type
			parent: @calendar
			name: "Month Text"
			text: "September 2017"
			uwpStyle: "subtitle"
			padding:
				left: 12
				top: 8

		@downArrow = new Type
			parent: @calendar
			name: "Down Arrow"
			text: "\uE0E5"
			uwpStyle: "glyph"
			fontSize: 20
			padding: 10
			y: 2
			color: UWPColor.baseMediumHigh
		@downArrow.maxX = @calendar.maxX - 2

		@upArrow = new Type
			parent: @calendar
			name: "Up Arrow"
			text: "\uE0E4"
			uwpStyle: "glyph"
			fontSize: 20
			padding: 10
			y: 2
			color: UWPColor.baseMediumHigh
		@upArrow.maxX = @downArrow.x

		days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
		daysContainer = new Layer
			parent: @calendar
			backgroundColor: UWPColor.transparent
			y: @monthText.maxY + 22
			width: @calendar.width
			height: 14

		for i in [0..days.length - 1]
			day = new Type
				parent: daysContainer
				text: days[i]
				uwpStyle: "caption"
				width: 42
				textAlign: "center"
				x: 42 * i

		@calendarGrid = new Layer
			parent: @calendar
			name: "Lines"
			backgroundColor: UWPColor.transparent
			width: @calendar.width - 2
			height: 254
		@calendarGrid.y = 78

		@populateDates()
		@makeGridLines()
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

		@calendar.onClick ->
			@.visible = false

	updateVisuals: (curEvent) ->
		if @options.enabled
			if @dateText.text == "mm/dd/yyyy"
				dateColor = UWPColor.baseMedium
			else
				dateColor = UWPColor.baseHigh

			headerColor = UWPColor.baseHigh
			glyphColor = UWPColor.baseHigh

			if curEvent == "mouseup"
				boxBorderColor = UWPColor.baseMedium
				boxBackgroundColor = UWPColor.altMedium
				@calendar.visible = @calendar.visible is false ? true : false
			else if curEvent == "mousedown"
				boxBorderColor = UWPColor.baseMediumLow
				boxBackgroundColor = UWPColor.baseLow
			else if curEvent == "mouseover"
				boxBorderColor = UWPColor.baseMedium
				boxBackgroundColor = UWPColor.altMedium
			else
				boxBorderColor = UWPColor.baseMediumLow
				boxBackgroundColor = UWPColor.altMediumLow
		else
			headerColor = UWPColor.baseMediumLow
			dateColor = UWPColor.baseMediumLow
			glyphColor = UWPColor.baseMediumLow
			boxBorderColor = UWPColor.transparent
			boxBackgroundColor = UWPColor.baseLow

		@headerText.color = headerColor
		@dateText.color = dateColor
		@glyph.color = glyphColor
		@box.backgroundColor = boxBackgroundColor
		@box.borderColor = boxBorderColor

	populateDates: ->
		dates1 = ["27", "28", "29", "30", "31", "1", "2"]
		dates1Container = new Layer
			parent: @calendarGrid
			backgroundColor: UWPColor.transparent

		for i in [0..dates1.length-1]
			date = new Type
				parent: dates1Container
				width: 42
				text: dates1[i]
				x: 42 * i
				textAlign: "center"
				padding:
					top: 11
					bottom: 12

			if i >= 0 and i <= 4
				date.backgroundColor = UWPColor.chromeLow

		dates2 = ["3", "4", "5", "6", "7", "8", "9"]
		dates2Container = new Layer
			parent: @calendarGrid
			backgroundColor: UWPColor.transparent
			y: 42

		for i in [0..dates2.length-1]
			date = new Type
				parent: dates2Container
				width: 42
				text: dates2[i]
				x: 42 * i
				textAlign: "center"
				padding:
					top: 11
					bottom: 12

		dates3 = ["10", "11", "12", "13", "14", "15", "16"]
		dates3Container = new Layer
			parent: @calendarGrid
			backgroundColor: UWPColor.transparent
			y: 42 * 2

		for i in [0..dates3.length-1]
			date = new Type
				parent: dates3Container
				width: 42
				text: dates3[i]
				x: 42 * i
				textAlign: "center"
				padding:
					top: 11
					bottom: 12

		dates4 = ["17", "18", "19", "20", "21", "22", "23"]
		dates4Container = new Layer
			parent: @calendarGrid
			backgroundColor: UWPColor.transparent
			y: 42 * 3

		for i in [0..dates4.length-1]
			date = new Type
				parent: dates4Container
				width: 42
				text: dates4[i]
				x: 42 * i
				textAlign: "center"
				padding:
					top: 11
					bottom: 12

			if i == 6
				date.backgroundColor = UWPColor.accent
				date.color = UWPColor.chromeWhite

		dates5 = ["24", "25", "26", "27", "28", "29", "30"]
		dates5Container = new Layer
			parent: @calendarGrid
			backgroundColor: UWPColor.transparent
			y: 42 * 4

		for i in [0..dates5.length-1]
			date = new Type
				parent: dates5Container
				width: 42
				text: dates5[i]
				x: 42 * i
				textAlign: "center"
				padding:
					top: 11
					bottom: 12

		dates6 = ["1", "2", "3", "4", "5", "6", "7"]
		dates6Container = new Layer
			parent: @calendarGrid
			backgroundColor: UWPColor.transparent
			y: 42 * 5

		for i in [0..dates6.length-1]
			date = new Type
				parent: dates6Container
				width: 42
				text: dates6[i]
				x: 42 * i
				textAlign: "center"
				backgroundColor: UWPColor.chromeLow
				padding:
					top: 11
					bottom: 12

	makeGridLines: ->
		for i in [0..5]
			horRule = new Layer
				parent: @calendarGrid
				name: "Horizontal Line"
				height: 2
				width: @calendarGrid.width
				backgroundColor: UWPColor.chromeMedium
				y: 42 * i

		for i in [0..5]
			verRule = new Layer
				parent: @calendarGrid
				name: "Vertical Line"
				width: 2
				height: @calendarGrid.height
				backgroundColor: UWPColor.chromeMedium
				x: 42 * i + 40
