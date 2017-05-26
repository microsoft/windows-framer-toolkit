{SystemColor} = require "SystemColor"
{Type} = require "Type"
{ContextMenu} = require "ContextMenu"

minimalMoreButtonPadding =
	left: 12
	top: 2
	right: 12
	bottom: 2
compactAppBarButtonPadding =
	left: 24
	top: 14
	right: 24
	bottom: 14
compactMoreButtonPadding =
	left: 12
	top: 14
	right: 12
	bottom: 14

appBarButtonWidth = 68
moreButtonWidth = 48

minimalHeight = 24
compactHeight = 48
expandedHeight = 60
minMenuWidth = 160

commands = [ "List item 1", "List item 2", "List item 3"]

class AppBarButton extends Type
	constructor: (options) ->
		super(options)
		@fontSize = 20
		@uwpStyle = "glyph"
		@textAlign = "center"

		@.onMouseOver ->
			@.backgroundColor = SystemColor.listLow
		@.onMouseDown ->
			@.backgroundColor = SystemColor.listMedium
		@.onMouseUp ->
			@.backgroundColor = SystemColor.listLow
		@.onMouseOut ->
			@.backgroundColor = SystemColor.transparent

class AppBarButtonLabel extends Type
	constructor: (options) ->
		super(options)
		@uwpStyle = "caption"
		@textAlign = "center"
		@width = appBarButtonWidth

# -------------- #
#  Minimal Mode  #
# -------------- #
minimalLabel = new Type
	text: "Minimal Mode"
	style: "header"
	x: 24
	y: 24

# layer to clip the minimalModeMenu when it's collapsed
minimalModeClip = new Layer
	backgroundColor: SystemColor.transparent
	width: Screen.width
	height: screen.height
	clip: true

minimalMode = new Layer
	width: Screen.width
	y: minimalLabel.maxY + 24
	height: minimalHeight
	width: Screen.width
	backgroundColor: SystemColor.chromeMedium

minimalModeClip.y = minimalMode.y

minimalMoreButton = new AppBarButton
	parent: minimalMode
	text: "\uE10C"
	width: moreButtonWidth
	padding: minimalMoreButtonPadding
	maxX: minimalMode.maxX

minimalModeMenu = new ContextMenu
	parent: minimalModeClip
	items: commands
	width: minMenuWidth

minimalModeMenu.maxX = minimalMode.maxX
minimalModeMenu.maxY = minimalHeight

minimalMoreButton.onClick ->
	if minimalModeMenu.maxY is minimalHeight
		minimalModeMenu.animate
			y: minimalHeight
			options:
				time: 0.3
	else
		minimalModeMenu.animate
			maxY: minimalHeight
			options:
				time: 0.3

minimalModeMenu.onClick ->
	minimalModeMenu.animate
		maxY: minimalHeight
		options:
			time: 0.3

# -------------- #
#  Compact Mode  #
# -------------- #
compactLabel = new Type
	text: "Compact Mode"
	style: "header"
	x: 24
	y: minimalMode.maxY + 80

# layer to clip the compactModeMenu when it's collapsed
compactModeClip = new Layer
	backgroundColor: SystemColor.transparent
	width: Screen.width
	height: screen.height
	clip: true

compactMode = new Layer
	width: Screen.width
	y: compactLabel.maxY + 24
	height: compactHeight
	width: Screen.width
	backgroundColor: SystemColor.chromeMedium
	clip: true

compactModeClip.y = compactMode.y

compactMoreButton = new AppBarButton
	parent: compactMode
	text: "\uE10C"
	width: moreButtonWidth
	height: expandedHeight
	padding: compactMoreButtonPadding

compactModeMenu = new ContextMenu
	parent: compactModeClip
	items: commands
	width: minMenuWidth

compactModeMenu.maxX = compactMode.maxX
compactModeMenu.maxY = compactHeight

appBarButton1 = new AppBarButton
	parent: compactMode
	text: "\uE72D"
	width: appBarButtonWidth
	height: expandedHeight
	padding: compactAppBarButtonPadding

divider = new Layer
	parent: compactMode
	height: 20
	width: 1
	backgroundColor: SystemColor.baseLow

appBarButton2 = new AppBarButton
	parent: compactMode
	text: "\uE70F"
	width: appBarButtonWidth
	height: expandedHeight
	padding: compactAppBarButtonPadding

appBarButton3 = new AppBarButton
	parent: compactMode
	text: "\uE74D"
	width: appBarButtonWidth
	height: expandedHeight
	padding: compactAppBarButtonPadding

appBarButton4 = new AppBarButton
	parent: compactMode
	text: "\uE74E"
	width: appBarButtonWidth
	height: expandedHeight
	padding: compactAppBarButtonPadding

compactMoreButton.maxX = compactMode.maxX
appBarButton4.maxX = compactMoreButton.x
appBarButton3.maxX = appBarButton4.x
appBarButton2.maxX = appBarButton3.x
divider.maxX = appBarButton2.x - 15
divider.y = 14
appBarButton1.maxX = divider.x - 16

labels = new Layer
	parent: compactMode
	backgroundColor: SystemColor.transparent
	y: 38
	width: compactMode.width
	opacity: 0

appBarButton1Label = new AppBarButtonLabel
	parent: labels
	text: "Share"
	x: appBarButton1.x

appBarButton2Label = new AppBarButtonLabel
	parent: labels
	text: "Edit"
	x: appBarButton2.x

appBarButton3Label = new AppBarButtonLabel
	parent: labels
	text: "Delete"
	x: appBarButton3.x

appBarButton4Label = new AppBarButtonLabel
	parent: labels
	text: "Save"
	x: appBarButton4.x

compactMoreButton.onClick ->
	if compactMode.height is compactHeight
		compactMode.animate
			height: expandedHeight
			options:
				time: 0.3
		labels.animate
			opacity: 1
			options:
				time: 0.3
		compactModeMenu.animate
			y: expandedHeight
			options:
				time: 0.3
	else
		compactMode.animate
			height: compactHeight
			options:
				time: 0.3
		labels.animate
			opacity: 0
			options:
				time: 0.3
		compactModeMenu.animate
			maxY: compactHeight
			options:
				time: 0.3

compactModeMenu.onClick ->
	compactMode.animate
		height: compactHeight
		options:
			time: 0.3
	labels.animate
		opacity: 0
		options:
			time: 0.3
	compactModeMenu.animate
		maxY: compactHeight
		options:
			time: 0.3
