# Monkey2Tutorials
Some example code for the Monkey2 programming language

##Spacecraft Tutorial
###Part 1:

1) Create a SpaceCraft class that extends Window
2) Prepare some methods to draw and update the screen
3) Make a GameObject Class which will be the base class for all our game objects
4) Implement a simple Component class for giving game objects functionality
5) Create a Player class with a control Component and get it drawing to the screen

###Part 2:

1) Enable the GameObject to have a Body and Space and set up an InitPhysics method
2) Add a chipmunk Space in the SpaceCraft class.
3) Write some maintainence functions to handle adding and removing from the Space
4) Use a Chipmunk bounding box query to draw all objects on screen (in this case just the player).

###Part 3:

1) Build on the Controls component to define the player controls and get it moving about
2) Use a chipmunk query to update objects that are on screen
