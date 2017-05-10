# Dependencies
{Color} = require "Color"
{Type} = require "Type"
{Slider} = require "Slider"

class MediaPlayerButton extends Type
	constructor: (options) ->
		super(options)
		@fontSize = 20
		@uwpStyle = "glyph"
		@textAlign = "center"

		@.onMouseOver ->
			@.backgroundColor = Color.listLow
		@.onMouseDown ->
			@.backgroundColor = Color.listMedium
		@.onMouseUp ->
			@.backgroundColor = Color.listLow
		@.onMouseOut ->
			@.backgroundColor = Color.transparent

# Ideally duration would be read by file
getDuration = (duration) ->
	duration || 387

addZero = (i) ->
	if i < 10
		i = "0" + i
	return i

formatTime = (totalTimeInSeconds) ->
	totalTimeInSeconds = Math.round(totalTimeInSeconds) || 0
	h = Math.floor(totalTimeInSeconds/3600);
	h = addZero(h)
	m = Math.floor((totalTimeInSeconds-h*3600)/60);
	m = addZero(m)
	s = totalTimeInSeconds-(m*60)-(h*3600);
	s = addZero(s)
	h + ":" + m + ":" + s
	
getTime = (time, elapsed) ->
	if elapsed
		formatTime(time)	
	else
		remainingTime = getDuration() - time
		formatTime(remainingTime)	
		
container = new Layer
	backgroundColor: Color.altMedium
	width: Screen.width
	height: 96
	
slider = new Slider
	width: container.width - 24
	header: ""
	x: Align.center
	parent: container

timecodeElapsed = new Type
	parent: slider 
	y: 30
	text: null || formatTime()
	uwpStyle = "caption"

timecodeRemaining = new Type
	parent: slider 
	y: 30
	x: Align.right
	text: null || formatTime(getDuration())
	uwpStyle = "caption"
	
slider.sliderComp.on "change:value", ->
	time = Utils.modulate(Math.round(@value), [0,50], [0, getDuration()])
	timecodeElapsed.text = getTime(time, true)
	timecodeRemaining.text = getTime(time)

leftBtnGlyphs = ["\ue767", "\ued1e", "\ued1f"]

leftButtons = new Layer
	parent: container
	height: 48
	width: leftBtnGlyphs.length * 48
	maxY: container.maxY
	backgroundColor: Color.transparent

for i in [0..leftBtnGlyphs.length - 1]
	button = new MediaPlayerButton
		text: leftBtnGlyphs[i]
		x: 48 * i
		padding: 14
		parent: leftButtons
		
middleBtnGlyphs = ["\ued3c", "\ue768", "\ued3d"]
middleButtons = new Layer
	parent: container
	height: 48
	width: middleBtnGlyphs.length * 48
	maxY: container.maxY
	backgroundColor: Color.transparent
	x: Align.center

for i in [0..middleBtnGlyphs.length - 1]
	button = new MediaPlayerButton
		text: middleBtnGlyphs[i]
		x: 48 * i
		padding: 14
		parent: middleButtons
		
rightBtnGlyphs = ["\ue799", "\uec15", "\ue740", "\ue712"]

rightButtons = new Layer
	parent: container
	height: 48
	width: rightBtnGlyphs.length * 48
	maxY: container.maxY
	backgroundColor: Color.transparent
	x: Align.right
	
for i in [0..rightBtnGlyphs.length - 1]
	button = new MediaPlayerButton
		text: rightBtnGlyphs[i]
		x: 48 * i
		padding: 14
		parent: rightButtons