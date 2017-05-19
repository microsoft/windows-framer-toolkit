exports.noise = (opacity, element) ->
	if !!!document.createElement('canvas').getContext
		print "false!"
		return false
	canvas = document.createElement('canvas')
	ctx = canvas.getContext('2d')
	x = undefined
	y = undefined
	number = undefined
	opacity = opacity or .2
	canvas.width = 100
	canvas.height = 100
	x = 0
	for i in [1..canvas.width]
		y = 0
		for j in [1..canvas.height]
			number = Math.floor(Math.random() * 255)
			ctx.fillStyle = 'rgba(' + number + ',' + number + ',' + number + ',' + opacity + ')'
			ctx.fillRect x, y, 1, 1
			y++
		x++
	element.style.backgroundImage = 'url(' + canvas.toDataURL('image/png') + ')'
	element.style.backgroundRepeat = 'repeat'
	element.style.backgroundPosition = 'top left'
	element.style.backgroundSize = 'auto'
