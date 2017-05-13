n = require "noise"

exports.acrylic = (color, opacity, element) ->
	# Create some CSS to add to the dom to handle CSS Transition of backdrop blur because Framer can't animate it
	css = """
	.has-blur {
		transition-property: -webkit-backdrop-filter;
		transition-timing-function: cubic-bezier(.5,0,0,.9);
		transition-duration: .3s;
	}
	.add-blur {
		-webkit-backdrop-filter: blur(30px);
	}
	"""

	# Add the above CSS to the DOM
	Utils.insertCSS(css)

	blurryBG = new Layer
		parent: element
		name: "Blur Layer"
		x: 0
		y: 0
		width: element.width
		height: element.height
		backgroundColor: Color.transparent
		index: 1
		shadowX: 0
		shadowY: 0
		shadowBlur: 25
		shadowColor: "rgba(0,0,0,0.075)"

	blurryBG.classList.add("add-blur", "has-blur")

	# furthest layer in the window stack
	tintBg = new Layer
		parent:element
		name: "Exclusion Layer"
		backgroundColor: "rgba(255,255,255,0.1)"
		index: 2
		width: element.width
		height: element.height

	tintBg.style = {"mix-blend-mode": "exclusion"}

	colorBG = new Layer
		parent: element
		name: "Color Layer"
		x: 0
		y: 0
		width: element.width
		height: element.height
		index: 3
		backgroundColor: color
		opacity: opacity

	noisyBG = new Layer
		parent: element
		name: "Noise Layer"
		x: 0
		y: 0
		index: 4
		width: element.width
		height: element.height
		backgroundColor: Color.transparent

	# Add noise via the module
	n.noise(0.04, noisyBG)
