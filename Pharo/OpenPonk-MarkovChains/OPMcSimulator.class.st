Class {
	#name : #OPMcSimulator,
	#superclass : #SpPresenter,
	#instVars : [
		'diagramController',
		'recognizer',
		'input',
		'inputLabel',
		'startButton',
		'stopButton',
		'resetButton',
		'backButton',
		'nextButton',
		'idleLabel',
		'idleInput',
		'runButton',
		'pauseButton',
		'resumeButton',
		'stateTable'
	],
	#category : #'OpenPonk-MarkovChains-Simulations'
}

{ #category : #layout }
OPMcSimulator class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: #inputLabel width: 40;
				   add: #input;
					add: #idleLabel width: 45;
					add: #idleInput width: 60;
				   yourself)
		  height: self toolbarHeight;
		  add: (SpBoxLayout newLeftToRight
				   add: #startButton;
				   add: #stopButton;
				   add: #resetButton;
				   yourself)
		  height: self toolbarHeight;
		  add: (SpBoxLayout newLeftToRight
				   add: #backButton;
				   add: #nextButton;
				   add: #runButton;
				   add: SpNullPresenter new;
				   yourself)
		  height: self toolbarHeight;
		  add: (SpBoxLayout newLeftToRight
				   add: #pauseButton;
					add: #resumeButton;
				   add: SpNullPresenter new;
				   yourself)
		  height: self toolbarHeight;
		  add: 'List of States' expand: false;
		  add: (SpBoxLayout newLeftToRight 
					add: #stateTable;
					"add: #stateList;"
					"add: SpNullPresenter new;"
					yourself);
		  "height: 100;"
		  "add: SpNullPresenter new;"
		  yourself
]

