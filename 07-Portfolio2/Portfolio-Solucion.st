!classDefinition: #PortfolioTest category: 'Portfolio-Solucion'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioTest methodsFor: 'test' stamp: 'HAW 5/25/2019 11:16:26'!
test01BalanceOfPortfolioWithoutAccountsIsZero

	self assert: 0 equals: Portfolio new balance! !

!PortfolioTest methodsFor: 'test' stamp: 'NR 5/27/2021 17:36:04'!
test02BalanceOfPortfolioWithAccountsIsSumOfAccountsBalance

	| account portfolio |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: account balance equals: portfolio balance! !

!PortfolioTest methodsFor: 'test' stamp: 'HAW 5/25/2019 11:23:25'!
test03BalanceOfPortfolioIsCalculatedRecursivelyOnPortfolios

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortofolio |
	
	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	Withdraw register: 50 on: composedPortfolioAccount.
	composedPortofolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolioAccount balance + simplePortfolio balance) equals: composedPortofolio balance! !

!PortfolioTest methodsFor: 'test' stamp: 'HAW 5/25/2019 11:43:15'!
test04PortfolioWithoutAccountsHasNoRegisteredTransaction

	self deny: (Portfolio new hasRegistered: (Deposit for: 100))! !

!PortfolioTest methodsFor: 'test' stamp: 'HAW 5/25/2019 11:43:11'!
test05PortfolioHasRegisteredItsAccountsTransactions

	| account portfolio deposit |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: (portfolio hasRegistered: deposit)! !

