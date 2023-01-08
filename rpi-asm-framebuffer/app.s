/*/

	En la siguiente animacion intentamos recrear el 
	despertar de un sueño. 
	Usamos tecnicas como "puntillismo" para crear efectos de translucidad 
	e iluminación.
	Usamos degradados del color para crear efecto de sombras. 
	La idea de la imagen en si, es un hombre fumando un cigarrillo,
	(la mano es lo marron de abajo perdon, lo nuestro no es el dibujo)
	el cual esta observando desde un mirador/balcon el mar. 


*/

/*

	Notese el hecho de que la mayoria de los "componentes"
	tienen un "code style". el cual es el siguiente
	setXXXXInitialPos:
		# aca nosotros seteamos los registros en la posicion inicial
		  de nuestra animacion

	declareXXXX:
		#Seteamos los registros x4 y x5 a las correspondientes en el initial pos.
		#Seteamos el color (usamos w10 pero se puede usar cualquier registro de color)
		#Seteamos variables de largo y ancho. Por ejemplo x3 y x13 respectivamente
		mov x4, xX// Y
		mov x5, xX // X
		mov w10, 0x####
		movk w10, 0x##, lsl 16

	XXXXPosition:
		# Seteamos los registros del declare en los registros listados aca abajo
		# Esto lo usamos para mover el FB a la posicion deseada
		mov x1, x13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y value
		mov x8, x5			// X value
		mov x9, SCREEN_WIDTH 

	setXXXXPosition:
		# Movemos el FB a la posicion seteada
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6
	XXXX:
		# Dibujamos el componente	
		stur w10, [x0]
		add x0, x0, 4
		sub x1, x1, 1
		cmp x1, 0
		b.ge XXXX

	resetXXXX:
		# reseteamos el dibujo y podemos modificar las variables Y, X, Ancho, etc
		sub	 x4, x4, 1
		sub x3,x3,1
		cbnz x3, XXXXPosition

	FOR ANIMATION:
	x1 = Drawing Iterator
	x2 = aux variable
	x3...x9 = Used in position select where (x5: X, x4: Y)
	x10 =	color
	x11 =	color
    x12 =	SMOKE COUNT
	x13 = store the n value for the x1 to iterate to
	x14 = X IN USUALLY NON ANIMATED ITEMS
	x15 = Y IN USUALLY NON ANIMATED ITEMS
	x16 = background color
	x17 = FIRE QUANTITY
	x18 = FIRE OFFSET
	x19 = aux variable
	x20 = base FB
	x21 =	SMOKE Y
	x22 = 	SMOKE X
	x24 = 	BOAT ANCHO
	x23 = 	BOAT X
	x25 = 	fire of the pucho heigh
	x26 =	free
	x27 = 	Boat Y
	x28 = 	Cloud Scaling
	x29 = 	FARO ON/OF counter

 */

 
.equ SCREEN_WIDTH, 		640  //X
.equ SCREEN_HEIGH, 		480  //Y
.equ BITS_PER_PIXEL,  	32
.equ START_POSITIION_SMOKE_X, 400
.equ START_POSITIION_SMOKE_Y,  356
.globl main

main:
mov x20, x0	// Save framebuffer base address to x20	
mov x29, 0  // Counter used like "frames"

mov x25, 1
setSmokeInitialPos:
	mov x21, START_POSITIION_SMOKE_Y
	mov x22, START_POSITIION_SMOKE_X
	mov x12, 3

setBoatInitialPos:
	mov x24, 0

	mov x27, 250

reset:    /* ANIMATION RESET */
setBuildingStructureInitialPos:
		mov x14, 286
		mov x15, 40

	declareBuildingStructure:
		mov x4, x14 // Y
		mov x5, x15 // X
		mov x3, 37

		mov w10, 0x0307
		mov x13, 640
	
	BuildingStructurePosition:
		mov x1, x13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 

	setBuildingStructurePosition:
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6

	BuildingStructure:	
		stur w10, [x0]
		add x0, x0, 4
		sub x1, x1, 1
		cmp x1, 0
		b.ge BuildingStructure

	resetBuildingStructure:
		sub	 x4, x4, 1
		sub x3,x3,1
		cbnz x3, BuildingStructurePosition

setSkyPosition:
	mov x0, x20
	mov x2, SCREEN_HEIGH         // Y Size
	mov x5, 480					// sky box
	mov w10, #0x3838
	movk w10, 0x39, lsl 16
