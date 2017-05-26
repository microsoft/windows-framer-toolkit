# Use desktop cursor
document.body.style.cursor = "auto"

{Type} = require "Type"
{SystemThemeColor} = require "SystemThemeColor"
m = require "motionCurves"
a = require "acrylic"

hoverColor = SystemThemeColor.listLow
pressColor = SystemThemeColor.listMedium
restColor = SystemThemeColor.transparent

contentMargin = 24

bg = new Layer
	width: Screen.width
	height: Screen.height
	image: ""

appWindow = new Layer
	y: 100
	width: 1024
	height: 32
	backgroundColor: SystemThemeColor.transparent

appWindow.centerX()
appWindow.draggable.enabled = true
appWindow.draggable.momentum = false

leftPane = new Layer
	parent: appWindow
	width: 320
	height: 768
	clip: true
	backgroundColor: SystemThemeColor.transparent

leftPane.states =
	collapsed:
		width: 48
	expanded:
		width: 320
	animationOptions:
		curve: m.curve("NavPane")
		time: 0.3

leftPane.stateSwitch("expanded")

a.acrylic(SystemThemeColor.altHigh, 0.6, leftPane)

mainPane = new Layer
	parent: appWindow
	x: leftPane.maxX
	width: appWindow.width - leftPane.width
	height: 768
	backgroundColor: SystemThemeColor.altHigh

mainPane.states =
	collapsed:
		width: appWindow.width - 48
		x: 48
	expanded:
		width: appWindow.width - 320
		x: 320
	animationOptions:
		curve: m.curve("NavPane")
		time: 0.3

mainPane.stateSwitch("expanded")

titleBar = new Layer
	parent: appWindow
	width: appWindow.width
	height: 32
	backgroundColor: SystemThemeColor.transparent

backButton = new Type
	parent: titleBar
	width: 48
	height: 32
	fontSize: 12
	text: "\uE830"
	uwpStyle: "glyph"
	padding:
		left: 18
		top: 10
		right: 18
		bottom: 10

title = new Type
	parent: titleBar
	text: "Application title"
	style: "caption"
	x: backButton.maxX + 12
	padding:
		top: 6

close = new Type
	parent: titleBar
	width: 48
	height: 32
	maxX: titleBar.maxX
	fontSize: 10
	text: "\uE8BB"
	uwpStyle: "glyph"
	padding:
		left: 19
		top: 11
		right: 19
		bottom: 11

maximize = new Type
	parent: titleBar
	width: 48
	height: 32
	maxX: close.x
	fontSize: 10
	text: "\uE922"
	uwpStyle: "glyph"
	padding:
		left: 19
		top: 11
		right: 19
		bottom: 11

minimize = new Type
	parent: titleBar
	width: 48
	height: 32
	maxX: maximize.x
	fontSize: 10
	text: "\uE921"
	uwpStyle: "glyph"
	padding:
		left: 19
		top: 11
		right: 19
		bottom: 11

pageTitle = new Type
	parent: mainPane
	name: "Page Title"
	text: "Page title two"
	uwpStyle: "title"
	width: mainPane.width
	y: 40
	padding:
		left: contentMargin
		top: 5
		bottom: 11

contentWidth = mainPane.width - contentMargin * 2
contentHeight = mainPane.height - titleBar.height - pageTitle.height - 8

viewOne = new Layer
	parent: mainPane
	name: "View One"
	index: 1
	x: contentMargin
	y: pageTitle.maxY
	width: contentWidth
	height: contentHeight
	backgroundColor: "LightPink"

viewTwo = new Layer
	parent: mainPane
	name: "View Two"
	index: 1
	x: contentMargin
	y: pageTitle.maxY
	width: contentWidth
	height: contentHeight
	backgroundColor: "LightBlue"

viewThree = new Layer
	parent: mainPane
	name: "View Three"
	index: 1
	x: contentMargin
	y: pageTitle.maxY
	width: contentWidth
	height: contentHeight
	backgroundColor: "LightGreen"

viewFour = new Layer
	parent: mainPane
	name: "View Four"
	index: 1
	x: contentMargin
	y: pageTitle.maxY
	width: contentWidth
	height: contentHeight
	backgroundColor: "Lavender"

viewOne.visible = false
viewThree.visible = false
viewFour.visible = false

