!classDefinition: #MarsRover category: 'MarsRover-WithHeading'!
Object subclass: #MarsRover
	instanceVariableNames: 'position head observers manager'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRover methodsFor: 'exceptions' stamp: 'AG 6/3/2023 10:42:59'!
invalidCommandErrorDescription
	
	^'Invalid command'! !

!MarsRover methodsFor: 'exceptions' stamp: 'AG 6/3/2023 10:42:59'!
signalInvalidCommand
	
	self error: self invalidCommandErrorDescription ! !


!MarsRover methodsFor: 'initialization' stamp: 'AG 6/3/2023 18:09:27'!
initializeAt: aPosition heading: aHeadingType

	position := aPosition.
	head := aHeadingType for: self .
	manager := MarsRoverEventManager  for: self.
	! !


!MarsRover methodsFor: 'heading' stamp: 'AG 6/3/2023 13:07:23'!
headEast
	
	head := MarsRoverHeadingEast for: self.
	manager logNewHeadingEast.! !

!MarsRover methodsFor: 'heading' stamp: 'AG 6/3/2023 13:07:35'!
headNorth
	
	head := MarsRoverHeadingNorth for: self .
	manager logNewHeadingNorth.! !

!MarsRover methodsFor: 'heading' stamp: 'AG 6/3/2023 13:07:44'!
headSouth
	
	head := MarsRoverHeadingSouth for: self.
	manager logNewHeadingSouth.! !

!MarsRover methodsFor: 'heading' stamp: 'AG 6/3/2023 13:07:51'!
headWest
	
	head := MarsRoverHeadingWest for: self .
	manager logNewHeadingWest.! !

!MarsRover methodsFor: 'heading' stamp: 'AG 6/3/2023 10:42:59'!
rotateLeft
	
	head rotateLeft! !

!MarsRover methodsFor: 'heading' stamp: 'AG 6/3/2023 10:42:59'!
rotateRight
	
	head rotateRight! !


!MarsRover methodsFor: 'testing' stamp: 'AG 6/3/2023 10:42:59'!
isAt: aPosition heading: aHeadingType

	^position = aPosition and: [ head isHeading: aHeadingType ]! !

!MarsRover methodsFor: 'testing' stamp: 'AG 6/3/2023 10:42:59'!
isBackwardCommand: aCommand

	^aCommand = $b! !

!MarsRover methodsFor: 'testing' stamp: 'AG 6/3/2023 10:42:59'!
isForwardCommand: aCommand

	^aCommand = $f ! !

!MarsRover methodsFor: 'testing' stamp: 'AG 6/3/2023 10:42:59'!
isRotateLeftCommand: aCommand

	^aCommand = $l! !

!MarsRover methodsFor: 'testing' stamp: 'AG 6/3/2023 10:42:59'!
isRotateRightCommand: aCommand

	^aCommand = $r! !


!MarsRover methodsFor: 'moving' stamp: 'AG 6/3/2023 10:42:58'!
moveBackward
	
	head moveBackward! !

!MarsRover methodsFor: 'moving' stamp: 'AG 6/3/2023 13:06:43'!
moveEast
	
	position := position + (1@0).
	manager logNewPosition: position.! !

!MarsRover methodsFor: 'moving' stamp: 'AG 6/3/2023 10:42:59'!
moveForward
	
	head moveForward! !

!MarsRover methodsFor: 'moving' stamp: 'AG 6/3/2023 13:06:18'!
moveNorth
	
	position := position + (0@1).
	manager logNewPosition: position.! !

!MarsRover methodsFor: 'moving' stamp: 'AG 6/3/2023 13:06:33'!
moveSouth
	
	position := position + (0@-1).
	manager logNewPosition: position.! !

!MarsRover methodsFor: 'moving' stamp: 'AG 6/3/2023 13:06:38'!
moveWest
	
	position := position + (-1@0).
	manager logNewPosition: position.! !


!MarsRover methodsFor: 'command processing' stamp: 'AG 6/3/2023 10:42:59'!
process: aSequenceOfCommands

	aSequenceOfCommands do: [:aCommand | self processCommand: aCommand ]
