!classDefinition: #CantSuspend category: 'CodigoRepetido-Ejercicio'!
Error subclass: #CantSuspend
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #NotFound category: 'CodigoRepetido-Ejercicio'!
Error subclass: #NotFound
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #CustomerBookTest category: 'CodigoRepetido-Ejercicio'!
TestCase subclass: #CustomerBookTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBookTest methodsFor: 'testing' stamp: 'mp 4/12/2023 18:41:46'!
assert: aCostumer isTheOnlyCostumerIn: customerBook

	self assert: customerBook numberOfCustomers = 1.
	self assert: (customerBook includesCustomerNamed: aCostumer)! !

!CustomerBookTest methodsFor: 'testing' stamp: 'mp 4/12/2023 18:42:21'!
assertIsCostumerCanNotBeEmptyError: anError

	^ self assert: anError messageText = CustomerBook customerCanNotBeEmptyErrorMessage! !

!CustomerBookTest methodsFor: 'testing' stamp: 'AG 4/11/2023 19:56:04'!
chekIfCustomersOf:customerBook hasActived:aNumberOfActiveCustomer hasSuspended:aNumberOfSuspendedCustomers areInTotal:aNumberOfCustomers 
	
	
	self assert: aNumberOfActiveCustomer equals: customerBook numberOfActiveCustomers.
	self assert: aNumberOfSuspendedCustomers equals: customerBook numberOfSuspendedCustomers.
	self assert: aNumberOfCustomers equals: customerBook numberOfCustomers.
	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'AG 4/10/2023 21:31:16'!
do: aClosure takeLessThan: aTime 
	
	
	| timeAfterRunning timeBeforeRunning |
	timeBeforeRunning := Time millisecondClockValue *millisecond.
	aClosure value.
	timeAfterRunning := Time millisecondClockValue * millisecond.
	
	self assert: (timeAfterRunning-timeBeforeRunning) < (aTime)
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'AG 4/10/2023 21:42:27'!
test01AddingCustomerShouldNotTakeMoreThan50Milliseconds

	self do: [CustomerBook new addCustomerNamed: 'John Lennon'.] takeLessThan: 50*millisecond
	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'AG 4/10/2023 21:47:42'!
test02RemovingCustomerShouldNotTakeMoreThan100Milliseconds

		self do: [(CustomerBook new addCustomerNamed: 'PaulMcCartney')removeCustomerNamed: 'PaulMcCartney'.] takeLessThan: 100*millisecond
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'mp 4/12/2023 18:42:45'!
test03CanNotAddACustomerWithEmptyName 

	| customerBook |
			
	customerBook := CustomerBook new.

		
	self try: [ customerBook addCustomerNamed: '' .] onExpected: Error do:  [ :anError | 
			self assertIsCostumerCanNotBeEmptyError: anError.
			self assert: customerBook isEmpty ]! !

!CustomerBookTest methodsFor: 'testing' stamp: 'mp 4/12/2023 18:43:16'!
test04CanNotRemoveAnInvalidCustomer

	| customerBook johnLennon |
			
	customerBook := CustomerBook new.
	johnLennon := 'John Lennon'.
	customerBook addCustomerNamed: johnLennon.
	
	self try: [customerBook removeCustomerNamed: 'Paul McCartney'.] onExpected: NotFound do: [ :anError | 
			self assert: johnLennon isTheOnlyCostumerIn: customerBook]
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'AG 4/11/2023 19:56:04'!
test05SuspendingACustomerShouldNotRemoveItFromCustomerBook

	| customerBook paulMcCartney|
	
	customerBook := CustomerBook new.
	paulMcCartney := 'Paul McCartney'.
	
	customerBook addCustomerNamed: paulMcCartney.
	customerBook suspendCustomerNamed: paulMcCartney.
	self chekIfCustomersOf:customerBook hasActived:0 hasSuspended:1 areInTotal:1 .
	self assert: (customerBook includesCustomerNamed: paulMcCartney).

	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'AG 4/11/2023 19:56:04'!
test06RemovingASuspendedCustomerShouldRemoveItFromCustomerBook

	| customerBook paulMcCartney|
	
	customerBook := CustomerBook new.
	paulMcCartney := 'Paul McCartney'.

	customerBook addCustomerNamed: paulMcCartney.
	customerBook suspendCustomerNamed: paulMcCartney.
	customerBook removeCustomerNamed: paulMcCartney.

	self chekIfCustomersOf: customerBook hasActived: 0 hasSuspended:0 areInTotal:0.

	self deny: (customerBook includesCustomerNamed: paulMcCartney).! !

