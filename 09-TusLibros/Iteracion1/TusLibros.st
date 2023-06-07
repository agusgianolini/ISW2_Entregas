!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'mp 6/7/2023 17:00:16'!
test01CreateNewCartStartsEmpty
	|cart|
	
	cart := Cart new.
	
	self assert: cart isEmpty.! !

!CartTest methodsFor: 'tests' stamp: 'mp 6/7/2023 17:08:07'!
test02AddABookToEmptyCartMakesItNoEmpty
	|cart|
	
	cart := Cart new.
	cart add: #Book.
	
	self deny: cart isEmpty.! !

!CartTest methodsFor: 'tests' stamp: 'mp 6/7/2023 19:45:01'!
test03CanFindABookOnCartWithABookAdded
	|cart|
	
	cart := Cart new.
	cart add: #Book.	
	
	self assert: (cart hasBook: #Book).! !

!CartTest methodsFor: 'tests' stamp: 'mp 6/7/2023 17:42:18'!
test04AddASecondBookToCartShouldKeepsBoth
	|cart|
	
	cart := Cart new.
	cart add: #Book1.	
	cart add: #Book2.
	
	self assert: (cart hasBook: #Book1).
	self assert: (cart hasBook: #Book2).! !

!CartTest methodsFor: 'tests' stamp: 'mp 6/7/2023 18:27:14'!
test05SendListToCartShouldReturnTheBookListOfTheCart
	|cart list|
	
	cart := Cart new.
	cart add: #Book1.	
	cart add: #Book2.
	
	list := OrderedCollection with: #Book1 with: #Book2.
	
	self assert: (cart listBooks = list).! !

!CartTest methodsFor: 'tests' stamp: 'mp 6/7/2023 19:24:11'!
test06CanFindTheQuantityOfTimesABookIsInACart
	|cart|
	
	cart := Cart new.
	cart add: #Book1 quantity: 3.		
		
	self assert: (cart quantityHasOf: #Book1) equals: 3.! !

!CartTest methodsFor: 'tests' stamp: 'mp 6/7/2023 19:38:35'!
test07CanNotAddLessThanOneUnitOfABookToACart
	|cart|
	
	cart := Cart new.
	
	self 
		should: [cart add: #Book1 quantity: 0]
		raise: Error
		withExceptionDo: [:error | 
			self assert: Cart invalidBookQuantityErrorDescription equals: error messageText]! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'books'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'list' stamp: 'mp 6/7/2023 18:27:14'!
listBooks
	^books copy! !


!Cart methodsFor: 'product occurences' stamp: 'mp 6/7/2023 19:08:15'!
quantityHasOf: aBookToFind 
	^books count: [:book | book = aBookToFind ]! !


!Cart methodsFor: 'add' stamp: 'mp 6/7/2023 17:51:05'!
add: aBook
	books add: aBook.! !

!Cart methodsFor: 'add' stamp: 'mp 6/7/2023 19:36:37'!
add: aBook quantity: bookQuantity 
	
	self validateQuantity: bookQuantity.
	
	books add: aBook withOccurrences: bookQuantity ! !


!Cart methodsFor: 'testing' stamp: 'mp 6/7/2023 17:50:46'!
hasBook: aBook

	^books anySatisfy: [:book | aBook = book].! !

!Cart methodsFor: 'testing' stamp: 'mp 6/7/2023 17:42:54'!
isEmpty
	^books isEmpty ! !

!Cart methodsFor: 'testing' stamp: 'mp 6/7/2023 19:38:17'!
validateQuantity: bookQuantity

	^ (bookQuantity < 1) ifTrue: [self error: self class invalidBookQuantityErrorDescription ]! !


!Cart methodsFor: 'initialization' stamp: 'mp 6/7/2023 17:42:45'!
initialize
	books := OrderedCollection new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'error description' stamp: 'mp 6/7/2023 19:37:39'!
invalidBookQuantityErrorDescription
	
	^'Can not add less than one unit of book'! !