! !

!MarsRover methodsFor: 'command processing' stamp: 'AG 6/3/2023 10:42:59'!
processCommand: aCommand

	(self isForwardCommand: aCommand) ifTrue: [ ^ self moveForward ].
	(self isBackwardCommand: aCommand) ifTrue: [ ^ self moveBackward ].
	(self isRotateRightCommand: aCommand) ifTrue: [ ^ self rotateRight ].
	(self isRotateLeftCommand: aCommand) ifTrue: [ ^ self rotateLeft ].

	self signalInvalidCommand.! !


!MarsRover methodsFor: 'manager' stamp: 'mp 6/3/2023 13:35:45'!
manager
	^manager! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRover-WithHeading'!
MarsRover class
	instanceVariableNames: 'headings'!

!MarsRover class methodsFor: 'instance creation' stamp: 'AG 6/3/2023 10:42:59'!
at: aPosition heading: aHeadingType
	
	^self new initializeAt: aPosition heading: aHeadingType! !


!classDefinition: #MarsRoverEventManager category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverEventManager
	instanceVariableNames: 'observers marsRover'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverEventManager methodsFor: 'initialization' stamp: 'AG 6/3/2023 13:09:13'!
initializeFor: aMarsRover

	observers := OrderedCollection new.
	marsRover := aMarsRover ! !


!MarsRoverEventManager methodsFor: 'heading' stamp: 'AG 6/3/2023 13:11:06'!
logNewHeadingEast

	observers do:[:anObserver| 
		
		[anObserver logNewHeadingEast] 
		on: Error
			do:[] 
			].! !

!MarsRoverEventManager methodsFor: 'heading' stamp: 'AG 6/3/2023 13:22:55'!
logNewHeadingNorth

	observers do:[:anObserver| 
	
		anObserver logNewHeadingNorth
			].! !

!MarsRoverEventManager methodsFor: 'heading' stamp: 'AG 6/3/2023 13:11:17'!
logNewHeadingSouth

	observers do:[:anObserver| 
		
		[anObserver logNewHeadingSouth] 
		on: Error
			do:[] 
			].! !

!MarsRoverEventManager methodsFor: 'heading' stamp: 'AG 6/3/2023 13:10:11'!
logNewHeadingWest

	observers do:[:anObserver| 
		
		[anObserver logNewHeadingWest] 
		on: Error
			do:[] 
			].! !


!MarsRoverEventManager methodsFor: 'position' stamp: 'mp 6/3/2023 13:29:40'!
logNewPosition: aPosition

	observers do:[:anObserver| 		anObserver logNewPosition: aPosition].
	! !


!MarsRoverEventManager methodsFor: 'observer' stamp: 'AG 6/3/2023 13:09:13'!
addObserver: anObserver

	observers add: anObserver.
	
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverEventManager class' category: 'MarsRover-WithHeading'!
MarsRoverEventManager class
	instanceVariableNames: ''!

!MarsRoverEventManager class methodsFor: 'as yet unclassified' stamp: 'AG 6/3/2023 13:04:40'!
for: aMarsRover

	^self new initializeFor: aMarsRover .! !


!classDefinition: #MarsRoverHeading category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverHeading
	instanceVariableNames: 'marsRover'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeading methodsFor: 'heading' stamp: 'AG 6/3/2023 10:42:59'!
rotateLeft

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'AG 6/3/2023 10:42:59'!
rotateRight

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'testing' stamp: 'AG 6/3/2023 10:42:59'!
isHeading: aHeadingType

	^self isKindOf: aHeadingType ! !


!MarsRoverHeading methodsFor: 'moving' stamp: 'AG 6/3/2023 10:42:59'!
moveBackward

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'moving' stamp: 'AG 6/3/2023 10:42:59'!
moveForward

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'initialization' stamp: 'AG 6/3/2023 10:42:59'!
initializeFor: aMarsRover 
	
	marsRover := aMarsRover.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverHeading class' category: 'MarsRover-WithHeading'!
