!classDefinition: #MarsRoverTest category: 'MarsRoverExercise'!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!MarsRoverTest methodsFor: 'assertions' stamp: 'AG 5/13/2023 17:40:40'!
assertRoverRotatesLeftFrom: anInitialDirection to: aDirectionToRotate
	| rover |
	rover := MarsRover inPosition: 0@0 atDirection: anInitialDirection.
	
	rover commands: 'l'.
	
	self assert: rover position equals: 0@0.
	self assert: rover direction equals: aDirectionToRotate.! !

!MarsRoverTest methodsFor: 'assertions' stamp: 'AG 5/13/2023 17:40:00'!
assertRoverRotatesRightFrom: aDirection to: aDirectionToRotate
	| rover |
	rover := MarsRover inPosition: 0@0 atDirection: aDirection.
	
	rover commands: 'r'.
	
	self assert: rover position equals: 0@0.
	self assert: rover direction equals: aDirectionToRotate.! !


!MarsRoverTest methodsFor: 'mars rover' stamp: 'AG 5/15/2023 14:05:03'!
marsRoverAtOriginFacingEast

	^ MarsRover inPosition: 0@0 atDirection: #Este! !

!MarsRoverTest methodsFor: 'mars rover' stamp: 'AG 5/15/2023 13:47:46'!
marsRoverAtOriginFacingNorth

	^ MarsRover inPosition: 0@0 atDirection: #Norte! !

!MarsRoverTest methodsFor: 'mars rover' stamp: 'AG 5/15/2023 14:04:42'!
marsRoverAtOriginFacingSouth

	^ MarsRover inPosition: 0@0 atDirection: #Sur! !

!MarsRoverTest methodsFor: 'mars rover' stamp: 'AG 5/15/2023 14:03:50'!
marsRoverAtOriginFacingWest

	^ MarsRover inPosition: 0@0 atDirection: #Oeste! !


!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/15/2023 13:47:46'!
test01MarsRoverCreationHasInitialPositionAndDirection

	| rover |
	rover := self marsRoverAtOriginFacingNorth.
	
	self assert: rover position equals: 0@0.
	self assert: rover direction equals: #Norte.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/15/2023 14:02:23'!
test02EmptyComandsShouldNotMove

	| rover |
	rover := self marsRoverAtOriginFacingNorth.
	
	rover commands: ''.
	
	self assert: rover position equals: 0@0.
	self assert: rover direction equals: #Norte.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/15/2023 13:47:46'!
test03MoveFowardNorthChangesYPosition

	| rover |
	rover := self marsRoverAtOriginFacingNorth.
	
	rover commands: 'f'.
	
	self assert: rover position equals: 0@1.
	! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/15/2023 13:47:46'!
test04MoveBackwardFacingNorthSubstractsOneYPosition

	| rover |
	rover := self marsRoverAtOriginFacingNorth.
	
	rover commands: 'b'.
	
	self assert: rover position equals: 0@-1.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/13/2023 17:41:43'!
test05CommandLeftRotateFromNorteDirectionShouldChangeToOeste

	self assertRoverRotatesLeftFrom: #Norte to: #Oeste. ! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/13/2023 17:42:12'!
test06CommandLeftRotateFromSurDirectionShouldChangeToEste

	self assertRoverRotatesLeftFrom: #Sur to: #Este.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/13/2023 17:42:29'!
test07CommandLeftRotateFromOesteDirectionShouldChangeToSur

	self assertRoverRotatesLeftFrom: #Oeste to: #Sur.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/13/2023 17:42:50'!
test08CommandLeftRotateFromEsteDirectionShouldChangeToNorte

	self assertRoverRotatesLeftFrom: #Este to: #Norte.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/13/2023 17:43:23'!
test09CommandRightRotateFromEsteDirectionShouldChangeToSur

	self assertRoverRotatesRightFrom: #Este to: #Sur. ! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/13/2023 17:43:42'!