{ #category : #layout }
OPMcSimulator class >> toolbarMenu: aBuilder [

	<opEditorToolbarMenu: #OPMcPlugin>
	(aBuilder item: 'Open Simulator')
		icon: OPCoreIcons opMcDiagramIcon;
		action: [ self new openOn: aBuilder model diagramController ]
]

{ #category : #actions }
OPMcSimulator >> backAction [
	recognizer back.
	recognizer consumed ifEmpty: [ backButton disable. ].
	nextButton enable.
	runButton enable.
	self listOfStates
]

{ #category : #actions }
OPMcSimulator >> backButton [
	^ backButton
]

{ #category : #actions }
OPMcSimulator >> connectPresenters [

	super connectPresenters.
	inputLabel label: 'Steps'.
	input whenTextChangedDo: [ :text | 
		text
			ifEmpty: [ startButton disable ]
			ifNotEmpty: [ startButton enable ] ].
	idleLabel label: 'Idle [s]:'.
	idleInput text: '0.1'.
	startButton
		label: 'Start';
		iconName: #glamorousThrough;
		action: [ self startAction ];
		disable.
	stopButton
		label: 'Stop';
		iconName: #stop;
		action: [ self stopAction ];
		disable.
	resetButton
		label: 'Reset';
		iconName: #smallUpdate;
		action: [ self resetAction ];
		disable.
	backButton
		label: 'Back';
		iconName: #back;
		action: [ self backAction ];
		disable.
	nextButton
		label: 'Next';
		iconName: #forward;
		action: [ self nextAction ];
		disable.
	runButton
		label: 'Run';
		iconName: #smallDoIt;
		action: [ self runAction ];
		disable.
	pauseButton 
		label: 'Pause';
		iconName: #testYellow;
		action: [ self pauseAction ];
		disable.
	resumeButton 
		label: 'Resume';
		iconName: #smallDoIt;
		action: [ self resumeAction ];
		disable.
	stateTable 
		addColumn: (SpStringTableColumn title: 'States' evaluated: #name);
		addColumn: (SpStringTableColumn title: 'Enterings' evaluated: #activations)
	
]

{ #category : #actions }
OPMcSimulator >> idleData [

	^ self idleInput text
]

{ #category : #actions }
OPMcSimulator >> idleInput [
	^ idleInput
]

{ #category : #actions }
OPMcSimulator >> idleLabel [
	^ idleLabel
]

{ #category : #actions }
OPMcSimulator >> initialize [
	recognizer := OPMcRecognizer new.
	self watchRecognizer: recognizer.
	super initialize
]

{ #category : #actions }
OPMcSimulator >> initializePresenters [

	inputLabel := self newLabel.
	input := self newTextInput.
	idleLabel := self newLabel.
	idleInput := self newTextInput.
	startButton := self newButton.
	stopButton := self newButton.
	resetButton := self newButton.
	backButton := self newButton.
	nextButton := self newButton.
	runButton := self newButton.
	pauseButton := self newButton.
	resumeButton := self newButton.
	stateTable := self newTable.
	
]

{ #category : #actions }
OPMcSimulator >> initializeWindow: aWindow [

	aWindow initialExtent: 400 @ 400.
	aWindow title: 'Markov Chain Simulator'
]

{ #category : #actions }
OPMcSimulator >> input [
	^ input
]

{ #category : #actions }
OPMcSimulator >> inputData [

	^ self input text
]

{ #category : #actions }
OPMcSimulator >> inputLabel [
	^ inputLabel
]

{ #category : #actions }
OPMcSimulator >> listOfStates [ 
		
	stateTable
		items: recognizer allStates;
		sortingBlock: [ :a :b | a name < b name ]
		
]

{ #category : #actions }
OPMcSimulator >> nextAction [
	backButton enable.
	recognizer 
		resume;
		next.
	self listOfStates 
]

{ #category : #actions }
OPMcSimulator >> nextButton [
	^ nextButton
]

{ #category : #actions }
OPMcSimulator >> openOn: aDiagramController [

	diagramController := aDiagramController.
	self open
]

{ #category : #actions }
OPMcSimulator >> pauseAction [
	input disable.
	idleInput disable.
	startButton disable.
	stopButton enable.
	backButton enable.
	nextButton enable.
	resumeButton enable.
	recognizer pause.
	self listOfStates 
]

{ #category : #actions }
OPMcSimulator >> pauseButton [
	^ pauseButton
]

{ #category : #accessing }
OPMcSimulator >> recognizer [
	^ recognizer
]

{ #category : #actions }
OPMcSimulator >> resetAction [
	diagramController model elements
		do: [ :each | OPMcFigureHighlighter unhighlight: (diagramController roassalShapeForModel: each) ].
	self resetStateEntries.
	stateTable 
		items: #().
]

{ #category : #actions }
OPMcSimulator >> resetButton [
	^ resetButton
]

{ #category : #actions }
OPMcSimulator >> resetStateEntries [
	diagramController model states
		do: [ :state | state counterReset ]
]

{ #category : #actions }
OPMcSimulator >> resumeAction [
	input disable.
	idleInput disable.
	startButton disable.
	stopButton enable.
	backButton disable.
	nextButton disable.
	resumeButton disable.
	recognizer 
		resume;
		nextUpToEnd
]

{ #category : #actions }
OPMcSimulator >> resumeButton [
	^ resumeButton
]

{ #category : #actions }
OPMcSimulator >> runAction [
	nextButton disable.
	backButton disable.
	runButton disable.
	pauseButton enable.
	recognizer nextUpToEnd
]

{ #category : #actions }
OPMcSimulator >> runButton [
	^ runButton
]

{ #category : #actions }
OPMcSimulator >> startAction [
	input disable.
	idleInput disable.
	startButton disable.
	stopButton enable.
	backButton disable.
	nextButton enable.
	runButton enable.
	resetButton disable.
	self resetAction.
	recognizer 
		input: self inputData
		startingAt: (diagramController model states detect: #isNormal)
		for: self idleData
]

{ #category : #actions }
OPMcSimulator >> startButton [
	^ startButton
]

{ #category : #actions }
OPMcSimulator >> stopAction [
	input enable.
	idleInput enable.
	startButton enable.
	stopButton disable.
	backButton disable.
	nextButton disable.
	runButton disable.
	resetButton enable.
	pauseButton disable.
	recognizer stop.
	diagramController model elements
		do: [ :each | OPMcFigureHighlighter unhighlight: (diagramController roassalShapeForModel: each) ]
]

{ #category : #actions }
OPMcSimulator >> stopButton [
	^ stopButton
]

{ #category : #actions }
OPMcSimulator >> watchRecognizer: aRecognizer [
	aRecognizer when: OPMcRecognizerSuccess do: [ :ann | 
		OPMcFigureHighlighter
			highlightNode: (diagramController roassalShapeForModel: ann place)
			with: Color green.
			nextButton disable.
			backButton enable.
			pauseButton disable.
			runButton disable.
			self listOfStates. ].
	aRecognizer when: OPMcRecognizerFailure do: [ :ann | 
		OPMcFigureHighlighter
			highlightNode: (diagramController roassalShapeForModel: ann place)
			with: Color red.
			nextButton disable.
			backButton enable.
			pauseButton disable.
			runButton disable.
			self listOfStates. ].
	aRecognizer when: OPMcRecognizerLeave do: [ :ann | 
		OPMcFigureHighlighter unhighlight:
			(diagramController roassalShapeForModel: ann place) ].
	aRecognizer when: OPMcRecognizerEnter do: [ :ann | 
		OPMcFigureHighlighter
			highlight: (diagramController roassalShapeForModel: ann place)
			with: Color orange ]
]
