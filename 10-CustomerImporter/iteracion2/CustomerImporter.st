!classDefinition: #ImportTest category: 'CustomerImporter'!
TestCase subclass: #ImportTest
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'tests' stamp: 'mp 6/26/2023 21:36:46'!
assertOnlyImportJuanPerez

	self assertJuanPerezWasImportedCorrectly.
			self assertImportedRightNumberOfCustomers: 1! !

!ImportTest methodsFor: 'tests' stamp: 'mp 6/29/2023 15:30:06'!
test01ImportCorrectlyARightFile

	CustomerImporter valueFrom: self validImportData into: session..

	self assertImportedRightNumberOfCustomers: 2.
	self assertPepeSanchezWasImportedCorrecty.
	self assertJuanPerezWasImportedCorrectly ! !

!ImportTest methodsFor: 'tests' stamp: 'mp 6/29/2023 15:41:13'!
test02InvalidDataTypeShouldRaiseError
	| data |
	data := self dataWithALineWithAnInvalidTypeIdentifier.

	self should: [CustomerImporter valueFrom: (ReadStream on: data) into: session]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | 
			self assert: anError messageText equals: CustomerImporter invalidDataTypeErrorMessage.
			self assertOnlyImportJuanPerez ].
! !

!ImportTest methodsFor: 'tests' stamp: 'mp 6/29/2023 15:39:51'!
test03DataTypeNotEqualsToIdentificatorsTypesShouldRaiseError

	| data |
	data := self dataWithALineWithTheCustomerClass.

	self should: [CustomerImporter valueFrom: (ReadStream on: data) into: session]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | 
			self assert: anError messageText equals: CustomerImporter invalidDataTypeErrorMessage.
			self assertOnlyImportJuanPerez.].
! !

!ImportTest methodsFor: 'tests' stamp: 'mp 6/29/2023 15:38:43'!
test04DataTypeWithExtraFieldsShouldRaiseError
	| data |
	data := self dataWithALineWithExtraFields.

	self should: [CustomerImporter valueFrom: (ReadStream on: data) into: session	]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: CustomerImporter invalidQuantityOfParametersErrorMessage .
			self assertOnlyImportJuanPerez]
		
		
		! !

!ImportTest methodsFor: 'tests' stamp: 'mp 6/29/2023 15:38:20'!
test05DataTypeWithLessFieldsShouldRaiseError
	| data |
	data := self dataWithALineWithLessFields.

	self should: [CustomerImporter valueFrom: (ReadStream on: data) into: session	]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: CustomerImporter invalidQuantityOfParametersErrorMessage .
			self assertOnlyImportJuanPerez]
		
		
		! !

!ImportTest methodsFor: 'tests' stamp: 'mp 6/29/2023 15:37:05'!
test06CanNotImportAnAddressBeforeImportTheTheFirstCustomer
	| data |
	data := self dataWithAddressBeforeCustomer.

	self should: [CustomerImporter valueFrom: (ReadStream on: data) into: session	]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | self assert: anError messageText equals: CustomerImporter addressNeedsACustomerToBeAddedErrorMessage .
			self assertImportedRightNumberOfCustomers: 0]
		
		
		! !


!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:22:05'!
assertAddressOf: importedCustomer at: aStreetName hasNumber: aNumber town: aTown zipCode: aZipCode province: aProvince

	| importedAddress |

	importedAddress := importedCustomer addressAt: aStreetName ifNone: [ self fail ].
	self assert: aStreetName equals: importedAddress streetName.
	self assert: aNumber equals: importedAddress streetNumber.
	self assert: aTown equals: importedAddress town.
	self assert: aZipCode equals: importedAddress zipCode.
	self assert: aProvince equals: importedAddress province.

	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:27:57'!
assertCustomerWithIdentificationType: anIdType number: anIdNumber hasFirstName: aFirstName lastName: aLastName

	| importedCustomer |

	importedCustomer := self customerWithIdentificationType: anIdType number: anIdNumber.

	self assert: aFirstName equals: importedCustomer firstName.
	self assert: aLastName equals: importedCustomer lastName.
	self assert: anIdType equals: importedCustomer identificationType.
	self assert: anIdNumber equals: importedCustomer identificationNumber.

	^importedCustomer

	! !

!ImportTest methodsFor: 'assertions' stamp: 'mp 6/26/2023 21:35:19'!
assertImportedRightNumberOfCustomers: aCustomersNumber

	^ self assert: aCustomersNumber equals: (session selectAllOfType: Customer) size! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:45'!
assertJuanPerezWasImportedCorrectly

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'C' number: '23-25666777-9' hasFirstName: 'Juan' lastName: 'Perez'.
	self assertAddressOf: importedCustomer at: 'Alem' hasNumber: 1122 town: 'CABA' zipCode: 1001 province: 'CABA'
	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:05'!
assertPepeSanchezWasImportedCorrecty

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'D' number: '22333444' hasFirstName: 'Pepe' lastName: 'Sanchez'.
	self assertAddressOf: importedCustomer at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'.
	self assertAddressOf: importedCustomer at: 'Maipu' hasNumber: 888 town: 'Florida' zipCode: 1122 province: 'Buenos Aires'.


	! !