test10CommandRightRotateFromSurDirectionShouldChangeToOeste

	self assertRoverRotatesRightFrom: #Sur to: #Oeste. ! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/13/2023 17:43:57'!
test11CommandRightRotateFromOesteDirectionShouldChangeToNorte

	self assertRoverRotatesRightFrom: #Oeste to: #Norte. ! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/13/2023 17:44:14'!
test12CommandRightRotateFromNorteDirectionShouldChangeToEste

		self assertRoverRotatesRightFrom: #Norte to: #Este. ! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/15/2023 13:47:46'!
test13TwoCommandRightShouldRotateRightTwice

	| rover |
	rover := self marsRoverAtOriginFacingNorth.
	
	rover commands: 'rr'.
	
	self assert: rover position equals: 0@0.
	self assert: rover direction equals: #Sur.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/15/2023 13:47:46'!
test14ManyCommandsRightShouldRotateRightManyTimes

	| rover |
	rover := self marsRoverAtOriginFacingNorth.
	
	rover commands: 'rrr'.
	
	self assert: rover position equals: 0@0.
	self assert: rover direction equals: #Oeste.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/15/2023 13:47:46'!
test15ManyCommandsLeftShouldRotateLeftManyTimes

	| rover |
	rover := self marsRoverAtOriginFacingNorth.
	
	rover commands: 'lll'.
	
	self assert: rover position equals: 0@0.
	self assert: rover direction equals: #Este.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/15/2023 14:04:42'!
test16CommandForwardFacingSurReduceOneYPosition

	| rover |
	rover := self marsRoverAtOriginFacingSouth.
	
	rover commands: 'f'.
	
	self assert: rover position equals: 0@-1.
	self assert: rover direction equals: #Sur.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/15/2023 14:03:50'!
test17CommandForwardFacingOesteReduceOneXPosition

	| rover |
	rover := self marsRoverAtOriginFacingWest.
	
	rover commands: 'f'.
	
	self assert: rover position equals: -1@0.
	self assert: rover direction equals: #Oeste.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/15/2023 14:05:03'!
test18CommandForwardFacingEsteIncrementOneXPosition

	| rover |
	rover := self marsRoverAtOriginFacingEast.
	
	rover commands: 'f'.
	
	self assert: rover position equals: 1@0.
	self assert: rover direction equals: #Este.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/15/2023 14:05:04'!
test19CommandBackwardFacingEsteReduceOneXPosition

	| rover |
	rover := self marsRoverAtOriginFacingEast.
	
	rover commands: 'b'.
	
	self assert: rover position equals: -1@0.
	self assert: rover direction equals: #Este.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/15/2023 14:04:42'!
test20CommandBackwardFacingSurIncrementsOneYPosition

	| rover |
	rover := self marsRoverAtOriginFacingSouth.
	
	rover commands: 'b'.
	
	self assert: rover position equals: 0@1.
	self assert: rover direction equals: #Sur.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/15/2023 14:03:50'!
test21CommandBackwardFacingOesteIncrementsOneXPosition

	| rover |
	rover := self marsRoverAtOriginFacingWest.
	
	rover commands: 'b'.
	
	self assert: rover position equals: 1@0.
	self assert: rover direction equals: #Oeste.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/15/2023 14:03:50'!
test22ManyCommandsBackwardsShouldMoveBackwardsManyTimes

	| rover |
	rover := self marsRoverAtOriginFacingWest.
	
	rover commands: 'bbb'.
	
	self assert: rover position equals: 3@0.
	self assert: rover direction equals: #Oeste.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/15/2023 14:03:50'!
test23ManyCommandsForwardsShouldMoveForwardManyTimes

	| rover |
	rover := self marsRoverAtOriginFacingWest.
	
	rover commands: 'fff'.
	
	self assert: rover position equals: -3@0.
	self assert: rover direction equals: #Oeste.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/15/2023 14:03:50'!
test24RoverCanHandleManyDifferentsCommands

	| rover |
	rover := self marsRoverAtOriginFacingWest.
	
	rover commands: 'ffbl'.
	
	self assert: rover position equals: -1@0.
	self assert: rover direction equals: #Sur.! !

