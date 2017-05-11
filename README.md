# Introduction
The official Microsoft FramerJS Toolkit. Here's an overview of everything you need to know:

## Documentation
[Documentation for available controls](/documentation.md)

## Framer modules
Modules have a superpower: they help keep your code clean so you can focus on the good stuff. They do this by enabling segmentation of modular bits of code.

### Module overview
* Modules are granular by design. This means you'll have one module for each control and not one module containing multiple controls. This will be explained in more detail in the exports section.
* A module consists of a coffeescript file called `ModuleName.coffee`. Follow object class naming patterns, capitalized first word, camel case after that. So, if you create a calendar date picker module, your file would be named `CalendarDatePicker.coffee`
* Everything in the scope of your module must be included in `exports`. So, for our calendar date picker, we need to include `exports.CalendarDatePicker = ->` to make the it available in the module.
* To use the module in Framer Studio, you reference it by doing a couple of things:
	1. Put the module file in your `/modules` directory.
	2. At the top of your Framer project, require the module `{CalendarDatePicker} = require "CalendarDatePicker"`
	3. Then you can use your nifty calendar date picker in your Framer project

## Contribute to Windows Framer Module Toolkit

The foundation of the Windows Framer Toolkit is simplicity.

Using modules should be as simple as including a module and calling it. This is why we generally will extend existing Framer classes.

### General rules

* DO keep your module focused on one control, not a control family. For instance, in the family of Toggles there is CheckBox, RadioButton, and ToggleSwitch. There should be a module for each.
* DO group your module file into it's proper family. If you're unsure where it should go, view the XD or Illustrator Toolkit file for reference, or just ask.
* DO name your module the name of the control. For instance, ToggleSwitch and not BadAssToggle (though we all know it is indeed badass).
* DO include the essential interactive states. For instance, Button has rest, disabled, pressed and hover. Make sure your button has all the expected behaviors for those states.

### Naming conventions
* Class names are capitalized and camel case. Example: ToggleSwitch, not toggleSwitch or Toggleswitch.

### A good pull request
Every contribution should include:

* A control that is needed. Before starting coding, make sure the module you're creating is a Windows control that doesn't already have a Framer module built or in progress. If there's no existing module, open up an issue on Github to start the conversation to let us know you want to build it.  
* A README.md file for the module documenting and describing it's unique properties. See the README.md for ToggleSwitch as an example.
* PR has to target the master branch

### Process
* We will respond to a new pull request within 24 hours (or 1 business day).
* Pull request has to be validated by at least two core members before being merged.
* Once merged, it'll be in master and available for the community to use. Huzzah! Congrats!
