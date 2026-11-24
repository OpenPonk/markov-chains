"
Unit tests for the Markov Chain random simulator presenter, verifying presenter wiring, button state transitions, deterministic stepping, recognizer failure highlighting, and dark-theme terminal box colors.
"
Class {
	#name : 'OPMcSimulatorTest',
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
OPMcSimulatorTest >> setUp [

	| transitionAlphaBeta transitionBetaGamma |
	super setUp.
	markovChain := OPMc named: 'Simulator Test Chain'.
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
	project := OPProject named: 'McSimulatorTest'.
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
	simulator := OPMcSimulator new.
	simulator instVarNamed: #diagramController put: diagramController.
	window := simulator asWindow
]

{ #category : 'running' }
OPMcSimulatorTest >> tearDown [

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
OPMcSimulatorTest >> testPauseResumeAndStopButtonStateTransitions [

	| runInvocations |
	runInvocations := 0.
	simulator recognizer stub nextUpToEnd will: [ runInvocations := runInvocations + 1 ].
	simulator input text: '3'.
	simulator idleInput text: '0'.

	simulator startButton click.
	simulator runButton click.
	self assert: runInvocations equals: 1.
	self assert: simulator pauseButton isEnabled description: 'Run must enable pauseButton'.

	simulator pauseButton click.
	self deny: simulator pauseButton isEnabled description: 'Pause must disable pauseButton'.
	self assert: simulator resumeButton isEnabled description: 'Pause must enable resumeButton'.
	self assert: simulator backButton isEnabled description: 'Pause must enable backButton'.
	self assert: simulator nextButton isEnabled description: 'Pause must enable nextButton'.

	simulator resumeButton click.
	self assert: runInvocations equals: 2.
	self assert: simulator pauseButton isEnabled description: 'Resume must re-enable pauseButton'.
	self deny: simulator resumeButton isEnabled description: 'Resume must disable resumeButton'.

	simulator pauseButton click.
	simulator stopButton click.
	self deny: simulator resumeButton isEnabled description: 'Stop after pause must disable resumeButton'.
	self deny: simulator pauseButton isEnabled description: 'Stop must disable pauseButton'.
	self assert: simulator startButton isEnabled description: 'Stop must re-enable startButton'
]

{ #category : 'tests' }
OPMcSimulatorTest >> testPresenterAccessorsAndInputTogglesStartButton [

	self assert: simulator inputLabel label equals: 'Steps'.
	self assert: simulator idleLabel label equals: 'Idle [s]:'.
	self assert: simulator startButton label equals: 'Start'.
	self assert: simulator stopButton label equals: 'Stop'.
	self assert: simulator resetButton label equals: 'Reset'.
	self assert: simulator backButton label equals: 'Back'.
	self assert: simulator nextButton label equals: 'Next'.
	self assert: simulator runButton label equals: 'Run'.
	self assert: simulator pauseButton label equals: 'Pause'.
	self assert: simulator resumeButton label equals: 'Resume'.
	self deny: simulator startButton isEnabled description: 'Start button must be disabled while input is empty'.

	simulator input text: '2'.
	self assert: simulator startButton isEnabled description: 'Non-empty input must enable startButton'.

	simulator input text: ''.
	self deny: simulator startButton isEnabled description: 'Clearing input must disable startButton again'
]

{ #category : 'tests' }
OPMcSimulatorTest >> testSteppingBackToEmptyDisablesBackButtonAndResetClearsState [

	simulator input text: '3'.
	simulator idleInput text: '0'.

	simulator startButton click.
	self deny: simulator backButton isEnabled description: 'Back button must stay disabled right after start'.
	self assert: simulator nextButton isEnabled description: 'Next button must be enabled after start'.

	simulator nextButton click.
	self assert: simulator backButton isEnabled description: 'Back button must be enabled after stepping forward'.

	simulator backButton click.
	self deny: simulator backButton isEnabled description: 'Back button must disable when consumed stack becomes empty'.
	self assert: simulator nextButton isEnabled description: 'Next button must remain enabled after stepping back'.
	self assert: simulator runButton isEnabled description: 'Run button must remain enabled after stepping back'.

	simulator stopButton click.
	self assert: simulator resetButton isEnabled description: 'Stop must enable resetButton'.

	stateAlpha counterAdd.
	simulator resetButton click.
	self assert: stateAlpha activations equals: 0
]

{ #category : 'tests' }
OPMcSimulatorTest >> testTerminalBoxMorphDarkThemeColorScheme [

	| terminalBox darkTheme |
	darkTheme := PharoDarkTheme new.
	terminalBox := OPMcTerminalBoxMorph new.
	terminalBox stub theme willReturn: darkTheme.

	terminalBox initializeColorScheme.

	terminalBox normal.
	self assert: terminalBox color equals: darkTheme windowColor.
	terminalBox processed.
	self assert: terminalBox color equals: Color paleOrange muchDarker.
	terminalBox failure.
	self assert: terminalBox color equals: Color paleRed muchDarker.
	terminalBox success.
	self assert: terminalBox color equals: Color paleGreen muchDarker
]

{ #category : 'tests' }
OPMcSimulatorTest >> testWatchRecognizerHighlightsFailureRedAndDisablesRunControls [

	| gammaShape |
	simulator input text: '2'.
	simulator idleInput text: '0'.
	simulator startButton click.
	simulator recognizer input: '2' startingAt: stateGamma for: '0'.

	simulator nextButton click.
	gammaShape := diagramController roassalShapeForModel: stateGamma.
	self assert: gammaShape borderColor equals: Color red.
	self deny: simulator nextButton isEnabled description: 'Failure must disable nextButton'.
	self assert: simulator backButton isEnabled description: 'Failure must enable backButton'.
	self deny: simulator pauseButton isEnabled description: 'Failure must disable pauseButton'.
	self deny: simulator runButton isEnabled description: 'Failure must disable runButton'
]
