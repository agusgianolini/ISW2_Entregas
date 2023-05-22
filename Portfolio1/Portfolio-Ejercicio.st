!classDefinition: #PortfolioTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!PortfolioTest methodsFor: 'testing' stamp: 'mp 5/21/2023 13:30:28'!
test01PorfolioHasZeroAsBalanceWhenCreated

	self assert: (Portfolio new) balance equals: 0.! !

!PortfolioTest methodsFor: 'testing' stamp: 'AG 5/22/2023 13:19:32'!
test02PortfolioBalanceWithOnlyOneAccountReturnAccountBalance
	
	| acc port |
	
	acc := self receptiveAccountWith100Deposit.
	
	port := self portfolioWithChild:  acc.
	
	self assert: port balance equals: 100.! !

!PortfolioTest methodsFor: 'testing' stamp: 'AG 5/22/2023 13:18:59'!
test03PortfolioWithManyAccountsReturnTheSumOfTheManyAccountsBalance
	
	| port acc1 acc2 |
	acc1 := self receptiveAccountWith100Deposit.
	
	acc2 := ReceptiveAccount new.
	acc2 register: (Withdraw for: 50).
	
	port := self portfolioWithChild:  acc1.
	port add: acc2.
	
	self assert: port balance equals: 50.! !

!PortfolioTest methodsFor: 'testing' stamp: 'AG 5/22/2023 13:26:41'!
test04PortfolioWithASecondPortfolioShouldReturnSecondPortfolioBalanceWhenAskBalance
	
	| port1 port2 acc1|
	acc1 := self receptiveAccountWith300Deposit.

	port1 := self portfolioWithChild:  acc1.	
	port2 := self portfolioWithChild:  port1.
	
	
	self assert: port2 balance equals: 300.! !

!PortfolioTest methodsFor: 'testing' stamp: 'AG 5/22/2023 13:21:18'!
test05AssertPortfolioHasRegisteredATransaction
	
	| port acc transact |
	
	transact := Deposit for: 50.
	acc := ReceptiveAccount new register: transact.
	
	port := self portfolioWithChild:  acc.
	
	self assert: (port hasRegistered: transact).
	
	! !

!PortfolioTest methodsFor: 'testing' stamp: 'AG 5/22/2023 13:23:07'!
test06PortfolioRootHasRegisteredPortfolioLeafTransaction
	
	| port1 port2 acc transaction |
	
	transaction := Deposit for: 50.
	acc := ReceptiveAccount new register: transaction.
	
	port1 := self portfolioWithChild: acc.
	port2 := self portfolioWithChild:  port1.
	
	self assert: (port2 hasRegistered: transaction).
	
	! !

!PortfolioTest methodsFor: 'testing' stamp: 'mp 5/22/2023 12:04:28'!
test07PortfolioHasZeroTransactionsWhenIsCreated
	
	| port1|	
	
	port1 := Portfolio new .	
	
	self assert: port1 transactions isEmpty.
	
	! !

!PortfolioTest methodsFor: 'testing' stamp: 'AG 5/22/2023 13:17:43'!
test08PortfolioWithOneAccountWhenAskForTransactionsShouldReturnsTransactionsOfTheAccount
	
	| port1 acc transaction |
	
	transaction := Deposit for: 50.
	acc := ReceptiveAccount new register: transaction.
	port1 := self portfolioWithChild: acc.	
	
	self assert: port1 transactions includes: transaction	.
	self assert: (port1 transactions size) equals: 1.
	
	! !

!PortfolioTest methodsFor: 'testing' stamp: 'AG 5/22/2023 13:16:45'!
test09PortfolioWithManyPortfoliosAndAccountsWhenAskTransactionsShouldReturnsAllTransactionsOfChilds
	
	| port1 port2 acc1 acc2 transaction1 transaction2|
	
	transaction1 := Deposit for: 50.
	acc1 := ReceptiveAccount new register: transaction1.
	
	transaction2 := Deposit for: 150.
	acc2 := ReceptiveAccount new register: transaction2.
	
	port1 := self portfolioWithChild: acc1.
	
	port2 := self portfolioWithChild: port1.	
	port2 add: acc2.
	
	self assert: port2 transactions includes: transaction1.
	self assert: port2 transactions includes: transaction2.
	
	! !

!PortfolioTest methodsFor: 'testing' stamp: 'AG 5/22/2023 13:23:46'!
test10ShouldRaiseErrorAddAnAccountToPortfolioThatAlreadyHasTheAccount
	
	| port acc |
	
	acc := self receptiveAccountWith50Deposit.
	port := self portfolioWithChild: acc.		
	
	self 
		should: [port add: acc] 
		raise: Error
		withExceptionDo: [:error | 
			self assert: Portfolio canNotAddAnAccountErrorMessage equals: error messageText.].! !

