Class {
	#name : 'OPMcPredictedSimulation',
	#superclass : 'OPMcSimulator',
	#instVars : [
		'separatorLabel',
		'separatorInput',
		'letterPanel'
	],
	#category : 'OpenPonk-MarkovChains-Simulations',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Simulations'
}

{ #category : 'layout' }
OPMcPredictedSimulation class >> defaultLayout [

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
				   add: #separatorLabel width: 80;
					add: #separatorInput width: 60;
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
		  add: (SpScrollableLayout with: (SpBoxLayout newLeftToRight
						add: #letterPanel;
						yourself))
		  height: 50;
		  add: 'List of States' expand: false;
		  add: (SpBoxLayout newLeftToRight 
					add: #stateTable;
					yourself);
		  yourself
]

{ #category : 'layout' }
OPMcPredictedSimulation class >> toolbarMenu: aBuilder [

	<opEditorToolbarMenu: #OPMcPlugin>
	(aBuilder item: 'Open Predicted Simulation')
		icon: OPCoreIcons opMcDiagramIcon;
		action: [ self new openOn: aBuilder model diagramController ]
]

{ #category : 'actions' }
OPMcPredictedSimulation >> backAction [
	recognizer backPredicted.
	recognizer consumed ifEmpty: [ backButton disable. ].
	nextButton enable.
	runButton enable.
	self listOfStates
]

{ #category : 'actions' }
OPMcPredictedSimulation >> connectPresenters [

	super connectPresenters.
	inputLabel label: 'Input:'.
	input whenTextChangedDo: [ :text | 
		text
			ifEmpty: [ startButton disable ]
			ifNotEmpty: [ startButton enable ] ].
	idleLabel label: 'Idle [s]:'.
	idleInput text: '0.1'.
	separatorLabel label: 'Separated by:'.
	separatorInput text: ','.
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
	letterPanel data: ''.
	"stateTable 
		addColumn: (SpStringTableColumn title: 'States' evaluated: #name);
		addColumn: (SpStringTableColumn title: 'Enterings' evaluated: #activations)"
	
]

{ #category : 'actions' }
OPMcPredictedSimulation >> initialize [
	recognizer := OPMcRecognizer new.
	self watchRecognizer: recognizer.
	super initialize
]

{ #category : 'actions' }
OPMcPredictedSimulation >> initializePresenters [

	inputLabel := self newLabel.
	input := self newTextInput.
	idleLabel := self newLabel.
	idleInput := self newTextInput.
	separatorLabel := self newLabel.
	separatorInput := self newTextInput.
	letterPanel := self instantiate: OPMcTerminalPanelPresenter.
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

{ #category : 'actions' }
OPMcPredictedSimulation >> inputData [
	"^self input text"

	^ self separatorInput text
		ifEmpty: [ self input text trim asArray collect: #asString ]
		ifNotEmpty: [ :sep | ^ ((self input text splitOn: sep) collect: #trim) removeAllSuchThat: #isEmpty ]
]

{ #category : 'accessing' }
OPMcPredictedSimulation >> letterPanel [
	^ letterPanel
]

{ #category : 'actions' }
OPMcPredictedSimulation >> nextAction [
	backButton enable.
	recognizer 
		resume;
		nextPredicted.
	self listOfStates 
]

{ #category : 'actions' }
OPMcPredictedSimulation >> openOn: aDiagramController [

	diagramController := aDiagramController.
	self open
]

{ #category : 'preconditions' }
OPMcPredictedSimulation >> preconditions [
	diagramController model states
		detect: [ :each | each name = (self inputData at: 1) asString]
		ifNone: [ UIManager default abort: 'No state named ', 
				(self inputData at: 1) asString, 
				' found'.
			^ false ].
	^ true
]

{ #category : 'actions' }
OPMcPredictedSimulation >> resumeAction [
	input disable.
	idleInput disable.
	startButton disable.
	stopButton enable.
	backButton disable.
	nextButton disable.
	resumeButton disable.
	recognizer 
		resume;
		nextUpToEndPredicted
]

{ #category : 'actions' }
OPMcPredictedSimulation >> runAction [
	nextButton disable.
	backButton disable.
	runButton disable.
	pauseButton enable.
	recognizer nextUpToEndPredicted
]

{ #category : 'accessing' }
OPMcPredictedSimulation >> separatorInput [
	^ separatorInput
]

{ #category : 'accessing' }
OPMcPredictedSimulation >> separatorLabel [
	^ separatorLabel
]

{ #category : 'actions' }
OPMcPredictedSimulation >> startAction [
	self preconditions
		ifFalse: [ ^ self ].
	self preconditions.
	input disable.
	separatorInput disable.
	startButton disable.
	stopButton enable.
	backButton disable.
	nextButton enable.
	runButton enable.
	self resetAction.
	recognizer
		predictedInput: self inputData
		startingAt: (diagramController model states detect: 
			[ :each | each name = (self inputData at: 1) asString])
		for: self idleData.
	letterPanel data: self inputData.
]

{ #category : 'actions' }
OPMcPredictedSimulation >> stopAction [
	input enable.
	idleInput enable.
	startButton enable.
	stopButton disable.
	backButton disable.
	nextButton disable.
	runButton disable.
	resetButton enable.
	pauseButton disable.
	recognizer stopPredicted.
	diagramController model elements
		do: [ :each | OPMcFigureHighlighter unhighlight: (diagramController roassalShapeForModel: each) ]
]

{ #category : 'actions' }
OPMcPredictedSimulation >> watchRecognizer: aRecognizer [
	aRecognizer when: OPMcRecognizerEvent do: [ :ann | 
		(ann isKindOf: OPMcRecognizerFailure) not & ann place isState 
			ifTrue: [ 
				self letterPanel
					changeBoxAt: aRecognizer inputPositionExclNil 
					to: #success ].
		ann place isTransition ifTrue: [ 
			self letterPanel
				changeBoxAt: aRecognizer inputPositionExclNil 
				to: #processed ] ].
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
			self listOfStates. 
			self letterPanel
				changeBoxAt: aRecognizer inputPositionExclNil
				to: #failure ].
	aRecognizer when: OPMcRecognizerLeave do: [ :ann | 
		OPMcFigureHighlighter unhighlight:
			(diagramController roassalShapeForModel: ann place) ].
	aRecognizer when: OPMcRecognizerEnter do: [ :ann | 
		OPMcFigureHighlighter
			highlight: (diagramController roassalShapeForModel: ann place)
			with: Color orange ]
]