!CustomerBookTest methodsFor: 'testing' stamp: 'mp 4/12/2023 18:43:54'!
test07CanNotSuspendAnInvalidCustomer

	
	| customerBook johnLennon |
			
	customerBook := CustomerBook new.
	johnLennon := 'John Lennon'.
	customerBook addCustomerNamed: johnLennon.
		

	self try: [customerBook suspendCustomerNamed: 'George Harrison'.] onExpected: CantSuspend do: [ :anError | 
			self assert: johnLennon isTheOnlyCostumerIn: customerBook ]
		
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'mp 4/12/2023 18:44:32'!
test08CanNotSuspendAnAlreadySuspendedCustomer

	| customerBook johnLennon |
			
	customerBook := CustomerBook new.
	johnLennon := 'John Lennon'.
	customerBook addCustomerNamed: johnLennon.
	customerBook suspendCustomerNamed: johnLennon.
	
	[ customerBook suspendCustomerNamed: johnLennon.
	self fail ]
		on: CantSuspend 
		do: [ :anError | 
			self assert: johnLennon isTheOnlyCostumerIn: customerBook ]
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'mp 4/12/2023 18:40:54'!
try: aClosure onExpected: anExpectedError do: anAssertOfErrorClosure

	[ aClosure value.
	self fail ]
		on: anExpectedError 
		do: anAssertOfErrorClosure ! !


!classDefinition: #CustomerBook category: 'CodigoRepetido-Ejercicio'!
Object subclass: #CustomerBook
	instanceVariableNames: 'suspended active'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBook methodsFor: 'testing' stamp: 'mp 4/12/2023 18:18:20'!
includesCustomerNamed: aName

	^(self isCostumerActived: aName) or: [ self isCostumerSuspended: aName ]! !

!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
isEmpty
	
	^active isEmpty and: [ suspended isEmpty ]! !


!CustomerBook methodsFor: 'initialization' stamp: 'AG 4/11/2023 20:05:53'!
initialize



	active := OrderedCollection new.
	
	suspended:= OrderedCollection new.! !


!CustomerBook methodsFor: 'customer management' stamp: 'mp 4/12/2023 18:31:09'!
addActivedCustomer: aName

	^ active add: aName! !

!CustomerBook methodsFor: 'customer management' stamp: 'mp 4/12/2023 18:31:09'!
addCustomerNamed: aName
	self ifEmptySendCannotBeEmpty: aName.
	
	self sendSignalIfCostumerAlreadyExists: aName.
	self addActivedCustomer: aName ! !

!CustomerBook methodsFor: 'customer management' stamp: 'mp 4/12/2023 18:30:36'!
addSuspendedCustomer: aName

	^ suspended add: aName! !

!CustomerBook methodsFor: 'customer management' stamp: 'AG 4/11/2023 20:56:21'!
ifEmptySendCannotBeEmpty: aName

	^ aName isEmpty ifTrue: [ self signalCustomerNameCannotBeEmpty ]! !

!CustomerBook methodsFor: 'customer management' stamp: 'mp 4/12/2023 18:18:20'!
includes: aName

	^(self isCostumerActived: aName) or: [self isCostumerSuspended: aName]! !

!CustomerBook methodsFor: 'customer management' stamp: 'mp 4/12/2023 18:17:06'!
isCostumerActived: aName

	^ active includes: aName! !

!CustomerBook methodsFor: 'customer management' stamp: 'mp 4/12/2023 18:18:20'!
isCostumerSuspended: aName

	^ suspended includes: aName! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
numberOfActiveCustomers
	
	^active size! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
numberOfCustomers
	
	^active size + suspended size! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 9/19/2018 17:36:09'!
numberOfSuspendedCustomers
	
	^suspended size! !

!CustomerBook methodsFor: 'customer management' stamp: 'mp 4/12/2023 18:28:40'!
removeActivedCustomer: aName

	^ active remove: aName! !

!CustomerBook methodsFor: 'customer management' stamp: 'mp 4/12/2023 18:29:14'!
removeCustomerNamed: aName 

	[self removeActivedCustomer: aName] 
	
	on: Error do:
	
	[ [self removeSuspendedCustomer: aName] on: Error do:[ ^NotFound signal] ].
! !

!CustomerBook methodsFor: 'customer management' stamp: 'mp 4/12/2023 18:29:14'!
removeSuspendedCustomer: aName

	^ suspended remove: aName! !

!CustomerBook methodsFor: 'customer management' stamp: 'mp 4/12/2023 18:12:12'!
sendSignalIfCostumerAlreadyExists: aName

	^ (self includes: aName) ifTrue: [ self signalCustomerAlreadyExists ]! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:52'!
signalCustomerAlreadyExists 

	self error: self class customerAlreadyExistsErrorMessage! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:51'!
signalCustomerNameCannotBeEmpty 

	self error: self class customerCanNotBeEmptyErrorMessage ! !

!CustomerBook methodsFor: 'customer management' stamp: 'mp 4/12/2023 18:30:36'!
suspendCustomerNamed: aName 
	
	(self isCostumerActived: aName) ifFalse: [^CantSuspend signal].
	
	self removeActivedCustomer: aName.
	
	self addSuspendedCustomer: aName
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerBook class' category: 'CodigoRepetido-Ejercicio'!
CustomerBook class
	instanceVariableNames: ''!

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 4/9/2023 22:25:52'!
customerAlreadyExistsErrorMessage

	^'Customer already exists!!!!!!'! !

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 4/9/2023 22:25:56'!
customerCanNotBeEmptyErrorMessage

	^'Customer name cannot be empty!!!!!!'! !