!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 00:27:50'!
setUp

	session := DataBaseSession for: (Array with: Address with: Customer).
	session beginTransaction.
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 00:28:23'!
tearDown

	session commit.
	session close.
	! !


!ImportTest methodsFor: 'customer' stamp: 'HAW 5/22/2022 18:14:22'!
customerWithIdentificationType: anIdType number: anIdNumber

	^ (session
		select: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]
		ofType: Customer) anyOne! !


!ImportTest methodsFor: 'test data' stamp: 'mp 6/29/2023 15:41:12'!
dataWithALineWithAnInvalidTypeIdentifier

	^ 'C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA
X,Pepe,Sanchez,D,22333444'! !

!ImportTest methodsFor: 'test data' stamp: 'mp 6/29/2023 15:38:43'!
dataWithALineWithExtraFields

	^ 'C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA
C, , ,Pepe,Sanchez,D,22333444
C,Juan,Lopez,C,23-25444777-9'! !

!ImportTest methodsFor: 'test data' stamp: 'mp 6/29/2023 15:38:20'!
dataWithALineWithLessFields

	^ 'C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA
C,Pepe,Sanchez
C,Juan,Lopez,C,23-25444777-9'! !

!ImportTest methodsFor: 'test data' stamp: 'mp 6/29/2023 15:39:51'!
dataWithALineWithTheCustomerClass

	^ 'C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA
Customer,Pepe,Sanchez,D,22333444'! !

!ImportTest methodsFor: 'test data' stamp: 'mp 6/29/2023 15:37:05'!
dataWithAddressBeforeCustomer

	^ 'A,Alem,1122,CABA,1001,CABA
C,Juan,Perez,C,23-25666777-9'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 18:08:08'!
validImportData

	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !


!classDefinition: #Address category: 'CustomerImporter'!
Object subclass: #Address
	instanceVariableNames: 'id streetName streetNumber town zipCode province'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province

	^province! !

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province: aProvince

	province := aProvince
	! !


!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 17:55:46'!
isAt: aStreetName

	^streetName = aStreetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName

	^streetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName: aStreetName

	streetName := aStreetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber

	^streetNumber ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber: aStreetNumber

	streetNumber := aStreetNumber ! !


!Address methodsFor: 'town' stamp: 'HAW 5/22/2022 00:19:29'!
town

	^town! !

!Address methodsFor: 'town' stamp: 'HAW 5/22/2022 00:19:29'!
town: aTown

	town := aTown! !


!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode

	^zipCode! !

!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode: aZipCode

	zipCode := aZipCode! !


!classDefinition: #Customer category: 'CustomerImporter'!
Object subclass: #Customer
	instanceVariableNames: 'id firstName lastName identificationType identificationNumber addresses'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addAddress: anAddress

	addresses add: anAddress ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 17:55:17'!
addressAt: aStreetName ifNone: aNoneBlock

	^addresses detect: [ :address | address isAt: aStreetName ] ifNone: aNoneBlock ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addresses

	^ addresses! !


!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName

	^firstName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName: aName

	firstName := aName! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName

	^lastName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName: aLastName

	lastName := aLastName
! !


!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber

	^identificationNumber ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber: anIdentificationNumber

	identificationNumber := anIdentificationNumber! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType

	^identificationType ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType: anIdentificationType

	identificationType := anIdentificationType! !


!Customer methodsFor: 'initialization' stamp: 'HAW 5/22/2022 00:19:29'!
initialize

	super initialize.
	addresses := OrderedCollection new.! !


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
Object subclass: #CustomerImporter
	instanceVariableNames: 'session readStream line newCustomer record'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'HAW 5/22/2022 18:06:47'!
initializeFrom: aReadStream into: aSession
	session := aSession.
	readStream := aReadStream.! !


!CustomerImporter methodsFor: 'error signals' stamp: 'mp 6/26/2023 21:46:55'!
signalAddressNeedsACustomerToBeAdded

	^ self error: self class addressNeedsACustomerToBeAddedErrorMessage! !

!CustomerImporter methodsFor: 'error signals' stamp: 'mp 6/26/2023 20:45:10'!
signalInvalidDataType

	^ self error: self class invalidDataTypeErrorMessage! !

!CustomerImporter methodsFor: 'error signals' stamp: 'mp 6/26/2023 21:19:24'!
signalInvalidQuantityOfParameters

	^ self error: self class invalidQuantityOfParametersErrorMessage! !


!CustomerImporter methodsFor: 'import' stamp: 'mp 6/26/2023 20:14:49'!
createRecord

	^ record := line findTokens: $,! !

!CustomerImporter methodsFor: 'import' stamp: 'mp 6/26/2023 21:47:19'!
importAddress
	| newAddress |
	
	self validAddressRecord.
	self validCustomerToAdd.
	newAddress := Address new.
	newCustomer addAddress: newAddress.
	newAddress streetName: record second.
	newAddress streetNumber: record third asNumber .
	newAddress town: record fourth.
	newAddress zipCode: record fifth asNumber .
	newAddress province: record sixth.
! !