resetSky:
	mov x1, SCREEN_WIDTH         // X Size
	mov x2, SCREEN_HEIGH	
	add x0, x0, 2000
	add w10, w10, 1
sky:
	stur w10,[x0]
	add x0,x0, 128
	sub x1,x1,64
	cbnz x1,sky
	sub x5, x5, 1
	cbz x5, setFloor
	sub x2, x2, 48
	cbnz x2, resetSky
setFloor:
	
	mov w11, 0x0952
	movk w11, 0x48, lsl 16
	mov x0, x20
	mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
	mov x7, #300		// Y value
	mov x9, SCREEN_WIDTH 
	madd x6, x7, x9, x9
	lsl x6, x6, 2
	add x0, x20, x6
	mov x5, SCREEN_WIDTH					// Floor box

resetFloor:
	mov x1, SCREEN_WIDTH         // X Size
	mov x2, SCREEN_HEIGH


floor:
	stur w11,[x0]
	add x0,x0, 4
	sub x1,x1,1
	cbnz x1,floor
	sub x5, x5, 1
	cmp x5, 300
	b.ge changeColor
	b.ne keep

changeColor:
	add w11, w11, 0x010000

keep:
	cbz x5, declareWall
	sub x2, x2, 1
	cbnz x2, resetFloor



declareWall:
	mov x4, 320 // Y
	mov x5, 0 // X
	mov x3, 32
	mov w10, 0x0753
	movk w10, 0x48, lsl 16
WallPosition:
	mov x1, 640
	mov x0, x20
	mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
	mov x7, x4			// Y Navevalue
	mov x8, x5			// X Navevalue
	mov x9, SCREEN_WIDTH 
setWallPosition:
	// Move the framebuffer to an specific center to draw a road
	madd x6, x7, x9, x8
	lsl x6, x6, 2
	add x0, x20, x6
Wall:	
	stur w10, [x0]
	add x0, x0, 4
	sub x1, x1, 1
	cbnz x1, Wall
	sub w10, w10, 0x00001

resetWall:
	sub x4,x4, 1
	sub x3,x3,1
	cbnz x3, WallPosition

setWallDetailInitialPos:
		mov x14, 320
		mov x15, 0
		mov x16, 7

	declareWallDetail:
		mov x4, x14 // Y
		mov x5, x15 // X
		mov x3, 10
		mov w10, 0x4645
		movk w10, 0x43, lsl 16
		mov x13, 20
	
	WallDetailPosition:
		mov x1, x13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 

	setWallDetailPosition:
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6

	WallDetail:	
		stur w10, [x0]
		add x0, x0, 4
		sub x1, x1, 1
		cmp x1, 0
		b.ge WallDetail

	resetWallDetail:
		sub	 x4, x4, 1
		sub x3,x3,1
		cbnz x3, WallDetailPosition

	NewWallDetail:
		add x15, x15, 100
		sub x16,x16, 1
		cbnz x16, declareWallDetail

	declareMoon:
		mov x4, 75 // Y
		mov x5, 300 // X
		mov x3, 100
		mov w10, 0x7777
		movk w10, 0x77, lsl 16
		mov x13, 50
	
	MoonPosition:
		mov x1, x13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 

	setMoonPosition:
		// Move the framebuffer to an specific center to draw a road
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6

	Moon:	
		stur w10, [x0]
		add x0, x0, 8
		sub x1, x1, 1
		cmp x1, 0
		b.ge Moon

	resetMoon:
		sub x4, x4, 1
		sub x3,x3,1
		cbnz x3, MoonPosition


	setCloudInitialPos:
		mov x14, 26
		mov x15, 49
		mov x16, 3

	declareCloud:
		mov x4, x14 // Y
		mov x5, x15 // X
		mov x3, 15
		mov w10, 0x2029
		movk w10, 0x27, lsl 16
		mov x13, 60
	
	CloudPosition:
		mov x1, x13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 

	setCloudPosition:
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6

	Cloud:	
		stur w10, [x0]
		add x0, x0, 8
		sub x1, x1, 1
		cmp x1, 0
		b.ge Cloud

	resetCloud:
		add x4, x4, 1
		add x5, x5, 1
		sub x13, x13, 1
		sub x3,x3,1
		cbnz x3, CloudPosition

	NewCloud:
		sub x16, x16, 1
		add x15, x15, 420
		add x14, x14, 30
		cbnz x16, declareCloud


	setWindowInitialPos:
		mov x14, 430
		mov x15, 00
		mov x16, 2

	declareWindow:
		mov x4, x14 // Y
		mov x5, x15 // X
		mov x3, 40
		mov w10, 0x4969
		movk w10, 0x97, lsl 16
		mov x13, 120
	