hamburger = new Type
	parent: leftPane
	text: "\uE700"
	fontSize: 16
	uwpStyle: "glyph"
	padding: 16
	width: leftPane.width
	y: backButton.maxY + 8


navItemData = [
	["\uF156", "Nav item one", null, viewOne, "Page title one"],
	["\uF157", "Nav item two", "selected", viewTwo, "Page title two"],
	["\uF158", "Nav item three", null, viewThree, "Page title three"],
	["\uF159", "Nav item four", null, viewFour, "Page title four"]
]

navItems = []

footerItemData = [
	["\uE77B", "Jane Username"],
	["\uE713", "Settings"]
]

itemsContainer = new Layer
	parent: leftPane
	name: "Items Container"
	backgroundColor: SystemThemeColor.transparent
	width: leftPane.width
	height: navItemData.length * 40
	y: hamburger.maxY

footerItemsContainer = new Layer
	parent: leftPane
	name: "Footer Items Container"
	backgroundColor: SystemThemeColor.transparent
	width: leftPane.width
	height: footerItemData.length * 40
	maxY: leftPane.maxY - 8

initNavItems = ->
	navItem = new Layer
		parent: itemsContainer
		name: "Nav Item " + i
		width: leftPane.width
		height: 40
		backgroundColor: SystemThemeColor.tranparent
		y: i * 40

	selection = new Layer
		parent: navItem
		width: 6
		height: 24
		backgroundColor: SystemThemeColor.accent
		y: 8
		visible: false

	if navItemData[i][2] != null
		selection.visible = true
	else
		selection.visible = false

	navItems.push(selection)

	navItemIcon = new Type
		parent: navItem
		name: "Nav Item Icon " + i
		text: navItemData[i][0]
		fontSize: 16
		uwpStyle: "glyph"
		padding:
			left: 16
			top: 12
			right: 16
			bottom: 12

	navItemText = new Type
		parent: navItem
		name: "Nav Item Text " + i
		x: navItemIcon.maxX
		text: navItemData[i][1]
		padding:
			top: 10

	currentPage = navItemData[i][3]
	currentTitle = navItemData[i][4]

	navItem.onMouseOver ->
		@.backgroundColor = hoverColor
	navItem.onMouseDown ->
		@.backgroundColor = pressColor
		clearSelection()
		selection.visible = true
		currentPage.visible = true
		pageTitle.text = currentTitle
	navItem.onMouseUp ->
		@.backgroundColor = hoverColor
	navItem.onMouseOut ->
		@.backgroundColor = restColor

initFooterItems = ->
	footerItem = new Layer
		name: "Footer Item " + i
		parent: footerItemsContainer
		width: leftPane.width
		height: 40
		backgroundColor: SystemThemeColor.transparent
		y: i * 40

	footerItemIcon = new Type
		parent: footerItem
		name: "Footer Item Icon " + i
		text: footerItemData[i][0]
		fontSize: 16
		uwpStyle: "glyph"
		padding:
			left: 16
			top: 12
			right: 16
			bottom: 12

	footerItemText = new Type
		parent: footerItem
		name: "Footer Item Text " + i
		x: footerItemIcon.maxX
		text: footerItemData[i][1]
		padding:
			top: 10

	footerItem.onMouseOver ->
		@.backgroundColor = hoverColor
	footerItem.onMouseDown ->
		@.backgroundColor = pressColor
	footerItem.onMouseUp ->
		@.backgroundColor = hoverColor
	footerItem.onMouseOut ->
		@.backgroundColor = restColor

for i in [0..navItemData.length - 1]
	initNavItems()

for i in [0..footerItemData.length - 1]
	initFooterItems()

clearSelection = ->
	viewOne.visible = false
	viewTwo.visible = false
	viewThree.visible = false
	viewFour.visible = false

	for i in [0..navItems.length - 1]
		navItems[i].visible = false

hamburger.onMouseOver ->
	hamburger.backgroundColor = hoverColor

hamburger.onMouseDown ->
	hamburger.backgroundColor = pressColor
	if leftPane.states.current.name is "expanded"
		leftPane.animate("collapsed")
		mainPane.animate("collapsed")
	else
		leftPane.animate("expanded")
		mainPane.animate("expanded")

hamburger.onMouseUp ->
	hamburger.backgroundColor = hoverColor

hamburger.onMouseOut ->
	hamburger.backgroundColor = restColor
