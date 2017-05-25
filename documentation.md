# Windows Controls
All of the controls and styles currently exist in their light theme for mouse input state.

For more information on Windows controls, visit [Controls and patterns for UWP apps](https://docs.microsoft.com/en-us/windows/uwp/controls-and-patterns/index)

If you hit any of the known bugs listed below for a specific control, please contact us. If you know how to fix them, please create a pull request.

#### Actions
[Button](#button)

[HyperlinkButton](#hyperlinkbutton)

[Rating](#rating)

[Slider](#slider)

#### MediaPlayer
[MediaPlayer](#MediaPlayer)

#### Navigation
[AppBar](#appbar)

[NavigationView](#navigationview)

[TreeView](#treeview)

#### Overlays
[ContextMenu](#contextmenu)

[Dialog](#dialog)

#### Pickers
[CalendarDatePicker](#calendardatepicker)

[DatePicker](#datepicker)

[TimePicker](#timepicker)

#### Toggles
[CheckBox](#checkbox)

[RadioButton](#radiobutton)

[ToggleSwitch](#toggleswitch)

#### Motion
[Motion Curves](#motioncurves)

#### Fluent
[Noise](#noise)

[Acrylic](#acrylic)

#### Style
[Color](#color)

[Type](#type)

## Actions
### Button
* [Detailed Button documentation](https://docs.microsoft.com/en-us/windows/uwp/controls-and-patterns/buttons)
* Properties available:
	* *label:* a label that appears inside of a clickable rectangle, default: "Label"
	* *enabled:* determines whether the control is actionable or not, default: true
	* *width:* constrain the width of the control and make the text wrap, minimum width is 120px, default: @labelText.width
* Example:
```
clickMeButton = new Button
	label: "Click me!"
	enabled: true
```
* Known bugs: Only @labelText width and height update when the label or width properties are changed at runtime, the width and height of the entire control stays the same as the initial values.

### HyperlinkButton
* [Detailed HyperlinkButton documentation](https://docs.microsoft.com/en-us/windows/uwp/controls-and-patterns/hyperlinks)
* Properties available:
	* *label:* a label that appears inside of a clickable area, default: "Label"
	* *enabled:* determines whether the control is actionable or not, default: true
* Example:
```
penSettingsLink = new HyperlinkButton
	label: "Pen settings"
	enabled: true
```

### Rating
* [Detailed Rating documentation](https://docs.microsoft.com/en-us/windows/uwp/controls-and-patterns/rating)
* Properties available:
	* *starsFilled:* determines the initial star rating from 0 to 5 stars, default: 0
	* *allowInput:* determines whether the control responds to user input / is editable, the control must also be enabled to allow input, default: true
	* *enabled:* determines whether the control is active or not, the control will appear grayed out when set to false, default: true
* Example:
```
movieRating = new Rating
	starsFilled: 4
	enabled: false
	allowInput: false
```

### Slider
* [Detailed Slider documentation](https://docs.microsoft.com/en-us/windows/uwp/controls-and-patterns/slider)
* Properties available:
	* *header:* a label that appears above the control, default: "Control header"
	* *value:* the current value, which sets the position of the slider knob, default: 25
	* *min:* the minimum possible value, default: 0
	* *max:* the maximum possible value, default: 50
	* *enabled:* determines whether the control is actionable or not, default: true
* Example:
```
volumeSlider = new Slider
	header: "Volume"
	value: 50
	min: 0
	max: 120
	enabled: true
```

## Navigation
### AppBar
* [Detailed AppBar documentation](https://docs.microsoft.com/en-us/windows/uwp/controls-and-patterns/app-bars)
* Due to its complexity, AppBar has been built as a template instead of a module. Copy the contents of AppBarTemplate.coffee into the app.coffee file for your project to get started.
* Make sure to include the modules for Type, Color, and ContextMenu in your modules folder.

### NavigationView
* Detailed NavigationView documentation coming soon
* Due to its complexity, NavigationView has been built as a template instead of a module. Copy the contents of NavViewTemplate.coffee into the app.coffee file for your project to get started.
* Make sure to include the modules for Type, Color, motion, and acrylic in your modules folder.
* To see the acrylic material, make sure to add an image to the bg layer.

### TreeView
* [Detailed TreeView documentation](https://docs.microsoft.com/en-us/windows/uwp/controls-and-patterns/tree-view)
* Properties available:
	* *items:* an array of nested objects that populate the levels in the TreeView, give each object itemText, set isExpanded to true/false, and add children, default: []
* Example:
```
items = [
	{"itemText" : "Item 1.1", "isExpanded" : true, "children" : [
			{"itemText" : "Item 2.1"},
			{"itemText" : "Item 2.2", "isExpanded" : true, "children" : [
				{"itemText" : "Item 3.1", "isExpanded" : false, "children" : [
					{"itemText" : "Item 4.1"}
					]}]
			}]
	},
	{"itemText" : "Item 1.2", "isExpanded" : true, "children" : [
		{"itemText" : "Item 2.1"},
		{"itemText" : "Item 2.2"},
		{"itemText" : "Item 2.3"},
		{"itemText" : "Item 2.4"}]
	}
]
inboxFolders = new TreeView
	items: items
```
* Known bugs: Height of an instance of TreeView doesn't update with the module's container height.

## Overlays
### ContextMenu
* [Detailed ContextMenu documentation](https://docs.microsoft.com/en-us/windows/uwp/controls-and-patterns/menus)
* Properties available:
	* *items:* an array that populates the items in the list
	* *disabledItems:* an array of the indexes that should be disabled within the items array (first item has index 0)
* Example:
```
commands = ["reply", "reply all", "forward"]
disabled = [1, 2]
mailOptions = new ContextMenu
	items: commands
	disabledItems: disabled
```
* Known bugs: Changing the items array at runtime doesn't resize the container.

### Dialog
* [Detailed Dialog documentation](https://docs.microsoft.com/en-us/windows/uwp/controls-and-patterns/dialogs)
* Properties available:
	* *title:* a title that appears at the top of the dialog, default: "Dialog title"
	* *content:* the message that appears inside of the dialog, default: "Message text. This is where the message dialog text goes. The text can wrap."
	* *button1Text:* the content for the first button, default: "Button"
	* *button2Text:* the content for the second button, default: undefined
	* *button3Text:* the content for the third button, default: undefined
* Example:
```
alertMessage = new Dialog
	parent: scroller.content
	y: overlays.maxY + 24
	button1Text: "Save"
	button2Text: "Save as"
	button3Text: "Cancel"
	title: "Quit without saving?"
	content: "Are you sure you want to quit the application before saving?"
alertMessage.button3.onClick ->
	alertMessage.opacity = 0
```
* Known bugs: Size doesn't reliably update when content strings are changed at runtime.

### Flyout
* [Detailed Flyout documentation](https://docs.microsoft.com/en-us/windows/uwp/controls-and-patterns/dialogs)
* Properties available:
	* *label:* text that appears inside of the flyout
* Example:
```
message = new Flyout
	label: "This is a flyout."
```

## Pickers
### DatePicker
* [Detailed TimePicker documentation](https://docs.microsoft.com/en-us/windows/uwp/controls-and-patterns/time-picker)
* Properties available:
	* *header:* text that appears above the control, default: "Control header"
	* *month:* the selected month in collapsed mode, default: "January"
	* *date:* the selected date in collapsed mode, default: "11"
	* *year:* the selected year in collapsed mode, default: "2014"
	* *enabled:* determines whether the control is actionable or note, default: true
* Example:
```
setDate = new DatePicker
	header: "Set date"
	month: "June"
	date: "14"
	year: "2018"
```


### CalendarDatePicker
* [Detailed CalendarDatePicker documentation](https://docs.microsoft.com/en-us/windows/uwp/controls-and-patterns/calendar-date-picker)
* Properties available:
	* *header:* text that appears above the control, default: "Control header"
	* *date:* the selected date in collapsed mode, default: "mm/dd/yyyy"
	* *enabled:* determines whether the control is actionable or not, default: true
* Example:
```
pickDate = new CalendarDatePicker
	label: "Select departure date"
	date: "09/23/2017"
```

### TimePicker
* [Detailed TimePicker documentation](https://docs.microsoft.com/en-us/windows/uwp/controls-and-patterns/time-picker)
* Properties available:
	* *header:* text that appears above the control, default: "Control header"
	* *hour:* the selected hour in collapsed mode, default: "9"
	* *minute:* the selected minute in collapsed mode, default: "26"
	* *ampm:* AM or PM in collapsed mode, default: "AM"
	* *enabled:* determines whether the control is actionable or note, default: true
* Example:
```
setTime = new TimePicker
	header: "Set start time"
	hour: "7"
	minute: "24"
	ampm: "PM"
```

## Toggles
### CheckBox
* [Detailed CheckBox documentation](https://docs.microsoft.com/en-us/windows/uwp/controls-and-patterns/checkbox)
* Properties available:
	* *label:* a label that appears to the right of the CheckBox, default: "Label"
	* *toggled:* determines whether the control is selected or not, default: false
	* *enabled:* determines whether the control is actionable or not, default: true
	* *width:* constrain the width of the control and make the text wrap, minimum width is 120px, default: undefined
* Example:
```
autoUpdate = new CheckBox
	label: "Download updates automatically"
	toggled: false
	enabled: false
	width: 150
```
* Known bugs: CheckBox text width isn't constrained by its parent layer and wrapping text bleeds off the edge of the screen. Only @container width and height update when the label or width properties are changed at runtime, the width and height of the entire control stay the same as the initial values.

### RadioButton
* [Detailed RadioButton documentation](https://docs.microsoft.com/en-us/windows/uwp/controls-and-patterns/radio-button)
* Properties available:
	* *label:* a label that appears to the right of the RadioButton, default: "Label"
	* *toggled:* determines whether the control is selected or not, default: false
	* *enabled:* determines whether the control is actionable or not, default: true
	* *width:* constrain the width of the control and make the text wrap, minimum width is 120px, default: undefined
* Example:
```
themeRadioButton = new RadioButton
	label: "Dark theme"
	toggled: true
	enabled: false
```
* Known bugs: RadioButton text width isn't constrained by its parent layer and wrapping text bleeds off the edge of the screen. Only @container width and height update when the label or width properties are changed at runtime, the width and height of the entire control stay the same as the initial values.

### ToggleSwitch
* [Detailed ToggleSwitch documentation](https://docs.microsoft.com/en-us/windows/uwp/controls-and-patterns/toggles)
* Properties available:
	* *header:* a label that appears above the control, default: "Control header"
	* *onText:* a label that appears to the right of the toggle when the toggle is on, default: "On"
	* *offText:* a label that appears to the right of the toggle when the toggle is off, default: "Off"
	* *toggled:* determines whether the control is on or off, default: false
	* *enabled:* determines whether the control is actionable or not, default: true
* Example:
```
frontDoorLock = new ToggleSwitch
	header: "Front door"
	onText: "Locked"
	offText: "Unlocked"
	toggled: true
	enabled: true
```
* Known bugs: ToggleSwitch control width doesn't update when header is longer than the toggle + on/off text.

### MediaPlayer
* [Detailed MediaPlayer documentation](https://docs.microsoft.com/en-us/windows/uwp/controls-and-patterns/media-playback)
* Due to its complexity, MediaPlayer has been built as a template instead of a module. Copy the contents of MediaPlayerTemplate.coffee into the app.coffee file for your project to get started.
* Make sure to include the modules for Type, Color and Slider in your modules folder.

## Motion
### Motion Curves
* Use motion curves in your animations. Make sure to include both motion_curves.json and motionCurves.coffee in your modules folder.
* Available curves:
	* Linear
	* EaseOut
	* EaseOutSmooth
	* EaseIn
	* DrillIn
	* BackToApp
	* AppToApp
	* FastIn
	* FastOut
	* FastInOut
	* Exponential
	* FastInFortySevenPercent
	* ExponentialReversed
	* NavPane
* Example:
```
m = require "motionCurves"
...
leftPane.states =
	collapsed:
		width: 48
	expanded:
		width: 320
	animationOptions:
		curve: m.curve("NavPane")
		time: 0.3
```

## Fluent
### Noise
* Noise is used by the acrylic module to create acrylic material.

### Acrylic
* [Detailed Acrylic documentation](https://docs.microsoft.com/en-us/windows/uwp/style/acrylic)
* To use acrylic on a layer, pass in the base background color, opacity, and the layer name. Make sure to include both the noise and acrylic modules in your modules folder.
* Example:
```
a = require "acrylic"
...
leftPane = new Layer
	parent: appWindow
	width: 320
	height: 768
	backgroundColor: SystemThemeColor.transparent
a.acrylic(SystemThemeColor.altHigh, 0.8, leftPane)
```

## Style
### Color
* Color allows the user to apply colors from [Windows System Colors](https://docs.microsoft.com/en-us/windows/uwp/style/color#color-theming).
* Use the following syntax: SystemThemeColor.altHigh, SystemThemeColor.baseHigh, SystemThemeColor.accent, etc.
* accentColor is set to the default Windows Blue: #0078D7.
* Example:
```
backgroundLayer = new Layer
	backgroundColor: SystemThemeColor.accent
```

### Type
* Type allows the user to create text using the styles from the [Windows Type Ramp](https://docs.microsoft.com/en-us/windows/uwp/style/typography#type-ramp).
* Properties available:
	* *text:* the text content for your layer, default: "Content"
	* *color:* the color of the text, default: SystemThemeColor.baseHigh
	* *textAlign:* the alignment of the text, default: "left"
	* *width:* this property can be used to constrain the width of the layer so that the text wraps, default: width of the text string
	* *height:* this property can be used to constrain the height of the layer, default: line height of the text per the style applied
	* *uwpStyle:* the style of the text, default: "body", choose any of the following from the Windows Type Ramp:
		* "caption"
		* "captionAlt"
		* "body"
		* "baseAlt"
		* "base"
		* "subtitleAlt"
		* "subtitle"
		* "title"
		* "subheader"
		* "header"
		* "glyph" (sets fontSize to undefined, lineHeight to 1, and fontFamily to Segoe MDL2 Assets, can receive a font glyph in the form of a unicode value, e.g. "\uE735")
* Example:
```
placeholderText = new Type
	content: "Lorem ipsum"
	style: "captionAlt"
	color: SystemThemeColor.baseMedium
	textAlign: "center"
```
