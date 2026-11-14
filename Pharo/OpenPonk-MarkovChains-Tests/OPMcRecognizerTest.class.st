"
Unit tests for Markov Chain simulation stepping, backtracking, event announcements, and predicted input recognition.
"
Class {
	#name : 'OPMcRecognizerTest',
	#superclass : 'TestCase',
	#instVars : [
		'markovChain',
		'stateAlpha',
		'stateBeta',
		'stateGamma',
		'transitionAlphaBeta',
		'transitionBetaGamma',
		'recognizer',
		'recordedEvents'
	],
	#category : 'OpenPonk-MarkovChains-Tests-Simulations',
	#package : 'OpenPonk-MarkovChains-Tests',
	#tag : 'Simulations'
}

{ #category : 'running' }
OPMcRecognizerTest >> setUp [

	super setUp.
	markovChain := OPMc named: 'Simulation Chain'.
	stateAlpha := OPMcState named: 'a'.
	stateBeta := OPMcState named: 'b'.
	stateGamma := OPMcState named: 'c'.
	transitionAlphaBeta := OPMcTransition from: stateAlpha to: stateBeta named: '1.0'.
	transitionBetaGamma := OPMcTransition from: stateBeta to: stateGamma named: '1.0'.
	markovChain
		add: stateAlpha;
		add: stateBeta;
		add: stateGamma;
		add: transitionAlphaBeta;
		add: transitionBetaGamma.
	recognizer := OPMcRecognizer new.
	recordedEvents := OrderedCollection new.
	recognizer when: OPMcRecognizerEvent do: [ :event | recordedEvents add: event ] for: self
]

{ #category : 'running' }
OPMcRecognizerTest >> tearDown [

	recognizer ifNotNil: [ recognizer unsubscribe: self ].
	recognizer := nil.
	recordedEvents := nil.
	markovChain := nil.
	stateAlpha := nil.
	stateBeta := nil.
	stateGamma := nil.
	transitionAlphaBeta := nil.
	transitionBetaGamma := nil.
	super tearDown
]

{ #category : 'tests' }
OPMcRecognizerTest >> testAllStatesAndTransitionLookupHelpers [

	| transitionGammaAlpha |
	transitionGammaAlpha := OPMcTransition from: stateGamma to: stateAlpha named: '1.0'.
	markovChain add: transitionGammaAlpha.

	recognizer predictedInput: #( 'a' 'b' 'c' ) startingAt: stateAlpha for: '0'.
	recognizer nextUpToEndPredicted.
	"OPMcRecognizer>>#allStates cascades #yourself on the Boolean result of #ifFalse:, selecting only states appearing at least twice in path."
	self assertEmpty: recognizer allStates.

	recognizer predictedInput: #( 'a' 'b' 'c' 'a' ) startingAt: stateAlpha for: '0'.
	recognizer nextUpToEndPredicted.
	self assertCollection: recognizer allStates hasSameElements: { stateAlpha }.

	self assert: (recognizer transitionFrom: stateAlpha using: '1.0') identicalTo: transitionAlphaBeta.
	self assert: (recognizer transitionFrom: stateAlpha using: 'missing') isNil description: 'Unmatched symbol should return nil'.

	recognizer predictedInput: #( 'a' 'b' ) startingAt: stateAlpha for: '0'.
	recognizer incrementGCInclZero.
	recordedEvents removeAll.
	recognizer nextTransition.
	self assertEmpty: recordedEvents.

	recognizer predictedInput: #( 'a' 'z' ) startingAt: stateAlpha for: '0'.
	recognizer incrementGCInclZero.
	recordedEvents removeAll.
	recognizer nextTransition.
	self assert: recordedEvents last class identicalTo: OPMcRecognizerFailure.

	markovChain remove: transitionGammaAlpha.
	recognizer predictedInput: #( 'c' ) startingAt: stateGamma for: '0'.
	recognizer incrementGCInclZero.
	recordedEvents removeAll.
	recognizer nextTransition.
	self assert: recordedEvents last class identicalTo: OPMcRecognizerSuccess.

	recordedEvents removeAll.
	recognizer beSuccess.
	recognizer beFailure.
	self assert: recordedEvents first class identicalTo: OPMcRecognizerSuccess.
	self assert: recordedEvents second class identicalTo: OPMcRecognizerFailure
]

{ #category : 'tests' }
OPMcRecognizerTest >> testBackAndResumeNextInRandomSimulation [

	| transitionGammaAlpha |
	transitionGammaAlpha := OPMcTransition from: stateGamma to: stateAlpha named: '1.0'.
	markovChain add: transitionGammaAlpha.
	recognizer input: '4' startingAt: stateAlpha for: '0'.
	recordedEvents removeAll.

	recognizer back.
	self assertEmpty: recordedEvents.

	5 timesRepeat: [ recognizer next ].
	self assert: stateGamma activations equals: 1.
	self assert: recognizer globalCounter equals: 3.
	self assert: recordedEvents last place identicalTo: transitionGammaAlpha.

	recognizer back.
	self assert: stateGamma activations equals: 0.
	self assert: recognizer globalCounter equals: 2.
	self assert: recordedEvents last place identicalTo: transitionBetaGamma.

	recognizer next.
	self assert: recordedEvents last place identicalTo: stateGamma.

	recognizer back.
	recognizer back.
	self assert: recordedEvents last place identicalTo: stateBeta.
	self assert: recognizer globalCounter equals: 1.

	recognizer pause.
	recognizer next.
	self assert: recordedEvents last class identicalTo: OPMcRecognizerFailure.

	recognizer resume.
	recognizer next.
	self assert: stateBeta activations equals: 2.
	self assert: recognizer globalCounter equals: 2.
	self assert: recordedEvents last place identicalTo: stateGamma
]

{ #category : 'tests' }
OPMcRecognizerTest >> testBackPredictedAndConsumedBackNotEmptyBranches [

	recognizer predictedInput: #( 'a' 'b' 'c' ) startingAt: stateAlpha for: '0'.
	recordedEvents removeAll.

	recognizer backPredicted.
	self assertEmpty: recordedEvents.

	recognizer nextPredicted.
	recognizer backPredicted.
	self assertEmpty: recognizer consumed.
	self assert: recognizer globalCounter equals: 0.

	recognizer predictedInput: #( 'a' 'b' 'c' ) startingAt: stateAlpha for: '0'.
	3 timesRepeat: [ recognizer nextPredicted ].
	self assert: stateBeta activations equals: 1.
	self assert: recognizer globalCounter equals: 2.

	recognizer backPredicted.
	self assert: stateBeta activations equals: 0.
	self assert: recognizer globalCounter equals: 1.
	self assert: recordedEvents last place identicalTo: stateBeta.

	recognizer backPredicted.
	self assert: recordedEvents last place identicalTo: transitionAlphaBeta.

	recognizer nextPredicted.
	self assert: recordedEvents last place identicalTo: stateBeta.

	recognizer nextPredicted.
	self assert: stateBeta activations equals: 1.
	self assert: recognizer globalCounter equals: 2.

	recognizer predictedInput: #( 'a' 'b' 'c' ) startingAt: stateAlpha for: '0'.
	2 timesRepeat: [ recognizer nextPredicted ].
	recognizer backPredicted.
	recognizer nextPredicted.
	self assert: recordedEvents last place identicalTo: stateBeta.

	stateBeta counterReset.
	recognizer predictedInput: #( 'a' 'b' 'c' ) startingAt: stateAlpha for: '0'.
	4 timesRepeat: [ recognizer nextPredicted ].
	self assert: stateBeta activations equals: 1.
	recognizer backPredicted.
	recognizer backPredicted.
	self assert: stateBeta activations equals: 0.
	recordedEvents removeAll.
	recognizer nextPredicted.
	self assert: stateBeta activations equals: 1.
	self assert: recognizer globalCounter equals: 2.
	self assert: recordedEvents last place identicalTo: transitionBetaGamma.

	recognizer predictedInput: #( 'a' 'b' ) startingAt: stateAlpha for: '0'.
	3 timesRepeat: [ recognizer nextPredicted ].
	recognizer backPredicted.
	recordedEvents removeAll.
	recognizer nextPredicted.
	self assert: recordedEvents last class identicalTo: OPMcRecognizerSuccess.

	markovChain remove: transitionBetaGamma.
	recognizer predictedInput: #( 'a' 'b' 'z' ) startingAt: stateAlpha for: '0'.
	3 timesRepeat: [ recognizer nextPredicted ].
	recognizer backPredicted.
	recordedEvents removeAll.
	recognizer nextPredicted.
	self assert: recordedEvents last class identicalTo: OPMcRecognizerFailure
]

{ #category : 'tests' }
OPMcRecognizerTest >> testGlobalCounterHelpers [

	| counterRecognizer |
	counterRecognizer := OPMcRecognizer new.
	self assert: counterRecognizer globalCounter isNil description: 'Fresh recognizer has nil counter'.

	counterRecognizer incrementGC.
	self assert: counterRecognizer globalCounter equals: 1.
	counterRecognizer incrementGC.
	self assert: counterRecognizer globalCounter equals: 2.
	counterRecognizer decrementGC.
	self assert: counterRecognizer globalCounter equals: 1.
	counterRecognizer decrementGC.
	self assert: counterRecognizer globalCounter equals: 1.

	counterRecognizer := OPMcRecognizer new.
	counterRecognizer incrementGCInclZero.
	self assert: counterRecognizer globalCounter equals: 0.
	counterRecognizer incrementGCInclZero.
	self assert: counterRecognizer globalCounter equals: 1.
	counterRecognizer incrementGCInclZero.
	self assert: counterRecognizer globalCounter equals: 2.
	counterRecognizer decrementGCInclZero.
	self assert: counterRecognizer globalCounter equals: 1.
	counterRecognizer decrementGCInclZero.
	self assert: counterRecognizer globalCounter equals: 0
]

{ #category : 'tests' }
OPMcRecognizerTest >> testInputConfigurationAndReset [

	recognizer input: '' startingAt: stateAlpha.
	self assert: recognizer inputs equals: ''.
	self assert: recognizer globalCounter equals: 1.
	self assert: recognizer inputPosition equals: 1.
	self assert: recognizer inputPositionExclNil equals: 2.
	self assert: recognizer isInputEmpty description: 'Empty input at state should report empty'.
	self assert: recognizer isPathEmpty description: 'Path should be empty before stepping'.
	self assertEmpty: recognizer consumed.
	self assert: recordedEvents size equals: 1.
	self assert: recordedEvents first class identicalTo: OPMcRecognizerEnter.
	self assert: recordedEvents first place identicalTo: stateAlpha.

	recognizer input: '2' startingAt: stateAlpha for: '0'.
	self assert: recognizer inputs equals: '2'.
	self deny: recognizer isInputEmpty description: 'Non-empty input should not report empty'.
	recognizer next.
	self deny: recognizer isInputEmpty description: 'Input emptiness requires current place to be a state'.

	recognizer reset.
	self assert: recognizer isPathEmpty description: 'Reset should clear path'.
	self assertEmpty: recognizer consumed.
	self assert: recognizer globalCounter equals: 1.

	recognizer input: '1' startingAt: stateAlpha for: '0'.
	recognizer next.
	recognizer stop.
	self assert: recognizer isPathEmpty description: 'Stop should clear path'.
	self assertEmpty: recognizer consumed.
	self assert: recognizer globalCounter equals: 1.

	recordedEvents removeAll.
	recognizer next.
	self assert: recordedEvents last class identicalTo: OPMcRecognizerSuccess.

	recognizer predictedInput: #( 'a' 'b' 'c' ) startingAt: stateAlpha for: '0'.
	self assert: recognizer inputs equals: #( 'a' 'b' 'c' ).
	self assert: recognizer globalCounter equals: 0.
	self assert: recognizer inputPosition equals: 0.
	self assert: recognizer inputPositionExclNil equals: 1.

	recognizer nextPredicted.
	self deny: recognizer isPathEmpty description: 'Path should record visited state'.
	self denyEmpty: recognizer consumed.

	recognizer resetPredicted.
	self assert: recognizer isPathEmpty description: 'Reset predicted should clear path'.
	self assertEmpty: recognizer consumed.
	self assert: recognizer globalCounter equals: 0.

	recognizer nextPredicted.
	recognizer stopPredicted.
	self assert: recognizer isPathEmpty description: 'Stop predicted should clear path'.
	self assertEmpty: recognizer consumed.
	self assert: recognizer globalCounter equals: 0
]

{ #category : 'tests' }
OPMcRecognizerTest >> testNextRandomSimulationFailureOnDeadEndAndZeroProbability [

	| impossibleTransition |
	recognizer input: '3' startingAt: stateGamma for: '0'.
	recordedEvents removeAll.
	recognizer next.
	self assert: recordedEvents size equals: 1.
	self assert: recordedEvents first class identicalTo: OPMcRecognizerFailure.
	self assert: recordedEvents first place identicalTo: stateGamma.

	impossibleTransition := OPMcTransition from: stateGamma to: stateAlpha named: '-1'.
	markovChain add: impossibleTransition.
	recognizer input: '3' startingAt: stateGamma for: '0'.
	recordedEvents removeAll.
	recognizer next.
	self assert: recordedEvents size equals: 1.
	self assert: recordedEvents first class identicalTo: OPMcRecognizerFailure.
	self assert: recordedEvents first place identicalTo: stateGamma
]

{ #category : 'tests' }
OPMcRecognizerTest >> testNextRandomSimulationSuccessAndPauseResume [

	recognizer input: '2' startingAt: stateAlpha for: '0'.
	recordedEvents removeAll.

	recognizer next.
	self assert: recordedEvents size equals: 2.
	self assert: recordedEvents first class identicalTo: OPMcRecognizerLeave.
	self assert: recordedEvents first place identicalTo: stateAlpha.
	self assert: recordedEvents second class identicalTo: OPMcRecognizerEnter.
	self assert: recordedEvents second place identicalTo: transitionAlphaBeta.

	recognizer next.
	self assert: recordedEvents last class identicalTo: OPMcRecognizerEnter.
	self assert: recordedEvents last place identicalTo: stateBeta.

	recognizer pause.
	recognizer next.
	self assert: recordedEvents last class identicalTo: OPMcRecognizerFailure.
	self assert: recordedEvents last place identicalTo: stateBeta.

	recognizer resume.
	recordedEvents removeAll.
	recognizer input: '2' startingAt: stateAlpha for: '0'.
	2 timesRepeat: [ recognizer next ].
	self assert: recordedEvents last place identicalTo: stateBeta.

	recognizer next.
	self assert: stateBeta activations equals: 1.
	self assert: recognizer globalCounter equals: 2.
	self assert: recordedEvents last place identicalTo: transitionBetaGamma.

	recognizer next.
	self assert: recordedEvents last place identicalTo: stateGamma.

	recognizer next.
	self assert: stateGamma activations equals: 1.
	self assert: recordedEvents last class identicalTo: OPMcRecognizerSuccess.
	self assert: recordedEvents last place identicalTo: stateGamma.

	stateAlpha counterReset.
	stateBeta counterReset.
	stateGamma counterReset.
	recordedEvents removeAll.
	recognizer input: '2' startingAt: stateAlpha for: '0'.
	recognizer nextUpToEnd.
	self assert: recordedEvents last class identicalTo: OPMcRecognizerSuccess.
	self assert: recordedEvents last place identicalTo: stateGamma.
	self assert: recognizer globalCounter equals: 2.
	self deny: recognizer isPathEmpty description: 'Completed run should populate path'
]

{ #category : 'tests' }
OPMcRecognizerTest >> testPredictedSimulationFailureAndSinkCompletion [

	recognizer predictedInput: #( 'a' 'z' ) startingAt: stateAlpha for: '0'.
	recordedEvents removeAll.
	recognizer nextPredicted.
	self assert: recordedEvents last class identicalTo: OPMcRecognizerFailure.
	self assert: recordedEvents last place identicalTo: stateAlpha.

	recognizer predictedInput: #( 'a' ) startingAt: stateGamma for: '0'.
	recordedEvents removeAll.
	recognizer nextPredicted.
	self assert: recordedEvents last class identicalTo: OPMcRecognizerSuccess.
	self assert: recordedEvents last place identicalTo: stateGamma
]

{ #category : 'tests' }
OPMcRecognizerTest >> testPredictedSimulationSuccessAndCompletion [

	recognizer predictedInput: #( 'a' 'b' 'c' ) startingAt: stateAlpha for: '0'.
	recordedEvents removeAll.

	5 timesRepeat: [ recognizer nextPredicted ].
	self assert: stateAlpha activations equals: 1.
	self assert: stateBeta activations equals: 1.
	self assert: stateGamma activations equals: 1.
	self assert: recognizer globalCounter equals: 3.
	self assert: recordedEvents last class identicalTo: OPMcRecognizerSuccess.
	self assert: recordedEvents last place identicalTo: stateGamma.

	recordedEvents removeAll.
	recognizer nextPredicted.
	self assert: recordedEvents last class identicalTo: OPMcRecognizerSuccess.

	recordedEvents removeAll.
	recognizer inputFinished.
	self assert: recordedEvents last class identicalTo: OPMcRecognizerSuccess.

	stateAlpha counterReset.
	stateBeta counterReset.
	stateGamma counterReset.
	recordedEvents removeAll.
	recognizer predictedInput: #( 'a' 'b' 'c' ) startingAt: stateAlpha for: '0'.
	recognizer nextUpToEndPredicted.
	self assert: recordedEvents last class identicalTo: OPMcRecognizerSuccess.
	self assert: recordedEvents last place identicalTo: stateGamma.
	self assert: recognizer globalCounter equals: 3
]

{ #category : 'tests' }
OPMcRecognizerTest >> testRecognizerEventAccessors [

	| enterEvent leaveEvent successEvent failureEvent |
	enterEvent := OPMcRecognizerEnter place: stateAlpha.
	leaveEvent := OPMcRecognizerLeave place: transitionAlphaBeta.
	successEvent := OPMcRecognizerSuccess place: stateGamma.
	failureEvent := OPMcRecognizerFailure place: stateBeta.

	self assert: enterEvent place identicalTo: stateAlpha.
	self assert: leaveEvent place identicalTo: transitionAlphaBeta.
	self assert: successEvent place identicalTo: stateGamma.
	self assert: failureEvent place identicalTo: stateBeta.

	enterEvent place: stateBeta.
	self assert: enterEvent place identicalTo: stateBeta
]