MarsRoverHeading class
	instanceVariableNames: ''!

!MarsRoverHeading class methodsFor: 'instance creation' stamp: 'AG 6/3/2023 10:42:59'!
for: aMarsRover 
	
	^self new initializeFor: aMarsRover ! !


!classDefinition: #MarsRoverHeadingEast category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingEast
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'AG 6/3/2023 10:42:59'!
moveBackward
	
	^marsRover moveWest! !

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'AG 6/3/2023 10:42:59'!
moveForward
	
	^marsRover moveEast! !


!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'AG 6/3/2023 10:42:59'!
rotateLeft
	
	^marsRover headNorth! !

!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'AG 6/3/2023 10:42:59'!
rotateRight
	
	^marsRover headSouth! !


!classDefinition: #MarsRoverHeadingNorth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingNorth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'AG 6/3/2023 10:42:59'!
moveBackward
	
	^marsRover moveSouth! !

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'AG 6/3/2023 10:42:59'!
moveForward
	
	^marsRover moveNorth! !


!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'AG 6/3/2023 10:42:59'!
rotateLeft
	
	^marsRover headWest! !

!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'AG 6/3/2023 10:42:59'!
rotateRight
	
	^marsRover headEast! !


!classDefinition: #MarsRoverHeadingSouth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingSouth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'AG 6/3/2023 10:42:59'!
moveBackward
	
	^marsRover moveNorth! !

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'AG 6/3/2023 10:42:59'!
moveForward
	
	^marsRover moveSouth! !


!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'AG 6/3/2023 10:42:59'!
rotateLeft
	
	^marsRover headEast! !

!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'AG 6/3/2023 10:42:59'!
rotateRight
	
	^marsRover headWest! !


!classDefinition: #MarsRoverHeadingWest category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingWest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'AG 6/3/2023 10:42:59'!
moveBackward

	^marsRover moveEast! !

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'AG 6/3/2023 10:42:59'!
moveForward
	
	^marsRover moveWest! !


!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'AG 6/3/2023 10:42:59'!
rotateLeft
	
	^marsRover headSouth! !

!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'AG 6/3/2023 10:42:59'!
rotateRight
	
	^marsRover headNorth! !


!classDefinition: #MarsRoverObserver category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverObserver
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverObserver methodsFor: 'initialization' stamp: 'AG 6/3/2023 11:57:55'!
initializeFor: aMarsRover

	self subclassResponsibility ! !


!MarsRoverObserver methodsFor: 'position' stamp: 'AG 6/3/2023 17:31:15'!
logNewPosition: aPosition

! !


!MarsRoverObserver methodsFor: 'heading' stamp: 'AG 6/3/2023 17:30:55'!
logNewHeadingEast

! !

!MarsRoverObserver methodsFor: 'heading' stamp: 'AG 6/3/2023 17:30:42'!
logNewHeadingNorth

	! !

!MarsRoverObserver methodsFor: 'heading' stamp: 'AG 6/3/2023 17:30:47'!
logNewHeadingSouth

	! !

!MarsRoverObserver methodsFor: 'heading' stamp: 'AG 6/3/2023 17:30:51'!
logNewHeadingWest

	! !


!MarsRoverObserver methodsFor: 'print' stamp: 'AG 6/3/2023 11:58:09'!
print

	self subclassResponsibility ! !


!classDefinition: #MarsRoverLogger category: 'MarsRover-WithHeading'!
MarsRoverObserver subclass: #MarsRoverLogger
	instanceVariableNames: 'logs'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverLogger methodsFor: 'initialization' stamp: 'mp 6/3/2023 13:39:03'!
initializeFor: aMarsRoverManager

	logs := OrderedCollection new.
	aMarsRoverManager addObserver: self.! !


!MarsRoverLogger methodsFor: 'heading' stamp: 'AG 6/3/2023 11:46:34'!
logNewHeadingEast

	logs add: 'East' .

	! !

