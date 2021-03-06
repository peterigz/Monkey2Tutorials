Namespace spacecraft

'
'	Class for creating repeating backgrounds with adjustable scroll speed
'	You could create as many of these as you need to create a layered parallax scroll effect. To use, create a
'	new Parallax and pass the Image along with the width and height of the area
'	you want to fill, which would typically be the window size.
'	
'	You can also pass the speed which is used to scale how much the background scrolls, the scale which will reduce or
'	increase the size of the image, plus you can also decide if you want the image to be repeated on either the x or y
'	directions. See Parallax.New for all the parameters
Class Parallax
	
	'The image to tile for the background
	Field Image:Image
	'The width and height of the space to fill - usually the screen size
	Field FillWidth:Int
	Field FillHeight:Int
	
	'This are calculated automatically and are used to work out how many times the image should be tiled
	Field Rows:Int
	Field Cols:Int
	
	'The speed allows you to controll how fast the background scrolls relative to the foreground
	Field Speed:Float
	'How much the image should be scaled by
	Field Scale:Float
	
	'Whether or not he background is repeated horizontally or vertically or both
	Field RepeatX:Int
	Field RepeatY:Int
	
	'The size of the image after being scaled
	Field ImageWidth:Float
	Field ImageHeight:Float

	'The blendmode used to draw the image.
	Field Blend:BlendMode = BlendMode.Alpha
	'The colour used to draw the image
	Field Color:Color = New Color(1,1,1,1)
	
	'An offset can be used to offset the drawing of the image
	Field Offset:Vec2f
	
	#Rem
		monkeydoc Create a new [[Parallax]]
		@param shape [[Image]]
		@param FillWidth Int width of area to fill with image
		@param FillHeight Int height of area to fill with image
		@param speed Float value of the amout to scale the origin by to controll how fast the image scrolls
		@param scale Float value of the image scale if you need to resize it
		@param repeatx True or False to control whether the image is tiled horizontally
		@param repeaty True or False to control whether the image is tiled Vertically
		@param offset Vec2f Amount to offest the image by. Usefull for none repeating backgrounds
	#End
	Method New(image:Image, fillwidth:Int, fillheight:Int, speed:Float = 0.5, scale:Float = 1, repeatx:Int = True, repeaty:Int = True, offset:Vec2f = New Vec2f)
		'Populate the fields with the values passed in to the method
		Image = image
		ImageWidth = image.Width * scale
		ImageHeight = image.Height * scale
		FillWidth = fillwidth
		FillHeight = fillheight
		
		'Calculate the number of rows and columns the background needs to be drawn in order to fill the whole space
		If repeaty
			Rows = FillHeight / (ImageHeight) + 1
			If (Rows * ImageHeight) - FillHeight < ImageHeight
				Rows += 1
			End If 
		Else
			Self.Rows = 0
		End If 
		If repeatx
			Cols = FillWidth / (ImageWidth) + 1
			If (Cols * ImageWidth) - FillWidth < ImageWidth
				Cols += 1
			End If 
		Else
			Cols = 0
		End If 
		'Populate the rest of the fields
		Speed = speed
		Scale = scale
		RepeatX = repeatx
		RepeatY = repeaty
		Offset = offset
	End
	
	#Rem
		monkeydoc Draw the [[Parallax]] Object
		To implement a parallax effect in your game, your game will presumably have some kind of world coordinates
		of the player or camera location. That will be the origin that you pass here and is used to determine how to
		draw the background. The origin will be scaled according to the Speed value you created the [[tlParallax]] Object
		with so you can easily create different backgrounds that scroll at different speeds.
		@param canvas the [[mojo.Canvas]] to draw onto
		@param origin Vec2f of the origin to draw the background
	#End
	Method Draw(canvas:Canvas, origin:Vec2f)
		'By multiplying the origin by the speed we can make the background scroll at a different speed
		origin*=-Speed
		
		canvas.BlendMode = Blend
		canvas.Color = Color

		'Draw the tiled background for all columns and rows
		For Local x:=0 To Cols
			For Local y:=0 To Rows
				'We need to do a bit of math to loop the tiles over and over as you scroll.
				Local offsetx:=origin.x - (Int((origin.x/ImageWidth)) * ImageWidth)
				Local offsety:=origin.y - (Int((origin.y/ImageHeight)) * ImageHeight)
				
				Local xpos:=Float(x * ImageWidth + offsetx) + Offset.x
				Local ypos:=Float(y * ImageHeight + offsety) + Offset.y
				
				'So if a tile has dropped off the edge of the screen put it back to the front so you're effectively
				'looping the background
				If xpos >= FillWidth And RepeatX xpos-=ImageWidth * (Cols+1)
				If ypos >= FillHeight And RepeatY ypos-=ImageHeight * (Rows+1)
				
				'draw the background
				canvas.DrawImage( Image, xpos, ypos, 0, Scale, Scale )
			Next
		Next
	End
	
End