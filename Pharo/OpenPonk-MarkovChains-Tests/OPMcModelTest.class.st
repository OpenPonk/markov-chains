"
Unit tests for Markov Chain domain model objects, covering state activation counters, vertex topology, transition matching, and removal behavior.
"
Class {
	#name : 'OPMcModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'markovChain',
		'stateAlpha',
		'stateBeta',
		'stateGamma',
		'transitionAlphaBeta',
		'transitionBetaGamma'
	],
	#category : 'OpenPonk-MarkovChains-Tests-Models',
	#package : 'OpenPonk-MarkovChains-Tests',
	#tag : 'Models'
}

{ #category : 'running' }
OPMcModelTest >> setUp [

	super setUp.
	markovChain := OPMc named: 'Test Chain'.
	stateAlpha := OPMcState named: 'a'.
	stateBeta := OPMcState named: 'b'.
	stateGamma := OPMcState named: 'c'.
	transitionAlphaBeta := OPMcTransition from: stateAlpha to: stateBeta named: '0.5'.
	transitionBetaGamma := OPMcTransition from: stateBeta to: stateGamma named: '1.0'.
	markovChain
		add: stateAlpha;
		add: stateBeta;
		add: stateGamma;
		add: transitionAlphaBeta;
		add: transitionBetaGamma
]

{ #category : 'running' }
OPMcModelTest >> tearDown [

	markovChain := nil.
	stateAlpha := nil.
	stateBeta := nil.
	stateGamma := nil.
	transitionAlphaBeta := nil.
	transitionBetaGamma := nil.
	super tearDown
]

{ #category : 'tests' }
OPMcModelTest >> testModelPredicatesAndCollections [

	self deny: markovChain isState description: 'Markov chain container must not report as a state'.
	self deny: markovChain isTransition description: 'Markov chain container must not report as a transition'.
	self assertCollection: markovChain states hasSameElements: {
			stateAlpha.
			stateBeta.
			stateGamma }.
	self assertCollection: markovChain transitions hasSameElements: {
			transitionAlphaBeta.
			transitionBetaGamma }
]

{ #category : 'tests' }
OPMcModelTest >> testRemoveVertexDetachesAndRemovesTransitions [

	markovChain remove: stateBeta.

	self assert: stateBeta owner isNil description: 'Removed vertex must clear its owner'.
	self assert: transitionAlphaBeta owner isNil description: 'Incoming transition must be removed with vertex'.
	self assert: transitionBetaGamma owner isNil description: 'Outgoing transition must be removed with vertex'.
	self assertCollection: markovChain states hasSameElements: {
			stateAlpha.
			stateGamma }.
	self assertEmpty: markovChain transitions
]

{ #category : 'tests' }
OPMcModelTest >> testStateActivationCounters [

	self assert: stateAlpha activations isNil description: 'Initial state activations should be nil before counting'.
	self assert: stateAlpha isNormal description: 'OPMcState must report as a normal state'.

	stateAlpha counterAdd.
	self assert: stateAlpha activations equals: 1.
	stateAlpha counterAdd.
	self assert: stateAlpha activations equals: 2.

	stateAlpha counterDecrement.
	self assert: stateAlpha activations equals: 1.
	stateAlpha counterDecrement.
	self assert: stateAlpha activations equals: 0.
	stateAlpha counterDecrement.
	self assert: stateAlpha activations equals: 0.

	stateAlpha counterAdd.
	stateAlpha counterAdd.
	stateAlpha counterReset.
	self assert: stateAlpha activations equals: 0
]

{ #category : 'tests' }
OPMcModelTest >> testTransitionCreationEqualityAndDetach [

	| anonymousTransition identicalTransition differentTransition |
	anonymousTransition := OPMcTransition from: stateAlpha to: stateGamma.
	self assert: anonymousTransition source identicalTo: stateAlpha.
	self assert: anonymousTransition target identicalTo: stateGamma.
	self assert: anonymousTransition name equals: ''.

	self deny: transitionAlphaBeta isState description: 'Transition must not report as a state'.
	self assert: transitionAlphaBeta isTransition description: 'Transition must report as a transition'.
	self assert: transitionAlphaBeta asTransition identicalTo: transitionAlphaBeta.

	identicalTransition := transitionAlphaBeta.
	differentTransition := OPMcTransition from: stateAlpha to: stateBeta named: '0.5'.
	self assert: transitionAlphaBeta equals: identicalTransition.
	self deny: transitionAlphaBeta equals: differentTransition.
	self deny: transitionAlphaBeta equals: stateAlpha.
	self assert: (transitionAlphaBeta represents: identicalTransition) description: 'Transition must represent itself'.

	transitionAlphaBeta source: stateGamma.
	transitionAlphaBeta target: stateAlpha.
	self assert: transitionAlphaBeta source identicalTo: stateGamma.
	self assert: transitionAlphaBeta target identicalTo: stateAlpha.

	transitionAlphaBeta detach.
	self assert: transitionAlphaBeta source isNil description: 'Detached transition must clear source'.
	self assert: transitionAlphaBeta target isNil description: 'Detached transition must clear target'.
	self assert: transitionAlphaBeta owner isNil description: 'Detached transition must clear owner'
]

{ #category : 'tests' }
OPMcModelTest >> testTransitionMatchingAndCustomBlock [

	| multiLabelTransition changedCount |
	multiLabelTransition := OPMcTransition from: stateAlpha to: stateBeta named: 'a,b'.
	self assert: (multiLabelTransition matches: 'a') description: 'Should match first comma-separated token'.
	self assert: (multiLabelTransition matches: #b) description: 'Should match symbol token converted via asString'.
	self assert: (multiLabelTransition matches: $a) description: 'Should match character token converted via asString'.
	self deny: (multiLabelTransition matches: 'c') description: 'Should reject unlisted token'.

	changedCount := 0.
	multiLabelTransition when: OPModelChanged do: [ changedCount := changedCount + 1 ] for: self.
	multiLabelTransition matchBlock: [ :value | value = 42 ].
	self assert: (multiLabelTransition matchBlock value: 42) description: 'Assigned custom matchBlock should be returned'.
	self assert: (multiLabelTransition matches: 42) description: 'Custom matchBlock should evaluate to true for 42'.
	self deny: (multiLabelTransition matches: 'a') description: 'Custom matchBlock should replace default matcher'.
	self assert: changedCount equals: 1
]

{ #category : 'tests' }
OPMcModelTest >> testVertexPredicatesAndTopology [

	| bareVertex unownedState selfTransition |
	bareVertex := OPMcVertex new.
	self deny: bareVertex isInitial description: 'Base vertex must not be initial'.
	self deny: bareVertex isFinal description: 'Base vertex must not be final'.
	self deny: bareVertex isNormal description: 'Base vertex must not be normal'.
	self assert: bareVertex isState description: 'Vertex must report as a state'.
	self deny: bareVertex isTransition description: 'Vertex must not report as a transition'.

	unownedState := OPMcState named: 'unowned'.
	self assertEmpty: unownedState incoming.
	self assertEmpty: unownedState outgoing.

	self assertCollection: stateAlpha outgoing hasSameElements: { transitionAlphaBeta }.
	self assertEmpty: stateAlpha incoming.
	self assertCollection: stateBeta incoming hasSameElements: { transitionAlphaBeta }.
	self assertCollection: stateBeta outgoing hasSameElements: { transitionBetaGamma }.

	selfTransition := (stateBeta => stateBeta)
		                  name: '0.2';
		                  yourself.
	self assert: selfTransition source identicalTo: stateBeta.
	self assert: selfTransition target identicalTo: stateBeta.
	markovChain add: selfTransition.
	self assertCollection: stateBeta relatedElements hasSameElements: {
			transitionAlphaBeta.
			transitionBetaGamma.
			selfTransition }
]
