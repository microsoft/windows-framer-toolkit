# AutoSuggestBox requires these modules. Please include them in your /modules directory
{Type} = require "Type"
{Color} = require "Color"

initalContentStringWidth = 0
autoSuggestBoxWidth = 296
wrapBorderWidth = 2
defaultItemList = [
	'Seattle Aquarium',
	'Seattle traffic',
	'Seattle Seahawks away game schedule and times',
	'Seattle Great Wheel ticket prices'
]
suggestionItemHeight = 44

class contentElem extends Type
	constructor: (@options) ->
		@options.x ?= 10
		@options.y ?= 4
		@options.color ?= Color.baseHigh
		super(@options)

class glyphButton extends Layer
	constructor: (@options={}) ->
		@options.width ?= 30
		@options.height ?= 28
		@options.backgroundColor ?= Color.transparent
		@options.icon ?= "\uE10A"
		@options.iconColor ?= Color.chromeBlackMedium
		super @options
		@createGlyphButton()

	@define "icon",
		get: ->
			@options.icon
		set: (value) ->
			@options.icon = value
			if @plate?
				 @createGlyphButton()

	createGlyphButton: ->
		if @plate?
			@plate.destroy()

		@plate = new Layer
			parent: @
			name: "button plate"
			width: @options.width
			height: @options.height
			backgroundColor: Color.transparent
			y: wrapBorderWidth

		@glyph = new Type
			parent: @plate
			name: "button icon"
			x: Align.center()
			y: Align.center()
			fontSize: 12
			uwpStyle: "glyph"
			text: @options.icon
			color: @options.iconColor

		@plate.onMouseOver ->
			@.parent.updateGlyphVisuals("mouseOver")
		@plate.onMouseDown ->
			@.parent.updateGlyphVisuals("mouseDown")
		@plate.onMouseUp ->
			@.parent.updateGlyphVisuals("mouseUp")
		@plate.onMouseOut ->
			@.parent.updateGlyphVisuals("mouseOut")

	updateGlyphVisuals: (curEvent) ->
		switch curEvent
			when "mouseOver"
				@glyph.color = Color.accent
			when "mouseDown"
				@glyph.color = Color.chromeWhite
				@plate.backgroundColor = Color.accent
			when "mouseUp"
				@glyph.color = Color.accent
				@plate.backgroundColor = Color.transparent
			when "mouseOut"
				@glyph.color = Color.chromeBlackMedium

class suggestItem extends Layer
	constructor: (@options={}) ->
		@options.backgroundColor ?= Color.transparent
		@options.width ?= autoSuggestBoxWidth
		@options.height ?= suggestionItemHeight
		@options.item ?= ""
		super @options
		@createItemLayer()

	@define "item",
		get: ->
			@options.item
		set: (value) ->
			@options.item = value
			if @string?
				@createItemLayer()

	createItemLayer: ->
		if @plate?
			@plate.destroy()

		@plate = new Layer
			parent: @
			name: "item plate"
			width: @options.width
			height: @options.height
			backgroundColor: @options.backgroundColor

		@string = new Type
			parent: @plate
			name: "item string"
			x: 12
			y: 11
			uwpStyle: "body"
			text: @options.item
			textOverflow: 'clip'

		@plate.onMouseOver ->
			@.parent.updateItemVisuals("mouseOver")
		@plate.onMouseDown ->
			@.parent.updateItemVisuals("mouseDown")
		@plate.onMouseUp ->
			@.parent.updateItemVisuals("mouseUp")
		@plate.onMouseOut ->
			@.parent.updateItemVisuals("mouseOut")

	updateItemVisuals: (curEvent) ->
		switch curEvent
			when "mouseOver"
				@plate.backgroundColor = Color.listAccentLow
			when "mouseDown"
				@plate.backgroundColor = Color.listAccentHigh
			when "mouseUp"
				@plate.backgroundColor = Color.listAccentLow
			when "mouseOut"
				@plate.backgroundColor = Color.transparent

