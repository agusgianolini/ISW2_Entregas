!classDefinition: #Cart category: 'TusLibros-Model'!
Object subclass: #Cart
	instanceVariableNames: 'catalog items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/21/2013 23:59'!
invalidItemErrorMessage
	
	^self class invalidItemErrorMessage ! !

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/22/2013 00:00'!
invalidQuantityErrorMessage
	
	^self class invalidQuantityErrorMessage ! !


!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/22/2013 14:17'!
assertIsValidItem: anItem

	(catalog includesKey: anItem) ifFalse: [ self signalInvalidItem ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/22/2013 14:18'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [self signalInvalidQuantity ]! !


!Cart methodsFor: 'initialization' stamp: 'HernanWilkinson 6/22/2013 12:29'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := Bag new.! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:44'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/22/2013 12:31'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	items add: anItem withOccurrences: aQuantity ! !


!Cart methodsFor: 'content' stamp: 'HernanWilkinson 6/22/2013 12:17'!
catalog
	
	^ catalog! !

!Cart methodsFor: 'content' stamp: 'HernanWilkinson 6/22/2013 12:30'!
content
	
	^items copy! !

!Cart methodsFor: 'content' stamp: 'HernanWilkinson 6/23/2013 12:10'!
itemsAndQuantitiesDo: aBlock
	
	^ items contents keysAndValuesDo: [ :anItem :aQuantity | aBlock value: anItem value: aQuantity ]! !

!Cart methodsFor: 'content' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !


!Cart methodsFor: 'error signal' stamp: 'HernanWilkinson 6/22/2013 14:18'!
signalInvalidItem 

	self error: self invalidItemErrorMessage! !

!Cart methodsFor: 'error signal' stamp: 'HernanWilkinson 6/22/2013 14:19'!
signalInvalidQuantity 

	self error: self invalidQuantityErrorMessage ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros-Model'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!Cart class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/21/2013 23:59'!
invalidItemErrorMessage
	
	^'Item is not in catalog'! !

!Cart class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/22/2013 00:00'!
invalidQuantityErrorMessage
	
	^'Invalid number of items'! !


!classDefinition: #CartSession category: 'TusLibros-Model'!
Object subclass: #CartSession
	instanceVariableNames: 'owner cart lastUsedTime systemFacade'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!CartSession methodsFor: 'time/expiration' stamp: 'HernanWilkinson 6/17/2015 20:34'!
assertIsNotExpirtedAt: aTime

	(self isExpiredAt: aTime) ifTrue: [ self signalCartSessionExpired ]! !

!CartSession methodsFor: 'time/expiration' stamp: 'HernanWilkinson 6/17/2015 20:36'!
isExpiredAt: aTime 
	
	^ (lastUsedTime + systemFacade sessionDuration) < aTime! !

!CartSession methodsFor: 'time/expiration' stamp: 'HernanWilkinson 6/17/2015 20:36'!
now

	^systemFacade now! !

!CartSession methodsFor: 'time/expiration' stamp: 'HernanWilkinson 6/17/2015 20:37'!
today

	^systemFacade today! !


!CartSession methodsFor: 'session management' stamp: 'HernanWilkinson 6/17/2015 20:35'!
do: aBlock

	| now |

	now := self now.
	self assertIsNotExpirtedAt: now.
	
	^ [ aBlock value: self ] ensure: [ lastUsedTime := now  ]! !


!CartSession methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2015 20:36'!
initializeOwnedBy: aCustomer with: aCart on: aSystemFacade

	owner := aCustomer.
	cart := aCart.
	systemFacade := aSystemFacade.
	lastUsedTime := self now.! !


!CartSession methodsFor: 'error signal' stamp: 'HernanWilkinson 6/17/2015 20:37'!
signalCartSessionExpired
	
	self error: systemFacade sessionHasExpiredErrorDescription ! !


!CartSession methodsFor: 'cart' stamp: 'HernanWilkinson 6/17/2015 20:34'!
addToCart: anAmount of: aBook

	^cart add: anAmount of: aBook! !

!CartSession methodsFor: 'cart' stamp: 'HernanWilkinson 6/17/2015 20:35'!
cartContent

	^cart content! !

!CartSession methodsFor: 'cart' stamp: 'HAW 7/23/2020 15:22:42'!
checkOutCartWithCreditCardNumbered: aCreditCartNumber ownedBy: anOwner expiringOn: anExpirationMonthOfYear 

	^(Cashier 
		toCheckout: cart 
		ownedBy: owner
		charging: (CreditCard numbered: aCreditCartNumber ownedBy: anOwner expiringOn: anExpirationMonthOfYear) 
		throught: systemFacade merchantProcessor 
		on: self today 
		registeringOn: systemFacade salesBook) checkOut ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CartSession class' category: 'TusLibros-Model'!
CartSession class
	instanceVariableNames: ''!

!CartSession class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2015 20:37'!
ownedBy: aCustomer with: aCart on: aSystemFacade

	^self new initializeOwnedBy: aCustomer with: aCart on: aSystemFacade! !


!classDefinition: #Cashier category: 'TusLibros-Model'!
Object subclass: #Cashier
	instanceVariableNames: 'cart salesBook merchantProcessor creditCard owner ticket'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/22/2013 12:17'!
createLineItemOf: anItem quantity: aQuantity 

	^LineItem of: anItem quantity: aQuantity total: (self totalOf: anItem quantity: aQuantity) ! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/22/2013 12:25'!
createSale

	^ Sale doneBy: owner certifiedWith: ticket
! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/22/2013 12:28'!
createTicket

	| lineItems |
	
	lineItems := OrderedCollection new.
	cart itemsAndQuantitiesDo: [ :anItem :aQuantity | 
		lineItems add: (self createLineItemOf: anItem quantity: aQuantity)].
	
	ticket := Ticket of: lineItems 
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'HAW 5/5/2020 18:04:55'!
debitTotal

	| transactionId |
	
	transactionId := merchantProcessor debit: ticket total from: creditCard.
	ticket transactionId: transactionId! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
registerSale

	salesBook add: self createSale! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/22/2013 12:17'!
totalOf: anItem quantity: aQuantity 

	^(cart catalog at: anItem) * aQuantity  ! !


!Cashier methodsFor: 'checkout' stamp: 'HernanWilkinson 6/22/2013 12:28'!
checkOut

	self createTicket.
	self debitTotal.
	self registerSale.

	^ ticket ! !


!Cashier methodsFor: 'initialization' stamp: 'HernanWilkinson 6/22/2013 12:02'!
initializeToCheckout: aCart ownedBy: anOwner charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook
	
	cart := aCart.
	owner := anOwner.
	creditCard := aCreditCard.
	merchantProcessor := aMerchantProcessor.
	salesBook := aSalesBook! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros-Model'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/22/2013 14:22'!
assertIsNotEmpty: aCart 
	
	aCart isEmpty ifTrue: [self signalCartCanNotBeEmpty ]! !

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/22/2013 14:22'!
assertIsNotExpired: aCreditCard on: aDate
	
	(aCreditCard isExpiredOn: aDate) ifTrue: [self signalCanNotChargeAnExpiredCreditCard]! !


!Cashier class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/22/2013 12:00'!
toCheckout: aCart ownedBy: anOwner charging: aCreditCard throught: aMerchantProcessor on: aDate registeringOn: aSalesBook
	
	self assertIsNotEmpty: aCart.
	self assertIsNotExpired: aCreditCard on: aDate.
	
	^self new initializeToCheckout: aCart ownedBy: anOwner charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook! !


!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 18:21'!
canNotChargeAnExpiredCreditCardErrorMessage
	
	^'Can not charge an expired credit card'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:56'!
cartCanNotBeEmptyErrorMessage
	
	^'Can not check out an empty cart'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 19:02'!
creditCardHasNoCreditErrorMessage
	
	^'Credit card has no credit'! !


!Cashier class methodsFor: 'error signal' stamp: 'HernanWilkinson 6/22/2013 14:22'!
signalCanNotChargeAnExpiredCreditCard

	 self error: self canNotChargeAnExpiredCreditCardErrorMessage ! !

!Cashier class methodsFor: 'error signal' stamp: 'HernanWilkinson 6/22/2013 14:22'!
signalCartCanNotBeEmpty

	self error: self cartCanNotBeEmptyErrorMessage! !


!classDefinition: #Clock category: 'TusLibros-Model'!
Object subclass: #Clock
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!Clock methodsFor: 'time' stamp: 'HernanWilkinson 6/22/2013 14:23'!
now

	self subclassResponsibility ! !

!Clock methodsFor: 'time' stamp: 'HernanWilkinson 6/22/2013 14:23'!
today

	self subclassResponsibility ! !


!classDefinition: #CreditCard category: 'TusLibros-Model'!
Object subclass: #CreditCard
	instanceVariableNames: 'expiration number ownerName'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!CreditCard methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 18:39'!
isExpiredOn: aDate 
	
	^expiration start < (Month month: aDate monthIndex year: aDate yearNumber) start ! !


!CreditCard methodsFor: 'initialization' stamp: 'HAW 7/22/2020 14:39:22'!
initializeNumbered: aNumber ownedBy: anOwnerName expiringOn: aMonth 
	
	number := aNumber.
	ownerName := anOwnerName.
	expiration := aMonth ! !


!CreditCard methodsFor: 'accessing' stamp: 'HAW 7/22/2020 14:37:53'!
expiration
	
	^expiration ! !

!CreditCard methodsFor: 'accessing' stamp: 'HAW 7/22/2020 14:37:11'!
number
	
	^number! !

!CreditCard methodsFor: 'accessing' stamp: 'HAW 7/22/2020 14:39:22'!
ownerName
	
	^ownerName ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros-Model'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'HAW 7/22/2020 14:40:01'!
numbered: aNumber ownedBy: anOwnerName expiringOn: aMonth 
	
	self assertIsValidNumber: aNumber.
	self assertIsValidOwnerName: anOwnerName.
	
	^self new initializeNumbered: aNumber ownedBy: anOwnerName expiringOn: aMonth! !


!CreditCard class methodsFor: 'exceptions' stamp: 'HAW 7/22/2020 14:19:45'!
invalidNumberErrorDescription
	
	^'Invalid credit card number. It must be 16 digits'! !

!CreditCard class methodsFor: 'exceptions' stamp: 'HAW 7/22/2020 14:27:09'!
invalidOwnerNameErrorDescription
	
	^'Owner name can not be empty'! !

!CreditCard class methodsFor: 'exceptions' stamp: 'HAW 7/22/2020 14:21:14'!
signalInvalidNumber
	
	self error: self invalidNumberErrorDescription ! !

!CreditCard class methodsFor: 'exceptions' stamp: 'HAW 7/22/2020 14:28:05'!
signalInvalidOwnerName
	
	self error: self invalidOwnerNameErrorDescription ! !


!CreditCard class methodsFor: 'assertions' stamp: 'HAW 7/22/2020 14:39:48'!
assertIsValidNumber: aNumber

	aNumber size = 16 ifFalse: [ self signalInvalidNumber ].
	(aNumber anySatisfy: [ :aCharacter | aCharacter isDigit not ]) ifTrue: [ self signalInvalidNumber ]! !

!CreditCard class methodsFor: 'assertions' stamp: 'HAW 7/22/2020 14:40:28'!
assertIsValidOwnerName: anOwnerName

	anOwnerName isEmpty ifTrue: [ self signalInvalidOwnerName ]! !


!classDefinition: #LineItem category: 'TusLibros-Model'!
Object subclass: #LineItem
	instanceVariableNames: 'item quantity total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!LineItem methodsFor: 'accessing' stamp: 'HernanWilkinson 6/22/2013 12:33'!
item
	
	^ item! !

!LineItem methodsFor: 'accessing' stamp: 'HAW 7/23/2020 15:33:00'!
quantity

	^quantity ! !

!LineItem methodsFor: 'accessing' stamp: 'HernanWilkinson 6/22/2013 12:21'!
total
	
	^ total! !


!LineItem methodsFor: 'initialization' stamp: 'HernanWilkinson 6/22/2013 12:18'!
initializeOf: anItem quantity: aQuantity total: aTotal

	item := anItem.
	quantity := aQuantity.
	total := aTotal 

! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LineItem class' category: 'TusLibros-Model'!
LineItem class
	instanceVariableNames: ''!

!LineItem class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/22/2013 12:18'!
of: anItem quantity: aQuantity total: aTotal

	^self new initializeOf: anItem quantity: aQuantity total: aTotal

! !


!classDefinition: #MerchantProcessor category: 'TusLibros-Model'!
Object subclass: #MerchantProcessor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!MerchantProcessor methodsFor: 'debit' stamp: 'HernanWilkinson 6/22/2013 14:31'!
README

	"Aunque nadie subclasifica esta clase, esta para definir el protocolo que se espera que todo MerchantProcessor sepa responder - Hernan"! !

!MerchantProcessor methodsFor: 'debit' stamp: 'HernanWilkinson 6/22/2013 14:30'!
debit: anAmount from: aCreditCard 

	self subclassResponsibility ! !


!classDefinition: #Sale category: 'TusLibros-Model'!
Object subclass: #Sale
	instanceVariableNames: 'customer ticket'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!Sale methodsFor: 'total' stamp: 'HernanWilkinson 6/22/2013 12:26'!
total
	
	^ ticket total! !


!Sale methodsFor: 'initialization' stamp: 'HernanWilkinson 6/22/2013 12:26'!
initializeDoneBy: aCustomer certifiedWith: aTicket 

	customer := aCustomer.
	ticket := aTicket ! !


!Sale methodsFor: 'testing' stamp: 'HernanWilkinson 6/22/2013 12:06'!
wasDoneBy: aCustomer

	^customer = aCustomer ! !


!Sale methodsFor: 'line items' stamp: 'HernanWilkinson 6/22/2013 12:33'!
lineItemsDo: aBlock
	
	^ticket lineItemsDo: aBlock ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sale class' category: 'TusLibros-Model'!
Sale class
	instanceVariableNames: ''!

!Sale class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/22/2013 12:25'!
doneBy: aCustomer certifiedWith: aTicket 

	^self new initializeDoneBy: aCustomer certifiedWith: aTicket ! !


!classDefinition: #Ticket category: 'TusLibros-Model'!
Object subclass: #Ticket
	instanceVariableNames: 'lineItems transactionId transactionIdSale transactionIdTaxes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!Ticket methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2015 20:39'!
total
	
	^lineItems sum: [ :aLineItem | aLineItem total]! !


!Ticket methodsFor: 'initialization' stamp: 'HernanWilkinson 6/22/2013 12:20'!
initializeOf: aCollectionOfLineItems 

	lineItems := aCollectionOfLineItems ! !

!Ticket methodsFor: 'initialization' stamp: 'HAW 5/5/2020 18:06:16'!
transactionId

	^transactionId ! !

!Ticket methodsFor: 'initialization' stamp: 'NR 6/13/2022 07:21:08'!
transactionId: anId

	transactionId := anId! !


!Ticket methodsFor: 'line items' stamp: 'HernanWilkinson 6/22/2013 12:33'!
lineItemsDo: aBlock
	
	^lineItems do: aBlock ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Ticket class' category: 'TusLibros-Model'!
Ticket class
	instanceVariableNames: ''!

!Ticket class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/22/2013 12:20'!
of: aCollectionOfLineItems

	^self new initializeOf: aCollectionOfLineItems ! !


!classDefinition: #TusLibrosSystemFacade category: 'TusLibros-Model'!
Object subclass: #TusLibrosSystemFacade
	instanceVariableNames: 'validUsersAndPasswords catalog lastId merchantProcessor salesBook clock cartSessions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Model'!

!TusLibrosSystemFacade methodsFor: 'error messages' stamp: 'HernanWilkinson 6/22/2013 11:24'!
canNotChargeAnExpiredCreditCardErrorMessage
	
	^Cashier canNotChargeAnExpiredCreditCardErrorMessage ! !

!TusLibrosSystemFacade methodsFor: 'error messages' stamp: 'HernanWilkinson 6/22/2013 11:17'!
cartCanNotBeEmptyErrorMessage
	
	^Cashier cartCanNotBeEmptyErrorMessage ! !

!TusLibrosSystemFacade methodsFor: 'error messages' stamp: 'HernanWilkinson 6/21/2013 23:27'!
invalidCartIdErrorDescription
	
	^'Invalid cart id'! !

!TusLibrosSystemFacade methodsFor: 'error messages' stamp: 'HernanWilkinson 6/21/2013 23:59'!
invalidItemErrorMessage
	
	^Cart invalidItemErrorMessage ! !

!TusLibrosSystemFacade methodsFor: 'error messages' stamp: 'HernanWilkinson 6/21/2013 23:03'!
invalidUserAndOrPasswordErrorDescription
	
	^'Invalid user and/or password'! !

!TusLibrosSystemFacade methodsFor: 'error messages' stamp: 'HernanWilkinson 6/22/2013 13:07'!
sessionHasExpiredErrorDescription
	
	^'Can not use the cart after ', self sessionDuration minutes printString , ' minutes of inactivity'! !


!TusLibrosSystemFacade methodsFor: 'time' stamp: 'HernanWilkinson 6/22/2013 13:02'!
now
	
	^clock now! !

!TusLibrosSystemFacade methodsFor: 'time' stamp: 'HernanWilkinson 6/22/2013 12:49'!
today
	
	^clock today! !


!TusLibrosSystemFacade methodsFor: 'authentication' stamp: 'HernanWilkinson 6/23/2013 12:18'!
does: aUser authenticatesWith: aPassword 

	"Recordar que esto es solo un ejemplo. No se deben guardar passwords en un sistema de verdad sino un
	hash o similar - Hernan"
	
	| storedPassword |
	
	storedPassword := validUsersAndPasswords at: aUser ifAbsent: [ ^false ].
	^aPassword = storedPassword ! !

!TusLibrosSystemFacade methodsFor: 'authentication' stamp: 'HernanWilkinson 6/23/2013 12:18'!
if: aUser authenticatesWith: aPassword do: aBlock

	^ (self does: aUser authenticatesWith: aPassword) 
		ifTrue: aBlock 
		ifFalse: [ self signalInvalidUserAndOrPassword ].
	! !


!TusLibrosSystemFacade methodsFor: 'error signal' stamp: 'HernanWilkinson 6/21/2013 23:27'!
signalInvalidCartId
	
	self error: self invalidCartIdErrorDescription ! !

!TusLibrosSystemFacade methodsFor: 'error signal' stamp: 'HernanWilkinson 6/21/2013 23:02'!
signalInvalidUserAndOrPassword
	
	self error: self invalidUserAndOrPasswordErrorDescription! !


!TusLibrosSystemFacade methodsFor: 'cart session management' stamp: 'HernanWilkinson 6/21/2013 23:32'!
generateCartId
	
	"Recuerden que esto es un ejemplo, por lo que voy a generar ids numericos consecutivos, pero en una 
	implementacion real no deberian se numeros consecutivos ni nada que genere problemas de seguridad - Hernan"
	
	lastId := lastId + 1.
	^lastId! !

!TusLibrosSystemFacade methodsFor: 'cart session management' stamp: 'HAW 5/6/2020 13:57:29'!
removeCartId: aCartId

	"I'll not generate an error if the cartId is invalid because when used from http
	request can be duplicated - Hernan"
	cartSessions removeKey: aCartId ifAbsent: []! !

!TusLibrosSystemFacade methodsFor: 'cart session management' stamp: 'HernanWilkinson 6/22/2013 13:02'!
sessionDuration
	
	^30 minutes! !

!TusLibrosSystemFacade methodsFor: 'cart session management' stamp: 'HernanWilkinson 6/17/2015 20:50'!
withCartSessionIdentifiedAs: aCartId do: aBlock

	| cartSession |
	
	cartSession := cartSessions at: aCartId ifAbsent: [self signalInvalidCartId ].
	^cartSession do: aBlock
! !


!TusLibrosSystemFacade methodsFor: 'facade protocol' stamp: 'HernanWilkinson 6/17/2015 20:41'!
add: anAmount of: aBook toCartIdentifiedAs: aCartId

	self withCartSessionIdentifiedAs: aCartId do: [ :cartSession | cartSession addToCart: anAmount of: aBook ]! !

!TusLibrosSystemFacade methodsFor: 'facade protocol' stamp: 'HAW 7/23/2020 15:24:41'!
checkOutCartIdentifiedAs: aCartId withCreditCardNumbered: aCreditCartNumber ownedBy: anOwner expiringOn: anExpirationMonthOfYear

	^self 
		withCartSessionIdentifiedAs: aCartId 
		do: [ :cartSession | | ticket | 
			ticket := cartSession 
				checkOutCartWithCreditCardNumbered: aCreditCartNumber 
				ownedBy: anOwner 
				expiringOn: anExpirationMonthOfYear.
			self removeCartId: aCartId.
			ticket transactionId ]
! !

!TusLibrosSystemFacade methodsFor: 'facade protocol' stamp: 'HernanWilkinson 6/17/2015 20:52'!
createCartFor: aUser authenticatedWith: aPassword

	^ self if: aUser authenticatesWith: aPassword do: [ | cartId cartSession |
	
		cartId := self generateCartId.
		cartSession := CartSession ownedBy: aUser with: (Cart acceptingItemsOf: catalog) on: self..
		cartSessions at: cartId put: cartSession.
	
		cartId  ]! !

!TusLibrosSystemFacade methodsFor: 'facade protocol' stamp: 'HernanWilkinson 6/17/2015 20:48'!
listCartIdentifiedAs: aCartId

	^ self withCartSessionIdentifiedAs: aCartId do: [ :cartSession | cartSession cartContent ]! !

!TusLibrosSystemFacade methodsFor: 'facade protocol' stamp: 'NR 6/13/2022 07:30:44'!
listPurchasesOf: aUser

	| sales soldItems total |
	
	sales := self salesDoneBy: aUser.	
	soldItems := sales
		inject: Dictionary new
		into: [ :quantitiesByItem :aSale | 
			self list: aSale on: quantitiesByItem.
			quantitiesByItem ].
	total := sales sum: [ :aSale | aSale total ] ifEmpty: [ 0 ].
	^Array with: soldItems with: total! !

!TusLibrosSystemFacade methodsFor: 'facade protocol' stamp: 'NR 6/13/2022 07:30:37'!
listPurchasesOf: aUser authenticatingWith: aPassword

	^self if: aUser authenticatesWith: aPassword do: [	self listPurchasesOf: aUser]! !


!TusLibrosSystemFacade methodsFor: 'checkout support' stamp: 'HernanWilkinson 6/17/2015 20:49'!
merchantProcessor

	^ merchantProcessor! !

!TusLibrosSystemFacade methodsFor: 'checkout support' stamp: 'HernanWilkinson 6/17/2015 20:50'!
salesBook

	^ salesBook! !


!TusLibrosSystemFacade methodsFor: 'private' stamp: 'ag 6/22/2023 11:46:29'!
bookPerformance: anItem
	

	| bookPerformance totalMoney totalSales closures |
	
	closures := OrderedCollection with: [totalSales := self totalSalesOf: anItem.] with: [totalMoney := self totalMoneyRaisedBy: anItem.].
	self forkClosures: closures.
		bookPerformance := Dictionary new.
		bookPerformance at: 'quantity' put: totalSales.
	bookPerformance at: 'total' put: totalMoney.
	bookPerformance at: 'summary' put: anItem,' was selled ',totalSales asString, ' times and raised a total amount of money equal to: ', totalMoney asString.
	^bookPerformance 
	
	


! !

!TusLibrosSystemFacade methodsFor: 'private' stamp: 'ag 6/22/2023 11:49:00'!
forkClosures: aClosureCollection
	|readySemaphore|
	readySemaphore := Semaphore new.

	aClosureCollection do:[:aBlockClosure|
		[aBlockClosure value.
			readySemaphore signal] fork
		].
	readySemaphore wait.
	


! !

!TusLibrosSystemFacade methodsFor: 'private' stamp: 'HAW 7/23/2020 15:34:54'!
list: aSale on: quantitiesByItem 

	"Esto es un indicio de que por ahi conviene empezar a pensar en modelar un SaleBook - Hernan"
	aSale lineItemsDo: [ :aLineItem | | oldQuantity newQuantity |
		oldQuantity := quantitiesByItem at: aLineItem item ifAbsentPut: [ 0 ].
		newQuantity := oldQuantity + aLineItem quantity.
		quantitiesByItem at: aLineItem item put: newQuantity ]! !

!TusLibrosSystemFacade methodsFor: 'private' stamp: 'HernanWilkinson 6/17/2015 20:55'!
salesDoneBy: aUser

	"Esto es un indicio de que por ahi conviene empezar a pensar en modelar un SaleBook - Hernan"
	^ salesBook select: [ :aSale | aSale wasDoneBy: aUser ]! !

!TusLibrosSystemFacade methodsFor: 'private' stamp: 'ag 6/22/2023 11:50:23'!
storePerformance

	| performance totalMoney totalSales closures|
	
	closures := OrderedCollection with: [totalSales := self totalSales.] with: [totalMoney := self totalMoneyRaised.].
	self forkClosures: closures.
	
		performance := Dictionary new.
		performance at: 'quantity' put: totalSales.
	performance at: 'total' put: totalMoney.
	performance at: 'summary' put: 'The store selled a total of ',totalSales asString, ' books and raised a total amount of money equal to: ', totalMoney asString.
	
	^performance
	
	! !

!TusLibrosSystemFacade methodsFor: 'private' stamp: 'NR 6/12/2022 21:34:25'!
totalMoneyRaised
	
	(Delay forSeconds: 1) wait.
	
	^salesBook sum: [:aSale | aSale total].
	
! !

!TusLibrosSystemFacade methodsFor: 'private' stamp: 'NR 6/13/2022 07:15:41'!
totalMoneyRaisedBy: anItem
	
	(Delay forSeconds: 1) wait.

	^salesBook sum: [:aSale | | totalPerItem |
		totalPerItem :=0.
		aSale lineItemsDo: [:aLineItem | (aLineItem item = anItem) ifTrue: [totalPerItem := totalPerItem + aLineItem total]].
		totalPerItem].
	
	! !

!TusLibrosSystemFacade methodsFor: 'private' stamp: 'NR 6/13/2022 07:18:34'!
totalSales
	
	(Delay forSeconds: 1) wait.

	^salesBook sum: [:aSale | | totalQuantity |
		totalQuantity := 0.
		aSale lineItemsDo: [:aLineItem | totalQuantity := totalQuantity + aLineItem quantity].
		totalQuantity].
	
! !

!TusLibrosSystemFacade methodsFor: 'private' stamp: 'NR 6/13/2022 07:15:27'!
totalSalesOf: anItem
	
	(Delay forSeconds: 1) wait.

	^salesBook sum: [:aSale | | quantityPerItem | 
		quantityPerItem := 0.
		aSale lineItemsDo: [:aLineItem | (aLineItem item = anItem) ifTrue: [quantityPerItem := quantityPerItem + aLineItem quantity]].
		quantityPerItem].

! !


!TusLibrosSystemFacade methodsFor: 'initialization' stamp: 'HernanWilkinson 6/22/2013 14:17'!
initializeAuthenticatingWith: aValidUsersAndPasswords 
	acceptingItemsOf: aCatalog 
	registeringOn: aSalesBook 
	debitingThrought: aMerchantProcessor 
	measuringTimeWith: aClock

	validUsersAndPasswords := aValidUsersAndPasswords.
	catalog := aCatalog.
	salesBook := aSalesBook.
	merchantProcessor := aMerchantProcessor.
	clock := aClock.
	
	cartSessions := Dictionary new.
	lastId := 0.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TusLibrosSystemFacade class' category: 'TusLibros-Model'!
TusLibrosSystemFacade class
	instanceVariableNames: ''!

!TusLibrosSystemFacade class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/22/2013 14:17'!
authenticatingWith: aValidUsersAndPasswords 
	acceptingItemsOf: aCatalog 
	registeringOn: aSalesBook 
	debitingThrought: aMerchantProcessor 
	measuringTimeWith: aClock

	^self new 
		initializeAuthenticatingWith: aValidUsersAndPasswords 
		acceptingItemsOf: aCatalog 
		registeringOn: aSalesBook 
		debitingThrought: aMerchantProcessor 
		measuringTimeWith: aClock! !
!classDefinition: #CartTest category: 'TusLibros-Tests'!
TestCase subclass: #CartTest
	instanceVariableNames: 'testObjectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Tests'!

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


!classDefinition: #CashierTest category: 'TusLibros-Tests'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'testObjectsFactory debitBehavior'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Tests'!

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/22/2013 12:00'!
test01CanNotCheckoutAnEmptyCart

	| salesBook |
	
	salesBook := OrderedCollection new.
	self 
		should: [ Cashier 
			toCheckout: testObjectsFactory createCart 
			ownedBy: testObjectsFactory customer
			charging: testObjectsFactory notExpiredCreditCard 
			throught: self
			on: testObjectsFactory today
			registeringOn:  salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier cartCanNotBeEmptyErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/22/2013 12:22'!
test02CalculatedTotalIsCorrect

	| cart cashier |
	
	cart := testObjectsFactory createCart.
	cart add: 2 of: testObjectsFactory itemSellByTheStore.
	
	cashier :=  Cashier
		toCheckout: cart 
		ownedBy: testObjectsFactory customer
		charging: testObjectsFactory notExpiredCreditCard 
		throught: self
		on: testObjectsFactory today 
		registeringOn: OrderedCollection new.
		
	self assert: cashier checkOut total = (testObjectsFactory itemSellByTheStorePrice * 2)! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/22/2013 12:01'!
test03CanNotCheckoutWithAnExpiredCreditCart

	| cart salesBook |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	salesBook := OrderedCollection new.
	
	self
		should: [ Cashier 
				toCheckout: cart 
				ownedBy: testObjectsFactory customer 
				charging: testObjectsFactory expiredCreditCard 
				throught: self
				on: testObjectsFactory today
				registeringOn: salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = Cashier canNotChargeAnExpiredCreditCardErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/22/2013 12:23'!
test04CheckoutRegistersASale

	| cart cashier salesBook total |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		ownedBy: testObjectsFactory customer 
		charging: testObjectsFactory notExpiredCreditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	total := cashier checkOut total.
					
	self assert: salesBook size = 1.
	self assert: salesBook first total = total.! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/22/2013 12:22'!
test05CashierChargesCreditCardUsingMerchantProcessor

	| cart cashier salesBook total creditCard debitedAmout debitedCreditCard  |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart
		ownedBy: testObjectsFactory customer 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	debitBehavior := [ :anAmount :aCreditCard | 
		debitedAmout := anAmount.
		debitedCreditCard := aCreditCard ].
	total := cashier checkOut total.
					
	self assert: debitedCreditCard = creditCard.
	self assert: debitedAmout = total.! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/22/2013 12:02'!
test06CashierDoesNotSaleWhenTheCreditCardHasNoCredit

	| cart cashier salesBook creditCard |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 	debitBehavior := [ :anAmount :aCreditCard | self error: Cashier creditCardHasNoCreditErrorMessage].
	
	cashier:= Cashier 
		toCheckout: cart 
		ownedBy: testObjectsFactory customer
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	self 
		should: [cashier checkOut ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier creditCardHasNoCreditErrorMessage.
			self assert: salesBook isEmpty ]! !


!CashierTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 19:03'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.
	debitBehavior := [ :anAmount :aCreditCard | ]! !


!CashierTest methodsFor: 'merchant processor protocol' stamp: 'HernanWilkinson 6/17/2013 19:02'!
debit: anAmount from: aCreditCard 

	^debitBehavior value: anAmount value: aCreditCard ! !


!classDefinition: #CreditCardTest category: 'TusLibros-Tests'!
TestCase subclass: #CreditCardTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Tests'!

!CreditCardTest methodsFor: 'tests' stamp: 'HAW 7/22/2020 14:26:34'!
test01CreditCardNumberWithLessThan16DigitsIsNotValid

	self 
		should: [ CreditCard numbered: '123456789012345' ownedBy: self validOwnerName expiringOn: Month current ]
		raise: Error - MessageNotUnderstood 
		withMessageText: CreditCard invalidNumberErrorDescription! !

!CreditCardTest methodsFor: 'tests' stamp: 'HAW 7/22/2020 14:26:33'!
test02CreditCardNumberWithMoreThan16DigitsIsNotValid

	self 
		should: [ CreditCard numbered: '12345678901234567' ownedBy: self validOwnerName expiringOn: Month current ]
		raise: Error - MessageNotUnderstood 
		withMessageText: CreditCard invalidNumberErrorDescription! !

!CreditCardTest methodsFor: 'tests' stamp: 'HAW 7/22/2020 14:26:33'!
test03CreditCardNumberShouldBeDigitsOnly

	self 
		should: [ CreditCard numbered: 'a234567890123456' ownedBy: self validOwnerName expiringOn: Month current ]
		raise: Error - MessageNotUnderstood 
		withMessageText: CreditCard invalidNumberErrorDescription! !

!CreditCardTest methodsFor: 'tests' stamp: 'HAW 7/22/2020 14:27:23'!
test04NameCanNotBeEmpty

	self 
		should: [ CreditCard numbered: '1234567890123456' ownedBy: '' expiringOn: Month current ]
		raise: Error - MessageNotUnderstood 
		withMessageText: CreditCard invalidOwnerNameErrorDescription! !

!CreditCardTest methodsFor: 'tests' stamp: 'HAW 7/22/2020 14:32:08'!
test05IsExpiredOnNextExpirationMonth

	| expirationMonth expiredMonth creditCard |
	
	expirationMonth := Month month: #January year: 2020. 
	expiredMonth := expirationMonth next.
	creditCard := CreditCard 
		numbered: '1234567890123456' 
		ownedBy: self validOwnerName 
		expiringOn: expirationMonth.
		
	self assert: (creditCard isExpiredOn: expiredMonth)! !

!CreditCardTest methodsFor: 'tests' stamp: 'HAW 7/22/2020 14:32:30'!
test06IsNotExpiredOnExpirationMonth

	| expirationMonth creditCard |
	
	expirationMonth := Month month: #January year: 2020. 
	creditCard := CreditCard 
		numbered: '1234567890123456' 
		ownedBy: self validOwnerName 
		expiringOn: expirationMonth.
		
	self deny: (creditCard isExpiredOn: expirationMonth)! !

!CreditCardTest methodsFor: 'tests' stamp: 'HAW 7/22/2020 14:39:10'!
test07CanGetCreditCardInfoFromIt

	| expirationMonth creditCard creditCardNumber creditCardOwner |
	
	expirationMonth := Month month: #January year: 2020. 
	creditCardNumber := self validCreditCardNumber.
	creditCardOwner := self validOwnerName.
	
	creditCard := CreditCard 
		numbered: creditCardNumber 
		ownedBy: creditCardOwner 
		expiringOn: expirationMonth.
		
	self assert: creditCardNumber equals: creditCard number.
	self assert: creditCardOwner equals: creditCard ownerName.
	self assert: expirationMonth equals: creditCard expiration! !

!CreditCardTest methodsFor: 'tests' stamp: 'HAW 7/22/2020 14:33:46'!
validCreditCardNumber

	^ '1234567890123456'! !

!CreditCardTest methodsFor: 'tests' stamp: 'HAW 7/22/2020 14:28:21'!
validOwnerName
	
	^'Pepe Sanchez'! !


!classDefinition: #TusLibrosSystemFacadeTest category: 'TusLibros-Tests'!
TestCase subclass: #TusLibrosSystemFacadeTest
	instanceVariableNames: 'testObjectsFactory clock systemFacade merchantProcessorTransactionId'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Tests'!

!TusLibrosSystemFacadeTest methodsFor: 'tests - add to cart' stamp: 'HAW 7/23/2020 15:59:09'!
test04CanAddItemsToACreatedCart

	| cartId cartContent |

	cartId := systemFacade createCartFor: self validUser authenticatedWith: self validUserPassword.
	systemFacade add: 1 of: self validBook toCartIdentifiedAs: cartId.
	
	cartContent := systemFacade listCartIdentifiedAs: cartId.
	
	self assert: 1 equals: (cartContent occurrencesOf: self validBook).
	self assert: 1 equals: cartContent size! !

!TusLibrosSystemFacadeTest methodsFor: 'tests - add to cart' stamp: 'HAW 7/23/2020 15:55:18'!
test05CanNotAddItemToNotCreatedCart

	self
		should: [systemFacade add: 1 of: self validBook toCartIdentifiedAs: self invalidCartId]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assertMessageTextOf: anError is: systemFacade invalidCartIdErrorDescription ]
		! !

!TusLibrosSystemFacadeTest methodsFor: 'tests - add to cart' stamp: 'HAW 7/23/2020 15:56:49'!
test06CanNotAddItemNotSellByTheStore

	| cartId |

	cartId := systemFacade createCartFor: self validUser authenticatedWith: self validUserPassword.
	self
		should: [systemFacade add: 1 of: self invalidBook toCartIdentifiedAs: cartId ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assertMessageTextOf: anError is: systemFacade invalidItemErrorMessage.
			self assertIsEmptyCartIdentifiedAs: cartId]
		! !

!TusLibrosSystemFacadeTest methodsFor: 'tests - add to cart' stamp: 'HAW 7/23/2020 15:57:13'!
test17CanNotAddToCartWhenSessionIsExpired

	| cartId |

	cartId := systemFacade createCartFor: self validUser authenticatedWith: self validUserPassword.
	self advanceTime: (systemFacade sessionDuration + 1 minutes) . 
	self 
		should: [systemFacade add: 2 of: self validBook toCartIdentifiedAs: cartId]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assertMessageTextOf: anError is: systemFacade sessionHasExpiredErrorDescription.
			self revertTime: systemFacade sessionDuration.
			self assertIsEmptyCartIdentifiedAs: cartId ]
! !


!TusLibrosSystemFacadeTest methodsFor: 'tests - performance' stamp: 'NR 6/9/2022 20:51:15'!
should: aBlock notTakeMoreThanMilliseconds: aTimeInMillis

	self assert: aBlock timeToRun <= aTimeInMillis! !

!TusLibrosSystemFacadeTest methodsFor: 'tests - performance' stamp: 'NR 6/13/2022 09:05:18'!
test20BookPerformanceShouldNotTakeTooLong

	| cartId bookPerformance quantity total |

	cartId := systemFacade createCartFor: self validUser authenticatedWith: self validUserPassword.
	systemFacade add: 2 of: self validBook toCartIdentifiedAs: cartId.
	systemFacade 
		checkOutCartIdentifiedAs: cartId 
		withCreditCardNumbered: testObjectsFactory validCreditCardNumber 
		ownedBy: testObjectsFactory validOwnerName 
		expiringOn: testObjectsFactory notExpiredMonthOfYear.
		
	cartId := systemFacade createCartFor: self anotherValidUser authenticatedWith: self anotherValidUserPassword.
	systemFacade add: 5 of: self validBook toCartIdentifiedAs: cartId.
	systemFacade 
		checkOutCartIdentifiedAs: cartId 
		withCreditCardNumbered: testObjectsFactory validCreditCardNumber 
		ownedBy: testObjectsFactory validOwnerName 
		expiringOn: testObjectsFactory notExpiredMonthOfYear.
		
	self should: [bookPerformance := systemFacade bookPerformance: self validBook ] 
		notTakeMoreThanMilliseconds: 1100.	

	quantity := bookPerformance at: 'quantity'.
	total := bookPerformance at: 'total'.
	self assert: 7 equals: quantity.
	self assert: (testObjectsFactory itemSellByTheStorePrice * 7) equals: total.
	self assert: 
		self validBook,' was selled ',quantity asString, ' times and raised a total amount of money equal to: ', total asString
		equals: (bookPerformance at: 'summary')
	! !

!TusLibrosSystemFacadeTest methodsFor: 'tests - performance' stamp: 'NR 6/13/2022 08:00:04'!
test21StorePerformanceShouldNotTakeTooLong

	| cartId storePerformance quantity total |

	cartId := systemFacade createCartFor: self validUser authenticatedWith: self validUserPassword.
	systemFacade add: 2 of: self validBook toCartIdentifiedAs: cartId.
	systemFacade add: 1 of: self anotherValidBook toCartIdentifiedAs: cartId.
	systemFacade 
		checkOutCartIdentifiedAs: cartId 
		withCreditCardNumbered: testObjectsFactory validCreditCardNumber 
		ownedBy: testObjectsFactory validOwnerName 
		expiringOn: testObjectsFactory notExpiredMonthOfYear.
	
	cartId := systemFacade createCartFor: self anotherValidUser authenticatedWith: self anotherValidUserPassword.
	systemFacade add: 5 of: self validBook toCartIdentifiedAs: cartId.
	systemFacade add: 10 of: self anotherValidBook toCartIdentifiedAs: cartId.
	systemFacade 
		checkOutCartIdentifiedAs: cartId 
		withCreditCardNumbered: testObjectsFactory validCreditCardNumber 
		ownedBy: testObjectsFactory validOwnerName 
		expiringOn: testObjectsFactory notExpiredMonthOfYear.
			
	self should: [storePerformance := systemFacade storePerformance] 
		notTakeMoreThanMilliseconds: 1100.	

	quantity := storePerformance at: 'quantity'.
	total := storePerformance at: 'total'.

	self assert: 18 equals: quantity.
	self assert: (testObjectsFactory itemSellByTheStorePrice * 7) + (testObjectsFactory anotherItemSellByTheStorePrice * 11) equals: total.
	self assert:
		'The store selled a total of ',quantity asString, ' books and raised a total amount of money equal to: ', total asString
		equals: (storePerformance at: 'summary')
		! !


!TusLibrosSystemFacadeTest methodsFor: 'tests - list purchases' stamp: 'HAW 7/23/2020 16:06:04'!
test14ListPurchasesIncludesBoughtItems

	| cartId purchases soldItems total |

	cartId := systemFacade createCartFor: self validUser authenticatedWith: self validUserPassword.
	systemFacade add: 2 of: self validBook toCartIdentifiedAs: cartId.
	systemFacade add: 1 of: self anotherValidBook toCartIdentifiedAs: cartId.
	systemFacade 
		checkOutCartIdentifiedAs: cartId 
		withCreditCardNumbered: testObjectsFactory validCreditCardNumber 
		ownedBy: testObjectsFactory validOwnerName 
		expiringOn: testObjectsFactory notExpiredMonthOfYear.
		
	purchases := systemFacade listPurchasesOf: self validUser authenticatingWith: self validUserPassword.
	soldItems := purchases first.
	total := purchases second.

	self assert: 2 equals: (soldItems at: self validBook).
	self assert: 1 equals: (soldItems at: self anotherValidBook).
	self 
		assert: (testObjectsFactory itemSellByTheStorePrice * 2 + testObjectsFactory anotherItemSellByTheStorePrice)
		equals: total! !

!TusLibrosSystemFacadeTest methodsFor: 'tests - list purchases' stamp: 'HAW 7/23/2020 16:06:33'!
test15CanNotListPurchasesOfInvalidCustomer

	self 
		should: [systemFacade listPurchasesOf: self invalidUser authenticatingWith: self validUserPassword ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assertMessageTextOf: anError is: systemFacade invalidUserAndOrPasswordErrorDescription ]! !

!TusLibrosSystemFacadeTest methodsFor: 'tests - list purchases' stamp: 'HAW 7/23/2020 16:06:46'!
test16CanNotListPurchasesOfValidCustomerWithInvalidPassword

	self 
		should: [systemFacade listPurchasesOf: self validUser authenticatingWith: self invalidPassword ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assertMessageTextOf: anError is: systemFacade invalidUserAndOrPasswordErrorDescription ]! !


!TusLibrosSystemFacadeTest methodsFor: 'tests - create cart' stamp: 'HAW 7/23/2020 15:56:11'!
test01CanCreateCartWithValidUserAndPassword

	| cartId |
	
	cartId := systemFacade createCartFor: self validUser authenticatedWith: self validUserPassword.
	
	self assertIsEmptyCartIdentifiedAs: cartId ! !

!TusLibrosSystemFacadeTest methodsFor: 'tests - create cart' stamp: 'HAW 7/23/2020 15:53:41'!
test02CanNotCreateCartWithInvalidUser

	self
		should: [ systemFacade createCartFor: self invalidUser authenticatedWith: self validUserPassword ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assertMessageTextOf: anError is: systemFacade invalidUserAndOrPasswordErrorDescription ]! !

!TusLibrosSystemFacadeTest methodsFor: 'tests - create cart' stamp: 'HAW 7/23/2020 15:54:39'!
test03CanNotCreateCartWithInvalidPassword

	self
		should: [ systemFacade createCartFor: self validUser authenticatedWith: self invalidPassword ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assertMessageTextOf: anError is: systemFacade invalidUserAndOrPasswordErrorDescription ]! !


!TusLibrosSystemFacadeTest methodsFor: 'merchant processor protocol' stamp: 'HAW 7/23/2020 16:07:46'!
debit: anAmount from: aCreditCard 

	^merchantProcessorTransactionId ! !


!TusLibrosSystemFacadeTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/22/2013 11:42'!
createSalesBook
	
	^OrderedCollection new! !

!TusLibrosSystemFacadeTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/22/2013 11:47'!
merchantProcessor 

	^self! !

!TusLibrosSystemFacadeTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2015 20:53'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.
	clock := ManualClock now: testObjectsFactory today.
	systemFacade := TusLibrosSystemFacade 
		authenticatingWith: self validUsersAndPasswords 
		acceptingItemsOf: testObjectsFactory defaultCatalog 
		registeringOn: self createSalesBook
		debitingThrought: self merchantProcessor 
		measuringTimeWith: clock
! !


!TusLibrosSystemFacadeTest methodsFor: 'test objects' stamp: 'HernanWilkinson 6/22/2013 00:15'!
anotherValidBook
	
	^testObjectsFactory anotherItemSellByTheStore ! !

!TusLibrosSystemFacadeTest methodsFor: 'test objects' stamp: 'NR 6/9/2022 20:18:52'!
anotherValidUser
	
	^'anotherValidUser'! !

!TusLibrosSystemFacadeTest methodsFor: 'test objects' stamp: 'NR 6/9/2022 20:19:12'!
anotherValidUserPassword
	
	^'anotherValidUserPassword'! !

!TusLibrosSystemFacadeTest methodsFor: 'test objects' stamp: 'HernanWilkinson 6/21/2013 23:49'!
invalidBook

	^testObjectsFactory itemNotSellByTheStore ! !

!TusLibrosSystemFacadeTest methodsFor: 'test objects' stamp: 'HAW 7/24/2020 11:08:48'!
invalidCartId
	
	"Devuelvo un objeto nuevo cada vez y de esa forma me aseguro que no pueda ser un id usado - Hernan"
	^Object new! !

!TusLibrosSystemFacadeTest methodsFor: 'test objects' stamp: 'HernanWilkinson 6/21/2013 23:06'!
invalidPassword
	
	^'invalidPassword'! !

!TusLibrosSystemFacadeTest methodsFor: 'test objects' stamp: 'HernanWilkinson 6/21/2013 22:30'!
invalidUser

	^'invalidUser'! !

!TusLibrosSystemFacadeTest methodsFor: 'test objects' stamp: 'HernanWilkinson 6/21/2013 23:50'!
validBook
	
	^testObjectsFactory itemSellByTheStore ! !

!TusLibrosSystemFacadeTest methodsFor: 'test objects' stamp: 'HernanWilkinson 6/21/2013 22:27'!
validUser
	
	^'validUser'! !

!TusLibrosSystemFacadeTest methodsFor: 'test objects' stamp: 'HernanWilkinson 6/21/2013 22:28'!
validUserPassword
	
	^'validUserPassword'! !

!TusLibrosSystemFacadeTest methodsFor: 'test objects' stamp: 'NR 6/9/2022 20:20:12'!
validUsersAndPasswords
	
	^Dictionary new
		at: self validUser put: self validUserPassword;
		at: self anotherValidUser put: self anotherValidUserPassword;
		yourself! !


!TusLibrosSystemFacadeTest methodsFor: 'tests - checkout' stamp: 'HAW 7/23/2020 16:07:46'!
test10CheckOutReturnsTransactionIdAndImpactsCustomerPurchases

	| cartId  currentTransactionId |

	cartId := systemFacade createCartFor: self validUser authenticatedWith: self validUserPassword.
	systemFacade add: 1 of: testObjectsFactory itemSellByTheStore toCartIdentifiedAs: cartId.
	
	merchantProcessorTransactionId := Random new nextInteger: 1000.
	
	currentTransactionId := systemFacade 
		checkOutCartIdentifiedAs: cartId 
		withCreditCardNumbered: testObjectsFactory validCreditCardNumber 
		ownedBy: testObjectsFactory validOwnerName 
		expiringOn: testObjectsFactory notExpiredMonthOfYear.
	
	self assert: merchantProcessorTransactionId equals: currentTransactionId.
	self assertValidUserBougthOnlyItemSellByTheStore
	
	
		! !

!TusLibrosSystemFacadeTest methodsFor: 'tests - checkout' stamp: 'HAW 7/23/2020 16:03:56'!
test10_1_CanNotCheckoutAnAlreadyCheckedOutCart

	| cartId  |

	cartId := systemFacade createCartFor: self validUser authenticatedWith: self validUserPassword.
	systemFacade add: 1 of: testObjectsFactory itemSellByTheStore toCartIdentifiedAs: cartId.
	systemFacade 
		checkOutCartIdentifiedAs: cartId 
		withCreditCardNumbered: testObjectsFactory validCreditCardNumber 
		ownedBy: testObjectsFactory validOwnerName 
		expiringOn: testObjectsFactory notExpiredMonthOfYear.
			
	self 
		should: [ 
			systemFacade 
				checkOutCartIdentifiedAs: cartId 
				withCreditCardNumbered: testObjectsFactory validCreditCardNumber 
				ownedBy: testObjectsFactory validOwnerName 
				expiringOn: testObjectsFactory notExpiredMonthOfYear ]		
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assertMessageTextOf: anError is: systemFacade invalidCartIdErrorDescription.
			self assertValidUserBougthOnlyItemSellByTheStore ]! !