WindowPosition:
		mov x1, x13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 

	setWindowPosition:
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6

	Window:	
		stur w10, [x0]
		add x0, x0, 8
		sub x1, x1, 1
		cmp x1, 0
		b.ge Window

	resetWindow:
		sub w10, w10, 0x00100
		sub x4, x4, 2
		add x5, x5, 1
		sub x3,x3,1
		cbnz x3, WindowPosition

	NewWindow:
		sub x16, x16, 1
		add x15, x15, 350
		cbnz x16, declareWindow
declareFaroLight:

		mov x4, 260 // Y
		mov x5, 375 // X
		mov x3, 175
		/* ESTO ES ANIMACION DEL ON/OFF. */
		cmp x29, 130
		b.ge faroOn
		cmp x29, 70
		b.ge faroOff
		cmp x29, 25
		b.ge faroOn
		cmp x29, 19
		b.ge faroOff
		cmp x29, 17
		b.ge faroOn
		cmp x29, 15
		b.ge faroOff
		cmp x29, 10
		b.ge faroOn
		faroOn:
			mov w10, 0x7282
			movk w10, 0x93, lsl 16
			b FaroLightPosition
		faroOff:
				mov w10, 0x11
		/* FIN ANIAMCION */
	FaroLightPosition:
		mov x1, 13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 

	setFaroLightPosition:
		// Move the framebuffer to an specific center to draw a road
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6

	FaroLight:	
		stur w10, [x0]
		add x0, x0, 8
		sub x1, x1, 1
		cmp x1, 0
		b.ge FaroLight
	
	resetFaroLight:
		sub x5, x5, 2
		sub x4,x4, 1
		sub x3,x3,1
		cbnz x3, FaroLightPosition

setFaroInitialPos:
		mov x14, 240
		mov x15, 25
		mov x16, 6
	declareFaro:
		mov x4, x14 // Y
		mov x5, x15 // X
		mov x3, 40

		mov w10, 0x0010
		movk w10, 0x18, lsl 16
		mov x13, 40
	
	FaroPosition:
		mov x1, x13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 

	setFaroPosition:
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6

	Faro:	
		stur w10, [x0]
		add x0, x0, 4
		cmp x0, 270
		sub x1, x1, 1
		cmp x1, 0
		b.ge Faro
	resetFaro:
		sub	 x4, x4, 1
		sub x3,x3,1
		cbnz x3, FaroPosition

setFaroInitialPos2:
		mov x14, 200
		mov x15, 25
		mov x16, 6
	declareFaro2:
		mov x4, x14 // Y
		mov x5, x15 // X
		mov x3, 40

		mov w10, 0x3232
		movk w10, 0x32, lsl 16
		mov x13, 40
	
	FaroPosition2:
		mov x1, x13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 

	setFaroPosition2:
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6

	Faro2:	
		stur w10, [x0]
		add x0, x0, 4
		cmp x0, 270
		sub x1, x1, 1
		cmp x1, 0
		b.ge Faro2
	resetFaro2:
		sub	 x4, x4, 1
		sub x3,x3,1
		cbnz x3, FaroPosition2

setFaroInitialPos3:
		mov x14, 160
		mov x15, 25
		mov x16, 6
	declareFaro3:
		mov x4, x14 // Y
		mov x5, x15 // X
		mov x3, 40

		mov w10, 0x0010
		movk w10, 0x24, lsl 16
		mov x13, 40
	
	FaroPosition3:
		mov x1, x13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 

	setFaroPosition3:
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6

	Faro3:	
		stur w10, [x0]
		add x0, x0, 4
		cmp x0, 270
		sub x1, x1, 1
		cmp x1, 0
		b.ge Faro3
	resetFaro3:
		sub	 x4, x4, 1
		add w10, w10, 0x1
		sub x3,x3,1
		cbnz x3, FaroPosition3

