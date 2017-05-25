# Rating requires these modules. Please include them in your /modules directory
{Type} = require "Type"
{SystemThemeColor} = require "SystemThemeColor"
m = require "motionCurves"

class exports.Rating extends Layer
	constructor: (@options={}) ->
		@options.enabled ?= true
		@options.allowInput ?= true
		@options.starsFilled ?= 0
		@options.width ?= 120
		@options.height ?= 32
		@options.backgroundColor ?= ""
		super @options
		@createLayers()

	@define "enabled",
		get: ->
			@options.enabled
		set: (value) ->
			@options.enabled = value
			if @container?
				@createLayers()

	@define "allowInput",
		get: ->
			@options.allowInput
		set: (value) ->
			@options.allowInput = value
			if @container?
				@createLayers()

	@define "starsFilled",
		get: ->
			@options.starsFilled
		set: (value) ->
			@options.starsFilled = value - 1
			if @container?
				@createLayers()

	createLayers: ->
		if @container?
			@container.destroy()

		Framer.Defaults.Animation =
			time: 0.3
			curve: m.curve("EaseOutSmooth")

		sf = 1
		dpr = (v) -> v * sf;

		starWidth = dpr(120 / 5)
		starHeight = dpr 32

		starEmptyColor = SystemThemeColor.baseLow
		starFillColor = SystemThemeColor.accent

		selectedStarIndex = undefined

		@container = new Layer
			parent: @
			name: "Container"
			width: dpr 120
			height: dpr 32
			backgroundColor: SystemThemeColor.transparent

		for i in [0..4]
			hitTarget = new Layer
				name: "Hit Target " + (i + 1)
				parent: @container
				width: starWidth
				height: starHeight
				x: i * starWidth
				backgroundColor: SystemThemeColor.transparent

			star = new Type
				name: "Star " + (i + 1)
				parent: hitTarget
				text: "\uE735"
				color: starEmptyColor
				uwpStyle: "glyph"
				fontSize: dpr 32
				scale: 0.5
				originY: 0.8

			star.center()
			star.y -= dpr 6 # re-center, because our scale throws it off

			if i <= @options.starsFilled
				if @options.enabled
					star.color = starFillColor
				else
					star.color = SystemThemeColor.baseMediumLow
				selectedStarIndex = @options.starsFilled

		# fix z order
		for i in [4..0]
			@container.children[i].bringToFront()

		findStarIndexFromOffset = (x) ->
			starIndex = -1

			if x < dpr(0)
				# Clear it!
			else if x >= dpr(0) and x < (starWidth * 1)
				starIndex = 0
			else if x >= (starWidth * 1) and x < (starWidth * 2)
				starIndex = 1
			else if x >= (starWidth * 2) and x < (starWidth * 3)
				starIndex = 2
			else if x >= (starWidth * 3) and x < (starWidth * 4)
				starIndex = 3
			else
				starIndex = 4

			return starIndex

		handleInput = (x, sender) ->
			centers = []

			centers[0] = (starWidth * 0) + (starWidth / 2)
			centers[1] = (starWidth * 1) + (starWidth / 2)
			centers[2] = (starWidth * 2) + (starWidth / 2)
			centers[3] = (starWidth * 3) + (starWidth / 2)
			centers[4] = (starWidth * 4) + (starWidth / 2)

			for i in [0..4]
				currentStar = sender.children[i].children[0]
				starIndex = findStarIndexFromOffset(x)

				relativeDist = centers[i] - x
				relativeDist = relativeDist / sf

				# The fifth star shouldn't ever shrink if you drag past it
				if x > centers[4] and i == 4
					relativeDist = 0

				scl = (-0.0004 * (relativeDist * relativeDist)) + 0.8

				if scl < 0.5
					scl = 0.5

				currentStar.scale = scl

		isTouched = false;

		if @options.enabled and @options.allowInput
			@container.on Events.MouseDown, (event, sender) ->
				isTouched = true

				x = Events.touchEvent(event).clientX - @.screenFrame.x
				starIndex = findStarIndexFromOffset(x)

				for i in [0..4]
					currentStar = sender.children[i].children[0]

					if i <= starIndex
						currentStar.animateStop()
						currentStar.color = starFillColor

						if i == starIndex
							currentStar.scale = 1

			@container.on Events.MouseMove, (event, sender) ->
				if isTouched
					#handleInput(event, sender, false, false)
				else
					x = Events.touchEvent(event).clientX - @.screenFrame.x
					handleInput(x, sender)
					starIndex = findStarIndexFromOffset(x)
					isOff = selectedStarIndex == -1 or !selectedStarIndex

					for i in [0..4]
						currentStar = sender.children[i].children[0]

						if i <= starIndex
							color = if isOff then SystemThemeColor.baseMedium else starFillColor
							@.parent.animateStar(currentStar, color)
						else
							@.parent.animateStar(currentStar, starEmptyColor)

			@container.on Events.MouseUp, (event, sender) ->
				isTouched = false
				x = Events.touchEvent(event).clientX - @.screenFrame.x
				starIndex = findStarIndexFromOffset(x)
				isTogglingOff = starIndex != -1 and starIndex == selectedStarIndex

				for i in [0..4]
					currentStar = sender.children[i].children[0]
					color = if isTogglingOff then starEmptyColor else starFillColor

					if i < starIndex
						@.parent.animateStar(currentStar, color, 0.5)
					else if i == starIndex
						@.parent.animateStar(currentStar, color, 0.8)
					else
						@.parent.animateStar(currentStar, starEmptyColor)

				selectedStarIndex = if isTogglingOff then undefined else starIndex

			@container.on Events.MouseOut, (event, sender) ->
				if event.clientX <= @.x or event.clientX >= @.maxX or event.clientY <= @.y or event.clientY >= @.maxY
					for i in [0..4]
						currentStar = sender.children[i].children[0]

						if selectedStarIndex == -1 or !selectedStarIndex
							@.parent.animateStar(currentStar, starEmptyColor, 0.5)
						else
							if i <= selectedStarIndex
								currentStar.animateStop()
								@.parent.animateStar(currentStar, starFillColor, 0.5)
							else
								@.parent.animateStar(currentStar, starEmptyColor, 0.5)

	animateStar: (currentStar, color, scale) ->
		currentStar.animate
			properties:
				color: color
				scale: scale
			time: 0.5
