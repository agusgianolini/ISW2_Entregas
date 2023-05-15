!classDefinition: #OOStackTest category: 'Stack-Exercise'!
TestCase subclass: #OOStackTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:30'!
test01StackShouldBeEmptyWhenCreated

	| stack |
	
	stack := OOStack new.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:29:55'!
test02PushAddElementsToTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	
	self deny: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:01'!
test03PopRemovesElementsFromTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:09'!
test04PopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	stack push: pushedObject.
	
	self assert: stack pop = pushedObject! !

!OOStackTest methodsFor: 'test' stamp: 'NR 9/16/2021 17:40:17'!
test05StackBehavesLIFO

	| stack firstPushedObject secondPushedObject |
	
	stack := OOStack new.
	firstPushedObject := 'firstSomething'.
	secondPushedObject := 'secondSomething'.
	
	stack push: firstPushedObject.
	stack push: secondPushedObject.
	
	self assert: stack pop = secondPushedObject.
	self assert: stack pop = firstPushedObject.
	self assert: stack isEmpty 
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:20'!
test06TopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack top = pushedObject.
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:24'!
test07TopDoesNotRemoveObjectFromStack

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack size = 1.
	stack top.
	self assert: stack size = 1.
	! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:26'!
test08CanNotPopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:31'!
test09CanNotPopWhenThereAreNoObjectsInTheStackAndTheStackHadObjects

	| stack  |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:44'!
test10CanNotTopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack top ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !


!classDefinition: #SentenceFinderByPrefixTest category: 'Stack-Exercise'!
TestCase subclass: #SentenceFinderByPrefixTest
	instanceVariableNames: 'sentenceFinder'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefixTest methodsFor: 'setup' stamp: 'mp 4/24/2023 08:55:01'!
setUp
	sentenceFinder := SentenceFinderByPrefix new.! !


!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'mp 4/24/2023 09:58:27'!
test01ShouldThrowErrorOnEmptyPrefixAndDontChangeStack

	| stack firstPushedsentence secondPushedSecond invalidEmptyPrefix|
	
	stack := OOStack new.
	firstPushedsentence := 'first sentence'.
	secondPushedSecond := 'second something'.
	
	stack push: firstPushedsentence.
	stack push: secondPushedSecond.
	invalidEmptyPrefix := ''.
	
	
	self
		should: [ sentenceFinder findPrefix: invalidEmptyPrefix onStack: stack ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = SentenceFinderByPrefix invalidPrefixErrorDescription ].
	
	self assert: stack pop = secondPushedSecond.
	self assert: stack pop = firstPushedsentence.
	self assert: stack isEmpty ! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'mp 4/24/2023 09:58:50'!
test02ShouldThrowErrorOnPrefixWithWhiteSpacesAndDontChangeStack

	| stack firstPushedsentence secondPushedSecond invalidPrefixWithWhiteSpaces|
	
	stack := OOStack new.
	firstPushedsentence := 'first sentence'.
	secondPushedSecond := 'second something'.
	
	stack push: firstPushedsentence.
	stack push: secondPushedSecond.
	invalidPrefixWithWhiteSpaces := 'first sen'.	
	
	self
		should: [ sentenceFinder findPrefix: invalidPrefixWithWhiteSpaces onStack: stack ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = SentenceFinderByPrefix invalidPrefixErrorDescription ].
	
	self assert: stack pop = secondPushedSecond.
	self assert: stack pop = firstPushedsentence.
	self assert: stack isEmpty ! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'mp 4/24/2023 12:04:11'!
test03ShouldGiveEmptyCollectionAnswerIfTheStackIsEmpty

	| emptyStack  validPrefix resultCollection|
	
	emptyStack := OOStack new.
	
	validPrefix := 'abc'.		
	
	resultCollection := sentenceFinder findPrefix: validPrefix onStack: emptyStack.
	
	self assert:  resultCollection isEmpty .
	! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'mp 4/24/2023 12:04:20'!