!TusLibrosSystemFacadeTest methodsFor: 'tests - checkout' stamp: 'HAW 7/23/2020 16:04:14'!
test11CanNotCheckoutANotCreatedCart

	self
		should: [systemFacade 
			checkOutCartIdentifiedAs: self invalidCartId  
			withCreditCardNumbered: testObjectsFactory validCreditCardNumber 
			ownedBy: testObjectsFactory validOwnerName 
			expiringOn: testObjectsFactory notExpiredMonthOfYear ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assertMessageTextOf: anError is: systemFacade invalidCartIdErrorDescription ]
		
		! !

!TusLibrosSystemFacadeTest methodsFor: 'tests - checkout' stamp: 'HAW 7/23/2020 16:04:29'!
test12CanNotCheckoutAnEmptyCart

	| cartId |

	cartId := systemFacade createCartFor: self validUser authenticatedWith: self validUserPassword.
	self
		should: [systemFacade 
			checkOutCartIdentifiedAs: cartId 
			withCreditCardNumbered: testObjectsFactory validCreditCardNumber 
			ownedBy: testObjectsFactory validOwnerName 
			expiringOn: testObjectsFactory notExpiredMonthOfYear ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assertMessageTextOf: anError is: systemFacade cartCanNotBeEmptyErrorMessage.
			self assertThereAreNoPurchasesForValidUser ]
		
		! !

