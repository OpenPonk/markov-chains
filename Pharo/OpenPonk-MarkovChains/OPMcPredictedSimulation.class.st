"
Spec presenter managing a predictive simulation mode for Markov Chains.
Extends the standard simulator with a visual terminal panel for sequential sequence prediction.
"
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

{ #category : 'actions' }
OPMcPredictedSimulation >> backAction [
	recognizer backPredicted.
	recognizer consumed ifEmpty: [ backButton disable. ].
	nextButton enable.
	runButton enable.
	self listOfStates
]

{ #category : 'initialization' }
OPMcPredictedSimulation >> connectPresenters [

	super connectPresenters.
	inputLabel label: 'Input:'.
	separatorLabel label: 'Separated by:'.
	separatorInput text: ','.
	letterPanel data: ''
]

{ #category : 'initialization' }
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

{ #category : 'preconditions' }
OPMcPredictedSimulation >> preconditions [

	| parsedInput firstStateName |
	parsedInput := self inputData.
	parsedInput ifEmpty: [
			UIManager default abort: 'No input states provided'.
			^ false ].
	firstStateName := parsedInput first asString.
	diagramController model states detect: [ :each | each name = firstStateName ] ifNone: [
			UIManager default abort: (String streamContents: [ :stream |
						 stream nextPutAll: 'No state named '.
						 stream nextPutAll: firstStateName.
						 stream nextPutAll: ' found' ]).
			^ false ].
	^ true
]

{ #category : 'actions' }
OPMcPredictedSimulation >> resumeAction [

	input disable.
	idleInput disable.
	separatorInput disable.
	startButton disable.
	stopButton enable.
	backButton disable.
	nextButton disable.
	pauseButton enable.
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

	self preconditions ifFalse: [ ^ self ].
	input disable.
	idleInput disable.
	separatorInput disable.
	startButton disable.
	stopButton enable.
	backButton disable.
	nextButton enable.
	runButton enable.
	resetButton disable.
	self resetAction.
	recognizer
		predictedInput: self inputData
		startingAt: (diagramController model states detect: [ :each | each name = self inputData first asString ])
		for: self idleData.
	letterPanel data: self inputData
]

{ #category : 'actions' }
OPMcPredictedSimulation >> stopAction [

	input enable.
	idleInput enable.
	separatorInput enable.
	startButton enable.
	stopButton disable.
	backButton disable.
	nextButton disable.
	runButton disable.
	resetButton enable.
	pauseButton disable.
	resumeButton disable.
	recognizer stopPredicted.
	diagramController model elements do: [ :each | OPMcShapeHighlighter unhighlight: (diagramController roassalShapeForModel: each) ]
]

{ #category : 'actions' }
OPMcPredictedSimulation >> watchRecognizer: aRecognizer [

	aRecognizer
		when: OPMcRecognizerEvent
		do: [ :ann |
			(ann isKindOf: OPMcRecognizerFailure) not & ann place isState
				ifTrue: [
					self letterPanel
						changeBoxAt: aRecognizer inputPositionExclNil
						to: #success ].
			ann place isTransition ifTrue: [
				self letterPanel
					changeBoxAt: aRecognizer inputPositionExclNil
					to: #processed ] ]
		for: self.
	aRecognizer
		when: OPMcRecognizerSuccess
		do: [ :ann |
			OPMcShapeHighlighter
				highlightNode: (diagramController roassalShapeForModel: ann place)
				with: Color green.
			nextButton disable.
			backButton enable.
			pauseButton disable.
			runButton disable.
			self listOfStates ]
		for: self.
	aRecognizer
		when: OPMcRecognizerFailure
		do: [ :ann |
			OPMcShapeHighlighter
				highlightNode: (diagramController roassalShapeForModel: ann place)
				with: Color red.
			nextButton disable.
			backButton enable.
			pauseButton disable.
			runButton disable.
			self listOfStates.
			self letterPanel
				changeBoxAt: aRecognizer inputPositionExclNil
				to: #failure ]
		for: self.
	aRecognizer
		when: OPMcRecognizerLeave
		do: [ :ann |
			OPMcShapeHighlighter unhighlight:
				(diagramController roassalShapeForModel: ann place) ]
		for: self.
	aRecognizer
		when: OPMcRecognizerEnter
		do: [ :ann |
			OPMcShapeHighlighter
				highlight: (diagramController roassalShapeForModel: ann place)
				with: Color orange ]
		for: self
]