test04ShouldGiveEmptyCollectionAnswerIfThereAreNotMatches

	| stack firstPushedSentence secondPushedSentence thirdPushedSentence validPrefix resultCollection|
	
	stack := OOStack new.
	firstPushedSentence := 'first sentence'.
	secondPushedSentence := 'second something'.
	thirdPushedSentence := 'Seccion mat'.
	
	stack push: firstPushedSentence.
	stack push: secondPushedSentence.
	stack push: thirdPushedSentence.
	validPrefix := 'abc'.
		
	
	resultCollection := sentenceFinder findPrefix: validPrefix onStack: stack.
	
	self assert:  resultCollection isEmpty .
	! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'mp 4/24/2023 12:03:57'!
test05ShouldFindRightAnswerOnGoodPrefix

	| stack firstPushedsentence secondPushedSecond validPrefix resultCollection expectedCollection|
	
	stack := OOStack new.
	firstPushedsentence := 'first sentence'.
	secondPushedSecond := 'second something'.
	
	stack push: firstPushedsentence.
	stack push: secondPushedSecond.
	validPrefix := 'fi'.
	
	expectedCollection := OrderedCollection new.
	expectedCollection add: firstPushedsentence.
	
	resultCollection := sentenceFinder findPrefix: validPrefix onStack: stack.
	
	self assert: resultCollection = expectedCollection .
	! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'mp 4/24/2023 12:03:50'!
test06ShouldGiveTheAnswerInTheSameOrderOfTheStack

	| stack firstPushedSentence secondPushedSentence thirdPushedSentence validPrefix resultCollection expectedCollection|
	
	stack := OOStack new.
	firstPushedSentence := 'first sentence'.
	secondPushedSentence := 'second something'.
	thirdPushedSentence := 'seccion mat'.
	
	stack push: firstPushedSentence.
	stack push: secondPushedSentence.
	stack push: thirdPushedSentence.
	validPrefix := 'sec'.
	
	expectedCollection := OrderedCollection new.
	expectedCollection add: secondPushedSentence.
	expectedCollection add: thirdPushedSentence.
	
	resultCollection := sentenceFinder findPrefix: validPrefix onStack: stack.
	
	self assert: resultCollection = expectedCollection .
	! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'mp 4/24/2023 12:05:38'!
test07ShouldGiveTheSentencesThatOnlyMatchesTheCamelCase

	| stack firstPushedSentence secondPushedSentence thirdPushedSentence fourthPushedSentence validPrefixWithCamelCase resultCollection expectedCollection|
	
	stack := OOStack new.
	firstPushedSentence := 'first sentence'.
	secondPushedSentence := 'second something'.
	thirdPushedSentence := 'Seccion mat'.
	fourthPushedSentence := 'seccion mat'.
	
	stack push: firstPushedSentence.
	stack push: secondPushedSentence.
	stack push: thirdPushedSentence.
	stack push: fourthPushedSentence.
	validPrefixWithCamelCase := 'Sec'.
	
	expectedCollection := OrderedCollection new.
	expectedCollection add: thirdPushedSentence.
	
	resultCollection := sentenceFinder findPrefix: validPrefixWithCamelCase onStack: stack.
	
	self assert: resultCollection = expectedCollection .
	! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'mp 4/24/2023 12:05:50'!
test08ShouldGiveTheSentencesThatMatchesOnlyInThePrefix

	| stack firstPushedSentence secondPushedSentence thirdPushedSentence validPrefix resultCollection expectedCollection|
	
	stack := OOStack new.
	firstPushedSentence := 'firstseccion'.
	secondPushedSentence := 'common second seccion'.
	thirdPushedSentence := 'seccion mat'.
	
	stack push: firstPushedSentence.
	stack push: secondPushedSentence.
	stack push: thirdPushedSentence.
	validPrefix := 'sec'.
	
	expectedCollection := OrderedCollection new.
	expectedCollection add: thirdPushedSentence.
	
	resultCollection := sentenceFinder findPrefix: validPrefix onStack: stack.
	
	self assert: resultCollection = expectedCollection .
	! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'mp 4/24/2023 12:12:52'!
