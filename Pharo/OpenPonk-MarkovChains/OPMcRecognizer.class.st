"
Simulates and tracks state transitions over a Markov Chain model. It manages input sequences, probability-based random walks, and triggers events upon state changes.
"
Class {
	#name : 'OPMcRecognizer',
	#superclass : 'OPAnnouncableObject',
	#instVars : [
		'input',
		'consumed',
		'path',
		'current',
		'canContinue',
		'idle',
		'globalCounter',
		'consumedBack'
	],
	#category : 'OpenPonk-MarkovChains-Simulations',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Simulations'
}

{ #category : 'accessing' }
OPMcRecognizer >> allStates [

	| visited |
	visited := Set new.
	^ path select: [ :element |
			  (visited includes: element)
				  ifTrue: [ false ]
				  ifFalse: [
						  visited add: element.
						  true ] ]
]

{ #category : 'accessing' }
OPMcRecognizer >> back [

	consumed ifEmpty: [ ^ self ].
	canContinue := true.
	consumed top isState ifTrue: [
			consumed top counterDecrement.
			self decrementGC ].
	consumedBack push: consumed pop.
	consumed ifEmpty: [
			self goTo: consumedBack top.
			^ self ].
	self goTo: consumed top
]

{ #category : 'accessing' }
OPMcRecognizer >> backPredicted [	
	consumed ifEmpty: [ ^ self ].
	canContinue := true.
	consumed top isState 
		ifTrue: [ consumed top counterDecrement.
					self decrementGCInclZero  ].
	consumedBack push: consumed pop.
	self goTo: consumedBack top.
	consumed ifEmpty: [ ^ self ].
]

{ #category : 'API' }
OPMcRecognizer >> beComplete [
	current outgoing isNil | (globalCounter = (input asNumber)) 
		ifTrue: [ self beSuccess ]
		ifFalse: [ self beFailure ].
	canContinue := false
	
"be complete when path reaches a length equals idle (steps given by the user)"
]

{ #category : 'actions' }
OPMcRecognizer >> beCompletePredicted [
	current outgoing isNil | (globalCounter = (input size)) 
		ifTrue: [ self beSuccess ]
		ifFalse: [ self beFailure ].
	canContinue := false
]

{ #category : 'terminators' }
OPMcRecognizer >> beFailure [
	self announce: (OPMcRecognizerFailure place: current).
]

{ #category : 'terminators' }
OPMcRecognizer >> beSuccess [
	self announce: (OPMcRecognizerSuccess place: current)
	
		
]

{ #category : 'accessing' }
OPMcRecognizer >> consumed [
	^ consumed
]

{ #category : 'accessing' }
OPMcRecognizer >> consumedBackEmpty [
	| transition |
		
	current isTransition ifTrue: [ 
		consumed push: current.
		^ self goTo: current target ].
	
	((current name = (input at: input size asInteger) asString) & (globalCounter = input size)) 		
		ifTrue: [ ^ self beCompletePredicted  ].
	
	path push: current.
	consumed push: current.
	current counterAdd.
	self incrementGCInclZero.
	
	((current name = (input at: input size asInteger) asString) & (globalCounter = input size)) 		
		ifTrue: [ ^ self beCompletePredicted  ].
	
	current outgoing do: [ :each | 
		(each target name = (input at: globalCounter + 1) asString) ifTrue: [
			 transition := each ] ].
	
	(transition isNil & (globalCounter ~= input size)) ifTrue: [ 
		^ self beCompletePredicted ].
	(transition isNil & (globalCounter = input size)) ifTrue: [ 
		^ self beCompletePredicted ].
	self goTo: transition.
]

{ #category : 'accessing' }
OPMcRecognizer >> consumedBackNotEmpty [

	| transition |
	consumed push: consumedBack pop.
	consumedBack isEmpty
		ifTrue: [
				consumed top isState
					ifTrue: [
							self incrementGCInclZero.
							consumed top counterAdd.
							(current name = (input at: input size asInteger) asString and: [ globalCounter = input size ]) ifTrue: [
								^ self beCompletePredicted ].
							globalCounter < input size ifTrue: [
								current outgoing do: [ :each | each target name = (input at: globalCounter + 1) asString ifTrue: [ transition := each ] ] ].
							transition ifNil: [ ^ self beCompletePredicted ].
							self goTo: transition ]
					ifFalse: [ ^ self goTo: consumed top target ] ]
		ifFalse: [
				consumed top isState ifTrue: [
						self incrementGCInclZero.
						consumed top counterAdd ].
				^ self goTo: consumedBack top ]
]

{ #category : 'actions' }
OPMcRecognizer >> decrementGC [
	globalCounter = 1
		ifFalse: [ globalCounter := globalCounter - 1 ] 
		ifTrue: [ globalCounter  := 1 ] 
	
]

{ #category : 'actions' }
OPMcRecognizer >> decrementGCInclZero [
	globalCounter = 1
		ifFalse: [ globalCounter := globalCounter - 1 ] 
		ifTrue: [ globalCounter  := 0 ] 
	
]

{ #category : 'accessing' }
OPMcRecognizer >> globalCounter [
	^ globalCounter
]

{ #category : 'private' }
OPMcRecognizer >> goTo: aPlace [
	current ifNotNil: [ self announce: (OPMcRecognizerLeave place: current) ].
	current := aPlace.
	self announce: (OPMcRecognizerEnter place: current)
]

{ #category : 'actions' }
OPMcRecognizer >> incrementGC [
	globalCounter 
		ifNotNil: [ globalCounter := globalCounter + 1 ] 
		ifNil: [ globalCounter  := 1 ] 
	
]

{ #category : 'actions' }
OPMcRecognizer >> incrementGCInclZero [
	globalCounter 
		ifNotNil: [ globalCounter := globalCounter + 1 ] 
		ifNil: [ globalCounter  := 0 ] 
	
]

{ #category : 'initialization' }
OPMcRecognizer >> initialize [

	super initialize.
	path := Stack new.
	consumed := Stack new.
	consumedBack := Stack new.
	canContinue := false
]

{ #category : 'accessing' }
OPMcRecognizer >> input: aCollection startingAt: aState [ 
	self reset.
	input := aCollection.
	self goTo: aState "outgoing anyOne target"
]

{ #category : 'accessing' }
OPMcRecognizer >> input: aCollection startingAt: aState for: idleTime [
	self reset.
	input := aCollection.
	idle := idleTime.
	self goTo: aState "outgoing anyOne target".
	globalCounter := 1.
	
]

{ #category : 'stepping' }
OPMcRecognizer >> inputFinished [
	((current name = (input at: input size asInteger) asString) & (globalCounter = input size)) 		
		ifTrue: [ ^ self beCompletePredicted  ].
]

{ #category : 'accessing' }
OPMcRecognizer >> inputPosition [
	^ "path size + 1" globalCounter
]

{ #category : 'accessing' }
OPMcRecognizer >> inputPositionExclNil [
	^ globalCounter + 1
]

{ #category : 'accessing - Action' }
OPMcRecognizer >> inputs [
	^ input
]

{ #category : 'testing' }
OPMcRecognizer >> isInputEmpty [
	^ current isState & input isEmpty
]

{ #category : 'testing' }
OPMcRecognizer >> isPathEmpty [
	^ path isEmpty
]

{ #category : 'accessing' }
OPMcRecognizer >> next [

	| transition sum probability |
	consumedBack isNotEmpty
		ifTrue: [
				canContinue ifFalse: [ ^ self beComplete ].
				current isTransition ifTrue: [
						consumed push: consumedBack pop.
						^ self goTo: current target ].
				((current isState and: [ current outgoing isNil ]) or: [ globalCounter = input asNumber ]) ifTrue: [
						current counterAdd.
						^ self beComplete ].
				(current isState and: [ consumed size > 1 ]) ifTrue: [
						current counterAdd.
						self incrementGC ].
				consumed push: consumedBack pop.
				consumedBack isNotEmpty ifTrue: [ ^ self goTo: consumedBack top ].
				consumed top isTransition ifTrue: [ ^ self goTo: consumed top target ] ]
		ifFalse: [
				consumed push: current.
				canContinue ifFalse: [ ^ self beComplete ].
				current isTransition ifTrue: [ ^ self goTo: current target ].
				((current isState and: [ current outgoing isNil ]) or: [ globalCounter = input asNumber ]) ifTrue: [
						path push: current.
						current counterAdd.
						^ self beComplete ].
				(current isState and: [ consumed size > 1 ]) ifTrue: [
						path push: current.
						current counterAdd.
						self incrementGC ] ].

	probability := (0 to: 100) atRandom.
	sum := 0.
	current outgoing do: [ :each |
			sum := sum + (each name asNumber * 100).
			(probability <= sum and: [ transition isNil ]) ifTrue: [ transition := each ] ].
	transition ifNil: [ ^ self beComplete ].
	self goTo: transition
]

{ #category : 'stepping' }
OPMcRecognizer >> nextPredicted [
	consumedBack isNotEmpty 
		ifTrue:[ self consumedBackNotEmpty ]
		ifFalse: [ self consumedBackEmpty ]. 
]

{ #category : 'stepping' }
OPMcRecognizer >> nextUpToEnd [
	[ canContinue ]
		whileTrue: [ self next.
			(idle asNumber) second asDelay wait.
			self currentWorld doOneCycle ]
]

{ #category : 'stepping' }
OPMcRecognizer >> nextUpToEndPredicted [
	[ canContinue ]
		whileTrue: [ self nextPredicted.
			(idle asNumber) second asDelay wait.
			self currentWorld doOneCycle ]
]

{ #category : 'actions' }
OPMcRecognizer >> pause [
	canContinue := false
	
"be complete when path reaches a length equals idle (steps given by the user)"
]

{ #category : 'accessing' }
OPMcRecognizer >> predictedInput: aCollection startingAt: aState for: idleTime [
	self resetPredicted.
	input := aCollection.
	idle := idleTime.
	self goTo: aState "outgoing anyOne target".
	globalCounter := 0.
]

{ #category : 'initialization' }
OPMcRecognizer >> reset [

	path := Stack new.
	consumed := Stack new.
	consumedBack := Stack new.
	canContinue := true.
	globalCounter := 1
]

{ #category : 'initialization' }
OPMcRecognizer >> resetPredicted [
	path := Stack new.
	consumed := Stack new.
	consumedBack := Stack new.
	canContinue := true.
	globalCounter := 0
]

{ #category : 'stepping - auto' }
OPMcRecognizer >> resume [
	canContinue := true
	
"be complete when path reaches a length equals idle (steps given by the user)"
]

{ #category : 'actions' }
OPMcRecognizer >> stop [
	canContinue := false.
	path := Stack new.
	consumed := Stack new.
	consumedBack := Stack new.
	globalCounter := 1

]

{ #category : 'actions' }
OPMcRecognizer >> stopPredicted [
	canContinue := false.
	path := Stack new.
	consumed := Stack new.
	consumedBack := Stack new.
	globalCounter := 0

]