!MarsRoverLogger methodsFor: 'heading' stamp: 'AG 6/3/2023 11:47:04'!
logNewHeadingNorth

	logs add: 'North' .

	! !

!MarsRoverLogger methodsFor: 'heading' stamp: 'AG 6/3/2023 11:47:20'!
logNewHeadingSouth

	logs add: 'South' .

	! !

!MarsRoverLogger methodsFor: 'heading' stamp: 'AG 6/3/2023 11:46:53'!
logNewHeadingWest

	logs add: 'West' .

	! !


!MarsRoverLogger methodsFor: 'print' stamp: 'AG 6/3/2023 11:22:42'!
print

	^logs! !


!MarsRoverLogger methodsFor: 'position' stamp: 'AG 6/3/2023 11:29:30'!
logNewPosition: aPosition

	logs add: aPosition .

	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverLogger class' category: 'MarsRover-WithHeading'!
MarsRoverLogger class
	instanceVariableNames: ''!

!MarsRoverLogger class methodsFor: 'as yet unclassified' stamp: 'mp 6/3/2023 13:42:39'!
for: aMarsRoverManager

	^self new initializeFor: aMarsRoverManager .! !


!classDefinition: #MarsRoverWindow category: 'MarsRover-WithHeading'!
MarsRoverObserver subclass: #MarsRoverWindow
	instanceVariableNames: 'position heading'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverWindow methodsFor: 'initialization' stamp: 'AG 6/3/2023 17:36:26'!
initializeFor: aMarsRoverManager
	
	heading := ''.
	position := ''.
	aMarsRoverManager addObserver: self.! !


!MarsRoverWindow methodsFor: 'heading' stamp: 'AG 6/3/2023 11:51:33'!
logNewHeadingEast
	
	heading := 'Apuntando al Este'. ! !

!MarsRoverWindow methodsFor: 'heading' stamp: 'AG 6/3/2023 11:51:30'!
logNewHeadingNorth
	
	heading := 'Apuntando al Norte'. ! !

!MarsRoverWindow methodsFor: 'heading' stamp: 'AG 6/3/2023 11:51:26'!
logNewHeadingSouth
	
	heading := 'Apuntando al Sur'. ! !

!MarsRoverWindow methodsFor: 'heading' stamp: 'AG 6/3/2023 11:51:23'!
logNewHeadingWest
	
	heading := 'Apuntando al Oeste'. 
	! !


!MarsRoverWindow methodsFor: 'print' stamp: 'AG 6/3/2023 17:38:54'!
print
	^'Posicion: ', (position asString), ', Heading: ', heading
! !


!MarsRoverWindow methodsFor: 'position' stamp: 'AG 6/3/2023 17:32:43'!
logNewPosition: aPosition 

	position := 	aPosition .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverWindow class' category: 'MarsRover-WithHeading'!
MarsRoverWindow class
	instanceVariableNames: ''!

!MarsRoverWindow class methodsFor: 'as yet unclassified' stamp: 'mp 6/3/2023 13:42:45'!
for: aMarsRoverManager

	^self new initializeFor: aMarsRoverManager .! !
!classDefinition: #MarsRoverLogTest category: 'MarsRover-Test'!
TestCase subclass: #MarsRoverLogTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-Test'!

!MarsRoverLogTest methodsFor: 'settingUp' stamp: 'AG 6/3/2023 18:22:22'!
marsRoverAtOneOneHeadingNorth

	^ MarsRover at: 1@1 heading: MarsRoverHeadingNorth! !

!MarsRoverLogTest methodsFor: 'settingUp' stamp: 'AG 6/3/2023 11:04:32'!
marsRoverLog

	|logs|
	
	logs := OrderedCollection new.
	logs add: 1@2.
	logs add: 1@3.
	logs  add: 'East'.
	logs add: 0@3.
	logs add: 'North'.
	logs add: 'West'.
	logs add: 'South'.
	
	^logs
	
	! !