test09TheStackShouldPreserveTheSentencesAndTheOrder

	| stack firstPushedSentence secondPushedSentence thirdPushedSentence fourthPushedSentence validPrefix |
	
	stack := OOStack new.
	firstPushedSentence := 'first sentence'.
	secondPushedSentence := 'second something'.
	thirdPushedSentence := 'Seccion mat'.
	fourthPushedSentence := 'seccion mat'.
	
	stack push: firstPushedSentence.
	stack push: secondPushedSentence.
	stack push: thirdPushedSentence.
	stack push: fourthPushedSentence.
	validPrefix := 'sec'.
	
	sentenceFinder findPrefix: validPrefix onStack: stack.
	
	self assert: stack pop = fourthPushedSentence.
	self assert: stack pop = thirdPushedSentence.
	self assert: stack pop = secondPushedSentence.
	self assert: stack pop = firstPushedSentence.
	self assert: stack isEmpty 
	! !


!classDefinition: #OOStack category: 'Stack-Exercise'!
Object subclass: #OOStack
	instanceVariableNames: 'colection stackFlag'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStack methodsFor: 'inicialization' stamp: 'mp 4/23/2023 12:20:17'!
initialize

	colection := OrderedCollection new.
	stackFlag := StackFlag withEmptyFlag: true.
	! !


!OOStack methodsFor: 'operations' stamp: 'mp 4/23/2023 12:14:48'!
pop

	^stackFlag popOnStack: self
	
! !

!OOStack methodsFor: 'operations' stamp: 'mp 4/23/2023 12:10:00'!
push: anObjectToPush

	stackFlag push: anObjectToPush  on: self! !

!OOStack methodsFor: 'operations' stamp: 'mp 4/23/2023 12:19:12'!
top	
	
	^ stackFlag topOfStack: self.! !


!OOStack methodsFor: 'comparing' stamp: 'mp 4/23/2023 11:43:21'!
isEmpty 
	
	^colection isEmpty ! !


!OOStack methodsFor: 'accessing' stamp: 'dfsdfs 4/20/2023 21:35:18'!
size

	^colection size.! !


!OOStack methodsFor: 'auxiliar operations' stamp: 'mp 4/23/2023 11:59:46'!
changeFlagToEmpty
	^ stackFlag := StackFlag withEmptyFlag: true.! !

!OOStack methodsFor: 'auxiliar operations' stamp: 'mp 4/23/2023 11:59:57'!
changeFlagToNotEmpty
	^ stackFlag := StackFlag withEmptyFlag: false.! !

!OOStack methodsFor: 'auxiliar operations' stamp: 'mp 4/23/2023 12:00:30'!
popOnEmpty

	^self error: self class stackEmptyErrorDescription
	! !

!OOStack methodsFor: 'auxiliar operations' stamp: 'mp 4/23/2023 12:00:58'!
popOnNotEmpty

	^colection removeLast! !

!OOStack methodsFor: 'auxiliar operations' stamp: 'mp 4/23/2023 12:12:59'!
pushObject: anObjectToPush

	colection add: anObjectToPush.
	! !

!OOStack methodsFor: 'auxiliar operations' stamp: 'mp 4/23/2023 11:23:29'!
topOfEmpty
	^self error: self class stackEmptyErrorDescription.! !

!OOStack methodsFor: 'auxiliar operations' stamp: 'mp 4/23/2023 12:18:49'!
topOfNotEmpty
	^ colection last.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStack class' category: 'Stack-Exercise'!
OOStack class
	instanceVariableNames: ''!