!PortfolioTest methodsFor: 'test' stamp: 'HAW 5/25/2019 11:58:06'!
test06PortfolioLooksForRegisteredTransactionsRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolio hasRegistered: simplePortfolioAccountDeposit).
	self assert: (composedPortfolio hasRegistered: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'test' stamp: 'HAW 5/25/2019 11:58:10'!
test07PortfolioHasNoTransactionWhenHasNoAccounts

	self assert: Portfolio new transactions isEmpty! !

!PortfolioTest methodsFor: 'test' stamp: 'NR 6/22/2020 07:31:19'!
test08PortfolioTransactionsIncludesAllItsAccountsTransactions

	| account portfolio accountDeposit anotherAccount portfolioTransactions anotherAccountWithdraw |
	
	account := ReceptiveAccount new.
	accountDeposit := Deposit register: 100 on: account.
	anotherAccount := ReceptiveAccount new.
	anotherAccountWithdraw := Withdraw register: 100 on: account.
	portfolio := Portfolio with: account.
	
	portfolioTransactions := portfolio transactions.
	
	self assert: 2 equals: portfolioTransactions size.
	self assert: (portfolioTransactions includes: accountDeposit).
	self assert: (portfolioTransactions includes: anotherAccountWithdraw)! !

!PortfolioTest methodsFor: 'test' stamp: 'HAW 5/25/2019 11:58:20'!
test09PortfolioTransactionsAreCalculatedRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit composedPortfolioTransactions |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	composedPortfolioTransactions := composedPortfolio transactions.
	self assert: 2 equals: composedPortfolioTransactions size.
	self assert: (composedPortfolioTransactions includes: simplePortfolioAccountDeposit).
	self assert: (composedPortfolioTransactions includes: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'test' stamp: 'HAW 5/25/2019 11:58:24'!
test10PortfolioCanNotIncludeTheSameAccountMoreThanOnce

	| account portfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio with: account.
	
	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: portfolio accountsSize.
			self assert: (portfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'test' stamp: 'HAW 5/25/2019 11:58:28'!
test11PortfolioCanNotIncludeAccountOfItsPortfolios

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	composedPortfolio := Portfolio with: simplePortfolio.
	
	self 
		should: [ composedPortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: composedPortfolio accountsSize.
			self assert: (composedPortfolio accountsIncludes: simplePortfolio) ]! !

!PortfolioTest methodsFor: 'test' stamp: 'HAW 5/25/2019 11:58:32'!
test12PortfolioCanNotIncludeItself

	| account simplePortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	
	self 
		should: [ simplePortfolio add: simplePortfolio ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: simplePortfolio accountsSize.
			self assert: (simplePortfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'test' stamp: 'HAW 5/25/2019 12:01:51'!
test13ComposedPortfolioCanNotHaveParentPortfolioAccount

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio new.
	composedPortfolio := Portfolio with: simplePortfolio.
	composedPortfolio add: account.
	
	self 
		should: [ simplePortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: simplePortfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'test' stamp: 'HAW 5/25/2019 12:12:16'!
test14ComposedPortfolioCanNotHaveAccountOfAnyRootParentRecursively

	| account leftParentPortfolio leftRootParentPortfolio portfolio rightParentPortfolio rightRootParentPortfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio new.
	leftParentPortfolio := Portfolio with: portfolio .
	leftRootParentPortfolio := Portfolio with: leftParentPortfolio.
	leftRootParentPortfolio add: account.
	
	rightParentPortfolio := Portfolio with: portfolio .
	rightRootParentPortfolio := Portfolio with: rightParentPortfolio.
	rightRootParentPortfolio add: account.

	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'test' stamp: 'HAW 5/29/2019 16:31:18'!
test15PortfolioCanNotIncludeAnyOfTheComposedAccountOfPortfolioToAdd

	| portfolioToAdd portfolioToModify rootPortfolio sharedAccount |
	
	sharedAccount := ReceptiveAccount new.
	portfolioToModify := Portfolio new.
	rootPortfolio := Portfolio with: sharedAccount with: portfolioToModify.
	portfolioToAdd := Portfolio with: sharedAccount.
	
	self 
		should: [ portfolioToModify add: portfolioToAdd ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolioToModify accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'test' stamp: 'mp 5/30/2023 20:41:41'!
test16PortfolioKnowsItsName

	| portfolio |
	
	
	
	portfolio := Portfolio named: 'Portfolio de hijos'.
	
	self assert: 'Portfolio de hijos' equals: portfolio name! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Solucion'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccountTest methodsFor: 'test' stamp: 'HAW 5/23/2019 15:19:48'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'test' stamp: 'HAW 5/23/2019 15:19:54'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'test' stamp: 'HAW 5/23/2019 15:20:02'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'test' stamp: 'HAW 5/23/2019 15:20:32'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'test' stamp: 'HAW 5/23/2019 15:20:46'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'test' stamp: 'HAW 5/23/2019 15:20:54'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'test' stamp: 'HAW 5/23/2019 15:21:24'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 100 on: account1.
		
	self assert: 1 equals: account1 transactions size .
	self assert: (account1 transactions includes: deposit1).
! !

!ReceptiveAccountTest methodsFor: 'test' stamp: 'mp 5/30/2023 20:36:27'!
test08AccountKnowsItsName

	| account1 |
	
	account1 := ReceptiveAccount named: 'cuenta de juan'.
		
	self assert: 'cuenta de juan' equals: account1 name .
	
! !


!classDefinition: #ReportTest category: 'Portfolio-Solucion'!
TestCase subclass: #ReportTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReportTest methodsFor: 'test' stamp: 'AG 6/1/2023 16:31:20'!
test01AnEmptyReceptiveAccountHasZeroBalanceAccountSummary

	|acc1 reporte|
	
	acc1 := ReceptiveAccount new.	
	
	reporte := OrderedCollection new.
	reporte add: 'Balance = 0'.
	
	self assert: (AccountSummaryReporter for: acc1) accountSummary equals: reporte.! !

!ReportTest methodsFor: 'test' stamp: 'AG 6/1/2023 11:12:58'!
test02AddDepositToReceptiveAccountAffectsAccountSummary

	|acc1 reporte|
	
	acc1 := ReceptiveAccount new register: (Deposit for: 50).	
	reporte := OrderedCollection new.
	reporte add: 'Depósito por 50.'.
	reporte add: 'Balance = 50'.
	
	self assert: (AccountSummaryReporter for: acc1) accountSummary equals: reporte.! !

!ReportTest methodsFor: 'test' stamp: 'AG 6/1/2023 11:13:33'!
test03AddWithdrawToReceptiveAccountAffectsAccountSummary

	|acc1 reporte|
	
	acc1 := ReceptiveAccount new register: (Withdraw for: 100).	
	reporte := OrderedCollection new.
	reporte add: 'Extracción por 100.'.
	reporte add: 'Balance = -100'.
	
	self assert: (AccountSummaryReporter for: acc1) accountSummary equals: reporte.! !

!ReportTest methodsFor: 'test' stamp: 'AG 6/1/2023 11:14:41'!
test04TransferFromReceptiveAccountIsAddedToSummaryAsTransferOut

	|acc1 acc2 reporte|
	
	acc1 := ReceptiveAccount new.	
	acc2 := ReceptiveAccount new.
	Transfer with: 20 from: acc1 to: acc2.
	
	reporte := OrderedCollection new.
	reporte add: 'Salida por transferencia de 20.'.
	reporte add: 'Balance = -20'.
	
	self assert: (AccountSummaryReporter for: acc1) accountSummary equals: reporte.! !

!ReportTest methodsFor: 'test' stamp: 'AG 6/1/2023 11:34:18'!
test05TransferToReceptiveAccountIsAddedToSummaryAsTransferIn

	|acc1 acc2 reporte|
	
	acc1 := ReceptiveAccount new.	
	acc2 := ReceptiveAccount new.
	Transfer with: 30 from: acc2 to: acc1.
	
	reporte := OrderedCollection new.
	reporte add: 'Entrada por transferencia de 30.'.
	reporte add: 'Balance = 30'.
	
	self assert: (AccountSummaryReporter for: acc1) accountSummary equals: reporte.! !

!ReportTest methodsFor: 'test' stamp: 'AG 6/1/2023 11:15:59'!
test06ManyTransactionsAreAddedToAccountSummaryInOrder

	|acc1 acc2 reporte|
	
	acc1 := ReceptiveAccount new.	
	acc2 := ReceptiveAccount new.
	
	acc1 register: (Deposit for: 100).
	acc1 register: (Withdraw for: 50).
	
	Transfer with: 20 from: acc1 to: acc2.
	Transfer with: 30 from: acc2 to: acc1.
	
	reporte := OrderedCollection new.
	reporte add: 'Depósito por 100.'.
	reporte add: 'Extracción por 50.'.
	reporte add: 'Salida por transferencia de 20.'.
	reporte add: 'Entrada por transferencia de 30.'.
	reporte add: 'Balance = 60'.
	
	self assert: (AccountSummaryReporter for: acc1) accountSummary equals: reporte.! !

!ReportTest methodsFor: 'test' stamp: 'AG 6/1/2023 11:16:40'!
test07TransferNetOfNewReceptiveAccountEqualsZero

	|acc1|
	
	acc1 := ReceptiveAccount new.	
	
	self assert: (TransferNetReporter for: acc1) transferNet equals: 0.! !

!ReportTest methodsFor: 'test' stamp: 'AG 6/1/2023 11:18:17'!
test08TransferInSumsItsValueToTransferNet

	|acc1 acc2|
	
	acc1 := ReceptiveAccount new.	
	acc2 := ReceptiveAccount new.
	Transfer with: 30 from: acc2 to: acc1.
	
	
	self assert: (TransferNetReporter for: acc1) transferNet equals: 30.! !

!ReportTest methodsFor: 'test' stamp: 'AG 6/1/2023 11:18:55'!
test09TransferOutSubstractsItsValueToTransferNet

	|acc1 acc2|
	
	acc1 := ReceptiveAccount new.	
	acc2 := ReceptiveAccount new.
	Transfer with: 30 from: acc1 to: acc2.
	
	self assert: (TransferNetReporter for: acc1) transferNet equals: -30.! !

!ReportTest methodsFor: 'test' stamp: 'AG 6/1/2023 11:19:39'!
test10DepositAndWithdrawDontAffectTransferNet

	|acc1 |
	
	acc1 := ReceptiveAccount new.	
	acc1 register: (Deposit for: 50).
	acc1 register: (Withdraw for: 100).
	
	self assert: (TransferNetReporter for: acc1) transferNet equals: 0.! !

!ReportTest methodsFor: 'test' stamp: 'AG 6/1/2023 11:20:28'!
test11ManyTransfersAffectTransferNet

	|acc1 acc2|
	
	acc1 := ReceptiveAccount new.	
	acc2 := ReceptiveAccount new.
	Transfer with: 30 from: acc1 to: acc2.
	Transfer with: 50 from: acc1 to: acc2.
	Transfer with: 20 from: acc2 to: acc1.
	
	self assert: (TransferNetReporter for: acc1) transferNet equals: -60.! !

!ReportTest methodsFor: 'test' stamp: 'AG 6/1/2023 11:25:46'!
test12PortfolioReportHasItsAccountsTransactionsAndPortfolioBalance

	|portfolio acc1 acc2 reporte|
	
	acc1 := ReceptiveAccount new.	
	acc2 := ReceptiveAccount new.
	
	acc1 register: (Deposit for: 100).
	acc1 register: (Withdraw for: 50).
	
	Transfer with: 20 from: acc1 to: acc2.
	Transfer with: 30 from: acc2 to: acc1.
	
	portfolio := Portfolio with: acc1.
	portfolio add: acc2.
	
	reporte := OrderedCollection new.
	reporte add: 'Depósito por 100.'.
	reporte add: 'Extracción por 50.'.
	reporte add: 'Salida por transferencia de 20.'.
	reporte add: 'Entrada por transferencia de 30.'.
	reporte add: 'Entrada por transferencia de 20.'.
	reporte add: 'Salida por transferencia de 30.'.
	reporte add: 'Balance = 50'.
	
	self assert: (AccountSummaryReporter for: portfolio) accountSummary equals: reporte.! !

!ReportTest methodsFor: 'test' stamp: 'AG 6/1/2023 11:28:47'!
test13NameTreeReporterOfEmptyPortfolioHasPortfolioName

	|portfolio reporte|
	
	
	portfolio := Portfolio named: 'Portfolio sin cuentas'.
	
	
	reporte := OrderedCollection new.
	reporte add: 'Portfolio sin cuentas'.
	
	
	self assert: (AccountNameTreeReporter for: portfolio) accountNameTree equals: reporte.! !

!ReportTest methodsFor: 'test' stamp: 'AG 6/1/2023 11:29:14'!
test14NameTreeReporterOfPortfolioHasPortfolioNameAndAccountsName

	|portfolio acc1 acc2 reporte |
	
	
	portfolio := Portfolio named: 'Portfolio con cuentas'.
	acc1 := ReceptiveAccount named: 'Cuenta de juan'.	
	acc2 := ReceptiveAccount named: 'Cuenta de Maria'.
	portfolio add: acc1.
	portfolio add: acc2.
	
	reporte := OrderedCollection new.
	reporte add: 'Portfolio con cuentas'.
	
	reporte add: (' ', acc1 name).
	reporte add: (' ' , acc2 name).
	
	
	self assert: (AccountNameTreeReporter for: portfolio) accountNameTree equals: reporte.! !

!ReportTest methodsFor: 'test' stamp: 'AG 6/1/2023 11:32:50'!
test15NameTreeReporterIdentsAsTreeDepthIncreases

	|portfolio portfolioHijo acc1 reporte|
	
	
	portfolio := Portfolio named: 'Portfolio con cuentas'.
	portfolioHijo := Portfolio named: 'Portfolio hijo de cuentas'.
	acc1 := ReceptiveAccount named: 'Cuenta de juan'.	
	
	portfolioHijo add: acc1.
	portfolio add: portfolioHijo .
	
	reporte := OrderedCollection new.
	reporte add: 'Portfolio con cuentas'.	
	reporte add: ' Portfolio hijo de cuentas'.	
	reporte add: '  Cuenta de juan'.
		
	
	self assert: (AccountNameTreeReporter for: portfolio) accountNameTree equals: reporte.! !

!ReportTest methodsFor: 'test' stamp: 'AG 6/1/2023 11:33:38'!
test16TreeReporterHasAccountsTransactions

	|portfolio portfolioChild acc1 acc2 reporte|
	
	portfolio := Portfolio named: 'Portfolio familiar'.
	portfolioChild := Portfolio named: 'Portfolio de Maria'.
	
	acc1 := ReceptiveAccount named: 'Cuenta de juan'.		
	acc1 register: (Deposit for: 250).
	acc1 register: (Withdraw for: 50).
	
	acc2 := ReceptiveAccount named: 'Cuenta de Maria'.		
	Transfer with: 80 from: acc1 to: acc2.
	
	portfolio add: acc1 .
	portfolio add: portfolioChild .
	portfolioChild add: acc2.
	
	reporte := OrderedCollection new.
	reporte add: 'Portfolio familiar'.		
	reporte add: ' Cuenta de juan'.
	reporte add: '  Depósito por 250.'.	
	reporte add: '  Extracción por 50.'.			
	reporte add: '  Salida por transferencia de 80.'.		
	reporte add: '  Balance = 120'.		
	reporte add: ' Portfolio de Maria'.		
	reporte add: '  Cuenta de Maria'.
	reporte add: '   Entrada por transferencia de 80.'.	
	reporte add: '   Balance = 80'.		
	
	self assert: (AccountTransactionsTreeReporter for: portfolio) accountTransactionsTree equals: reporte.
	
	! !


!classDefinition: #TransferTest category: 'Portfolio-Solucion'!
TestCase subclass: #TransferTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferTest methodsFor: 'test' stamp: 'AG 6/1/2023 15:46:47'!
test01TransferToAccountAffectsBalance

	|transfer acc1 acc2|
	
	acc1 := self receptiveAccountWith150Deposit.
	acc2 := ReceptiveAccount new.
	transfer := self transfer50To: acc2 from: acc1.
	
	self assert: acc1 balance equals: 100.
	self assert: acc2 balance equals: 50.
	! !

!TransferTest methodsFor: 'test' stamp: 'AG 6/1/2023 15:46:47'!
test02TransferKnowsItsValue

	|transfer acc1 acc2|
	
	acc1 := self receptiveAccountWith150Deposit.
	acc2 := ReceptiveAccount new.
	transfer := self transfer50To: acc2 from: acc1.
	
	self assert: transfer value equals: 50.
	! !

!TransferTest methodsFor: 'test' stamp: 'AG 6/1/2023 15:46:47'!
test03TransferOutCounterPartIsTransferIn

	|transactionOut transactionIn acc1 acc2|
	
	acc1 := ReceptiveAccount new.
	acc2 := ReceptiveAccount new.
	self transfer50To: acc2 from: acc1.
		
	transactionOut := acc1 transactions first. 
	transactionIn := acc2 transactions first.
	
	self assert: transactionOut counterPart equals: transactionIn.
	! !

!TransferTest methodsFor: 'test' stamp: 'AG 6/1/2023 15:46:47'!
test04TransferInCounterPartIsTransferOut

	|transactionOut transactionIn acc1 acc2|
	
	acc1 := ReceptiveAccount new.
	acc2 := ReceptiveAccount new.
	self transfer50To: acc2 from: acc1.
		
	transactionOut := acc1 transactions first. 
	transactionIn := acc2 transactions first.
	
	self assert: transactionIn counterPart equals: transactionOut.
	! !

!TransferTest methodsFor: 'test' stamp: 'AG 6/1/2023 11:53:42'!
test05ZeroValueTransferShouldRaiseInvalidAmmountError

	|acc1 acc2|
	
	acc1 := ReceptiveAccount new.
	acc2 := ReceptiveAccount new.
	
	self 
		should: [Transfer with: 0 from: acc1 to: acc2.]
		raise: Error
		withExceptionDo: [:error | 
			self assert: Transfer invalidAmountErrorDescription equals: error messageText.].
	
	! !


!TransferTest methodsFor: 'setup' stamp: 'AG 6/1/2023 11:57:05'!
receptiveAccountWith150Deposit

	^ ReceptiveAccount new register:(Deposit for: 150)! !

!TransferTest methodsFor: 'setup' stamp: 'AG 6/1/2023 15:48:03'!
transfer50To: aBeneficiaryAccount from: aCreditorAccount

	^ Transfer with: 50 from: aCreditorAccount to: aBeneficiaryAccount! !


!classDefinition: #Account category: 'Portfolio-Solucion'!
Object subclass: #Account
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:23:47'!
hasRegistered: aTransaction

	self subclassResponsibility ! !

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:24:25'!
isComposedBy: anAccount

	self subclassResponsibility ! !


!Account methodsFor: 'balance' stamp: 'HAW 5/25/2019 12:23:40'!
balance

	self subclassResponsibility ! !


!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:27'!
addTransactionsTo: aCollectionOfTransactions

	self subclassResponsibility ! !

!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:15'!
transactions

	self subclassResponsibility ! !


!Account methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:24:04'!
addedTo: aPortfolio

	self subclassResponsibility ! !


!Account methodsFor: 'name' stamp: 'mp 5/31/2023 21:42:33'!
name
	self subclassResponsibility ! !


!classDefinition: #Portfolio category: 'Portfolio-Solucion'!
Account subclass: #Portfolio
	instanceVariableNames: 'accounts parents name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:20'!
accountsIncludes: anAccount

	^accounts includes: anAccount ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:05:04'!
accountsIsEmpty
	
	^accounts isEmpty ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:06'!
accountsSize
	
	^accounts size! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:19:20'!
add: accountToAdd

	self assertCanAdd: accountToAdd.
		
	accounts add: accountToAdd.
	accountToAdd addedTo: self 
	! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:17:31'!
rootParents
	
	| rootParents |
	
	rootParents := Set new.
	self addRootParentsTo: rootParents.
	
	^ rootParents! !


!Portfolio methodsFor: 'initialization' stamp: 'HAW 5/25/2019 12:03:18'!
initialize

	accounts := OrderedCollection new.
	parents := OrderedCollection new.! !

!Portfolio methodsFor: 'initialization' stamp: 'mp 5/30/2023 20:42:43'!
initializeWith: aName

	name := aName.
	accounts := OrderedCollection new.
	parents := OrderedCollection new.! !


!Portfolio methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:19:36'!
balance
	
	^accounts sum: [ :anAccount | anAccount balance ] ifEmpty: [ 0 ]! !


!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:42:55'!
addTransactionsTo: aCollectionOfTransactions

	accounts do: [ :anAccount | anAccount addTransactionsTo: aCollectionOfTransactions ]! !

!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:32'!
transactions
	
	| transactions |
	
	transactions := OrderedCollection new.
	accounts do: [ :anAccount | anAccount addTransactionsTo: transactions ].
	
	^transactions ! !


!Portfolio methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:02:59'!
addedTo: aPortfolio 
	
	parents add: aPortfolio ! !


!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:20:56'!
anyRootParentIsComposedBy: accountToAdd

	^self rootParents anySatisfy: [ :aParent | aParent isComposedBy: accountToAdd]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:28:29'!
hasRegistered: aTransaction

	^accounts anySatisfy: [ :anAccount | anAccount hasRegistered: aTransaction ]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/29/2019 16:24:54'!
isComposedBy: anAccount

	^ self = anAccount or: [ accounts anySatisfy: [ :composedAccount | (composedAccount isComposedBy: anAccount) or: [ anAccount isComposedBy: composedAccount ]]]! !


!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:17:31'!
addRootParentsTo: rootParents

	parents 
		ifEmpty: [ rootParents add: self ] 
		ifNotEmpty: [ parents do: [ :aParent | aParent addRootParentsTo: rootParents ]]! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:20:36'!
assertCanAdd: accountToAdd

	(self anyRootParentIsComposedBy: accountToAdd) ifTrue: [ self signalCanNotAddAccount ].
! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 11:48:34'!
signalCanNotAddAccount
	
	self error: self class canNotAddAccountErrorMessage! !


!Portfolio methodsFor: 'as yet unclassified' stamp: 'mp 5/31/2023 21:31:58'!
executeForAccountFor: anAccountNameTreeReporter
	
	anAccountNameTreeReporter executeForPortfolioOf: self ! !

!Portfolio methodsFor: 'as yet unclassified' stamp: 'mp 5/31/2023 21:33:24'!
executeOnChildsAccountsFor: anAccountNameTreeReporter
	
	accounts do: [:account | account executeForAccountFor: anAccountNameTreeReporter ].
	! !

!Portfolio methodsFor: 'as yet unclassified' stamp: 'mp 5/31/2023 21:35:41'!
executeOnTransactionsFor: aReporter 
	
	accounts do: [:account | account executeOnTransactionsFor: aReporter]! !


!Portfolio methodsFor: 'name' stamp: 'mp 5/30/2023 20:43:03'!
name
	^name! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio-Solucion'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:48:55'!
canNotAddAccountErrorMessage
	
	^'Can not add repeated account to a portfolio'! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'mp 5/30/2023 20:42:15'!
named: aName 
	^self new initializeWith: aName! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:18:21'!
with: anAccount

	^self new 
		add: anAccount;
		yourself! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:23:59'!
with: anAccount with: anotherAccount

	^self new 
		add: anAccount;
		add: anotherAccount;
		yourself! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Solucion'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:35'!
initialize

	super initialize.
	transactions := OrderedCollection new.! !

!ReceptiveAccount methodsFor: 'initialization' stamp: 'mp 5/30/2023 20:38:53'!
initializeWith: aName

	super initialize.
	name := aName.
	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:52'!
addTransactionsTo: aCollectionOfTransactions

	aCollectionOfTransactions addAll: transactions ! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'AG 5/22/2023 21:58:05'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:24:46'!
balance

	^transactions 
		inject: 0
		into: [ :currentBalance :transaction | transaction affectBalance: currentBalance ]! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/21/2019 18:55:56'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:54:51'!
isComposedBy: anAccount

	^self = anAccount ! !


!ReceptiveAccount methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:03:32'!
addedTo: aPortfolio 
	
	! !


!ReceptiveAccount methodsFor: 'as yet unclassified' stamp: 'mp 5/31/2023 21:31:58'!
executeForAccountFor: anAccountNameTreeReporter
	
	anAccountNameTreeReporter executeForReceptiveAccountOf: self ! !

!ReceptiveAccount methodsFor: 'as yet unclassified' stamp: 'mp 5/31/2023 21:37:55'!
executeOnTransactionsFor: aReporter
	
	transactions do: [:transaction | transaction executeOnTransactionFor: aReporter].
	
	
! !


!ReceptiveAccount methodsFor: 'name' stamp: 'mp 5/30/2023 20:39:25'!
name
	^name! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ReceptiveAccount class' category: 'Portfolio-Solucion'!
ReceptiveAccount class
	instanceVariableNames: ''!

!ReceptiveAccount class methodsFor: 'as yet unclassified' stamp: 'mp 5/30/2023 20:38:33'!
named: aName
	
	^self new initializeWith: aName! !


!classDefinition: #AccountTransaction category: 'Portfolio-Solucion'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountTransaction methodsFor: 'value' stamp: 'mp 5/26/2023 18:57:07'!
value 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:39'!
affectBalance: aBalance

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Solucion'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/21/2019 18:54:27'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'private' stamp: 'mp 5/31/2023 21:36:59'!
executeOnTransactionFor: aReporter

	^aReporter executeForDepositOf: self.! !


!Deposit methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:02'!
affectBalance: aBalance

	^aBalance + value ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Solucion'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #TransferPart category: 'Portfolio-Solucion'!
AccountTransaction subclass: #TransferPart
	instanceVariableNames: 'transfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferPart methodsFor: 'initialization' stamp: 'mp 5/26/2023 18:55:23'!
initializeFor: aTransfer

	transfer := aTransfer .! !


!TransferPart methodsFor: 'value' stamp: 'mp 5/26/2023 18:55:27'!
value

	^ transfer value! !


!TransferPart methodsFor: 'counterPart' stamp: 'mp 5/26/2023 18:49:53'!
counterPart

	self subclassResponsibility ! !


!classDefinition: #TransferIn category: 'Portfolio-Solucion'!
TransferPart subclass: #TransferIn
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferIn methodsFor: 'balance' stamp: 'mp 5/26/2023 18:35:15'!
affectBalance: aBalance

	^aBalance + (self value) ! !


!TransferIn methodsFor: 'counterPart' stamp: 'mp 5/26/2023 18:55:01'!
counterPart

	^transfer counterPartOfTransferIn.! !


!TransferIn methodsFor: 'execution' stamp: 'mp 5/31/2023 21:37:29'!
executeOnTransactionFor: aReporter

	^aReporter executeForTransferInOf: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferIn class' category: 'Portfolio-Solucion'!
TransferIn class
	instanceVariableNames: ''!

!TransferIn class methodsFor: 'as yet unclassified' stamp: 'mp 5/26/2023 18:28:04'!
of: aTransfer

	^ self new initializeFor: aTransfer .! !


!classDefinition: #TransferOut category: 'Portfolio-Solucion'!
TransferPart subclass: #TransferOut
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferOut methodsFor: 'counterPart' stamp: 'mp 5/26/2023 18:55:58'!
counterPart

	^transfer counterPartOfTransferOut.! !


!TransferOut methodsFor: 'execution' stamp: 'mp 5/31/2023 21:37:38'!
executeOnTransactionFor: aReporter

	^aReporter executeForTransferOutOf: self.! !


!TransferOut methodsFor: 'balance' stamp: 'mp 5/26/2023 18:35:34'!
affectBalance: aBalance

	^aBalance - (self value) .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferOut class' category: 'Portfolio-Solucion'!
TransferOut class
	instanceVariableNames: ''!

!TransferOut class methodsFor: 'as yet unclassified' stamp: 'mp 5/26/2023 18:33:24'!
of: aTransfer

	^ self new initializeFor: aTransfer .! !


!classDefinition: #Withdraw category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !


!Withdraw methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:15'!
affectBalance: aBalance

	^aBalance - value! !


!Withdraw methodsFor: 'private' stamp: 'mp 5/31/2023 21:37:47'!
executeOnTransactionFor: aReporter

	^aReporter executeForWithdrawOf: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Solucion'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #AccountTransactionsReporter category: 'Portfolio-Solucion'!
Object subclass: #AccountTransactionsReporter
	instanceVariableNames: 'account'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountTransactionsReporter methodsFor: 'execution' stamp: 'mp 5/30/2023 19:42:33'!
executeForDepositOf: aDeposit
	self subclassResponsibility ! !

!AccountTransactionsReporter methodsFor: 'execution' stamp: 'mp 5/30/2023 19:43:01'!
executeForTransferInOf: aTransferIn
	self subclassResponsibility ! !

!AccountTransactionsReporter methodsFor: 'execution' stamp: 'mp 5/30/2023 19:43:23'!
executeForTransferOutOf: aTransferOut
	self subclassResponsibility ! !

!AccountTransactionsReporter methodsFor: 'execution' stamp: 'mp 5/30/2023 19:43:08'!
executeForWithdrawOf: aWithdraw
	self subclassResponsibility ! !


!AccountTransactionsReporter methodsFor: 'initialization' stamp: 'mp 5/30/2023 19:41:29'!
initializeWith: anAccount
	account := anAccount .! !


!classDefinition: #AccountSummaryReporter category: 'Portfolio-Solucion'!
AccountTransactionsReporter subclass: #AccountSummaryReporter
	instanceVariableNames: 'currentReport'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountSummaryReporter methodsFor: 'execution' stamp: 'mp 5/30/2023 19:29:29'!
executeForDepositOf: aDeposit

	currentReport add: ('Depósito por ', aDeposit value asString , '.').
! !

!AccountSummaryReporter methodsFor: 'execution' stamp: 'mp 5/30/2023 19:30:05'!
executeForTransferInOf: aTransferIn  
	
	currentReport add: 'Entrada por transferencia de ', aTransferIn value asString , '.'
! !

!AccountSummaryReporter methodsFor: 'execution' stamp: 'mp 5/30/2023 19:30:21'!
executeForTransferOutOf: aTransferOut  
	
	currentReport add: 'Salida por transferencia de ', aTransferOut value asString , '.'
! !

!AccountSummaryReporter methodsFor: 'execution' stamp: 'mp 5/30/2023 19:30:37'!
executeForWithdrawOf: aWithdraw  

	currentReport add: 'Extracción por ', aWithdraw value asString , '.'
! !


!AccountSummaryReporter methodsFor: 'private' stamp: 'AG 6/1/2023 12:36:05'!
addBalanceToCurrentReport

	^ currentReport add: ('Balance = ', account balance asString )! !


!AccountSummaryReporter methodsFor: 'accountSummary' stamp: 'AG 6/1/2023 12:36:05'!
accountSummary
	
	currentReport := OrderedCollection new.
	account executeOnTransactionsFor: self.
	self addBalanceToCurrentReport.
	
	^currentReport! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountSummaryReporter class' category: 'Portfolio-Solucion'!
AccountSummaryReporter class
	instanceVariableNames: ''!

!AccountSummaryReporter class methodsFor: 'instance creation' stamp: 'mp 5/30/2023 17:09:12'!
for: anAccount
	^self new initializeWith: anAccount! !


!classDefinition: #TransferNetReporter category: 'Portfolio-Solucion'!
AccountTransactionsReporter subclass: #TransferNetReporter
	instanceVariableNames: 'currentTransferNet'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferNetReporter methodsFor: 'execution' stamp: 'mp 5/30/2023 19:32:20'!
executeForDepositOf: aDeposit
	! !

!TransferNetReporter methodsFor: 'execution' stamp: 'mp 5/30/2023 19:32:37'!
executeForTransferInOf: aTransferIn
	currentTransferNet := currentTransferNet + aTransferIn value.! !

!TransferNetReporter methodsFor: 'execution' stamp: 'mp 5/30/2023 19:32:57'!
executeForTransferOutOf: aTransferOut
	currentTransferNet := currentTransferNet - aTransferOut value! !

!TransferNetReporter methodsFor: 'execution' stamp: 'mp 5/30/2023 19:33:09'!
executeForWithdrawOf: aWithdraw 
	! !


!TransferNetReporter methodsFor: 'transferNet' stamp: 'mp 5/31/2023 21:35:41'!
transferNet
	currentTransferNet := 0.
	account executeOnTransactionsFor: self.
	^currentTransferNet.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferNetReporter class' category: 'Portfolio-Solucion'!
TransferNetReporter class
	instanceVariableNames: ''!

!TransferNetReporter class methodsFor: 'instance creation' stamp: 'mp 5/30/2023 18:15:19'!
for: anAccount
	^self new initializeWith: anAccount! !


!classDefinition: #PortfolioReporter category: 'Portfolio-Solucion'!
Object subclass: #PortfolioReporter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioReporter methodsFor: 'execution' stamp: 'mp 5/31/2023 21:41:14'!
executeForPortfolioOf: aPortfolio  
	self subclassResponsibility ! !

!PortfolioReporter methodsFor: 'execution' stamp: 'mp 5/31/2023 21:41:25'!
executeForReceptiveAccountOf: aReceptiveAccount  
	self subclassResponsibility ! !


!classDefinition: #AccountNameTreeReporter category: 'Portfolio-Solucion'!
PortfolioReporter subclass: #AccountNameTreeReporter
	instanceVariableNames: 'portfolio tabsCounter currentReport'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountNameTreeReporter methodsFor: 'tabs padding' stamp: 'mp 5/31/2023 21:30:27'!
actualLeftPadding

	^ String new: tabsCounter withAll: $ .! !

!AccountNameTreeReporter methodsFor: 'tabs padding' stamp: 'AG 6/1/2023 12:25:54'!
incrementTabCounter
	
	tabsCounter := tabsCounter + 1.
			
	! !


!AccountNameTreeReporter methodsFor: 'execution' stamp: 'AG 6/1/2023 12:39:10'!
addToCurrentReport: anAccount

	^ currentReport add: (self actualLeftPadding , anAccount name)! !

!AccountNameTreeReporter methodsFor: 'execution' stamp: 'AG 6/1/2023 12:39:46'!
executeForPortfolioOf: aPortfolio  
	
	self addToCurrentReport: aPortfolio.
	
	self incrementTabCounter.
			
	aPortfolio executeOnChildsAccountsFor: self.
	
	self incrementTabCounter.
	! !

!AccountNameTreeReporter methodsFor: 'execution' stamp: 'AG 6/1/2023 12:38:46'!
executeForReceptiveAccountOf: aReceptiveAccount  
	
	self addToCurrentReport: aReceptiveAccount.
	! !


!AccountNameTreeReporter methodsFor: 'initialization' stamp: 'mp 5/31/2023 21:44:56'!
initializeWith: aPortfolio
	portfolio := aPortfolio .! !


!AccountNameTreeReporter methodsFor: 'accessing' stamp: 'mp 5/31/2023 21:45:18'!
accountNameTree
	
	tabsCounter := 0.
	currentReport := OrderedCollection new.
	self executeForPortfolioOf: portfolio .
	
	^currentReport! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountNameTreeReporter class' category: 'Portfolio-Solucion'!
AccountNameTreeReporter class
	instanceVariableNames: ''!

!AccountNameTreeReporter class methodsFor: 'instance creation' stamp: 'mp 5/31/2023 19:16:05'!
for: anAccount

	(anAccount isKindOf: Portfolio ) ifFalse: [self error: 'El reporte es exclusivo para Portfolios'].
	
	^self new initializeWith: anAccount! !


!classDefinition: #AccountTransactionsTreeReporter category: 'Portfolio-Solucion'!
PortfolioReporter subclass: #AccountTransactionsTreeReporter
	instanceVariableNames: 'portfolio tabsCounter currentReport'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountTransactionsTreeReporter methodsFor: 'execution' stamp: 'AG 6/1/2023 12:46:39'!
executeForPortfolioOf: aPortfolio  
	
	self addToCurrentReport: aPortfolio .
	
	self incrementTabCounter.
			
	aPortfolio executeOnChildsAccountsFor: self.
	
	self decreseTabCounter.	
	! !

!AccountTransactionsTreeReporter methodsFor: 'execution' stamp: 'AG 6/1/2023 15:55:59'!
executeForReceptiveAccountOf: aReceptiveAccount  
	|transactionsReport|
	
	self addToCurrentReport: aReceptiveAccount.
	
	self incrementTabCounter .
	
	transactionsReport := (AccountSummaryReporter for: aReceptiveAccount ) accountSummary .
	
	self addToCurrentReportMessagesOf: transactionsReport.
	
	self decreseTabCounter .! !


!AccountTransactionsTreeReporter methodsFor: 'initialization' stamp: 'mp 5/31/2023 21:56:09'!
initializeWith: aPortfolio
	portfolio := aPortfolio .! !


!AccountTransactionsTreeReporter methodsFor: 'accesing' stamp: 'mp 5/31/2023 21:56:59'!
accountTransactionsTree
	
	tabsCounter := 0.
	currentReport := OrderedCollection new.
	self executeForPortfolioOf: portfolio .
	
	^currentReport! !


!AccountTransactionsTreeReporter methodsFor: 'private' stamp: 'AG 6/1/2023 12:41:20'!
addToCurrentReport: aReceptiveAccount

	^ currentReport add: (self actualLeftPadding , aReceptiveAccount name)! !

!AccountTransactionsTreeReporter methodsFor: 'private' stamp: 'AG 6/1/2023 12:47:15'!
addToCurrentReportMessagesOf: aReport

	^ aReport do: [:message | currentReport add: (self actualLeftPadding , message)]! !


!AccountTransactionsTreeReporter methodsFor: 'tabs padding' stamp: 'mp 5/31/2023 22:02:30'!
actualLeftPadding

	^ String new: tabsCounter withAll: $ .! !

!AccountTransactionsTreeReporter methodsFor: 'tabs padding' stamp: 'mp 5/31/2023 22:34:29'!
decreseTabCounter

	tabsCounter := tabsCounter - 1! !

!AccountTransactionsTreeReporter methodsFor: 'tabs padding' stamp: 'mp 5/31/2023 22:34:32'!
incrementTabCounter

	tabsCounter := tabsCounter + 1! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransactionsTreeReporter class' category: 'Portfolio-Solucion'!
AccountTransactionsTreeReporter class
	instanceVariableNames: ''!

!AccountTransactionsTreeReporter class methodsFor: 'instance creation' stamp: 'mp 5/31/2023 21:54:18'!
for: anAccount

	(anAccount isKindOf: Portfolio ) ifFalse: [self error: 'El reporte es exclusivo para Portfolios'].
	
	^self new initializeWith: anAccount! !


!classDefinition: #Transfer category: 'Portfolio-Solucion'!
Object subclass: #Transfer
	instanceVariableNames: 'amount creditorAccount beneficiaryAccount value transferIn transferOut'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Transfer methodsFor: 'counterPart' stamp: 'mp 5/26/2023 18:36:43'!
counterPartOfTransferIn
	^transferOut! !

!Transfer methodsFor: 'counterPart' stamp: 'mp 5/26/2023 18:36:34'!
counterPartOfTransferOut
	^transferIn ! !


!Transfer methodsFor: 'initialization' stamp: 'mp 5/26/2023 18:41:56'!
initializeWith: anAmount from: aCreditorAccount to: aBeneficiaryAccount 

	value := anAmount.
	transferIn := TransferIn of: self.
	transferOut := TransferOut of: self.
	
	aCreditorAccount register: transferOut .
	aBeneficiaryAccount register: transferIn.! !


!Transfer methodsFor: 'value' stamp: 'mp 5/26/2023 18:36:13'!
value
	^value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transfer class' category: 'Portfolio-Solucion'!
Transfer class
	instanceVariableNames: ''!

!Transfer class methodsFor: 'instance creation' stamp: 'mp 5/26/2023 19:09:13'!
with: anAmount from: aCreditorAccount to: aBeneficiaryAccount 

	(anAmount <= 0) ifTrue: [self error: self invalidAmountErrorDescription ].
	
	^self new initializeWith: anAmount from: aCreditorAccount to: aBeneficiaryAccount .
	! !


!Transfer class methodsFor: 'error description' stamp: 'mp 5/26/2023 19:09:21'!
invalidAmountErrorDescription
	
	^'Amount have to be positive'! !