setFaroInitialPos4:
		mov x14, 120
		mov x15, 25
		mov x16, 6
	declareFaro4:
		mov x4, x14 // Y
		mov x5, x15 // X
		mov x3, 50

		mov w10, 0x3232
		movk w10, 0x32, lsl 16
		mov x13, 40
	
	FaroPosition4:
		mov x1, x13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 

	setFaroPosition4:
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6

	Faro4:	
		stur w10, [x0]
		add x0, x0, 4
		cmp x0, 270
		sub x1, x1, 1
		cmp x1, 0
		b.ge Faro4
	resetFaro4:
		sub	 x4, x4, 1
		add w10, w10, 0x1
		sub x3,x3,1
		cbnz x3, FaroPosition4

setFaroInitialPos5:					/*ROOF */
		mov x14, 70
		mov x15, 21
		mov x16, 6
	declareFaro5:
		mov x4, x14 // Y
		mov x5, x15 // X
		mov x3, 30
		mov x13, 50
	
	FaroPosition5:
		mov x1, x13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 

	setFaroPosition5:
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6

	Faro5:	
		stur w10, [x0]
		add x0, x0, 4
		cmp x0, 270
		sub x1, x1, 1
		cmp x1, 0
		b.ge Faro5
	resetFaro5:
		add w10, w10, 0x1
		sub	 x4, x4, 1
		add x5, x5, 1
		sub x13, x13, 2
		add w10, w10, 0x1
		sub x3,x3,1
		cbnz x3, FaroPosition5

setFaroDoorInitialPos:
		mov x14, 238
		mov x15, 40
	declareFaroDoor:
		mov x4, x14 // Y
		mov x5, x15 // X
		mov x3, 20
		mov x13, 10
		mov w10, 0x6050
		movk w10, 0x84, lsl 16
	
	FaroDoorPosition:
		mov x1, x13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 

	setFaroDoorPosition:
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6

	FaroDoor:	
		stur w10, [x0]
		add x0, x0, 4
		cmp x0, 270
		sub x1, x1, 1
		cmp x1, 0
		b.ge FaroDoor
	resetFaroDoor:
		add w10, w10, 0x4
		sub	 x4, x4, 1
		sub x3,x3,1
		cbnz x3, FaroDoorPosition

setFaroFocoInitialPos:
		mov x14, 102
		mov x15, 32
	declareFaroFoco:
		mov x4, x14 // Y
		mov x5, x15 // X
		mov x3, 23
		mov x13, 27
		mov w10, 0x6050
		movk w10, 0x84, lsl 16
	
	FaroFocoPosition:
		mov x1, x13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 

	setFaroFocoPosition:
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6

	FaroFoco:	
		stur w10, [x0]
		add x0, x0, 4
		cmp x0, 270
		sub x1, x1, 1
		cmp x1, 0
		b.ge FaroFoco
	resetFaroFoco:
		sub	 x4, x4, 1
		sub x3,x3,1
		cbnz x3, FaroFocoPosition

setFaroDecoInitialPos:
		mov x14, 115
		mov x15, 25
		mov x16, 2
	declareFaroDeco:
		mov x4, x14 // Y
		mov x5, x15 // X
		mov x3, 10
		mov x13, 40
		mov w10, 0x0010
		movk w10, 0x24, lsl 16
	
	FaroDecoPosition:
		mov x1, x13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 

	setFaroDecoPosition:
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6

	FaroDeco:	
		stur w10, [x0]
		add x0, x0, 4
		cmp x0, 270
		sub x1, x1, 1
		cmp x1, 0
		b.ge FaroDeco
	resetFaroDeco:
		add w10, w10, 0x4
		sub	 x4, x4, 1
		sub x3,x3,1
		cbnz x3, FaroDecoPosition
	NewFaroDeco:
		add x14, x14, 75
		sub x16, x16, 1
		cbnz x16, declareFaroDeco

setFaroDecoLInitialPos:
		mov x14, 135
		mov x15, 35
		mov x16, 2
	declareFaroDecoL:
		mov x4, x14 // Y
		mov x5, x15 // X
		mov x3, 15
		mov x13, 20
		mov w10, 0x5939
		movk w10, 0x6F, lsl 16
	
	FaroDecoLPosition:
		mov x1, x13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 

	setFaroDecoLPosition:
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6

	FaroDecoL:	
		stur w10, [x0]
		add x0, x0, 4
		cmp x0, 270
		sub x1, x1, 1
		cmp x1, 0
		b.ge FaroDecoL
	resetFaroDecoL:
		add	 x4, x4, 1
		sub x3,x3,1
		cbnz x3, FaroDecoLPosition
	NewFaroDecoL:
		add x14, x14, 43
		sub x16, x16, 1
		cbnz x16, declareFaroDecoL

