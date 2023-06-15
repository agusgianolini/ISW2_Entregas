!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: 'testObjectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test01NewCartsAreCreatedEmpty

	self assert: testObjectsFactory createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [ cart add: testObjectsFactory itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSellByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 0 of: testObjectsFactory itemSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 2 of: testObjectsFactory itemNotSellByTheStore  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test06CartRemembersAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSellByTheStore.
	self assert: (cart includes: testObjectsFactory itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self deny: (cart includes: testObjectsFactory itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: 2 of: testObjectsFactory itemSellByTheStore.
	self assert: (cart occurrencesOf: testObjectsFactory itemSellByTheStore) = 2! !


!CartTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 18:09'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'testObjectsFactory debitBehavior'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:50'!
test01CanNotCheckoutAnEmptyCart

	| salesBook |
	
	salesBook := OrderedCollection new.
	self 
		should: [ Cashier 
			toCheckout: testObjectsFactory createCart 
			charging: testObjectsFactory notExpiredCreditCard 
			throught: self
			on: testObjectsFactory today
			registeringOn:  salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier cartCanNotBeEmptyErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:51'!
test02CalculatedTotalIsCorrect

	| cart cashier |
	
	cart := testObjectsFactory createCart.
	cart add: 2 of: testObjectsFactory itemSellByTheStore.
	
	cashier :=  Cashier
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard 
		throught: self
		on: testObjectsFactory today 
		registeringOn: OrderedCollection new.
		
	self assert: cashier checkOut = (testObjectsFactory itemSellByTheStorePrice * 2)! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:51'!
test03CanNotCheckoutWithAnExpiredCreditCart

	| cart salesBook |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	salesBook := OrderedCollection new.
	
	self
		should: [ Cashier 
				toCheckout: cart 
				charging: testObjectsFactory expiredCreditCard 
				throught: self
				on: testObjectsFactory today
				registeringOn: salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = Cashier canNotChargeAnExpiredCreditCardErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'ARM 6/11/2023 13:50:03'!
test04CheckoutRegistersASale

	| cart cashier salesBook total |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	total := cashier checkOut.
					
	self assert: salesBook size = 1.
	self assert: salesBook first = total.! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 19:00'!
test05CashierChargesCreditCardUsingMerchantProcessor

	| cart cashier salesBook total creditCard debitedAmout debitedCreditCard  |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	debitBehavior := [ :anAmount :aCreditCard | 
		debitedAmout := anAmount.
		debitedCreditCard := aCreditCard ].
	total := cashier checkOut.
					
	self assert: debitedCreditCard = creditCard.
	self assert: debitedAmout = total.! !

!CashierTest methodsFor: 'tests' stamp: 'ARM 6/11/2023 14:10:01'!
test06CashierDoesNotSaleWhenTheCreditCardHasNoCredit

	| cart cashier salesBook creditCard |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 	debitBehavior := [ :anAmount :aCreditCard | self error: self creditCardHasNoCreditErrorMessage].
	
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	self 
		should: [cashier checkOut ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = self creditCardHasNoCreditErrorMessage.
			self assert: salesBook isEmpty ]! !


!CashierTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 19:03'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.
	debitBehavior := [ :anAmount :aCreditCard | ]! !


!CashierTest methodsFor: 'merchant processor protocol' stamp: 'ARM 6/11/2023 14:09:42'!
creditCardHasNoCreditErrorMessage
	
	^'Credit card has no credit'! !

!CashierTest methodsFor: 'merchant processor protocol' stamp: 'HernanWilkinson 6/17/2013 19:02'!
debit: anAmount from: aCreditCard 

	^debitBehavior value: anAmount value: aCreditCard ! !


!classDefinition: #RestInterfaceTest category: 'TusLibros'!
TestCase subclass: #RestInterfaceTest
	instanceVariableNames: 'testObjectsFactory sessionClockBehavior restInterface'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!RestInterfaceTest methodsFor: 'behavior simulators' stamp: 'mp 6/14/2023 22:02:05'!
now
	
	^sessionClockBehavior value! !


!RestInterfaceTest methodsFor: 'setUp/tearDown' stamp: 'mp 6/15/2023 10:07:37'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.
	sessionClockBehavior := [			testObjectsFactory today 		].
	restInterface := self createDefaultInterface
! !


!RestInterfaceTest methodsFor: 'support' stamp: 'mp 6/15/2023 10:00:29'!
assertRaiseError: aBlock withDescription: anErrorMessage	
	self
		should: aBlock
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = anErrorMessage ]! !


!RestInterfaceTest methodsFor: 'tests' stamp: 'mp 6/15/2023 10:08:33'!
test01CanCreateCartWithValidUserAndPassword

	| cartID |
	
	cartID := restInterface createCartFor: self validUser authenticatedWith: self validUserPassword.
	
	self assert: (restInterface listCartIdentifiedAs: cartID) isEmpty! !

!RestInterfaceTest methodsFor: 'tests' stamp: 'mp 6/15/2023 10:08:46'!
test02CanNotCreateCartWithInvalidUser

	self 
		assertRaiseError: [restInterface createCartFor: self invalidUser authenticatedWith: self validUserPassword ] 
		withDescription: restInterface invalidUserAndOrPasswordErrorDescription! !

!RestInterfaceTest methodsFor: 'tests' stamp: 'mp 6/15/2023 10:08:57'!
test03CanNotCreateCartWithInvalidPassword

	self 
		assertRaiseError: [restInterface createCartFor: self validUser authenticatedWith: self invalidPassword ] 
		withDescription: restInterface invalidUserAndOrPasswordErrorDescription
	! !

!RestInterfaceTest methodsFor: 'tests' stamp: 'mp 6/15/2023 10:09:12'!
test04CanAddItemsToACreatedCart

	| cartId |

	cartId := restInterface createCartFor: self validUser authenticatedWith: self validUserPassword.
	self
		shouldnt: [restInterface add: self validBook quantity: 1 toCartIdentifiedAs: cartId]
		raise: Error - MessageNotUnderstood
		! !

!RestInterfaceTest methodsFor: 'tests' stamp: 'mp 6/15/2023 10:15:34'!
test05CanNotAddItemToNotCreatedCart

	self 
		assertRaiseError: [restInterface add: self validBook quantity: 1 toCartIdentifiedAs: self invalidCartId ] 
		withDescription: restInterface invalidCartIdErrorDescription! !

!RestInterfaceTest methodsFor: 'tests' stamp: 'mp 6/15/2023 10:09:38'!
test06CanNotAddItemNotSellByTheStore

	| cartId |

	cartId := restInterface createCartFor: self validUser authenticatedWith: self validUserPassword.
	
	self 
		assertRaiseError: [restInterface add: self invalidBook quantity: 1 toCartIdentifiedAs: cartId ] 
		withDescription: restInterface invalidItemErrorMessage
		! !

!RestInterfaceTest methodsFor: 'tests' stamp: 'mp 6/15/2023 10:10:18'!
test07ListCartOfAnEmptyCartReturnsAnEmptyBag

	| cartId |

	cartId := restInterface createCartFor: self validUser authenticatedWith: self validUserPassword.
	
	self assert: (restInterface listCartIdentifiedAs: cartId) isEmpty 
	! !

!RestInterfaceTest methodsFor: 'tests' stamp: 'mp 6/15/2023 10:16:41'!
test08CanNotListCartOfInvalidCartId

	self 
		assertRaiseError: [restInterface listCartIdentifiedAs: self invalidCartId] 
		withDescription: restInterface invalidCartIdErrorDescription.
! !

!RestInterfaceTest methodsFor: 'tests' stamp: 'mp 6/15/2023 10:10:44'!
test09ListCartReturnsTheRightNumberOfItems

	| cartId cartContent |

	cartId := restInterface createCartFor: self validUser authenticatedWith: self validUserPassword.
	restInterface add: self validBook quantity: 1 toCartIdentifiedAs: cartId.
	restInterface add: self anotherValidBook quantity: 2 toCartIdentifiedAs: cartId.
	cartContent := restInterface listCartIdentifiedAs: cartId.
	
	self assert: (cartContent occurrencesOf: self validBook) = 1. 
	self assert: (cartContent occurrencesOf: self anotherValidBook) = 2
! !

!RestInterfaceTest methodsFor: 'tests' stamp: 'mp 6/15/2023 10:11:03'!
test10CanCheckoutACart

	| cartId  |

	cartId := restInterface createCartFor: self validUser authenticatedWith: self validUserPassword.
	restInterface add: self validBook quantity: 1 toCartIdentifiedAs: cartId.
	
	self
		shouldnt: [restInterface 
			checkOutCartIdentifiedAs: cartId 
			withCreditCardNumbered: '1111222233334444' 
			ownedBy: 'Juan Perez' 
			expiringOn: testObjectsFactory notExpiredMonthOfYear ]
		raise: Error - MessageNotUnderstood
		
		! !

!RestInterfaceTest methodsFor: 'tests' stamp: 'mp 6/15/2023 10:17:44'!
test11CanNotCheckoutANotCreatedCart

	self 
		assertRaiseError:  [restInterface 
			checkOutCartIdentifiedAs: self invalidCartId  
			withCreditCardNumbered: '1111222233334444' 
			ownedBy: 'Juan Perez' 
			expiringOn: testObjectsFactory notExpiredMonthOfYear ]
		withDescription: restInterface invalidCartIdErrorDescription.

	! !

!RestInterfaceTest methodsFor: 'tests' stamp: 'mp 6/15/2023 10:18:24'!
test12CanNotCheckoutAnEmptyCart

	| cartId |

	cartId := restInterface createCartFor: self validUser authenticatedWith: self validUserPassword.
	
	self 
		assertRaiseError:  [restInterface 
			checkOutCartIdentifiedAs: cartId 
			withCreditCardNumbered: '1111222233334444' 
			ownedBy: 'Juan Perez' 
			expiringOn: testObjectsFactory notExpiredMonthOfYear ]
		withDescription: restInterface cartCanNotBeEmptyErrorMessage
	! !

!RestInterfaceTest methodsFor: 'tests' stamp: 'mp 6/15/2023 10:20:27'!
test13CanNotAddAnItemToCartWhenTheTimerSessionExpires

	| cartId |

	cartId := restInterface createCartFor: self validUser authenticatedWith: self validUserPassword.
	
	sessionClockBehavior := [			testObjectsFactory todayWithThirtyMoreMinutes ].
	
	self 
		assertRaiseError:  [restInterface add: self validBook quantity: 1 toCartIdentifiedAs: cartId ]
		withDescription: restInterface signalSessionExpired! !

!RestInterfaceTest methodsFor: 'tests' stamp: 'mp 6/15/2023 10:12:01'!
test14AddAnItemToCartUpdateTheTimeOfTheLastCartActivity

	| cartId |

	cartId := restInterface createCartFor: self validUser authenticatedWith: self validUserPassword.
	
	sessionClockBehavior := [			testObjectsFactory todayWithTwentyMoreMinutes].
	
	restInterface add: self validBook quantity: 1 toCartIdentifiedAs: cartId.
	
	sessionClockBehavior := [			testObjectsFactory todayWithFortyMoreMinutes ].
	
	self
		shouldnt: [restInterface add: self validBook quantity: 1 toCartIdentifiedAs: cartId ]
		raise: Error - MessageNotUnderstood	
		
		! !

!RestInterfaceTest methodsFor: 'tests' stamp: 'mp 6/15/2023 10:21:20'!
test15CanNotListCartWhenTheTimerSessionExpires

	| cartId |

	cartId := restInterface createCartFor: self validUser authenticatedWith: self validUserPassword.
	restInterface add: self validBook quantity: 1 toCartIdentifiedAs: cartId.
	
	sessionClockBehavior := [			testObjectsFactory todayWithThirtyMoreMinutes ].
	
	self 
		assertRaiseError:  [ restInterface listCartIdentifiedAs: cartId ]
		withDescription: restInterface signalSessionExpired
	! !

!RestInterfaceTest methodsFor: 'tests' stamp: 'mp 6/15/2023 10:12:42'!
test16ListACartUpdateTheTimeOfTheLastCartActivity

	| cartId |

	cartId := restInterface createCartFor: self validUser authenticatedWith: self validUserPassword.
	
	sessionClockBehavior := [			testObjectsFactory todayWithTwentyMoreMinutes ].
	
	restInterface listCartIdentifiedAs: cartId.
	
	sessionClockBehavior := [			testObjectsFactory todayWithFortyMoreMinutes ].
	
	self
		shouldnt: [restInterface listCartIdentifiedAs: cartId ]
		raise: Error - MessageNotUnderstood	
		
		! !

!RestInterfaceTest methodsFor: 'tests' stamp: 'mp 6/15/2023 10:21:57'!
test17CanNotCheckoutCartWhenTheTimerSessionExpires

	| cartId |

	cartId := restInterface createCartFor: self validUser authenticatedWith: self validUserPassword.
	restInterface add: self validBook quantity: 1 toCartIdentifiedAs: cartId.
	
	sessionClockBehavior := [			testObjectsFactory todayWithThirtyMoreMinutes ].
	
	self 
		assertRaiseError:  [ restInterface 
			checkOutCartIdentifiedAs: cartId 
			withCreditCardNumbered: '1111222233334444' 
			ownedBy: 'Juan Perez' 
			expiringOn: testObjectsFactory notExpiredMonthOfYear ]
		withDescription: restInterface signalSessionExpired
! !


!RestInterfaceTest methodsFor: 'users and passwords' stamp: 'HernanWilkinson 6/21/2013 23:06'!
invalidPassword
	
	^'invalidPassword'! !

!RestInterfaceTest methodsFor: 'users and passwords' stamp: 'HernanWilkinson 6/21/2013 22:30'!
invalidUser

	^'invalidUser'! !

!RestInterfaceTest methodsFor: 'users and passwords' stamp: 'ARM 6/11/2023 13:57:02'!
is: aUser authenticatingWith: aPassword 
	| storedPassword |
	
	storedPassword := self validUsersAndPasswords at: aUser ifAbsent: [ ^false ].
	^aPassword = storedPassword ! !

!RestInterfaceTest methodsFor: 'users and passwords' stamp: 'HernanWilkinson 6/21/2013 22:27'!
validUser
	
	^'validUser'! !

!RestInterfaceTest methodsFor: 'users and passwords' stamp: 'HernanWilkinson 6/21/2013 22:28'!
validUserPassword
	
	^'validUserPassword'! !

!RestInterfaceTest methodsFor: 'users and passwords' stamp: 'HernanWilkinson 6/21/2013 22:43'!
validUsersAndPasswords
	
	^Dictionary new
		at: self validUser put: self validUserPassword;
		yourself! !


!RestInterfaceTest methodsFor: 'rest interface' stamp: 'mp 6/14/2023 21:25:30'!
createDefaultInterface
	
	^RestInterface
		authenticatingWith: self
		acceptingItemsOf: testObjectsFactory defaultCatalog
		clock: self
		merchantProcessor: self.! !


!RestInterfaceTest methodsFor: 'books' stamp: 'HernanWilkinson 6/22/2013 00:15'!
anotherValidBook
	
	^testObjectsFactory anotherItemSellByTheStore ! !

!RestInterfaceTest methodsFor: 'books' stamp: 'HernanWilkinson 6/21/2013 23:49'!
invalidBook

	^testObjectsFactory itemNotSellByTheStore ! !

!RestInterfaceTest methodsFor: 'books' stamp: 'HernanWilkinson 6/21/2013 23:50'!
validBook
	
	^testObjectsFactory itemSellByTheStore ! !


!RestInterfaceTest methodsFor: 'cart' stamp: 'HernanWilkinson 6/21/2013 23:25'!
invalidCartId
	
	"Devuelvo nil porque seguro que siempre sera un id invalido, no importa que sea el id - Hernan"
	^nil! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'catalog items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/21/2013 23:59'!
invalidItemErrorMessage
	
	^self class invalidItemErrorMessage ! !

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/22/2013 00:00'!
invalidQuantityErrorMessage
	
	^self class invalidQuantityErrorMessage ! !


!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:06'!
assertIsValidItem: anItem

	(catalog includesKey: anItem) ifFalse: [ self error: self invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'content' stamp: 'HernanWilkinson 6/22/2013 00:20'!
content
	
	^Bag new
		addAll: items;
		yourself ! !


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


!Cart methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2013 19:09'!
total

	^ items sum: [ :anItem | catalog at: anItem ]! !


!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:44'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:51'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	1 to: aQuantity do: [ :aNumber | items add: anItem ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/21/2013 23:59'!
invalidItemErrorMessage
	
	^'Item is not in catalog'! !

!Cart class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/22/2013 00:00'!
invalidQuantityErrorMessage
	
	^'Invalid number of items'! !


!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'cart salesBook merchantProcessor creditCard total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:08'!
calculateTotal

	total := cart total.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'ARM 6/11/2023 13:49:52'!
createSale

	^ total
! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
debitTotal

	merchantProcessor debit: total from: creditCard.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
registerSale

	salesBook add: self createSale! !


!Cashier methodsFor: 'checkout' stamp: 'HernanWilkinson 6/17/2013 19:06'!
checkOut

	self calculateTotal.
	self debitTotal.
	self registerSale.

	^ total! !


!Cashier methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:53'!
initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook
	
	cart := aCart.
	creditCard := aCreditCard.
	merchantProcessor := aMerchantProcessor.
	salesBook := aSalesBook! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:22'!
assertIsNotEmpty: aCart 
	
	aCart isEmpty ifTrue: [self error: self cartCanNotBeEmptyErrorMessage ]! !

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:23'!
assertIsNotExpired: aCreditCard on: aDate
	
	(aCreditCard isExpiredOn: aDate) ifTrue: [ self error: self canNotChargeAnExpiredCreditCardErrorMessage ]! !


!Cashier class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:51'!
toCheckout: aCart charging: aCreditCard throught: aMerchantProcessor on: aDate registeringOn: aSalesBook
	
	self assertIsNotEmpty: aCart.
	self assertIsNotExpired: aCreditCard on: aDate.
	
	^self new initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook! !


!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 18:21'!
canNotChargeAnExpiredCreditCardErrorMessage
	
	^'Can not charge an expired credit card'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:56'!
cartCanNotBeEmptyErrorMessage
	
	^'Can not check out an empty cart'! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'expiration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 18:39'!
isExpiredOn: aDate 
	
	^expiration start < (Month month: aDate monthIndex year: aDate yearNumber) start ! !


!CreditCard methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:38'!
initializeExpiringOn: aMonth 
	
	expiration := aMonth ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:38'!
expiringOn: aMonth 
	
	^self new initializeExpiringOn: aMonth! !


!classDefinition: #RestInterface category: 'TusLibros'!
Object subclass: #RestInterface
	instanceVariableNames: 'authenticationSystem carts catalog lastId merchantProcessor salesBook clock cartsSessions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!RestInterface methodsFor: 'date' stamp: 'mp 6/14/2023 22:03:10'!
today
	
	^clock now! !


!RestInterface methodsFor: 'cart' stamp: 'mp 6/15/2023 00:31:05'!
add: aBook quantity: anAmount toCartIdentifiedAs: aCartId

	| cart |
	
	cart := carts at: aCartId ifAbsent: [ self signalInvalidCartId ].
	
	self validateSessionOf: aCartId .
			
	cart add: anAmount of: aBook.
	self updateLastActivityFor: aCartId .! !

!RestInterface methodsFor: 'cart' stamp: 'mp 6/15/2023 00:47:54'!
checkOutCartIdentifiedAs: aCartId withCreditCardNumbered: aCreditCartNumber ownedBy: anOwner expiringOn: anExpirationMonthOfYear

	| cart |
	
	cart := carts at: aCartId ifAbsent: [self signalInvalidCartId ].
	self validateSessionOf: aCartId .
	
	Cashier 
		toCheckout: cart 
		charging: (CreditCard expiringOn: anExpirationMonthOfYear) 
		throught: merchantProcessor 
		on: self today 
		registeringOn: salesBook! !

!RestInterface methodsFor: 'cart' stamp: 'mp 6/15/2023 00:04:26'!
createCartFor: aUser authenticatedWith: aPassword

	| cartId |
	
	(self is: aUser authenticatingWith: aPassword) ifFalse: [ self signalInvalidUserAndOrPassword ].
	
	cartId := self generateCartId.
	carts at: cartId put: (Cart acceptingItemsOf: catalog).	
	self updateLastActivityFor: cartId.
	
	^cartId ! !

!RestInterface methodsFor: 'cart' stamp: 'HernanWilkinson 6/21/2013 23:32'!
generateCartId
	
	"Recuerden que esto es un ejemplo, por lo que voy a generar ids numericos consecutivos, pero en una 
	implementacion real no deberian se numeros consecutivos ni nada que genere problemas de seguridad - Hernan"
	
	lastId := lastId + 1.
	^lastId! !

!RestInterface methodsFor: 'cart' stamp: 'mp 6/15/2023 00:41:33'!
listCartIdentifiedAs: aCartId

	| cart |
	
	cart := carts at: aCartId ifAbsent: [ self signalInvalidCartId ].
	self validateSessionOf: aCartId .
	self updateLastActivityFor: aCartId .
	
	^cart content! !


!RestInterface methodsFor: 'initialization' stamp: 'mp 6/14/2023 22:18:57'!
initializeAuthenticatingWith: anAuthenticationSystem acceptingItemsOf: aCatalog clock: aClock merchantProcessor: anMP

	authenticationSystem := anAuthenticationSystem.
	catalog := aCatalog.
	carts := Dictionary new.
	cartsSessions := Dictionary new.
	lastId := 0.
	clock := aClock.
	merchantProcessor := anMP! !


!RestInterface methodsFor: 'error description' stamp: 'HernanWilkinson 6/22/2013 11:17'!
cartCanNotBeEmptyErrorMessage
	
	^Cashier cartCanNotBeEmptyErrorMessage ! !

!RestInterface methodsFor: 'error description' stamp: 'HernanWilkinson 6/21/2013 23:27'!
invalidCartIdErrorDescription
	
	^'Invalid cart id'! !

!RestInterface methodsFor: 'error description' stamp: 'HernanWilkinson 6/21/2013 23:59'!
invalidItemErrorMessage
	
	^Cart invalidItemErrorMessage ! !

!RestInterface methodsFor: 'error description' stamp: 'HernanWilkinson 6/21/2013 23:03'!
invalidUserAndOrPasswordErrorDescription
	
	^'Invalid user and/or password'! !


!RestInterface methodsFor: 'session' stamp: 'mp 6/15/2023 00:28:07'!
sessionDuration

	^ Duration minutes: 30! !

!RestInterface methodsFor: 'session' stamp: 'mp 6/15/2023 00:04:26'!
updateLastActivityFor: cartId

	^ cartsSessions at: cartId put: self today! !

!RestInterface methodsFor: 'session' stamp: 'mp 6/15/2023 00:30:10'!
validateSessionOf: aCartId
	| cartSession |
	
	cartSession := cartsSessions at: aCartId.
	
	((cartSession subtractFrom: self today ) < (self sessionDuration)) 
		ifFalse: 	[self error: self signalSessionExpired].! !


!RestInterface methodsFor: 'exception signals' stamp: 'HernanWilkinson 6/21/2013 23:27'!
signalInvalidCartId
	
	self error: self invalidCartIdErrorDescription ! !

!RestInterface methodsFor: 'exception signals' stamp: 'HernanWilkinson 6/21/2013 23:02'!
signalInvalidUserAndOrPassword
	
	self error: self invalidUserAndOrPasswordErrorDescription! !

!RestInterface methodsFor: 'exception signals' stamp: 'mp 6/15/2023 00:05:23'!
signalSessionExpired

	^ 'Session has expired. The request could not be processed'! !


!RestInterface methodsFor: 'authentication' stamp: 'ARM 6/11/2023 13:54:36'!
is: aUser authenticatingWith: aPassword 
	
	^authenticationSystem is: aUser authenticatingWith: aPassword 
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RestInterface class' category: 'TusLibros'!
RestInterface class
	instanceVariableNames: ''!

!RestInterface class methodsFor: 'instance creation' stamp: 'mp 6/14/2023 21:26:10'!
authenticatingWith: aValidUsersAndPasswords acceptingItemsOf: aCatalog clock: aClock merchantProcessor: anMP

	^self new initializeAuthenticatingWith: aValidUsersAndPasswords acceptingItemsOf: aCatalog clock: aClock merchantProcessor: anMP! !


!classDefinition: #StoreTestObjectsFactory category: 'TusLibros'!
Object subclass: #StoreTestObjectsFactory
	instanceVariableNames: 'today'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/22/2013 00:16'!
anotherItemSellByTheStore
	
	^'anotherValidBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/22/2013 00:16'!
anotherItemSellByTheStorePrice
	
	^15! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemSellByTheStore
	
	^ 'validBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemSellByTheStorePrice
	
	^10! !


!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'HernanWilkinson 6/17/2013 18:08'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'HernanWilkinson 6/22/2013 00:16'!
defaultCatalog
	
	^ Dictionary new
		at: self itemSellByTheStore put: self itemSellByTheStorePrice;
		at: self anotherItemSellByTheStore put: self anotherItemSellByTheStorePrice;
		yourself ! !


!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/17/2013 18:37'!
expiredCreditCard
	
	^CreditCard expiringOn: (Month month: today monthIndex year: today yearNumber - 1)! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/22/2013 11:06'!
notExpiredCreditCard
	
	^CreditCard expiringOn: self notExpiredMonthOfYear! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/22/2013 11:06'!
notExpiredMonthOfYear

	^ Month month: today monthIndex year: today yearNumber + 1! !


!StoreTestObjectsFactory methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:37'!
initialize

	today := DateAndTime now! !


!StoreTestObjectsFactory methodsFor: 'date' stamp: 'HernanWilkinson 6/17/2013 18:37'!
today
	
	^ today! !

!StoreTestObjectsFactory methodsFor: 'date' stamp: 'mp 6/15/2023 00:38:18'!
todayWithFortyMoreMinutes
	
	^ self todayWithMoreMinutes: 40! !

!StoreTestObjectsFactory methodsFor: 'date' stamp: 'mp 6/15/2023 00:37:56'!
todayWithMoreMinutes: aQuantityOfMinutes
	
	^ today 	+ (Duration minutes: aQuantityOfMinutes)! !

!StoreTestObjectsFactory methodsFor: 'date' stamp: 'mp 6/15/2023 00:38:39'!
todayWithThirtyMoreMinutes
	
	^ self todayWithMoreMinutes: 30! !

!StoreTestObjectsFactory methodsFor: 'date' stamp: 'mp 6/15/2023 00:38:29'!
todayWithTwentyMoreMinutes
	
	^ self todayWithMoreMinutes: 20! !