!TusLibrosSystemFacadeTest methodsFor: 'tests - checkout' stamp: 'HAW 7/23/2020 16:08:24'!
test13CanNotCheckoutWithAnExpiredCreditCard

	| cartId |

	cartId := systemFacade createCartFor: self validUser authenticatedWith: self validUserPassword.
	systemFacade add: 1 of: self validBook toCartIdentifiedAs: cartId.
	self
		should: [systemFacade 
			checkOutCartIdentifiedAs: cartId 
			withCreditCardNumbered: testObjectsFactory validCreditCardNumber 
			ownedBy: testObjectsFactory validOwnerName 
			expiringOn: testObjectsFactory expiredMonthOfYear ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assertMessageTextOf: anError is: systemFacade canNotChargeAnExpiredCreditCardErrorMessage.
			self assertThereAreNoPurchasesForValidUser ]
		
		! !

!TusLibrosSystemFacadeTest methodsFor: 'tests - checkout' stamp: 'HAW 7/23/2020 16:08:40'!
test19CanNotCheckOutCartWhenSessionIsExpired

	| cartId |

	cartId := systemFacade createCartFor: self validUser authenticatedWith: self validUserPassword.
	systemFacade add: 2 of: self validBook toCartIdentifiedAs: cartId.
	self advanceTime: (systemFacade sessionDuration + 1 minutes). 
	
	self 
		should: [systemFacade 
			checkOutCartIdentifiedAs: cartId 
			withCreditCardNumbered: testObjectsFactory validCreditCardNumber 
			ownedBy: testObjectsFactory validOwnerName 
			expiringOn: testObjectsFactory notExpiredMonthOfYear ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assertMessageTextOf: anError is: systemFacade sessionHasExpiredErrorDescription.
			self assertThereAreNoPurchasesForValidUser ].

	! !


