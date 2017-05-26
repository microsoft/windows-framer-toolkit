# ComboBox requires these modules. Please include them in your /modules directory
{Type} = require "Type"
{Color} = require "Color"

comboBoxWidth = 296
itemHeight = 32

class suggestItem extends Layer
	@define "item",
		get: -> if @string? then @string.text
		set: (value) -> if @string? then @string.text = value

	@define "selected",
		get: -> if @? then return @_selected
		set: (value) -> if @? then @_selected = value

	constructor: (options) ->
		super _.defaults options,
			backgroundColor: undefined
			width: comboBoxWidth
			height: itemHeight
			item: "item"
			_selected: false
		@createItemLayer()
		@item = options.item
		@selected = options.selected

	createItemLayer: ->
		@backgroundColor = @setBackgroundColor("rest")

		@string = new Type
			parent: @
			name: "item string"
			x: 12
			y: 5
			uwpStyle: "body"
			textOverflow: "clip"
			text: "something"

		@onMouseOver -> @backgroundColor = @setBackgroundColor("over")
		@onMouseDown -> @backgroundColor = @setBackgroundColor("down")
		@onMouseUp -> @backgroundColor = @setBackgroundColor("over")
		@onMouseOut -> @backgroundColor = @setBackgroundColor("rest")
		@onTap -> @emit("itemTapped")

	setBackgroundColor: (state) ->
		switch state
			when "rest"
				if @selected then Color.listAccentLow else Color.transparent
			when "over"
				if @selected then Color.listAccentMedium else Color.listLow
			when "down"
				if @selected then Color.listAccentHigh else Color.listMedium

class exports.ComboBox extends Layer
	# A default list to get our customers going
	# The default list contains 2 values: 'item' and 'selected'
	defaultItemList = [
		{item:"Item 1"},
		{item:"item 2", selected: true},
		{item:"item 3"},
		{item:"item 4"}
	]

	listLength = defaultItemList.length

	@define "header",
		get: -> if @headerText? then return @headerText.text
		set: (value) -> if @headerText? then @headerText.text = value

	@define "itemList",
		get: -> if @? then return @_itemList
		set: (value) -> if @? then @_itemList = value

	constructor: (options) ->
		super _.defaults options,
			width: comboBoxWidth
			height: @setRootHeight()
			backgroundColor: Color.transparent
			header: "Control Header"
			_itemList: defaultItemList
		@createLayers()
		@header = options.header
		@itemList = options._itemList

	# COMBOBOX LAYERS
	createLayers: ->
		layers = @
		@headerText = new Type
			parent: @
			name: "header"

		@contentWrap = new Layer
			parent: @
			name: "content wrapper"
			width: comboBoxWidth
			height: 32
			backgroundColor: Color.altMediumLow
			borderColor: Color.baseMediumLow
			borderColor: "red"
			borderWidth: 2
			y: @headerText.height + 8

		@contentText = new Type
			parent: @contentWrap
			name: "content string"
			x: 10
			y: 4
			width: comboBoxWidth - 44
			color: Color.baseHigh
			textOverflow: "clip"

		@chevron = new Type
			parent: @contentWrap
			name: "chevron"
			y: Align.center
			x: Align.right(- 9)
			uwpStyle: "glyph"
			text: "\uE0E5"
			fontSize: 12
			color: Color.baseMediumLow

		@itemWrapScroll = new ScrollComponent
			parent: @
			name: "suggestion scroll"
			y: @contentWrap.y + (-7)
			width: comboBoxWidth
			visible: false
			opacity: 0.0
			backgroundColor: Color.chromeMedium
			borderColor: Color.chromeHigh
			borderWidth: 1
			scrollHorizontal: false

		@itemWrapScroll.states.listHidden =
			visible: false
			opacity: 0.0
			height: 0
			animationOptions:
				curve: "ease-in"
				time: .2
		@itemWrapScroll.states.listShowed =
			visible: true
			opacity: 1.0
			height:
				if @itemList is undefined
					itemHeight * listLength + 16
				else
					itemHeight * @itemList.length + 16
			animationOptions:
				curve: "ease-out"
				time: .2

		@initializeList()
		@updateBoxVisuals()
		@setRootHeight()

		for i in @itemWrapScroll.content.children[0..@itemWrapScroll.content.children.length]
			i.on "itemTapped", (isOn) ->
				for l in layers.itemWrapScroll.content.children
					[0...layers.itemWrapScroll.content.children.length]
					l.selected = false
					l.backgroundColor = Color.transparent

				this.selected = true
				layers.itemWrapScroll.animate("listHidden")
				layers.contentText.text = @string.text
				layers.contentText.width = @string.width

		# EVENTS
		@contentWrap.onMouseOver -> @.parent.updateBoxVisuals("over")
		@contentWrap.onMouseDown -> @.parent.updateBoxVisuals("down")
		@contentWrap.onMouseUp -> @.parent.updateBoxVisuals("up")
		@contentWrap.onMouseOut -> @.parent.updateBoxVisuals("out")
		@contentWrap.onTap -> @.parent.itemWrapScroll.states.switch("listShowed")

	# FUNCTIONS
	setRootHeight: -> if @headerText is "" then 38 else 60

	initializeList: ->
		pos = 0

		if @itemList is undefined
			listLength	= listLength
			list = defaultItemList
		else
			listLength = @itemList.length
			list = @itemList

		for i in list[0..listLength]
			itemPos = pos++
			@listItem = new suggestItem
				parent: @itemWrapScroll.content
				name: "item " + itemPos
				y: itemPos * itemHeight + 7
				item: i.item
				selected: i.selected

		filterItem = list.filter (f) -> f.selected
		@contentText.text = filterItem[0].item

	updateBoxVisuals: (curEvent) ->
		switch curEvent
			when "over"
				comboBoxBackgroundColor = Color.altMedium
				comboBoxBorderColor = Color.baseMediumHigh
				chevronColor = Color.baseMediumHigh
			when "down"
				comboBoxBackgroundColor = Color.listMedium
				comboBoxBorderColor = Color.baseMediumLow
			when "up"
				comboBoxBackgroundColor = Color.altMediumLow
			when "out"
				comboBoxBackgroundColor = Color.transparent
				comboBoxBorderColor = Color.baseMediumLow
			when "disabled"
				headerTextColor = Color.baseMediumLow
				comboBoxBackgroundColor = Color.baseLow
				comboBoxBorderColor = Color.baseLow
				chevronColor = Color.baseMediumLow
			else
				comboBoxBorderColor = Color.baseMediumLow
				comboBoxBackgroundColor = Color.transparent

		@contentWrap.backgroundColor = comboBoxBackgroundColor
		@contentWrap.borderColor = comboBoxBorderColor
		@chevron.color = chevronColor
		@headerText.color = headerTextColor