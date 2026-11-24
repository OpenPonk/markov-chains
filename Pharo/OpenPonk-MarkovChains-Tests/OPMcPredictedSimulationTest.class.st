"
Unit tests for the Markov Chain predicted simulation presenter, verifying single recognizer initialization, precondition validation, separator input parsing, terminal panel updates, and button state transitions.
"
Class {
	#name : 'OPMcPredictedSimulationTest',
	#superclass : 'TestCase',
	#instVars : [
		'project',
		'projectController',
		'markovChain',
		'stateAlpha',
		'stateBeta',
		'stateGamma',
		'diagramController',
		'simulator',
		'window'
	],
	#category : 'OpenPonk-MarkovChains-Tests-Simulations',
	#package : 'OpenPonk-MarkovChains-Tests',
	#tag : 'Simulations'
}

{ #category : 'running' }
OPMcPredictedSimulationTest >> setUp [

	| transitionAlphaBeta transitionBetaGamma |
	super setUp.
	markovChain := OPMc named: 'Predicted Simulator Test Chain'.
	stateAlpha := OPMcState named: 'a'.
	stateBeta := OPMcState named: 'b'.
	stateGamma := OPMcState named: 'c'.
	transitionAlphaBeta := OPMcTransition from: stateAlpha to: stateBeta named: '1.0'.
	transitionBetaGamma := OPMcTransition from: stateBeta to: stateGamma named: '1.0'.
	markovChain addAll: {
			stateAlpha.
			stateBeta.
			stateGamma.
			transitionAlphaBeta.
			transitionBetaGamma }.
	project := OPProject named: 'McPredictedSimulationTest'.
	project addModel: markovChain.
	projectController := OPProjectController forProject: project.
	diagramController := OPMcController new.
	projectController addDiagramController: diagramController.
	diagramController model: markovChain.
	diagramController diagramElement: (OPOpenPonkDiagram forModelElement: markovChain).
	diagramController canvasPresenter: (OPHeadlessCanvasPresenter new
			 canvas: RSCanvas new;
			 yourself).
	diagramController showAllElements.
	simulator := OPMcPredictedSimulation new.
	simulator instVarNamed: #diagramController put: diagramController.
	window := simulator asWindow
]

{ #category : 'running' }
OPMcPredictedSimulationTest >> tearDown [

	window ifNotNil: [
			window isOpen ifTrue: [ window close ].
			window := nil ].
	simulator := nil.
	diagramController := nil.
	projectController := nil.
	project := nil.
	markovChain := nil.
	stateAlpha := nil.
	stateBeta := nil.
	stateGamma := nil.
	super tearDown
]

{ #category : 'tests' }
OPMcPredictedSimulationTest >> testInitializeCreatesSingleRecognizer [

	| createdCount createdInstance |
	createdCount := 0.
	OPMcRecognizer stub new will: [
			createdCount := createdCount + 1.
			OPMcRecognizer basicNew initialize ].

	createdInstance := OPMcPredictedSimulation new.

	self assert: createdCount equals: 1.
	self assert: createdInstance recognizer class identicalTo: OPMcRecognizer
]

{ #category : 'tests' }
OPMcPredictedSimulationTest >> testPreconditionsHandlesEmptyInputDataAndMissingStartState [

	| abortMessages |
	abortMessages := OrderedCollection new.
	(UIManager default stub abort: Any) will: [ :message | abortMessages add: message ].

	simulator separatorInput text: ','.
	simulator input text: ',,,'.
	self deny: simulator preconditions description: 'Empty parsed inputData must fail preconditions without crashing'.
	self assert: abortMessages size equals: 1.

	abortMessages removeAll.
	simulator input text: 'missing,b'.
	simulator startButton click.
	self assert: abortMessages size equals: 1.
	self assert: abortMessages first equals: 'No state named missing found'.
	self assert: simulator startButton isEnabled description: 'Failed preconditions must keep startButton enabled'
]

{ #category : 'tests' }
OPMcPredictedSimulationTest >> testSeparatorInputParsingAndAccessors [

	self assert: simulator inputLabel label equals: 'Input:'.
	self assert: simulator separatorLabel label equals: 'Separated by:'.
	self assert: simulator separatorInput text equals: ','.

	simulator input text: 'a, b , , c'.
	self assert: simulator startButton isEnabled description: 'Non-empty input must enable startButton'.
	self assert: simulator inputData equals: (OrderedCollection with: 'a' with: 'b' with: 'c').

	simulator separatorInput text: ''.
	simulator input text: ' abc '.
	self assert: simulator inputData equals: #( 'a' 'b' 'c' ).

	simulator input text: ''.
	self deny: simulator startButton isEnabled description: 'Clearing input must disable startButton'
]

{ #category : 'tests' }
OPMcPredictedSimulationTest >> testSteppingBackToEmptyAndResetAction [

	simulator input text: 'a,b,c'.
	simulator idleInput text: '0'.

	simulator startButton click.
	self deny: simulator backButton isEnabled description: 'Back button must be disabled right after start'.
	self assert: simulator nextButton isEnabled description: 'Next button must be enabled after start'.

	simulator nextButton click.
	self assert: simulator backButton isEnabled description: 'Back button must be enabled after nextPredicted'.
	self assert: stateAlpha activations equals: 1.

	simulator backButton click.
	self deny: simulator backButton isEnabled description: 'Back button must disable when consumed stack is empty'.
	self assert: stateAlpha activations equals: 0.
	self assert: simulator nextButton isEnabled description: 'Next button must stay enabled after backPredicted'.
	self assert: simulator runButton isEnabled description: 'Run button must stay enabled after backPredicted'.

	simulator stopButton click.
	self assert: simulator resetButton isEnabled description: 'Stop must enable resetButton'.

	stateAlpha counterAdd.
	simulator resetButton click.
	self assert: stateAlpha activations equals: 0
]

{ #category : 'tests' }
OPMcPredictedSimulationTest >> testStopActionReEnablesSeparatorInputAndDisablesResumeButton [

	| runInvocations |
	runInvocations := 0.
	simulator recognizer stub nextUpToEndPredicted will: [ runInvocations := runInvocations + 1 ].
	simulator input text: 'a,b,c'.
	simulator idleInput text: '0'.

	simulator startButton click.
	self deny: simulator separatorInput isEnabled description: 'Start must disable separatorInput'.
	self deny: simulator idleInput isEnabled description: 'Start must disable idleInput'.
	self deny: simulator resetButton isEnabled description: 'Start must disable resetButton'.

	simulator runButton click.
	self assert: runInvocations equals: 1.
	simulator pauseButton click.
	self assert: simulator resumeButton isEnabled description: 'Pause must enable resumeButton'.

	simulator resumeButton click.
	self assert: runInvocations equals: 2.
	self assert: simulator pauseButton isEnabled description: 'Resume must re-enable pauseButton'.
	self deny: simulator separatorInput isEnabled description: 'Resume must keep separatorInput disabled'.

	simulator pauseButton click.
	simulator stopButton click.
	self assert: simulator separatorInput isEnabled description: 'Stop must re-enable separatorInput'.
	self assert: simulator idleInput isEnabled description: 'Stop must re-enable idleInput'.
	self deny: simulator resumeButton isEnabled description: 'Stop must disable resumeButton'.
	self deny: simulator pauseButton isEnabled description: 'Stop must disable pauseButton'
]