!OOStack class methodsFor: 'error descriptions' stamp: 'NR 9/16/2021 17:39:43'!
stackEmptyErrorDescription
	
	^ 'stack is empty!!!!!!'! !


!OOStack class methodsFor: 'instance creation' stamp: 'dfsdfs 4/20/2023 21:12:19'!
new
	^self basicNew initialize. ! !


!classDefinition: #SentenceFinderByPrefix category: 'Stack-Exercise'!
Object subclass: #SentenceFinderByPrefix
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefix methodsFor: 'auxiliar operations' stamp: 'mp 4/24/2023 10:45:42'!
findPrefix: aPrefixToFind onStack: aStackWhereToFind saveSenteceOn: auxiliarStack andCollectMatchesOn:aCollectionOfSenteces

	[ 
		|newSentence|
	
		newSentence := aStackWhereToFind pop.
	
		auxiliarStack push: newSentence.
	
		(newSentence is: aPrefixToFind substringAt: 1) ifTrue: [aCollectionOfSenteces addFirst: newSentence].
	
		self findPrefix: aPrefixToFind onStack: aStackWhereToFind saveSenteceOn: auxiliarStack andCollectMatchesOn:aCollectionOfSenteces
	] on: Error 
	
	do:[].	
	
! !

!SentenceFinderByPrefix methodsFor: 'auxiliar operations' stamp: 'mp 4/24/2023 09:50:49'!
hasEmptySpaces: aPrefixToValidate 
	
	(aPrefixToValidate size = (aPrefixToValidate withoutSeparators ) size) ifTrue: [^false].
	
	^ true

	
	
		! !

!SentenceFinderByPrefix methodsFor: 'auxiliar operations' stamp: 'Ag 4/23/2023 18:10:23'!
pushSentenceOn: aStackWhereToFind of: auxiliarStack

	
	[	|newSentence|
		newSentence := auxiliarStack pop.
		aStackWhereToFind push: newSentence.
		self pushSentenceOn: aStackWhereToFind of: auxiliarStack
		
		] on: Error do:[].! !

!SentenceFinderByPrefix methodsFor: 'auxiliar operations' stamp: 'mp 4/24/2023 09:40:44'!
validatePrefix: aPrefixToValidate
	(aPrefixToValidate isEmpty or: [self hasEmptySpaces: aPrefixToValidate ]) ifTrue: [^self error: self class invalidPrefixErrorDescription ]

	
	
		! !


!SentenceFinderByPrefix methodsFor: 'operations' stamp: 'mp 4/24/2023 09:24:03'!
findPrefix: aPrefixToFind onStack: aStackWhereToFind
	| auxiliarStack returnCollection |
	
	self validatePrefix: aPrefixToFind .
	
	auxiliarStack := OOStack new.
	returnCollection := OrderedCollection new.
	
	self findPrefix:aPrefixToFind  onStack: aStackWhereToFind  saveSenteceOn: auxiliarStack andCollectMatchesOn: returnCollection. 
	
	self pushSentenceOn: aStackWhereToFind of: auxiliarStack .
	
	^returnCollection .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SentenceFinderByPrefix class' category: 'Stack-Exercise'!
SentenceFinderByPrefix class
	instanceVariableNames: ''!

!SentenceFinderByPrefix class methodsFor: 'error descriptions' stamp: 'mp 4/24/2023 09:18:46'!
invalidPrefixErrorDescription
	
	^ 'the prefix is ​​empty or contains empty spaces!!!!!!'! !


!classDefinition: #StackFlag category: 'Stack-Exercise'!
Object subclass: #StackFlag
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!StackFlag methodsFor: 'value' stamp: 'mp 4/23/2023 10:19:27'!
value
	^ self subclassResponsibility ! !


!StackFlag methodsFor: 'operations' stamp: 'mp 4/23/2023 11:38:25'!
popOnStack: anStackToPop
	^ self subclassResponsibility ! !