!TusLibrosSystemFacadeTest methodsFor: 'tests - list cart' stamp: 'HAW 7/23/2020 15:58:09'!
test08CanNotListCartOfInvalidCartId

	self 
		should: [systemFacade listCartIdentifiedAs: self invalidCartId] 
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assertMessageTextOf: anError is: systemFacade invalidCartIdErrorDescription ]
	! !

!TusLibrosSystemFacadeTest methodsFor: 'tests - list cart' stamp: 'HAW 7/23/2020 16:00:20'!
test09ListCartReturnsTheRightNumberOfItems

	| cartId cartContent |

	cartId := systemFacade createCartFor: self validUser authenticatedWith: self validUserPassword.
	systemFacade add: 1 of: self validBook toCartIdentifiedAs: cartId.
	systemFacade add: 2 of: self anotherValidBook toCartIdentifiedAs: cartId.
	cartContent := systemFacade listCartIdentifiedAs: cartId.
	
	self assert: 1 equals: (cartContent occurrencesOf: self validBook). 
	self assert: 2 equals: (cartContent occurrencesOf: self anotherValidBook).
	self assert: 3 equals: cartContent size
! !

!TusLibrosSystemFacadeTest methodsFor: 'tests - list cart' stamp: 'HAW 7/23/2020 16:10:25'!
test18CanNotListCartWhenSessionIsExpired

	| cartId |

	cartId := systemFacade createCartFor: self validUser authenticatedWith: self validUserPassword.
	self advanceTime: (systemFacade sessionDuration + 1 minutes).
	 
	self 
		should: [systemFacade listCartIdentifiedAs: cartId]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assertMessageTextOf: anError is: systemFacade sessionHasExpiredErrorDescription ].

