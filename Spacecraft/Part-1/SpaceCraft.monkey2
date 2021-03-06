'Part 1 - Set up the window and GameObject/Player Object

'1) Create a SpaceCraft class that extends Window
'2) Prepare some methods to draw and update the screen
'3) Make a GameObject Class which will be the base class for all our game objects
'4) Implement a simple Component class for giving game objects functionality
'5) Create a Player class with a control Component and get it drawing to the screen

'Give our game a namespace, we probably won't need it but it's good practice
Namespace spacecraft

'Import the modules that we will need:
'std is a standard set of useful functionality that you will need 99% of the time
#Import "<std>"
'Mojo handles all of our graphics drawing
#Import "<mojo>"
'Our own individual files for including
#Import "gameobject"
#Import "player"

'Import everything that's in our assets folder ready for using
#Import "assets/"

Using std..
Using mojo..

'Create a global variable that we can use for our virtual resolution. Virtual resolution allows us to 
'make the screen space of the game the same no matter what the actual resolution is.
Global VirtualResolution:Vec2f = New Vec2f(800, 600)

'Our main window class
Class SpaceCraft Extends Window
	'A field to store our player
	Field Player:Player
	
	'Because we will have a world that you can move about in, we need someway of storing where the camera is
	'in that world so that the game objects can be drawn in the right places by offsetting their coordinates 
	'by this vector
	Field Origin:Vec2f
	
	'It's useful to store the canvas where the game is drawn to so we can access it easily elsewhere
	Field CurrentCanvas:Canvas

	Method New( title:String="Spacecraft",width:Int=800,height:Int=600,flags:WindowFlags=WindowFlags.Resizable )

		Super.New( title,width,height,flags )
		
		InitGame()
	End
	
	'method where we setup all our variables with the initial values
	Method InitGame()
		
		'Create a new player and load in an image for it. Set it to some initial coordinates and scale it down a bit.
		Player = New Player(Self)
		Player.Image = Image.Load("asset::Player/player.png")
		Player.XY = New Vec2f(400,200)
		Player.Scale = New Vec2f(0.35, 0.35)
	End

	Method OnRender( canvas:Canvas ) Override
		CurrentCanvas = canvas
		
		'Call our OnUpdate method before any rendering. Note that we're not using and kind of timing code and just relying
		'on the Monitor refresh rate. This can be enhanced at some point.
		OnUpdate()
	
		'Request a render form the app
		App.RequestRender()
		
		'Clear the canvas with a color, in this case black
		canvas.Clear(New Color(0,0,0,0))
		
		'This is the process to sort out the virtual resolution, start by pushing the canvas matrix onto the internal matrix stack
		canvas.PushMatrix()
		
		'Scale the canvas so that the virtual resolution will always fit in the screen.
		canvas.Scale(Width / VirtualResolution.x, Height / VirtualResolution.y)
		
		'Call our render world method which will render all of our game objects.
		RenderWorld()
		
		'We've finished with the canvas matrix so pop it
		canvas.PopMatrix()
		
		'Draw any useful info text for debugging here, after the popmatrix, so that it won't be scaled.
		canvas.DrawText("FPS: " + App.FPS, 10, 10)
	End
	
	'This method will convert screen coordinates into world coordinates (for example the mouse coordinates)
	'It will also take into account the current virtual resolution
	Method ScreenToWorld:Vec2f(screen:Vec2f)
		screen/=New Vec2f(Width / VirtualResolution.x, Height / VirtualResolution.y)
		Return screen + Origin
	End
	
	'This is the update method that's called by the UpdateTimer
	Method OnUpdate()
		Player.Update()
	End

	Method RenderWorld()
		'We will render our world here!
		Player.Draw(CurrentCanvas)
	End
	
End

'Every Monkey2 program needs a main function which executes the code we have written
Function Main()
	'Create a new App
	New AppInstance
	
	'Create a new Space craft game
	New SpaceCraft
	
	'Run the game!	
	App.Run()
End
