{SystemColor} = require "SystemColor"

class exports.Type extends TextLayer

	_uwpStyle = "body"
	@define "uwpStyle",
		get: ->
			return @_uwpStyle
		set: (value) ->
			@_uwpStyle = value
			@emit("change:uwpStyle")

	constructor: (options) ->
		super _.defaults options,
			fontFamily: "Segoe UI"
			color: SystemColor.baseHigh
			fontSize: 15
			lineHeight: 1.333
			fontWeight: 400

		@on "change:uwpStyle", ->
			@setStyle()

		@setStyle()

	setStyle: ->
		switch
			when @uwpStyle is "header"
				@fontSize = 46
				# lineHeight = 56px
				@lineHeight = 1.217
				@fontWeight = 200
			when @uwpStyle is "subheader"
				@fontSize = 34
				# lineHeight = 40px
				@lineHeight = 1.176
				@fontWeight = 200
			when @uwpStyle is "title"
				@fontSize = 24
				# lineHeight = 28px
				@lineHeight = 1.167
				@fontWeight = 300
			when @uwpStyle is "subtitle"
				@fontSize = 20
				# lineHeight = 24px
				@lineHeight = 1.2
				@fontWeight = 400
			when @uwpStyle is "subtitleAlt"
				@fontSize = 18
				# lineHeight = 22px
				@lineHeight = 1.222
				@fontWeight = 400
			when @uwpStyle is "base"
				@fontSize = 15
				# lineHeight = 20px
				@lineHeight = 1.333
				@fontWeight = 600
			when @uwpStyle is "baseAlt"
				@fontSize = 15
				# lineHeight = 20px
				@lineHeight = 1.333
				@fontWeight = 700
			when @uwpStyle is "body"
				@fontSize = 15
				# lineHeight = 20px
				@lineHeight = 1.333
				@fontWeight = 400
			when @uwpStyle is "captionAlt"
				@fontSize = 13
				# lineHeight = 16px
				@lineHeight = 1.23
				@fontWeight = 400
			when @uwpStyle is "caption"
				@fontSize = 12
				# lineHeight = 14px
				@lineHeight = 1.167
				@fontWeight = 400
			when @uwpStyle is "glyph"
				@fontSize = undefined
				@lineHeight = 1
				@fontWeight = 400
				@fontFamily = "Segoe MDL2 Assets"
			else
				@fontSize = 15
				# lineHeight = 20px
				@lineHeight = 1.333
				@fontWeight = 400

		@_styledText.render()