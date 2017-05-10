# Our motion library for use in Framer projects.
# Values stored in motion_curves.json and parsed here.

exports.curve = (arg) ->

    # First, decide whether we're getting a string or an Array
    # If it's a string, we'll want to see if it matches something in curves object
    # If it's an array, we'll simply set the x0, y0, x1, and y1 values and call it good
    isAry = (arg instanceof Array) ? true : false

    # Set or initialize the curve value variables
    x0 = if isAry then arg[0] else 0
    y0 = if isAry then arg[1] else 0
    x1 = if isAry then arg[2] else 0
    y1 = if isAry then arg[3] else 1

    if !isAry
        # Get the curve data via JSON and store it in an object
        curves = require("./motion_curves.json")

        # Match will be false unless a match is made in the loop below
        # If there is no match made, we'll send a message to the console and help find a curve that will match
        match = false

        # Iterate through curves object to find a match with the string passed in
        # Then update the curve value variables with the values in the object
        for i of curves
            if i == arg
                match = true
                x0 = curves[i].x0
                y0 = curves[i].y0
                x1 = curves[i].x1
                y1 = curves[i].y1

        # Alert if string passed does not match
        if !match
            print "Curve: #{arg} is unrecognized. See motion_curves.json for available curves"

    # Return the cubic-bezier curve as a string
    return "cubic-bezier(#{x0}, #{y0}, #{x1}, #{y1})"