!CustomerImporter methodsFor: 'import' stamp: 'mp 6/26/2023 21:22:10'!
importCustomer

	self validCustomerRecord.
	
	newCustomer := Customer new.
			newCustomer firstName: record second.
			newCustomer lastName: record third.
			newCustomer identificationType: record fourth.
			newCustomer identificationNumber: record fifth.
			session persist: newCustomer! !

!CustomerImporter methodsFor: 'import' stamp: 'mp 6/26/2023 20:44:10'!
importRecord

	self isCustomerRecord ifTrue: [ self importCustomer ]
		ifFalse: [	self isAddressRecord ifTrue: [ self importAddress ]
			ifFalse: [self signalInvalidDataType.]]! !


!CustomerImporter methodsFor: 'evaluating' stamp: 'mp 6/26/2023 20:22:19'!
hasLinesLeft

	line := readStream nextLine.
	^line notNil! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'mp 6/26/2023 20:49:35'!
isAddressRecord

	^ record first = 'A'! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'mp 6/26/2023 20:49:52'!
isCustomerRecord

	^ record first ='C'! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'mp 6/26/2023 21:25:57'!
validAddressRecord

	^ self validateRecordSizeIs: 6.! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'mp 6/26/2023 21:25:41'!
validCustomerRecord

	^ self validateRecordSizeIs: 5! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'mp 6/26/2023 21:47:19'!
validCustomerToAdd

	^ newCustomer ifNil:[self signalAddressNeedsACustomerToBeAdded]! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'mp 6/26/2023 21:25:41'!
validateRecordSizeIs: aSize

	^ (record size = aSize) ifFalse:[self signalInvalidQuantityOfParameters ]! !

!CustomerImporter methodsFor: 'evaluating' stamp: 'mp 6/26/2023 20:22:36'!
value
	 
	[self hasLinesLeft ] whileTrue: [
		self createRecord.
		self importRecord].

	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 18:06:47'!
from: aReadStream into: aSession
	^self new initializeFrom: aReadStream into: aSession! !


!CustomerImporter class methodsFor: 'importing' stamp: 'HAW 5/22/2022 18:11:27'!
valueFrom: aReadStream into: aSession

	^(self from: aReadStream into: aSession) value! !


!CustomerImporter class methodsFor: 'evaluating' stamp: 'mp 6/26/2023 21:46:25'!
addressNeedsACustomerToBeAddedErrorMessage

	^ 'Address needs customer to be added!!'! !

!CustomerImporter class methodsFor: 'evaluating' stamp: 'mp 6/26/2023 20:45:00'!
invalidDataTypeErrorMessage

	^ 'Invalid data type!!'! !

!CustomerImporter class methodsFor: 'evaluating' stamp: 'mp 6/26/2023 21:18:56'!
invalidQuantityOfParametersErrorMessage

	^ 'Invalid quantity of parameters!!'! !


!classDefinition: #DataBaseSession category: 'CustomerImporter'!
Object subclass: #DataBaseSession
	instanceVariableNames: 'configuration tables id'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 5/22/2022 00:19:29'!
beginTransaction

	! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 5/22/2022 19:17:36'!
commit

	(tables at: Customer ifAbsent: [#()]) do: [ :aCustomer | self persistAddressesOf: aCustomer ]
	! !


!DataBaseSession methodsFor: 'closing' stamp: 'HAW 5/22/2022 00:19:29'!
close

	! !


!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
defineIdOf: anObject

	anObject instVarNamed: 'id' put: (self newIdFor: anObject).! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
delay

	(Delay forMilliseconds: 100) wait! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 19:29:06'!
objectsOfType: aType

	^ tables at: aType ifAbsent: [ #() ]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
persistAddressesOf: anObjectWithAddresses

	anObjectWithAddresses addresses do: [ :anAddress | self persist: anAddress ]
	! !


!DataBaseSession methodsFor: 'initialization' stamp: 'HAW 5/22/2022 00:19:29'!
initializeFor: aConfiguration

	configuration := aConfiguration.
	tables := Dictionary new.
	id := 0.! !


!DataBaseSession methodsFor: 'id' stamp: 'HAW 5/22/2022 00:19:29'!
newIdFor: anObject

	id := id + 1.
	^id! !


!DataBaseSession methodsFor: 'persistance' stamp: 'HAW 5/22/2022 00:19:29'!
persist: anObject

	| table |

	self delay.
	table := tables at: anObject class ifAbsentPut: [ Set new ].

	self defineIdOf: anObject.
	table add: anObject.

	(anObject isKindOf: Customer) ifTrue: [ self persistAddressesOf: anObject ].! !


!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 5/22/2022 19:29:06'!
select: aCondition ofType: aType

	self delay.
	^(self objectsOfType: aType) select: aCondition ! !

!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 5/22/2022 19:29:06'!
selectAllOfType: aType

	self delay.
	^(self objectsOfType: aType) copy ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DataBaseSession class' category: 'CustomerImporter'!
DataBaseSession class
	instanceVariableNames: ''!

!DataBaseSession class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 00:19:29'!
for: aConfiguration

	^self new initializeFor: aConfiguration! !