!MarsRoverTest methodsFor: 'testing' stamp: 'AG 5/15/2023 14:03:50'!
test25IncorrectCommandShouldRaiseException

	| rover |
	rover := self marsRoverAtOriginFacingWest.
	
	
	self should: [rover commands: 'ffbltf'.]
		raise: Error
		withExceptionDo: [:error| self assert: Command invalidCommandErrorDescription 
			equals: 
				error messageText.] ! !


!classDefinition: #Command category: 'MarsRoverExercise'!
Object subclass: #Command
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!Command methodsFor: 'execution' stamp: 'AG 5/15/2023 13:24:52'!
executeIn: aMarsRover

	self subclassResponsibility .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Command class' category: 'MarsRoverExercise'!
Command class
	instanceVariableNames: ''!

!Command class methodsFor: 'instance creation' stamp: 'AG 5/15/2023 13:45:36'!
with: aCharacter

	^(self subclasses detect: [:aCommandClass | aCommandClass canHandle: aCharacter ] ifNone:[self error: self invalidCommandErrorDescription ]) new.! !


!Command class methodsFor: 'command selection' stamp: 'AG 5/15/2023 13:19:19'!
canHandle: aCharacter

	self subclassResponsibility .! !


!Command class methodsFor: 'error description' stamp: 'AG 5/15/2023 13:45:02'!
invalidCommandErrorDescription
	^'comando erróneo!!!!'! !


!classDefinition: #MoveBackward category: 'MarsRoverExercise'!
Command subclass: #MoveBackward
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!MoveBackward methodsFor: 'execution' stamp: 'AG 5/15/2023 13:24:52'!
executeIn: aMarsRover

	aMarsRover moveBackward ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MoveBackward class' category: 'MarsRoverExercise'!
MoveBackward class
	instanceVariableNames: ''!

!MoveBackward class methodsFor: 'command selection' stamp: 'AG 5/15/2023 13:19:35'!
canHandle: aCharacter

	^aCharacter = $b.! !


!classDefinition: #MoveForward category: 'MarsRoverExercise'!
Command subclass: #MoveForward
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!MoveForward methodsFor: 'execution' stamp: 'AG 5/15/2023 13:24:53'!
executeIn: aMarsRover

	aMarsRover moveForward ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MoveForward class' category: 'MarsRoverExercise'!
MoveForward class
	instanceVariableNames: ''!

!MoveForward class methodsFor: 'command selection' stamp: 'AG 5/15/2023 13:19:53'!
canHandle: aCharacter

	^aCharacter = $f.! !


!classDefinition: #RotateLeft category: 'MarsRoverExercise'!
Command subclass: #RotateLeft
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!RotateLeft methodsFor: 'execution' stamp: 'AG 5/15/2023 13:24:53'!
executeIn: aMarsRover

	aMarsRover rotateLeft .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RotateLeft class' category: 'MarsRoverExercise'!
RotateLeft class
	instanceVariableNames: ''!

!RotateLeft class methodsFor: 'command selection' stamp: 'AG 5/15/2023 13:20:09'!
canHandle: aCharacter

	^aCharacter = $l.! !


!classDefinition: #RotateRight category: 'MarsRoverExercise'!
Command subclass: #RotateRight
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!RotateRight methodsFor: 'execution' stamp: 'AG 5/15/2023 13:24:53'!
executeIn: aMarsRover

	aMarsRover rotateRight . ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RotateRight class' category: 'MarsRoverExercise'!
RotateRight class
	instanceVariableNames: ''!

!RotateRight class methodsFor: 'command selection' stamp: 'AG 5/15/2023 13:20:16'!
canHandle: aCharacter

	^aCharacter = $r! !


!classDefinition: #MarsRover category: 'MarsRoverExercise'!
Object subclass: #MarsRover
	instanceVariableNames: 'initialPosition initialDirection position state'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!MarsRover methodsFor: 'initialization' stamp: 'AG 5/13/2023 18:37:09'!