!PortfolioTest methodsFor: 'testing' stamp: 'AG 5/22/2023 13:15:47'!
test11ShouldRaiseErrorAddAnAccountToPortfolioThatAlreadyHasAPortfolioWithTheAccount
	
	| portfolioFather portfolioChild acc |
	
	acc := self receptiveAccountWith50Deposit.
	
	portfolioChild := self portfolioWithChild: acc.	
	
	portfolioFather := self portfolioWithChild: portfolioChild.		
	
	self 
		should: [portfolioFather add: acc] 
		raise: Error
		withExceptionDo: [:error | 
			self assert: (Portfolio canNotAddAnAccountErrorMessage = error messageText).].! !

!PortfolioTest methodsFor: 'testing' stamp: 'AG 5/22/2023 13:14:01'!
test12ShouldRaiseErrorAddAnAccountToPortfolioThatAlreadyIsIncludedOnThePortfolioFatherTree
	
	| portfolioFather portfolioChild acc |
	
	acc := self receptiveAccountWith50Deposit.
	portfolioChild := Portfolio new.		
	
	portfolioFather := self portfolioWithChild: portfolioChild.		
	portfolioFather add: acc.
	
	self 
		should: [portfolioChild add: acc] 
		raise: Error
		withExceptionDo: [:error | 
			self assert: (Portfolio canNotAddAnAccountErrorMessage = error messageText).].! !

!PortfolioTest methodsFor: 'testing' stamp: 'AG 5/22/2023 13:14:01'!
test13ShouldRaiseErrorAddAnAccountToPortfolioThatAlreadyIsIncludedOnADistantPortfolioFatherTree
	
	| portfolioDistantFather portfolioFather portfolioChild acc |
	
	acc := self receptiveAccountWith50Deposit.
	
	portfolioChild := Portfolio new.		
	
	portfolioFather := self portfolioWithChild: portfolioChild.			
	
	portfolioDistantFather := self portfolioWithChild: portfolioFather.		
	portfolioDistantFather add: acc.
	
	self 
		should: [portfolioChild add: acc] 
		raise: Error
		withExceptionDo: [:error | 
			self assert: (Portfolio canNotAddAnAccountErrorMessage = error messageText).].! !

!PortfolioTest methodsFor: 'testing' stamp: 'AG 5/22/2023 13:14:01'!
test14ShouldRaiseErrorAddAnEmptyPortfolioToAFatherPortfolioThatAlreadyHasTheEmptyPortfolio
	
	| portfolioFather portfolioChild |
	
	portfolioChild := Portfolio new.		
	
	portfolioFather := self portfolioWithChild: portfolioChild.		
	
	self 
		should: [portfolioFather add: portfolioChild] 
		raise: Error
		withExceptionDo: [:error | 
			self assert: Portfolio canNotAddAnAccountErrorMessage equals: error messageText.].! !

!PortfolioTest methodsFor: 'testing' stamp: 'AG 5/22/2023 13:24:54'!
test15ShouldRaiseErrorAddAPortfolioThatHasAnAccountThatAlreadyIsIncludedOnADistantPortfolioFatherTree
	
	| portfolioDistantFather portfolioFather portfolioChild portfolioToAdd duplicateAcc acc2|
	
	duplicateAcc := self receptiveAccountWith50Deposit.
	
	acc2 := self receptiveAccountWith300Deposit.
	
	portfolioChild := Portfolio new.		
	
	portfolioFather := self portfolioWithChild: portfolioChild.			
	
	portfolioDistantFather := self portfolioWithChild: portfolioFather.		
	portfolioDistantFather add: duplicateAcc.
	
	portfolioToAdd := self portfolioWithChild: acc2.
	portfolioToAdd add: duplicateAcc.
	
	self 
		should: [portfolioChild add: portfolioToAdd ] 
		raise: Error
		withExceptionDo: [:error | 
			self assert: (Portfolio canNotAddAnAccountErrorMessage = error messageText).].! !


!PortfolioTest methodsFor: 'setUp' stamp: 'AG 5/22/2023 13:14:01'!
portfolioWithChild: childAccount

	^ Portfolio new add: childAccount! !

!PortfolioTest methodsFor: 'setUp' stamp: 'AG 5/22/2023 13:09:09'!
receptiveAccountWith100Deposit

	^ ReceptiveAccount new register: (Deposit for: 100)! !

!PortfolioTest methodsFor: 'setUp' stamp: 'AG 5/22/2023 13:24:54'!
receptiveAccountWith300Deposit

	^ ReceptiveAccount new register:(Deposit for: 300)! !

!PortfolioTest methodsFor: 'setUp' stamp: 'AG 5/22/2023 13:06:11'!
receptiveAccountWith50Deposit

	^ ReceptiveAccount new register:(Deposit for: 50)! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:44'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:48'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:52'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:32'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:46'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 5/17/2021 17:29:53'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| deposit withdraw account |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 200.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:14:01'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 50 on: account1.
		
	self assert: 1 equals: account1 transactions size.
	self assert: (account1 transactions includes: deposit1).
! !