! !


!TusLibrosSystemFacadeTest methodsFor: 'time' stamp: 'HernanWilkinson 6/22/2013 12:53'!
advanceTime: aDuration 
	
	clock advanceTime: aDuration ! !

!TusLibrosSystemFacadeTest methodsFor: 'time' stamp: 'HernanWilkinson 6/22/2013 13:07'!
revertTime: aDuration 
	
	clock revertTime: aDuration ! !


!TusLibrosSystemFacadeTest methodsFor: 'assertions' stamp: 'HAW 7/23/2020 15:55:56'!
assertIsEmptyCartIdentifiedAs: cartId

	^ self assert: (systemFacade listCartIdentifiedAs: cartId) isEmpty! !

!TusLibrosSystemFacadeTest methodsFor: 'assertions' stamp: 'HAW 7/23/2020 15:54:17'!
assertMessageTextOf: anError is: anExpectedMessageText 
	
	self assert: anExpectedMessageText equals: anError messageText! !

!TusLibrosSystemFacadeTest methodsFor: 'assertions' stamp: 'HAW 7/23/2020 15:47:06'!
assertThereAreNoPurchasesForValidUser

	| purchases soldItems total |
	
	purchases := systemFacade listPurchasesOf: self validUser authenticatingWith: self validUserPassword.
	soldItems := purchases first.
	total := purchases second.

	self assert: soldItems isEmpty.
	self assert: 0 equals: total.! !