initializeInPosition: anInitialPosition atDirection: aInitialDirection 
	
	position := anInitialPosition .
	state := MarsRoverState stateFor: aInitialDirection .! !


!MarsRover methodsFor: 'command' stamp: 'AG 5/15/2023 13:25:42'!
commands: aStringOfCommands 

	aStringOfCommands do:[:character| |command| 
		
		command := Command with: character. 
		command executeIn: self.].! !


!MarsRover methodsFor: 'accessing' stamp: 'AG 5/13/2023 18:39:57'!
direction
	^state direction.! !

!MarsRover methodsFor: 'accessing' stamp: 'AG 5/13/2023 13:18:18'!
position
	^position.! !


!MarsRover methodsFor: 'command private' stamp: 'AG 5/15/2023 14:06:16'!
moveBackward
	
	state moveMarsRoverBackward: self.
! !

!MarsRover methodsFor: 'command private' stamp: 'AG 5/14/2023 11:21:33'!
moveBackwardFacingEste

				position := position + (-1@0).
	! !

!MarsRover methodsFor: 'command private' stamp: 'AG 5/14/2023 11:22:51'!
moveBackwardFacingNorte

				position := position + (0@-1)
	! !

!MarsRover methodsFor: 'command private' stamp: 'AG 5/14/2023 11:22:07'!
moveBackwardFacingOeste

				position := position + (1@0)
	! !

!MarsRover methodsFor: 'command private' stamp: 'AG 5/14/2023 11:22:33'!
moveBackwardFacingSur

				position := position + (0@1)
	! !

!MarsRover methodsFor: 'command private' stamp: 'AG 5/15/2023 14:06:24'!
moveForward

	state moveMarsRoverForward: self.
! !

!MarsRover methodsFor: 'command private' stamp: 'AG 5/14/2023 11:30:28'!
moveForwardFacingEste

				

		position := position + (1@0)! !

!MarsRover methodsFor: 'command private' stamp: 'AG 5/14/2023 11:30:18'!
moveForwardFacingNorte

		position := position + (0@1).! !

!MarsRover methodsFor: 'command private' stamp: 'AG 5/14/2023 11:30:41'!
moveForwardFacingOeste

				

		position := position + (-1@0)! !

!MarsRover methodsFor: 'command private' stamp: 'AG 5/14/2023 11:30:49'!
moveForwardFacingSur

				

		position := position + (0@-1)! !

!MarsRover methodsFor: 'command private' stamp: 'AG 5/15/2023 14:06:32'!
rotateLeft
	
	state rotateMarsRoverLeft: self.! !

!MarsRover methodsFor: 'command private' stamp: 'AG 5/13/2023 18:54:18'!
rotateLeftFromEste

	state := MarsRoverState stateFor: #Norte.! !

!MarsRover methodsFor: 'command private' stamp: 'AG 5/14/2023 10:38:28'!
rotateLeftFromNorte
	
	state := MarsRoverState stateFor: #Oeste.! !

!MarsRover methodsFor: 'command private' stamp: 'AG 5/14/2023 10:39:17'!
rotateLeftFromOeste
	
	state := MarsRoverState stateFor: #Sur.! !

!MarsRover methodsFor: 'command private' stamp: 'AG 5/14/2023 10:39:31'!
rotateLeftFromSur
	
	state := MarsRoverState stateFor: #Este.! !

!MarsRover methodsFor: 'command private' stamp: 'AG 5/14/2023 10:47:15'!
rotateRight
	state rotateMarsRoverRight: self.
! !

!MarsRover methodsFor: 'command private' stamp: 'AG 5/14/2023 10:45:33'!
rotateRightFromEste

	state := MarsRoverState stateFor: #Sur.! !

!MarsRover methodsFor: 'command private' stamp: 'AG 5/14/2023 10:45:44'!
rotateRightFromNorte

	state := MarsRoverState stateFor: #Este.! !