!StackFlag methodsFor: 'operations' stamp: 'mp 4/23/2023 12:15:34'!
push: anObjectToPush on: anStackWhereToPush
	^ self subclassResponsibility ! !

!StackFlag methodsFor: 'operations' stamp: 'mp 4/23/2023 12:16:23'!
topOfStack: anStackToGetTop
	^ self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'StackFlag class' category: 'Stack-Exercise'!
StackFlag class
	instanceVariableNames: ''!

!StackFlag class methodsFor: 'instance creation' stamp: 'mp 4/23/2023 11:08:35'!
withEmptyFlag: aTrueBooleanIfIsEmptyStack
	
	(aTrueBooleanIfIsEmptyStack)  ifTrue: [^ EmptyStackFlag new].
	^ NotEmptyStackFlag new.! !


!classDefinition: #EmptyStackFlag category: 'Stack-Exercise'!
StackFlag subclass: #EmptyStackFlag
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!EmptyStackFlag methodsFor: 'value' stamp: 'mp 4/23/2023 10:20:27'!
value 
	^ true.! !


!EmptyStackFlag methodsFor: 'operations' stamp: 'mp 4/23/2023 11:38:55'!
popOnStack: anStackToPop
	^ anStackToPop popOnEmpty .! !

!EmptyStackFlag methodsFor: 'operations' stamp: 'mp 4/23/2023 12:12:43'!
push: anObjectToPush on: anStackWhereToPush
	anStackWhereToPush pushObject: anObjectToPush .
	anStackWhereToPush changeFlagToNotEmpty .! !

!EmptyStackFlag methodsFor: 'operations' stamp: 'mp 4/23/2023 12:17:43'!
topOfStack: anStackToGetTop
	
	^anStackToGetTop topOfEmpty .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EmptyStackFlag class' category: 'Stack-Exercise'!
EmptyStackFlag class
	instanceVariableNames: 'uniqueInstance'!

!EmptyStackFlag class methodsFor: 'instance creation' stamp: 'mp 4/23/2023 10:36:46'!
new
	^uniqueInstance ! !


!EmptyStackFlag class methodsFor: 'initialization' stamp: 'mp 4/23/2023 10:37:14'!
initialize

	uniqueInstance := self basicNew ! !


!classDefinition: #NotEmptyStackFlag category: 'Stack-Exercise'!
StackFlag subclass: #NotEmptyStackFlag
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!NotEmptyStackFlag methodsFor: 'value' stamp: 'mp 4/23/2023 10:20:49'!
value
	^false! !


!NotEmptyStackFlag methodsFor: 'operations' stamp: 'mp 4/23/2023 11:50:17'!
popOnStack: anStackToPop
	|object|
	
	object := anStackToPop popOnNotEmpty .
	(anStackToPop isEmpty ) ifTrue: [anStackToPop changeFlagToEmpty].
	
	^object! !

!NotEmptyStackFlag methodsFor: 'operations' stamp: 'mp 4/23/2023 12:13:17'!
push: anObjectToPush on: anStackWhereToPush
	anStackWhereToPush pushObject: anObjectToPush .! !

!NotEmptyStackFlag methodsFor: 'operations' stamp: 'mp 4/23/2023 12:17:28'!
topOfStack: anStackToGetTop
	
	^anStackToGetTop topOfNotEmpty .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NotEmptyStackFlag class' category: 'Stack-Exercise'!
NotEmptyStackFlag class
	instanceVariableNames: 'uniqueInstance'!

!NotEmptyStackFlag class methodsFor: 'initialization' stamp: 'mp 4/23/2023 10:37:31'!
initialize

	uniqueInstance := self basicNew ! !


!NotEmptyStackFlag class methodsFor: 'instance creation' stamp: 'mp 4/23/2023 10:37:45'!
new
	^uniqueInstance ! !

EmptyStackFlag initialize!
NotEmptyStackFlag initialize!