setIslaInitialPos:
		mov x14, 252
		mov x15, 636
		mov x16, 10
	declareIsla:
		mov x4, x14 // Y
		mov x5, x15 // X
		mov x3, 16

		mov w10, 0x2320
		movk w10, 0x3A, lsl 16
		mov x13, 64
	
	IslaPosition:
		mov x1, x13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 

	setIslaPosition:
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6

	Isla:	
		stur w10, [x0]
		add x0, x0, 8
		sub x1, x1, 1
		cmp x1, 0
		b.ge Isla

	resetIsla:
		add w10, w10, 0x4
		sub	 x4, x4, 1
		sub x13, x13, 4
		cbz x13, NewIsla
		sub x3,x3,1
		cbnz x3, IslaPosition

	NewIsla:
		add x15, x15, 20
		sub x16,x16, 1
		cbnz x16, declareIsla



	/* FIRE (we just animate the color. So we dont need to modify the initial pos) */
	setFireInitialPos:
		mov x14, 299
		mov x15, 0
		mov x18, 43
		mov x16, x18
		mov x17, 1
		
		mov w10, 0x4645
		movk w10, 0x63, lsl 16
	
	declareFire:
		mov x4, x14 // Y
		mov x5, x15 // X
		mov x3,10
		mov x13, 20

	FirePosition:
		mov x1, x13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 

	setFirePosition:
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6

	Fire:	
		stur w10, [x0]
		add x0, x0, 4
		sub x1, x1, 1
		cmp x1, 0
		b.ge Fire

	resetFire:
		sub	 x4, x4, 1
		add x5, x5, 2
		sub x13, x13, 8
		cbz x13, NewFire
		sub x3,x3,1
		cbnz x3, FirePosition

	NewFire:
		add x15, x15, 15
		sub x16,x16, 1
		cbnz x16, declareFire

	CreateFire:
		mov x13, 20
		mul x19, x13, x18
		sub x15, x15, x19
		cmp x18, 2
		b.eq exec
		b.ne move
		move:
			add x15, x15, 10
		exec:
			add x15, x15, 10
			lsr x18, x18, 1
			cbz x18, setPuchoInitialPos
			mov x16, x18
			sub x17, x17, 1
			cbnz x17, declareFire


setPuchoInitialPos:
		mov x14, 470
		mov x15, 378
	declarePucho:
		mov x4, x14 // Y
		mov x5, x15 // X
		mov x3, 100

		mov w10, 0xFFFF
		movk w10, 0xFF, lsl 16
		mov x13, 20
	
	PuchoPosition:
		mov x1, x13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 

	setPuchoPosition:
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6

	Pucho:	
		stur w10, [x0]
		add x0, x0, 8
		cmp x0, 270
		sub x1, x1, 1
		cmp x1, 0
		b.ge Pucho
	resetPucho:
		sub	 x4, x4, 1
		sub x3,x3,1
		cbnz x3, PuchoPosition

setPuchoFuegoInitialPos:
		mov x14, 370
		mov x15, 378
		mov x3, x25
	declarePuchoFuego:
		mov x4, x14 // Y
		mov x5, x15 // X

		mov w10, 0x0000
		movk w10, 0xFF, lsl 16
		mov x13, 40
	
	PuchoFuegoPosition:
		mov x1, x13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 

	setPuchoFuegoPosition:
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6

	PuchoFuego:
		stur w10, [x0]
		add x0, x0, 4
		cmp x0, 270
		sub x1, x1, 1
		cmp x1, 0
		b.ge PuchoFuego
	resetPuchoFuego:
		add	 x4, x4, 1
		sub x3,x3,1
		cbnz x3, PuchoFuegoPosition