class exports.AutoSuggestBox extends Layer
	constructor: (@options={}) ->
		@options.width ?= autoSuggestBoxWidth
		@options.height ?= @setRootHeight()
		@options.backgroundColor ?= Color.transparent
		@options.header ?= "Header"
		@options.content ?= "Seat"
		@options.hint ?= "Hint text"
		@options.focused ?= false
		@options.suggestions ?= defaultItemList
		super @options
		@createLayers()

	@define "header",
		get: ->
			@options.header
		set: (value) ->
			@options.header = value
			if @autoSuggestBox?
				@createLayers()

	@define "content",
		get: ->
			@options.content
		set: (value) ->
			@options.content = value
			if @autoSuggestBox?
				@createLayers()

	@define "hint",
		get: ->
			@options.hint
		set: (value) ->
			@options.hint = value
			if @autoSuggestBox?
				@createLayers()

	@define "focused",
		get: ->
			@options.focused
		set: (value) ->
			@options.focused = value
			if @autoSuggestBox?
				@createLayers()

	@define "suggestions",
		get: ->
			@options.suggestions
		set: (value) ->
			@options.suggestions = value
			if @autoSuggestBox?
				@createLayers()

	# AUTOSUGGESTBOX LAYERS
	createLayers: ->
		if @autoSuggestBox?
			@autoSuggestBox.destroy()

		@autoSuggestBox = new Layer
			parent: @
			name: "auto suggest box"
			backgroundColor: Color.transparent
			width: autoSuggestBoxWidth
			height: @setRootHeight()

		@headerType = new Type
			parent: @autoSuggestBox
			name: "header"
			text: @options.header

		@contentWrap = new Layer
			parent: @autoSuggestBox
			name: "content wrapper"
			width: autoSuggestBoxWidth
			height: 32
			backgroundColor: Color.altMediumLow
			borderColor: Color.chromeDisabledLow
			borderWidth: 2
			y: @headerType.height + 8

		@hintString = new contentElem
			parent: @contentWrap
			name: "hint"
			text: @options.hint
			color: Color.baseMedium

		@contentString = new contentElem
			parent: @contentWrap
			name: "content string"
			text: @options.content
			color: Color.baseHigh
			visible: false
		initalContentStringWidth = @contentString.width

		@pipe = new Type
			parent: @contentWrap
			name: "pipe"
			x: @contentString.width + @contentString.x
			y: 3
			color: Color.baseHigh
			text: "|"
			visible: false

		@searchButton = new glyphButton
			parent: @autoSuggestBox
			name: "search button"
			y: @contentWrap.y
			x: Align.right(- 2)
			icon: "\uE094"

		@cancelButton = new glyphButton
			parent: @autoSuggestBox
			name: "cancel button"
			y: @contentWrap.y
			x: Align.right(- (@searchButton.width + 2))
			visible: false

		@suggestionScroll = new ScrollComponent
			parent: @autoSuggestBox
			name: "suggestion scroll"
			y: @contentWrap.y + @contentWrap.height
			width: autoSuggestBoxWidth
			height: if @focused then 0 else @setSuggestionsHeight()
			opacity: if @focused then 0.0 else 1.0
			backgroundColor: Color.chromeMedium
			borderColor: Color.chromeHigh
			borderWidth: 1
			scrollHorizontal: false

		@suggestionScroll.states.stateA =
			opacity: 0.0
			height: 0
			animationOptions:
				curve: "ease-out"
				time: 0.167
		@suggestionScroll.states.stateB =
			opacity: 1.0
			height: @setSuggestionsHeight()
			animationOptions:
				curve: "ease-out"
				time: 0.3

		@initializeSuggestions()
		@setFocus()
		@updateBoxVisuals()
		@playPipeAnim()
		@setRootHeight()

		# EVENTS
		@contentWrap.onMouseOver ->
			@.parent.parent.updateBoxVisuals("mouseOver")
		@contentWrap.onMouseDown ->
			@.parent.parent.updateBoxVisuals("mouseDown")
		@contentWrap.onMouseOut ->
			@.parent.parent.updateBoxVisuals("mouseOut")

	# FUNCTIONS
	setRootHeight: ->
		if !@options.header then 38 else 60

	setSuggestionsHeight: ->
		if @options.suggestions.length is 0
			suggestionItemHeight
		else if @options.suggestions.length >= 2
			suggestionItemHeight * @options.suggestions.length + 13
		else
			suggestionItemHeight

	initializeSuggestions: ->
		list = [0...@options.suggestions.length]

		if list.length is 0
			new suggestItem
				parent: @suggestionScroll.content
				name: "no result item"
				y: 0
				item: "No result"
		else
			for i in list
				new suggestItem
					parent: @suggestionScroll.content
					name: "item " + (i + 1)
					y: 44 * i
					item: @options.suggestions[i]

	setFocus: ->
		focusedStringMaxWidth = autoSuggestBoxWidth - (20 + @cancelButton.width + @searchButton.width)

		if @focused is true
			# Making sure that the string doesn't collide with the cancel button
			if @contentString.width >= focusedStringMaxWidth
				@contentString.width = focusedStringMaxWidth

			@cancelButton.visible = if !@contentString.text then false else true
			@hintString.visible = false
			@contentString.visible = true
			@contentString.textOverflow = "clip"
			@pipe.visible = true
			@contentWrap.borderColor = Color.accent
			@suggestionScroll.animate("stateB")
		else
			@cancelButton.visible = false
			@hintString.visible = true
			@contentString.visible = false
			@pipe.visible = false
			@contentWrap.borderColor = Color.chromeDisabledLow
			@suggestionScroll.animate("stateA")

		@pipe.x = @contentString.width + @contentString.x

	updateBoxVisuals: (curEvent) ->
		switch curEvent
			when "mouseOver"
				@contentWrap.borderColor = if @focused then Color.accent else Color.chromeAltLow
			when "mouseDown"
				@focused = true
			when "mouseOut"
				@contentWrap.borderColor = if @focused then Color.accent else Color.chromeDisabledLow

	# ANIMATIONS
	playPipeAnim: ->
		animTime = 0.6

		pipeOutAnim = new Animation
			layer: @pipe
			properties:
				opacity: 0.0
			curve: "ease-out"
			time: animTime

		pipeInAnim = new Animation
			layer: @pipe
			properties:
				opacity: 1.0
			curve: "ease-in"
			time: animTime

		pipeOutAnim.start()

		pipeOutAnim.onAnimationEnd ->
			pipeInAnim.start()

		pipeInAnim.onAnimationEnd ->
			pipeOutAnim.start()
