# Introduction
The official Microsoft FramerJS Toolkit. Here's an overview of everything you need to know:

## Documentation
[Documentation for available controls](/documentation.md)

## GIT
GIT is version control that allows for easy branching so you can try every crazy idea you might have with no risk of horking production code. For our project, you'll only need to know a handful of git commands. So, open up Terminal on your Mac, and here we go:

### Key GIT Concepts
* A git repository contains every character of every line of code in the history of the project.
* A git branch is a snapshot of the code in the repository at a specific point in time.
* Everything in git happens in branches. You should always create a working branch for your work `git checkout -b alias/branch_name` and you should never work in the master branch.
* Commiting changes is a two step process involving adding changes to the staging area and then committing the staged changes.
* The way your branch is merged into master is through a pull request. Sometimes we'll do manual merges, but it's better to use pull requests so people can review and comment on your code.

### GIT commands (or the few you need to know)
* `git status` is arguably the most important command of all. The reason is that local changes in your branch follow you around until you tell them what to do. So, if you edit a file, and then switch to a different branch before you add `git add .` and commit `git commit -m "edited my file, yo!"` then that file will show up as edited in the branch you switch to. The key thing here is to always look for the message `working directory clean` before doing anything.
* `git checkout` has different uses depending on what you're trying to do:
	* `git checkout joeday/branch_name` will checkout the branch `joeday/branch_name`
	* `git checkout -b joeday/other_branch_name` will create a new branch called `joeday/other_branch_name` based on the branch you are in when you run this command. So, if I'm in master, then at the moment I create `joeday/other_branch_name`, I have an identical copy of master.
** `git checkout README.md` checks out the file `README.md`. The most common use of this is reverting README.md to it's last checked in state. This is useful when you've made changes to a file that you'd like to forget. Forever.
* `git branch` shows you a list of all local branches (the branches you've created and/or checked out)
* `git branch -a` shows you a list of all local and remote branches. Remote branches are local branches that have been pushed to remote by using `git push`
* `git add` adds a change in the working directory to the staging area. It tells Git that you want to include updates to a particular file in the next commit. You can be nitpicky by using `git add file_name_a file_name_b` to only add the files `file_name_a` and `file_name_b` to the staging area. OR you can add all of your changes by simply using `git add .`.
* `git commit -m "added color to buttons"` will commit the staged files to your local repository and attach the comment `"added color to buttons"` to it.
	* Note: commit just commits your change to the branch you are currently in in your local repository. It does not add your changes to the master branch. It does not add the changes to your branch on remote. To do that, you'll have to do `git push` (see below)
	* Note: if you do `git status` after this, you'll see `working directory clean` which is pure awesomeness.
* `git push` pushes your local branch to the remote. You'll need to do this step before creating a pull request. You'll notice that when you run this command, it'll return a message to you `git push --set-upstream origin alias/branch_name` which you can just copy and paste.
	* Note: `git push --set-upstream origin` copies your local repository to the remote AND connects your local repository to it. This is helpful in the future when you've done changes in the course of a code review. Then you can just do `git push` and it knows where to put them.
	* Note: `git push` is also useful if you want to resume your work on a different computer. Say you're wanting to resume work on your laptop, you'd do `git push --set-upstream origin alias/branch_name` from your desktop. Then open your laptop, and do `git fetch`. You'll see `alias/branch_name` in the list of branches, then you can do `git pull alias/branch_name` to check out your branch.
* `git pull` pulls changes from remote into your local branch. You'll use this mostly to update the master branch, or to pull changes from remote into your local branch when working across different machines.

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

### Extending classes in Modules
A lot of what we will be doing with our project is extending the Layer class. There's one big reason why we will do this: to make things easy for our users. This way, when they use the module, after they require it all they have to do is create a new on and call it by name `foo = new Toggle`. Admittedly, extending the Layer class makes our modules a bit more complex, but it's worth it. You can look at the ToggleSwitch module as an example.

To extend the layer class, do this `class ToggleSwitch extends Layer`

Then create any of the properties you want ToggleSwitch to have in it's constructor object
```
constructor: (@options={}) ->
	@options.toggled ?= false
	super @options
```

`super @options` concludes initilization and appends it to the Layer class so you can use it just like any other layer property in Framer

Then add any defaults you want it to have. In this case, height and background color:

```
constructor: (@options={}) ->
	@options.toggled ?= false
	@options.height ?= 20
	@options.backgroundColor ?= ''
	super @options
```

Use `@define` to make your custom properties easier to use. At this point, to create an instance of ToggleSwitch and set it's toggled state to true, you'd do

```
foo = new ToggleSwitch
foo.options.toggled = true
```

But if we define the toggled state, then we can use the more clear and concise method.

```
constructor: (@options={}) ->
	@options.toggled ?= false
	@options.height ?= 20
	@options.backgroundColor ?= ''
	super @options
	@createLayers()

@define 'toggled',
	get: ->
		@options.toggled
	set: (value) ->
		@options.toggled = value
```

Now, when we instantiate our ToggleSwitch we can do

```
foo = new ToggleSwitch
	toggled: true
```

### `this` or `@` or both?
* `this` is one of those things in javascript that seems simple, and sometimes is, but other times it is not.
* `this` and `@` are identical. For convention sake, let's use `@`
* `this` is all about context! It references it's current context, unless it isn't (confusing, I know)
```
class ToggleSwitch extends Layer

	constructor: (@options={}) ->
		@options.toggled ?= false
		@options.height ?= 20
		@options.backgroundColor ?= ''
		super @options

	print @
```
returns:
`<Function ToggleSwitch(options) { var base, base1, base2; this.options = options != null ? options : {}; if ((base = this.options).toggled == null) { base.toggled = false; } if ((base1 = this.options).height == null) { base1.height = 20; } if ((base2 = this.options).backgroundColor == null) { base2.backgroundColor = ''; } Toggle.__super__.constructor.call(this, this.options); this.createLayers(); }>`
```
class ToggleSwitch extends Layer

	constructor: (@options={}) ->
		@options.toggled ?= false
		@options.height ?= 20
		@options.backgroundColor ?= ''
		super @options

		print @
```
returns:
`<ToggleSwitch id:1 (0, 0) 200x20>`
* Modules can reference other modules
	* EX: The ToggleSwitch module uses the Motion module
	* To reference another module inside your module, do it at the top of the file before anything else and add a comment to tell users that the other module is a dependency.
	```
	# This module requires the motionCurves module and it's associated JSON file. Please copy both motionCurves.coffee and motion_curves.json into your /modules directory
	m = require "motionCurves"
	```

##Contribute to Windows Framer Module Toolkit

The foundation of the Windows Framer Toolkit is simplicity.

Using modules should be as simple as including a module and calling it. This is why we generally will extend existing Framer classes.

### General rules

* DO keep your module focused on one control, not a control family. For instance, in the family of Toggles there is CheckBox, RadioButton, and ToggleSwitch. There should be a module for each.
* DO group your module file into it's proper family. If you're unsure where it should go, view the Sketch or Illustrator Toolkit file for reference, or just ask.
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