!TusLibrosSystemFacadeTest methodsFor: 'assertions' stamp: 'HAW 7/23/2020 16:03:38'!
assertValidUserBougthOnlyItemSellByTheStore
	
	| purchases soldItems total |
	purchases := systemFacade listPurchasesOf: self validUser authenticatingWith: self validUserPassword.
	soldItems := purchases first.
	total := purchases second.
	
	self assert: 1 equals: (soldItems at: self validBook).
	self assert: 1 equals: soldItems size.
	self assert: testObjectsFactory itemSellByTheStorePrice equals: total.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TusLibrosSystemFacadeTest class' category: 'TusLibros-Tests'!
TusLibrosSystemFacadeTest class
	instanceVariableNames: ''!

!TusLibrosSystemFacadeTest class methodsFor: 'fileOut' stamp: 'HAW 5/6/2020 14:06:42'!
fileOut

	"self fileOut"

	DirectoryEntry smalltalkImageDirectory // 'TusLibros.st' writeStreamDo: [ :fileStream |
		SystemOrganization fileOutCategory: 'TusLibros-Model' on: fileStream initializing: true.
		SystemOrganization fileOutCategory: 'TusLibros-Test' on: fileStream initializing: true ]! !


!classDefinition: #ManualClock category: 'TusLibros-Tests'!
Clock subclass: #ManualClock
	instanceVariableNames: 'now'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Tests'!