!classDefinition: #AccountTransaction category: 'Portfolio-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AccountTransaction methodsFor: 'balance' stamp: 'mp 5/22/2023 12:02:37'!
affectBalance: aBalance 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Ejercicio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/17/2019 03:22:00'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'as yet unclassified' stamp: 'Ag 5/15/2023 20:39:13'!
affectBalance: aBalance 
	^aBalance + self value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Ejercicio'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Withdraw category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !


!Withdraw methodsFor: 'as yet unclassified' stamp: 'Ag 5/15/2023 20:37:29'!
affectBalance: aBalance 
	^aBalance - self value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Accounts category: 'Portfolio-Ejercicio'!
Object subclass: #Accounts
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Accounts methodsFor: 'balance' stamp: 'mp 5/20/2023 16:35:36'!
balance
	self subclassResponsibility ! !


!Accounts methodsFor: 'transactions' stamp: 'mp 5/20/2023 16:35:46'!
transactions
	self subclassResponsibility ! !


!Accounts methodsFor: 'testing' stamp: 'mp 5/22/2023 12:00:54'!
has: anAccount
	self subclassResponsibility ! !

!Accounts methodsFor: 'testing' stamp: 'mp 5/20/2023 16:35:26'!
hasRegistered: aTransaction
	self subclassResponsibility ! !


!Accounts methodsFor: 'adding' stamp: 'mp 5/22/2023 11:54:30'!
handlerAddTo: aPortfolio 
	self subclassResponsibility ! !

!Accounts methodsFor: 'adding' stamp: 'mp 5/22/2023 12:02:02'!
isAddedTo: aPortfolio 
	self subclassResponsibility ! !


!classDefinition: #Portfolio category: 'Portfolio-Ejercicio'!
Accounts subclass: #Portfolio
	instanceVariableNames: 'accounts fatherPortfolio parents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'balance' stamp: 'mp 5/20/2023 16:37:18'!
balance
	^ accounts sum:[:account| account balance] ifEmpty: [0].! !


!Portfolio methodsFor: 'adding' stamp: 'AG 5/22/2023 04:12:25'!
add: anAccount
	
	self canHandleAdd: anAccount.
	
	anAccount isAddedTo: self.

	accounts add: anAccount.
	
	! !

!Portfolio methodsFor: 'adding' stamp: 'mp 5/22/2023 11:47:28'!
canHandleAdd: anAccount

	parents isEmpty 
		ifTrue: [ anAccount handlerAddTo: self ] 
		ifFalse: [
			parents do:[:account | account canHandleAdd: anAccount]]! !

!Portfolio methodsFor: 'adding' stamp: 'mp 5/22/2023 11:45:15'!
canHandleAddLeaf: aLeafAccount

	(self has: aLeafAccount ) ifTrue: [ self error: self class canNotAddAnAccountErrorMessage ]! !

!Portfolio methodsFor: 'adding' stamp: 'AG 5/22/2023 12:58:36'!
handlerAddTo: aPortfolio 

	accounts isEmpty
		ifTrue: [aPortfolio canHandleAddLeaf: self]
		ifFalse: [accounts do: [:childAccount | childAccount handlerAddTo: aPortfolio]]	.! !

!Portfolio methodsFor: 'adding' stamp: 'AG 5/22/2023 04:15:18'!
isAddedTo: anAccount

	parents add: anAccount.
	! !


!Portfolio methodsFor: 'testing' stamp: 'mp 5/22/2023 08:48:23'!
has: anAccount 
	^ (self = anAccount) or: [accounts anySatisfy: [:each | each has: anAccount]]! !

!Portfolio methodsFor: 'testing' stamp: 'mp 5/21/2023 16:43:36'!
hasRegistered: aTransaction
	
	^accounts anySatisfy: [:account | account hasRegistered: aTransaction].		! !


!Portfolio methodsFor: 'initialization' stamp: 'AG 5/22/2023 04:14:24'!
initialize

	accounts := OrderedCollection new.
	parents := OrderedCollection new.! !


!Portfolio methodsFor: 'transactions' stamp: 'mp 5/20/2023 16:41:11'!
transactions
	|transactions|
	
	transactions := OrderedCollection new.
	
	accounts do: [:account | transactions addAllLast: (account transactions)].	
	
	^transactions.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio-Ejercicio'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'error message' stamp: 'mp 5/20/2023 18:00:24'!
canNotAddAnAccountErrorMessage

	^ 'The account is included in the portfolio or in a portfolio that include this portfolio'! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Ejercicio'!
Accounts subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'NR 10/17/2019 15:06:56'!
initialize

	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'Ag 5/15/2023 20:38:56'!
balance


	^transactions inject: 0 into:[:balance :transaction| transaction affectBalance: balance]
	! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'mp 5/21/2023 15:44:07'!
has: anAccount 
	^self = anAccount .! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/17/2019 03:28:43'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !


!ReceptiveAccount methodsFor: 'adding' stamp: 'mp 5/22/2023 11:48:32'!
handlerAddTo: aPortfolio 
	aPortfolio canHandleAddLeaf: self.! !

!ReceptiveAccount methodsFor: 'adding' stamp: 'AG 5/22/2023 04:16:05'!
isAddedTo: aPortfolio 
	! !