!MarsRover methodsFor: 'command private' stamp: 'AG 5/14/2023 10:45:57'!
rotateRightFromOeste

	state := MarsRoverState stateFor: #Norte.! !

!MarsRover methodsFor: 'command private' stamp: 'AG 5/14/2023 10:46:10'!
rotateRightFromSur

	state := MarsRoverState stateFor: #Oeste.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRoverExercise'!
MarsRover class
	instanceVariableNames: ''!

!MarsRover class methodsFor: 'instance creation' stamp: 'AG 5/13/2023 13:06:54'!
inPosition: anInitialPosition atDirection: aInitialDirection 
	
	^self new initializeInPosition: anInitialPosition atDirection: 	aInitialDirection ! !


!classDefinition: #MarsRoverState category: 'MarsRoverExercise'!
Object subclass: #MarsRoverState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!MarsRoverState methodsFor: 'actions' stamp: 'AG 5/15/2023 13:52:10'!
moveMarsRoverBackward: aMarsRover

	self subclassResponsibility .! !

!MarsRoverState methodsFor: 'actions' stamp: 'AG 5/15/2023 13:52:19'!
moveMarsRoverForward: aMarsRover

	self subclassResponsibility .! !

!MarsRoverState methodsFor: 'actions' stamp: 'AG 5/15/2023 13:52:40'!
rotateMarsRoverLeft: aMarsRover

	self subclassResponsibility .! !

!MarsRoverState methodsFor: 'actions' stamp: 'AG 5/15/2023 13:52:52'!
rotateMarsRoverRight: aMarsRover

	self subclassResponsibility .! !


!MarsRoverState methodsFor: 'direction' stamp: 'AG 5/13/2023 18:40:09'!
direction
	self subclassResponsibility .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverState class' category: 'MarsRoverExercise'!
MarsRoverState class
	instanceVariableNames: ''!

!MarsRoverState class methodsFor: 'instance creation' stamp: 'AG 5/13/2023 18:40:52'!
stateFor: aDirection
	^(self subclasses detect: [:aMarsRoverStateClass | aMarsRoverStateClass canHandle: aDirection ]) new.
	! !


!MarsRoverState class methodsFor: 'state selection' stamp: 'AG 5/13/2023 18:34:39'!
canHandle: aDirection
	self subclassResponsibility .! !


!classDefinition: #MarsRoverEste category: 'MarsRoverExercise'!
MarsRoverState subclass: #MarsRoverEste
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!MarsRoverEste methodsFor: 'direction' stamp: 'AG 5/13/2023 18:41:27'!
direction
	^#Este.! !


!MarsRoverEste methodsFor: 'actions' stamp: 'AG 5/14/2023 11:14:07'!
moveMarsRoverBackward: aMarsRover

	aMarsRover moveBackwardFacingEste.! !

!MarsRoverEste methodsFor: 'actions' stamp: 'AG 5/14/2023 11:27:19'!
moveMarsRoverForward: aMarsRover

	aMarsRover moveForwardFacingEste.! !

!MarsRoverEste methodsFor: 'actions' stamp: 'AG 5/13/2023 18:46:12'!
rotateMarsRoverLeft: aMarsRover
	^aMarsRover rotateLeftFromEste.! !

!MarsRoverEste methodsFor: 'actions' stamp: 'AG 5/14/2023 10:44:21'!
rotateMarsRoverRight: aMarsRover
	^aMarsRover rotateRightFromEste.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverEste class' category: 'MarsRoverExercise'!
MarsRoverEste class
	instanceVariableNames: ''!

!MarsRoverEste class methodsFor: 'state selection' stamp: 'AG 5/13/2023 18:35:44'!
canHandle: aDirection

	^aDirection = #Este.! !


!classDefinition: #MarsRoverNorte category: 'MarsRoverExercise'!
MarsRoverState subclass: #MarsRoverNorte
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!MarsRoverNorte methodsFor: 'direction' stamp: 'AG 5/13/2023 18:42:01'!
direction
	^#Norte.! !