!MarsRoverLogTest methodsFor: 'test' stamp: 'AG 6/3/2023 18:22:22'!
test01LogIsEmptyWhenMarsRoverStarts
	|marsRover log |
	
	marsRover := self marsRoverAtOneOneHeadingNorth .
	log := MarsRoverLogger for: marsRover manager.
	
	self assert:  log print equals: OrderedCollection new.! !

!MarsRoverLogTest methodsFor: 'test' stamp: 'AG 6/3/2023 18:22:22'!
test02LoggerRegisterTheChangeOfPositionOfMarsRover
	|marsRover logs log |
	
	marsRover := self marsRoverAtOneOneHeadingNorth .
	log := MarsRoverLogger for: marsRover manager.

	marsRover process: 'f'.
	
	logs := OrderedCollection new.
	logs add: 1@2.
	
	self assert:  log print equals: logs.! !

!MarsRoverLogTest methodsFor: 'test' stamp: 'AG 6/3/2023 18:22:22'!
test03LoggerRegisterManyChangesOfPositionAndHeadingOfMarsRover
	|marsRover log |
	
	marsRover := self marsRoverAtOneOneHeadingNorth .
	log := MarsRoverLogger for: marsRover manager.

	marsRover process: 'ffrblll'.
	
	self assert:  log print equals: self marsRoverLog .! !


!classDefinition: #MarsRoverTest category: 'MarsRover-Test'!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-Test'!

!MarsRoverTest methodsFor: 'tests' stamp: 'AG 6/3/2023 10:42:59'!
test01DoesNotMoveWhenNoCommand

	self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: '' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'AG 6/3/2023 10:42:59'!
test02IsAtFailsForDifferentPosition

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@2 heading: self north)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'AG 6/3/2023 10:42:59'!
test03IsAtFailsForDifferentHeading

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@1 heading: self south)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'AG 6/3/2023 10:42:59'!
test04IncrementsYAfterMovingForwardWhenHeadingNorth

	self 
		assertIsAt: 1@3 
		heading: self north 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'AG 6/3/2023 10:42:59'!
test06DecrementsYAfterMovingBackwardsWhenHeadingNorth

	self 
		assertIsAt: 1@1 
		heading: self north 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'AG 6/3/2023 10:42:59'!
test07PointToEashAfterRotatingRightWhenHeadingNorth

	self 
		assertIsAt: 1@2 
		heading: self east 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'AG 6/3/2023 10:42:59'!
test08PointsToWestAfterRotatingLeftWhenPointingNorth

	self 
		assertIsAt: 1@2 
		heading: self west 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'AG 6/3/2023 10:42:59'!
test09DoesNotProcessInvalidCommand

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: self north.
	
	self 
		should: [ marsRover process: 'x' ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: marsRover invalidCommandErrorDescription.
			self assert: (marsRover isAt: 1@2 heading: self north) ]! !

!MarsRoverTest methodsFor: 'tests' stamp: 'AG 6/3/2023 10:42:59'!
test10CanProcessMoreThanOneCommand

	self 
		assertIsAt: 1@4 
		heading: self north 
		afterProcessing: 'ff' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'AG 6/3/2023 10:42:59'!
test11IncrementsXAfterMovingForwareWhenHeadingEast

	self 
		assertIsAt: 2@2 
		heading: self east 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'AG 6/3/2023 10:42:59'!
test12DecrementsXAfterMovingBackwardWhenHeadingEast

	self 
		assertIsAt: 0@2 
		heading: self east 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'AG 6/3/2023 10:42:59'!
test13PointsToSouthAfterRotatingRightWhenHeadingEast

		self 
		assertIsAt: 1@2 
		heading: self south 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'AG 6/3/2023 10:42:59'!
test14PointsToNorthAfterRotatingLeftWhenPointingEast

		self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'AG 6/3/2023 10:42:59'!
test15ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingSouth

	self 
		assertIsAt: 1@1 
		heading: self west 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self south 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'AG 6/3/2023 10:42:59'!
test16ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingWest

	self 
		assertIsAt: 0@2 
		heading: self north 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self west 
! !