!ManualClock methodsFor: 'time change' stamp: 'HernanWilkinson 6/22/2013 12:54'!
advanceTime: aDuration 
	
	now := now + aDuration ! !

!ManualClock methodsFor: 'time change' stamp: 'HernanWilkinson 6/22/2013 13:08'!
revertTime: aDuration 
	
	now := now + aDuration negated ! !


!ManualClock methodsFor: 'time' stamp: 'HernanWilkinson 6/22/2013 12:56'!
now
	
	^ now! !

!ManualClock methodsFor: 'time' stamp: 'HernanWilkinson 6/22/2013 12:53'!
today
	
	^now date! !


!ManualClock methodsFor: 'initialization' stamp: 'HernanWilkinson 6/22/2013 12:52'!
initializeNow: aTime 

	now := aTime ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ManualClock class' category: 'TusLibros-Tests'!
ManualClock class
	instanceVariableNames: ''!

!ManualClock class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/22/2013 12:52'!
now: aTime 
	
	^self new initializeNow: aTime ! !


!classDefinition: #StoreTestObjectsFactory category: 'TusLibros-Tests'!
Object subclass: #StoreTestObjectsFactory
	instanceVariableNames: 'today'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros-Tests'!

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


!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HAW 7/22/2020 14:26:34'!
expiredCreditCard
	
	^CreditCard numbered: self validCreditCardNumber ownedBy: self validOwnerName expiringOn: self expiredMonthOfYear ! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/22/2013 11:24'!
expiredMonthOfYear 

	^ Month month: today monthIndex year: today yearNumber - 1! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HAW 7/22/2020 14:26:34'!
notExpiredCreditCard
	
	^CreditCard numbered: self validCreditCardNumber ownedBy: self validOwnerName expiringOn: self notExpiredMonthOfYear! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/22/2013 11:06'!
notExpiredMonthOfYear

	^ Month month: today monthIndex year: today yearNumber + 1! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HAW 7/23/2020 15:25:37'!
validCreditCardNumber
	
	^'1234567890123456'! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HAW 7/23/2020 15:25:51'!
validOwnerName
	
	^'Pepe Sanchez'! !


!StoreTestObjectsFactory methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:37'!
initialize

	today := DateAndTime now! !


!StoreTestObjectsFactory methodsFor: 'date' stamp: 'HernanWilkinson 6/17/2013 18:37'!
today
	
	^ today! !


!StoreTestObjectsFactory methodsFor: 'customer' stamp: 'HernanWilkinson 6/22/2013 12:02'!
customer
	
	^'aCustomer'! !