setStoneInitialPos:
		mov x14, 480
		mov x15, 300
		mov x16, 4
	declareStone:
		mov x4, x14 // Y
		mov x5, x15 // X
		mov x3, 40

		mov w10, 0x4740
		movk w10, 0x6D, lsl 16
		mov x13, 150
	
	StonePosition:
		mov x1, x13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 

	setStonePosition:
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6

	Stone:
		stur w10, [x0]
		add x0, x0, 4
		sub x1, x1, 1
		cmp x1, 0
		b.ge Stone

	resetStone:
		sub	 x4, x4, 1
		add x5, x5, 2
		sub x13, x13, 4
		cbz x13, NewStone
		sub x3,x3,1
		cbnz x3, StonePosition

	NewStone:
		add x15, x15, 50
		sub x16,x16, 1
		cbnz x16, declareStone

renderAnimatedObjects:
	/*BOAT */
	declareBoat:
		mov x4, x27 // Y
		mov x5, x23 // X
		mov x3, 8
		mov x16, x24

			mov w10, 0x4222
			movk w10, 0x47, lsl 16

	BoatPosition:
		mov x1, x16
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 
	setBoatPosition:
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6
	Boat:
		stur w10, [x0]
		sub x0, x0, 4
		sub x1, x1, 1
		cmp x1, 0
		b.ge Boat
	resetBoat:
		add x4, x4, 1
		sub x16, x16, 1
		sub x3,x3,1
		cbnz x3, BoatPosition


	/*SMOKE */
	declareSmoke:
		mov x4, x21 // Y
		mov x5, x22 // X
		mov x3, 10
		mov w10, 0xFFFF
		movk w10, 0xFF, lsl 16
		mov x13, 50
	SmokePosition:
		mov x1, x13
		mov x0, x20
		mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
		mov x7, x4			// Y Navevalue
		mov x8, x5			// X Navevalue
		mov x9, SCREEN_WIDTH 
	setSmokePosition:
		madd x6, x7, x9, x8
		lsl x6, x6, 2
		add x0, x20, x6
	Smoke:	
		stur w10, [x0]
		add x0, x0, 16
		sub x1, x1, 20	
		cmp x1, 0
		b.ge Smoke
	resetSmoke:
		sub	 x4, x4, 2
		add x5, x5, 1
		add x13, x13, 2
		sub x3,x3,1
		cbnz x3, SmokePosition
	NewSmoke:
		sub x12,x12, 1					/*Resta y en el siguiente le hago esas add y sub arriba */
		cbnz x12, resetAnimation
	resetSmokeInitialPosition:
		mov x21, START_POSITIION_SMOKE_Y
		mov x22, START_POSITIION_SMOKE_X
		mov x12, 3

resetAnimation:
	mov x14, 0xFFFFFFF
	counter:
		sub x14, x14, 2
		cmp x14, xzr
		b.ge counter
	resetPositions:

		cmp x29, 150
		b.ge skip
		cmp x29, 120
		b.ge consume
		cmp x29, 90
		b.ge skip
		cmp x29, 70
		b.ge consume
		cmp x25, 20
		b.ge skip

		consume:
			add x25,x25, 1
		skip:
			mov x26, x25
			/*SMOKE */
			add x22, x22, 20
			sub x21,x21, 10
			/* FARO */
			add x29,x29,1
			cmp x29, 200
			b.eq declareWakeUp
			/*boat */
			cmp x29, 180
			b.ge firstMove
			cmp x24, 34
			b.lo expandBoat
			b.ge moveBoat

			firstMove:
				sub x24, x24, 4
				sub x23,x23,4
				sub x27, x27, 1
				B reset
			expandBoat:
				add x24, x24, 4
				add x27,x27,1
				B reset
			moveBoat:
				sub x23, x23, 3
				B reset


declareWakeUp:
	mov x4, 500 // Y
	mov x5, 400 // X
	mov x3, 1
	mov x1, x3

WakeUpPosition:
	mov x0, x20
	mov x6, xzr			// We are gonna use the x6 variable to calculate the direction of the framebuffer
	mov x7, x4			// Y Navevalue
	mov x8, x5			// X Navevalue
	mov x9, SCREEN_WIDTH 

setWakeUpPosition:
	madd x6, x7, x9, x8
	lsl x6, x6, 2
	add x0, x20, x6

WakeUp:
	stur x12,[x0]
	add x0, x0, 4
	sub x12, x12, 200
	sub x1, x1, 1
	cmp x1, 0
	b.ge WakeUp

	add x3, x3, 2
	mov x1, x3

	sub x5, x5, 4           // ITERATES TO INFINITY TO CREATE THE  WAKEUP EFECT
	b WakeUpPosition		// And a beutiful pattern too!
exit:
