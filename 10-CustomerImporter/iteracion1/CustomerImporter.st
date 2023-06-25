!classDefinition: #StreamSimulator category: 'CustomerImporter'!
ReadStream subclass: #StreamSimulator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!StreamSimulator methodsFor: 'initialization' stamp: 'AG 6/25/2023 19:09:02'!
on: aCollection
	"Initialize the stream to read over all of aCollection.
	The collection is considered to have useful content."

	collection := aCollection.
	readLimit := aCollection size.
	position := 0.
	self reset.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'StreamSimulator class' category: 'CustomerImporter'!
StreamSimulator class
	instanceVariableNames: ''!

!StreamSimulator class methodsFor: 'instance creation' stamp: 'AG 6/25/2023 19:09:09'!
on: aString

	^self basicNew on: aString.! !


!classDefinition: #ImportTest category: 'CustomerImporter'!
TestCase subclass: #ImportTest
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'mp 6/22/2023 20:32:30'!
setUp

	session := DataBaseSession for: (Array with: Address with: Customer).
	session beginTransaction! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'mp 6/22/2023 20:34:22'!
tearDown

	session commit.
	session close! !


!ImportTest methodsFor: 'private-assert' stamp: 'AG 6/25/2023 19:37:33'!
assertCustomer: customerPepe hasFirstName: aCustomerName andLastName: aCustomerLastName  

	self assert: customerPepe  firstName equals: aCustomerName.
	self assert: customerPepe  lastName equals: aCustomerLastName.! !

!ImportTest methodsFor: 'private-assert' stamp: 'AG 6/25/2023 18:19:40'!
assertCustomerHasAddress: aCustomer streetName: aStreetName province: aProvince town: aTown streetNumber: aStreetNumber zipCode: aZipCode     
	|anAddress|
	anAddress := Address new.
	
	anAddress streetName: aStreetName.
	anAddress province: aProvince.
	anAddress town: aTown .
	anAddress streetNumber: aStreetNumber.
	anAddress zipCode: aZipCode.
	
	self assert: (aCustomer containAddress: anAddress).! !

!ImportTest methodsFor: 'private-assert' stamp: 'AG 6/25/2023 19:53:11'!
assertDefaultCustomersInputIsCorrectlyImportedFrom: inputStream

	|customerPepe customerJuan |

	self importCustomers: 	inputStream to: session.
	
	customerPepe := (self selectFirstIdentificationType: 'D' andNumber: '22333444' ).
	
	customerJuan := (self selectFirstIdentificationType:'C' andNumber:  '23-25666777-9').
	

	self assert: (session selectAllOfType: Customer) size equals: 2.
	
	self assertCustomer: customerPepe hasFirstName: 'Pepe' andLastName: 'Sanchez'.
	self assertCustomer: customerJuan hasFirstName: 'Juan'  andLastName:'Perez'. 
	
	self assert: customerPepe  quantityOfAddresses equals: 2.
	self assert: customerJuan  quantityOfAddresses equals: 1.
	
	self assertCustomerHasAddress: customerPepe streetName: 'San Martin' province: 'BsAs' town: 'Olivos' streetNumber: 3322 zipCode: 1636.
	
	self assertCustomerHasAddress: customerPepe streetName:'Maipu'  province:'Buenos Aires'  town: 'Florida' streetNumber: 888  zipCode:1122. 
	
	self assertCustomerHasAddress: customerJuan streetName:'Alem'  province:'CABA'  town: 'CABA' streetNumber: 1122 zipCode:1001! !


!ImportTest methodsFor: 'private' stamp: 'AG 6/25/2023 19:53:30'!
defaultCustomersInput

	^ 'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !

!ImportTest methodsFor: 'private' stamp: 'AG 6/25/2023 19:25:38'!
importCustomers: inputStream to: dataBaseSession

	(CustomerImporter withInputStream: inputStream onDataBaseSession: dataBaseSession) execute.! !

!ImportTest methodsFor: 'private' stamp: 'AG 6/25/2023 19:34:31'!
selectFirstIdentificationType: anIdentificationType andNumber: anIdentificationNumber 

	^ (session select: [:aCustomer| aCustomer identificationType = anIdentificationType and: [aCustomer identificationNumber = anIdentificationNumber]]
	ofType: Customer) anyOne.! !


!ImportTest methodsFor: 'testing' stamp: 'AG 6/25/2023 19:54:39'!
test01ImportCustomersCorrectlyFromFileStream
	|inputStream|
	
	inputStream := UniFileStream new open: 'input.txt' forWrite: false.

	self assertDefaultCustomersInputIsCorrectlyImportedFrom: inputStream.! !

!ImportTest methodsFor: 'testing' stamp: 'AG 6/25/2023 19:54:48'!
test02ImportCustomersCorrectlyFromStreamSimulator
	|inputStream|
	
	inputStream := StreamSimulator on: self defaultCustomersInput.

	self assertDefaultCustomersInputIsCorrectlyImportedFrom: inputStream .
	
	
	
	
	
	! !


!classDefinition: #Address category: 'CustomerImporter'!
Object subclass: #Address
	instanceVariableNames: 'id streetName streetNumber town zipCode province'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Address methodsFor: 'province' stamp: 'mp 6/22/2023 20:05:03'!
province

	^province! !

!Address methodsFor: 'province' stamp: 'mp 6/22/2023 20:05:04'!
province: aProvince

	province := aProvince
	! !


!Address methodsFor: 'street' stamp: 'mp 6/22/2023 20:05:03'!
streetName

	^streetName ! !

!Address methodsFor: 'street' stamp: 'mp 6/22/2023 20:05:04'!
streetName: aStreetName

	streetName := aStreetName ! !

!Address methodsFor: 'street' stamp: 'mp 6/22/2023 20:05:04'!
streetNumber

	^streetNumber ! !

!Address methodsFor: 'street' stamp: 'mp 6/22/2023 20:05:03'!
streetNumber: aStreetNumber

	streetNumber := aStreetNumber ! !


!Address methodsFor: 'town' stamp: 'mp 6/22/2023 20:05:03'!
town

	^town! !

!Address methodsFor: 'town' stamp: 'mp 6/22/2023 20:05:03'!
town: aTown

	town := aTown! !


!Address methodsFor: 'zip code' stamp: 'mp 6/22/2023 20:05:04'!
zipCode

	^zipCode! !

!Address methodsFor: 'zip code' stamp: 'mp 6/22/2023 20:05:03'!
zipCode: aZipCode

	zipCode := aZipCode! !


!Address methodsFor: 'comparing' stamp: 'mp 6/22/2023 22:01:05'!
= anAddress
	(anAddress isKindOf: self class) ifTrue: [
	^anAddress streetName = streetName and: [
		anAddress town = town and:[
			anAddress zipCode = zipCode and:[
				anAddress streetNumber  = streetNumber and:[
					anAddress province = province ]]]]].

	^false
	! !


!classDefinition: #Customer category: 'CustomerImporter'!
Object subclass: #Customer
	instanceVariableNames: 'id firstName lastName identificationType identificationNumber addresses'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Customer methodsFor: 'addresses' stamp: 'mp 6/22/2023 20:05:04'!
addAddress: anAddress

	addresses add: anAddress ! !

!Customer methodsFor: 'addresses' stamp: 'mp 6/22/2023 20:05:04'!
addresses

	^ addresses! !

!Customer methodsFor: 'addresses' stamp: 'mp 6/22/2023 21:52:16'!
containAddress: anAddress 

	^addresses includes: anAddress ! !

!Customer methodsFor: 'addresses' stamp: 'AG 6/25/2023 18:23:36'!
quantityOfAddresses

	^addresses size.! !


!Customer methodsFor: 'name' stamp: 'mp 6/22/2023 20:05:04'!
firstName

	^firstName ! !

!Customer methodsFor: 'name' stamp: 'mp 6/22/2023 20:05:04'!
firstName: aName

	firstName := aName! !

!Customer methodsFor: 'name' stamp: 'mp 6/22/2023 20:05:04'!
lastName

	^lastName ! !

!Customer methodsFor: 'name' stamp: 'mp 6/22/2023 20:05:04'!
lastName: aLastName

	lastName := aLastName
! !


!Customer methodsFor: 'identification' stamp: 'mp 6/22/2023 20:05:04'!
identificationNumber

	^identificationNumber ! !

!Customer methodsFor: 'identification' stamp: 'mp 6/22/2023 20:05:04'!
identificationNumber: anIdentificationNumber

	identificationNumber := anIdentificationNumber! !

!Customer methodsFor: 'identification' stamp: 'mp 6/22/2023 20:05:04'!
identificationType

	^identificationType ! !

!Customer methodsFor: 'identification' stamp: 'mp 6/22/2023 20:05:04'!
identificationType: anIdentificationType

	identificationType := anIdentificationType! !


!Customer methodsFor: 'initialization' stamp: 'mp 6/22/2023 20:05:04'!
initialize

	super initialize.
	addresses := OrderedCollection new.! !


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
Object subclass: #CustomerImporter
	instanceVariableNames: 'inputSream dataBaseSession'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'AG 6/25/2023 19:22:28'!
initializeWithInputStream: anInputStream onDataBaseSession: aDataBaseSession
	inputSream := anInputStream.
	dataBaseSession := aDataBaseSession.! !


!CustomerImporter methodsFor: 'evaluating' stamp: 'AG 6/25/2023 19:25:15'!
execute

	| newCustomer line |


	line := inputSream nextLine.
	[ line notNil ] whileTrue: [
		(line beginsWith: 'C') ifTrue: [ | customerData |
			customerData := line findTokens: $,.
			newCustomer := Customer new.
			newCustomer firstName: customerData second.
			newCustomer lastName: customerData third.
			newCustomer identificationType: customerData fourth.
			newCustomer identificationNumber: customerData fifth.
			dataBaseSession persist: newCustomer ].

		(line beginsWith: 'A') ifTrue: [ | addressData newAddress |
			addressData := line findTokens: $,.
			newAddress := Address new.
			newCustomer addAddress: newAddress.
			newAddress streetName: addressData second.
			newAddress streetNumber: addressData third asNumber .
			newAddress town: addressData fourth.
			newAddress zipCode: addressData fifth asNumber .
			newAddress province: addressData sixth ].

		line := inputSream nextLine. ].

	inputSream close.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'instance creation' stamp: 'AG 6/25/2023 19:22:28'!
withInputStream: anInputStream onDataBaseSession: aDataBaseSession
	^self new initializeWithInputStream: anInputStream onDataBaseSession: aDataBaseSession! !


!classDefinition: #DataBaseSession category: 'CustomerImporter'!
Object subclass: #DataBaseSession
	instanceVariableNames: 'configuration tables id'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DataBaseSession methodsFor: 'transaction management' stamp: 'mp 6/22/2023 20:05:04'!
beginTransaction

	! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'mp 6/22/2023 20:05:04'!
commit

	(tables at: Customer ifAbsent: [#()]) do: [ :aCustomer | self persistAddressesOf: aCustomer ]
	! !


!DataBaseSession methodsFor: 'closing' stamp: 'mp 6/22/2023 20:05:04'!
close

	! !


!DataBaseSession methodsFor: 'persistence - private' stamp: 'mp 6/22/2023 20:05:04'!
defineIdOf: anObject

	anObject instVarNamed: 'id' put: (self newIdFor: anObject).! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'mp 6/22/2023 20:05:04'!
delay

	(Delay forMilliseconds: 100) wait! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'mp 6/22/2023 20:05:04'!
objectsOfType: aType

	^ tables at: aType ifAbsent: [ #() ]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'mp 6/22/2023 20:05:04'!
persistAddressesOf: anObjectWithAddresses

	anObjectWithAddresses addresses do: [ :anAddress | self persist: anAddress ]
	! !


!DataBaseSession methodsFor: 'initialization' stamp: 'mp 6/22/2023 20:05:04'!
initializeFor: aConfiguration

	configuration := aConfiguration.
	tables := Dictionary new.
	id := 0.! !


!DataBaseSession methodsFor: 'id' stamp: 'mp 6/22/2023 20:05:04'!
newIdFor: anObject

	id := id + 1.
	^id! !


!DataBaseSession methodsFor: 'persistance' stamp: 'mp 6/22/2023 20:05:04'!
persist: anObject

	| table |

	self delay.
	table := tables at: anObject class ifAbsentPut: [ Set new ].

	self defineIdOf: anObject.
	table add: anObject.

	(anObject isKindOf: Customer) ifTrue: [ self persistAddressesOf: anObject ].! !


!DataBaseSession methodsFor: 'selecting' stamp: 'mp 6/22/2023 20:05:04'!
select: aCondition ofType: aType

	self delay.
	^(self objectsOfType: aType) select: aCondition ! !

!DataBaseSession methodsFor: 'selecting' stamp: 'mp 6/22/2023 20:05:04'!
selectAllOfType: aType

	self delay.
	^(self objectsOfType: aType) copy ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DataBaseSession class' category: 'CustomerImporter'!
DataBaseSession class
	instanceVariableNames: ''!

!DataBaseSession class methodsFor: 'instance creation' stamp: 'mp 6/22/2023 20:05:04'!
for: aConfiguration

	^self new initializeFor: aConfiguration! !
