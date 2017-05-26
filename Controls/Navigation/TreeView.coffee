# TreeView requires these modules. Please include them in your /modules directory
{Type} = require "Type"
{SystemColor} = require "SystemColor"

class exports.TreeView extends Layer
	constructor: (@options={}) ->
		@options.items ?= []
		@options.width ?= 320
		@options.height ?= 44
		@options.backgroundColor ?= SystemColor.transparent
		super @options
		@createLayers()

	@define "items",
		get: ->
			@options.items
		set: (value) ->
			@options.items = value
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

		for item, index in @options.items
			itemLayer = @createChildren(item, index, @container, 0)

		@updateLayout()

	createChildren: (item, index, parent, level) ->
		# if isExpanded is undefined, set it to false
		if !item.isExpanded then item.isExpanded = false

		itemContainer = new Layer
			parent: parent
			name: "Item Container " + (level + 1) + "." + (index + 1)
			childLayer: []
			backgroundColor: SystemColor.transparent
		itemContainer.totalHeight = itemContainer.height
		item.layer = itemContainer
		itemContainer.item = item
		itemContainer.parentTreeView = this

		arrow = new Type
			parent: itemContainer
			name: "Arrow"
			text: if item.isExpanded then "\uE70D" else "\uE76C"
			fontSize: 12
			uwpStyle: "glyph"
			width: 36
			x: 16 * level
			textAlign: "center"
			padding:
				top: 16
				bottom: 16
			opacity: 0

		itemText = new Type
			parent: itemContainer
			name: "Item Text"
			text: item.itemText
			x: arrow.maxX
			padding:
				top: 12
				bottom: 13

		if item.children
			# show the arrow when an item has children
			arrow.opacity = 1
			level += 1

			for childNode, index in item.children
				childLayer = @createChildren(childNode, index, itemContainer, level, itemContainer.totalHeight)

		# EVENTS
		itemContainer.onMouseOver ->
			event.stopPropagation()
			@.backgroundColor = SystemColor.listLow
		itemContainer.onMouseDown ->
			event.stopPropagation()
			@.backgroundColor = SystemColor.listMedium
		itemContainer.onMouseUp ->
			event.stopPropagation()
			@.backgroundColor = SystemColor.listLow

			# if item has children, expand/collapse
			if childLayer
				if this.item.isExpanded
					this.item.isExpanded = false
					arrow.text = "\uE76C"
				else
					this.item.isExpanded = true
					arrow.text = "\uE70D"

			this.parentTreeView.updateLayout()

		itemContainer.onMouseOut ->
			event.stopPropagation()
			@.backgroundColor = SystemColor.transparent

		return itemContainer

	updateLayout: ->
		ypos = 0
		for item, index in @options.items
			@updateLayoutForNode(item)
			item.layer.y = ypos
			ypos += item.layer.totalHeight

			@options.height = @container.height = ypos

	updateLayoutForNode: (item)->
		item.layer.visible = true
		item.layer.y = 0
		item.layer.height = 44
		item.layer.width = @options.width
		item.layer.totalHeight = item.layer.height
		ypos = item.layer.totalHeight
		if item.children
			for childItem, index in item.children
				@updateLayoutForNode(childItem)

				if !item.isExpanded
					childItem.layer.visible = false
				else
					childItem.layer.visible = true
					item.layer.totalHeight += childItem.layer.totalHeight
					childItem.layer.y = ypos
					ypos += childItem.layer.totalHeight

		return ypos