!MarsRoverNorte methodsFor: 'actions' stamp: 'AG 5/14/2023 11:14:23'!
moveMarsRoverBackward: aMarsRover

	aMarsRover moveBackwardFacingNorte.! !

!MarsRoverNorte methodsFor: 'actions' stamp: 'AG 5/14/2023 11:27:31'!
moveMarsRoverForward: aMarsRover

	aMarsRover moveForwardFacingNorte.! !

!MarsRoverNorte methodsFor: 'actions' stamp: 'AG 5/14/2023 10:37:37'!
rotateMarsRoverLeft: aMarsRover
	^aMarsRover rotateLeftFromNorte.! !

!MarsRoverNorte methodsFor: 'actions' stamp: 'AG 5/14/2023 10:44:36'!
rotateMarsRoverRight: aMarsRover
	^aMarsRover rotateRightFromNorte.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverNorte class' category: 'MarsRoverExercise'!
MarsRoverNorte class
	instanceVariableNames: ''!

!MarsRoverNorte class methodsFor: 'state selection' stamp: 'AG 5/13/2023 18:35:55'!
canHandle: aDirection

	^aDirection = #Norte.! !


!classDefinition: #MarsRoverOeste category: 'MarsRoverExercise'!
MarsRoverState subclass: #MarsRoverOeste
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!MarsRoverOeste methodsFor: 'direction' stamp: 'AG 5/13/2023 18:42:48'!
direction
	^#Oeste! !


!MarsRoverOeste methodsFor: 'actions' stamp: 'AG 5/14/2023 11:14:39'!
moveMarsRoverBackward: aMarsRover

	aMarsRover moveBackwardFacingOeste.! !

!MarsRoverOeste methodsFor: 'actions' stamp: 'AG 5/14/2023 11:27:43'!
moveMarsRoverForward: aMarsRover

	aMarsRover moveForwardFacingOeste.! !

!MarsRoverOeste methodsFor: 'actions' stamp: 'AG 5/14/2023 10:38:55'!
rotateMarsRoverLeft: aMarsRover
	aMarsRover rotateLeftFromOeste! !

!MarsRoverOeste methodsFor: 'actions' stamp: 'AG 5/14/2023 10:44:54'!
rotateMarsRoverRight: aMarsRover
	^aMarsRover rotateRightFromOeste.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverOeste class' category: 'MarsRoverExercise'!
MarsRoverOeste class
	instanceVariableNames: ''!

!MarsRoverOeste class methodsFor: 'state selection' stamp: 'AG 5/13/2023 18:36:05'!
canHandle: aDirection

	^aDirection = #Oeste.! !


!classDefinition: #MarsRoverSur category: 'MarsRoverExercise'!
MarsRoverState subclass: #MarsRoverSur
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRoverExercise'!

!MarsRoverSur methodsFor: 'direction' stamp: 'AG 5/13/2023 18:43:00'!
direction
	^#Sur.! !


!MarsRoverSur methodsFor: 'actions' stamp: 'AG 5/14/2023 11:14:57'!
moveMarsRoverBackward: aMarsRover

	aMarsRover moveBackwardFacingSur.! !

!MarsRoverSur methodsFor: 'actions' stamp: 'AG 5/14/2023 11:27:52'!
moveMarsRoverForward: aMarsRover

	aMarsRover moveForwardFacingSur.! !

!MarsRoverSur methodsFor: 'actions' stamp: 'AG 5/14/2023 10:39:48'!
rotateMarsRoverLeft: aMarsRover
	aMarsRover rotateLeftFromSur ! !

!MarsRoverSur methodsFor: 'actions' stamp: 'AG 5/14/2023 10:45:13'!
rotateMarsRoverRight: aMarsRover
	aMarsRover rotateRightFromSur.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverSur class' category: 'MarsRoverExercise'!
MarsRoverSur class
	instanceVariableNames: ''!

!MarsRoverSur class methodsFor: 'state selection' stamp: 'AG 5/13/2023 18:36:13'!
canHandle: aDirection

	^aDirection = #Sur.! !
