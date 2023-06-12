!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: 'testFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'mp 6/11/2023 21:44:46'!
test01NewCartsAreCreatedEmpty

	self assert: (testFactory createCart) isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'mp 6/11/2023 21:46:34'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := testFactory createCart.
	
	self 
		should: [ cart add: testFactory itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'mp 6/11/2023 21:48:40'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := testFactory createCart.
	
	cart add: ( testFactory itemSellByTheStore ).
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'mp 6/11/2023 21:48:40'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := testFactory createCart.
	
	self 
		should: [cart add: 0 of: ( testFactory itemSellByTheStore ) ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'mp 6/11/2023 21:46:29'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := testFactory createCart.
	
	self 
		should: [cart add: 2 of: testFactory itemNotSellByTheStore  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'mp 6/11/2023 21:48:40'!
test06CartRemembersAddedItems

	| cart |
	
	cart := testFactory createCart.
	
	cart add: ( testFactory itemSellByTheStore ).
	self assert: (cart includes: ( testFactory itemSellByTheStore ))! !

!CartTest methodsFor: 'tests' stamp: 'mp 6/11/2023 21:48:40'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := testFactory createCart.
	
	self deny: (cart includes: ( testFactory itemSellByTheStore ))! !

!CartTest methodsFor: 'tests' stamp: 'mp 6/11/2023 21:48:40'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := testFactory createCart.
	
	cart add: 2 of: ( testFactory itemSellByTheStore ).
	self assert: (cart occurrencesOf: ( testFactory itemSellByTheStore )) = 2! !


!CartTest methodsFor: 'setUp' stamp: 'mp 6/11/2023 21:44:12'!
setUp

	testFactory := TusLibrosTestFactory new! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'testFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'setUp' stamp: 'mp 6/11/2023 21:41:06'!
setUp
	
	testFactory := TusLibrosTestFactory new.! !


!CashierTest methodsFor: 'support' stamp: 'mp 6/11/2023 20:38:22'!
cashierOnJuneWithMerchantProcessorSimulatorWithSalesBook: salesBook

	^ Cashier onDate: June, 2023 withSalesBook: salesBook andMerchantProcessor: (MerchantProcessorSimulator new).! !


!CashierTest methodsFor: 'tests' stamp: 'mp 6/11/2023 21:43:19'!
test01CheckoutOnEmptyCartShouldRiseError
	|cart cashier salesBook|
	
	cart := testFactory createCart .
	salesBook:= OrderedCollection new.
	
	cashier := self cashierOnJuneWithMerchantProcessorSimulatorWithSalesBook: salesBook.
	
	self 
	should: [cashier checkout: cart withCard: (CreditCard withNumber: 1000 expiredOn: July, 2030)] 
		raise: Error
		withExceptionDo: [:anError |
			self assert: Cashier canNotCheckoutAnEmptyCartErrorDescription equals: anError messageText.
			self assert: salesBook isEmpty ]
	! !

!CashierTest methodsFor: 'tests' stamp: 'mp 6/11/2023 21:47:22'!
test02CheckoutOnACartWithOneProductShouldNotRaiseError
	|cart cashier salesBook|
	
	cart := testFactory createCart .
	cart add: ( testFactory itemSellByTheStore ) .
	
	salesBook:= OrderedCollection new.
	
	cashier := self cashierOnJuneWithMerchantProcessorSimulatorWithSalesBook: salesBook.
	
	cashier checkout: cart withCard: (CreditCard withNumber: 1000 expiredOn: July, 2030).
	! !

!CashierTest methodsFor: 'tests' stamp: 'mp 6/11/2023 21:47:22'!
test03CheckoutOnAExpiredCardShouldRaiseError
	|cart cashier expiredDate salesBook|
	
	cart := testFactory createCart .
	cart add: ( testFactory itemSellByTheStore ) .
	
	salesBook := OrderedCollection new.
	
	cashier := self cashierOnJuneWithMerchantProcessorSimulatorWithSalesBook: salesBook.
	expiredDate:= CreditCard withNumber: 1000 expiredOn: May, 2020.
	
	self 
	should: [cashier checkout: cart withCard: expiredDate] 
		raise: Error
		withExceptionDo: [:anError |
			self assert: 'Expired credit card' equals: anError messageText.
			self assert: salesBook isEmpty  ]
	
	! !

!CashierTest methodsFor: 'tests' stamp: 'mp 6/11/2023 21:47:22'!
test04CheckoutOnACartWithAProductShouldBeRegisteredOnSalesBook
	|cart cashier expiredDate salesBook|
	
	cart := testFactory createCart .
	cart add: ( testFactory itemSellByTheStore ) .
	salesBook:= OrderedCollection new.
	
	cashier := self cashierOnJuneWithMerchantProcessorSimulatorWithSalesBook: salesBook.
	expiredDate:= CreditCard withNumber: 1000 expiredOn: July, 2030.
	
	cashier checkout: cart withCard: expiredDate.
	
	self deny: salesBook isEmpty.
	! !

!CashierTest methodsFor: 'tests' stamp: 'mp 6/11/2023 21:47:22'!
test05CheckoutOnAStolenCardShouldRaiseError
	|cart cashier stolenCard salesBook|
	
	cart := testFactory createCart .
	cart add: ( testFactory itemSellByTheStore ) .
	
	salesBook := OrderedCollection new.
	
	cashier := self cashierOnJuneWithMerchantProcessorSimulatorWithSalesBook: salesBook.
	stolenCard := CreditCard withNumber: 1111 expiredOn: July, 2030.
	
	self 
	should: [cashier checkout: cart withCard: stolenCard] 
		raise: Error 
		withExceptionDo: [:anError |
			self assert: 'Stolen credit card' equals: anError messageText.
			self assert: salesBook isEmpty  ]
	
	! !

!CashierTest methodsFor: 'tests' stamp: 'mp 6/11/2023 21:47:22'!
test06CheckoutOnACardWithInsufficientFundsShouldRaiseError
	|cart cashier insuficientFundsCard salesBook|
	
	cart := testFactory createCart .
	cart add: ( testFactory itemSellByTheStore ) .
	
	salesBook := OrderedCollection new.
	
	cashier := self cashierOnJuneWithMerchantProcessorSimulatorWithSalesBook: salesBook.
	insuficientFundsCard := CreditCard withNumber: 2222 expiredOn: July, 2030.
	
	self 
	should: [cashier checkout: cart withCard: insuficientFundsCard] 
		raise: Error 
		withExceptionDo: [:anError |
			self assert: 'The account has insufficient funds' equals: anError messageText.
			self assert: salesBook isEmpty  ]
	
	! !

!CashierTest methodsFor: 'tests' stamp: 'mp 6/11/2023 21:57:38'!
test07CheckoutOnAValidCardAndCartShouldRegisterTheAmmountOnTheSalesBook
	|cart cashier aCreditCard salesBook expectedSalesBook|
	
	cart := testFactory createCart .
	cart add: 3 of: ( testFactory itemSellByTheStore ) .	
	cart add: 2 of: ( testFactory anotherItemSellByTheStore ) .
	
	salesBook := OrderedCollection new.
	expectedSalesBook := OrderedCollection with: 7400 * peso.
	
	cashier := self cashierOnJuneWithMerchantProcessorSimulatorWithSalesBook: salesBook.
	aCreditCard := CreditCard withNumber: 1000 expiredOn: July, 2030.
	
	cashier checkout: cart withCard: aCreditCard.
	
	self assert: cashier salesBook equals: expectedSalesBook .
	
	! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'catalog items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidItemErrorMessage
	
	^'Item is not in catalog'! !

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidQuantityErrorMessage
	
	^'Invalid number of items'! !


!Cart methodsFor: 'assertions' stamp: 'mp 6/11/2023 21:35:50'!
assertIsValidItem: anItem

	(catalog includesKey: anItem) ifFalse: [ self error: self invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 17:48'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := OrderedCollection new.! !


!Cart methodsFor: 'queries' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:44'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:51'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	1 to: aQuantity do: [ :aNumber | items add: anItem ]! !


!Cart methodsFor: 'balance' stamp: 'mp 6/11/2023 22:15:38'!
balance
	
	^items sum: [:product  | catalog at: product ] ifEmpty: [^0].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'currentDate salesBook merchantProcessor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'as yet unclassified' stamp: 'mp 6/11/2023 22:02:58'!
checkout: aCart withCard: aCreditCard

	aCart  isEmpty ifTrue: [self error: self class canNotCheckoutAnEmptyCartErrorDescription ].
	
	(currentDate > aCreditCard expirationDate) ifTrue:[self error: 'Expired credit card'].
	
	merchantProcessor checkout: (aCart balance) with: aCreditCard.
	
	salesBook add: aCart balance.! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'mp 6/11/2023 20:05:18'!
initializeWithMonth: aMonthOfAYear andSalesBook: aSalesBook andMerchantProcessor: aMerchantProcessor

	currentDate:= aMonthOfAYear .
	salesBook := aSalesBook.
	merchantProcessor := aMerchantProcessor. ! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'mp 6/11/2023 21:59:52'!
salesBook

	^salesBook copy! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'as yet unclassified' stamp: 'mp 6/8/2023 20:00:51'!
canNotCheckoutAnEmptyCartErrorDescription
	
	^'Can not checkout an empty cart'! !

!Cashier class methodsFor: 'as yet unclassified' stamp: 'mp 6/11/2023 20:04:27'!
onDate: aMonthOfAYear withSalesBook: aSalesBook andMerchantProcessor: aMerchantProcessor

	^self new initializeWithMonth: aMonthOfAYear andSalesBook:aSalesBook andMerchantProcessor: aMerchantProcessor.
	
	! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'number expirationDate'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'as yet unclassified' stamp: 'mp 6/11/2023 20:01:33'!
expirationDate
	^expirationDate ! !

!CreditCard methodsFor: 'as yet unclassified' stamp: 'mp 6/11/2023 19:54:23'!
initializeWithNumber: aCreditCardNumber expiredOn: anExpiredDate 
	
	number := aCreditCardNumber .
	expirationDate := anExpiredDate ! !

!CreditCard methodsFor: 'as yet unclassified' stamp: 'mp 6/11/2023 19:55:04'!
number
	^number ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'as yet unclassified' stamp: 'mp 6/11/2023 19:53:06'!
withNumber: aCreditCardNumber expiredOn: anExpiredDate

	^ self new initializeWithNumber: aCreditCardNumber expiredOn: anExpiredDate ! !


!classDefinition: #MerchantProcessorSimulator category: 'TusLibros'!
Object subclass: #MerchantProcessorSimulator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MerchantProcessorSimulator methodsFor: 'as yet unclassified' stamp: 'mp 6/11/2023 22:19:28'!
checkout: anAmmount with: aCreditCard

	(aCreditCard number = 1111) ifTrue: [self error: 'Stolen credit card'].
	
	(aCreditCard number = 2222 and: [anAmmount > (150 * peso)]) ifTrue: [self error: 'The account has insufficient funds'].
	! !


!classDefinition: #TusLibrosTestFactory category: 'TusLibros'!
Object subclass: #TusLibrosTestFactory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibrosTestFactory methodsFor: 'as yet unclassified' stamp: 'mp 6/11/2023 21:53:31'!
anotherItemSellByTheStore
	
	^ 'anotherValidBook'! !

!TusLibrosTestFactory methodsFor: 'as yet unclassified' stamp: 'mp 6/11/2023 21:39:20'!
createCart
	
	^Cart acceptingItemsOf: self defaultPriceCatalog ! !

!TusLibrosTestFactory methodsFor: 'as yet unclassified' stamp: 'mp 6/11/2023 21:52:59'!
defaultPriceCatalog
	|catalog|
	catalog := Dictionary new .
	catalog at: self itemSellByTheStore put: 2000 * peso.
	catalog at: self anotherItemSellByTheStore put: 700 * peso.
	
	^ catalog! !

!TusLibrosTestFactory methodsFor: 'as yet unclassified' stamp: 'mp 6/11/2023 21:38:54'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!TusLibrosTestFactory methodsFor: 'as yet unclassified' stamp: 'mp 6/11/2023 21:39:04'!
itemSellByTheStore
	
	^ 'validBook'! !
