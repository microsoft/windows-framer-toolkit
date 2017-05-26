{SystemThemeColor} = require "SystemThemeColor"

class exports.Type extends TextLayer

	constructor: (@options={}) ->
		@options.uwpStyle ?= "body"
		@options.fontFamily ?= "Segoe UI"
		@options.color ?= SystemThemeColor.baseHigh
		@options.fontSize ?= 15
		@options.lineHeight ?= 1.333
		@options.fontWeight ?= 400
		super @options

	@define "uwpStyle",
		get: ->
			@options.uwpStyle
		set: (value) ->
			@options.uwpStyle = value
			@setStyle()

	setStyle: ->
		switch
			when @options.uwpStyle is "header"
				@fontSize = 46
				# lineHeight = 56px
				@lineHeight = 1.217
				@fontWeight = 200
			when @options.uwpStyle is "subheader"
				@fontSize = 34
				# lineHeight = 40px
				@lineHeight = 1.176
				@fontWeight = 200
			when @options.uwpStyle is "title"
				@fontSize = 24
				# lineHeight = 28px
				@lineHeight = 1.167
				@fontWeight = 300
			when @options.uwpStyle is "subtitle"
				@fontSize = 20
				# lineHeight = 24px
				@lineHeight = 1.2
				@fontWeight = 400
			when @options.uwpStyle is "subtitleAlt"
				@fontSize = 18
				# lineHeight = 22px
				@lineHeight = 1.222
				@fontWeight = 400
			when @options.uwpStyle is "base"
				@fontSize = 15
				# lineHeight = 20px
				@lineHeight = 1.333
				@fontWeight = 600
			when @options.uwpStyle is "baseAlt"
				@fontSize = 15
				# lineHeight = 20px
				@lineHeight = 1.333
				@fontWeight = 700
			when @options.uwpStyle is "body"
				@fontSize = 15
				# lineHeight = 20px
				@lineHeight = 1.333
				@fontWeight = 400
			when @options.uwpStyle is "captionAlt"
				@fontSize = 13
				# lineHeight = 16px
				@lineHeight = 1.23
				@fontWeight = 400
			when @options.uwpStyle is "caption"
				@fontSize = 12
				# lineHeight = 14px
				@lineHeight = 1.167
				@fontWeight = 400
			when @options.uwpStyle is "glyph"
				@fontSize = undefined
				@lineHeight = 1
				@fontWeight = 400
				@fontFamily = "Segoe MDL2 Assets"
			else
				@fontSize = 15
				# lineHeight = 20px
				@lineHeight = 1.333
				@fontWeight = 400