!MarsRoverTest methodsFor: 'headings' stamp: 'AG 6/3/2023 10:42:59'!
east

	^ MarsRoverHeadingEast ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'AG 6/3/2023 10:42:59'!
north

	^ MarsRoverHeadingNorth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'AG 6/3/2023 10:42:59'!
south

	^ MarsRoverHeadingSouth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'AG 6/3/2023 10:42:59'!
west

	^ MarsRoverHeadingWest ! !


!MarsRoverTest methodsFor: 'assertions' stamp: 'AG 6/3/2023 10:42:59'!
assertIsAt: newPosition heading: newHeadingType afterProcessing: commands whenStartingAt: startPosition heading: startHeadingType

	| marsRover |
	
	marsRover := MarsRover at: startPosition heading: startHeadingType. 
	
	marsRover process: commands.
	
	self assert: (marsRover isAt: newPosition heading: newHeadingType)! !


!classDefinition: #MarsRoverWindowTest category: 'MarsRover-Test'!
TestCase subclass: #MarsRoverWindowTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-Test'!

!MarsRoverWindowTest methodsFor: 'test' stamp: 'AG 6/3/2023 17:27:22'!
marsRoverAtOneOneHeadingNorth

	^ MarsRover at: 1@1 heading: MarsRoverHeadingNorth! !

!MarsRoverWindowTest methodsFor: 'test' stamp: 'AG 6/3/2023 18:12:22'!
test01WindowIsEmptyWhenMarsRoverStarts

	|marsRover window|
	
	marsRover := self marsRoverAtOneOneHeadingNorth .
	window := MarsRoverWindow for: marsRover manager.
	
	self assert: window print equals: 'Posicion: , Heading: '.
	
! !

!MarsRoverWindowTest methodsFor: 'test' stamp: 'AG 6/3/2023 18:13:04'!
test02MovingMarsRoverAffectWindowPosition
	|marsRover window |
	
	marsRover := self marsRoverAtOneOneHeadingNorth .
	window := MarsRoverWindow for: marsRover manager.

	marsRover process: 'f'.
	
	self assert: window print equals: 'Posicion: 1@2, Heading: '.
	! !

!MarsRoverWindowTest methodsFor: 'test' stamp: 'AG 6/3/2023 18:14:12'!
test03RotatingMarsRoverWestAffectsWindowHeading

	|marsRover window |
	
	marsRover := self marsRoverAtOneOneHeadingNorth .
	window := MarsRoverWindow for: marsRover manager.

	marsRover process: 'fl'.
	
	
	self assert:  window print equals: 'Posicion: 1@2, Heading: Apuntando al Oeste'.! !

!MarsRoverWindowTest methodsFor: 'test' stamp: 'AG 6/3/2023 18:14:38'!
test04RotatingMarsRoverSouthAffectsWindowHeading

	|marsRover window |
	
	marsRover := self marsRoverAtOneOneHeadingNorth .
	window := MarsRoverWindow for: marsRover manager.

	marsRover process: 'fll'.

	self assert:  window print equals: 'Posicion: 1@2, Heading: Apuntando al Sur'.! !

!MarsRoverWindowTest methodsFor: 'test' stamp: 'AG 6/3/2023 18:14:59'!
test05RotatingMarsRoverEastAffectsWindowHeading

	|marsRover window |
	
	marsRover := self marsRoverAtOneOneHeadingNorth .
	window := MarsRoverWindow for: marsRover manager.

	marsRover process: 'fr'.

	self assert:  window print equals: 'Posicion: 1@2, Heading: Apuntando al Este'.! !

!MarsRoverWindowTest methodsFor: 'test' stamp: 'AG 6/3/2023 18:15:08'!
test06RotatingMarsRoverNorthAffectsWindowHeading

	|marsRover window |
	
	marsRover := self marsRoverAtOneOneHeadingNorth .
	window := MarsRoverWindow for: marsRover manager.

	marsRover process: 'flr'.

	self assert:  window print equals: 'Posicion: 1@2, Heading: Apuntando al Norte'.! !
