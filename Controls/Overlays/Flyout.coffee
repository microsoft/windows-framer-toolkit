# Flyout requires these modules. Please include them in your /modules directory
{Type} = require "Type"
{Color} = require "Color"

topPadding = 11
leftRightPadding = 12
bottomPadding = 12

minFlyoutWidth = 96
maxFlyoutWidth = 456
minFlyoutHeight = 44
maxFlyoutHeight = 758

class exports.Flyout extends Layer
	constructor: (@options={}) ->
		@options.label ?= "Label"
		@options.width ?= 96
		@options.height ?= 44
		@options.backgroundColor ?= SystemThemeColor.transparent
		super @options
		@createLayers()

	@define "label",
		get: ->
			@options.label
		set: (value) ->
			@options.label = value
			if @container?
				@createLayers()

	createLayers: ->
		if @container?
			@container.destroy()

		@labelText = new Type
			name: "Label"
			text: @options.label
			x: leftRightPadding
			y: topPadding

		@container = new Layer
			parent: @
			name: "Flyout Background"
			backgroundColor: SystemThemeColor.chromeMediumLow
			borderColor: SystemThemeColor.chromeHigh
			borderWidth: 1
			width: @labelText.width + leftRightPadding * 2
			height: @labelText.height + topPadding + bottomPadding

		@labelText.parent = @container

		@resizeContainer()

	resizeContainer: ->
		width = @labelText.width + leftRightPadding * 2
		height = @labelText.height + topPadding + bottomPadding

		if width < minFlyoutWidth
			width = minFlyoutWidth

		if height < minFlyoutHeight
			height = minFlyoutHeight

		if width > maxFlyoutWidth
			width = maxFlyoutWidth
			@labelText.width = maxFlyoutWidth - leftRightPadding * 2
			height = @labelText.height + topPadding + bottomPadding

			if height > maxFlyoutHeight
				height = maxFlyoutHeight

		@options.width = @container.width = width
		@options.height = @container.height = height
