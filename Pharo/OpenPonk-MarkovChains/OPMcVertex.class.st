Class {
	#name : 'OPMcVertex',
	#superclass : 'OPModelObject',
	#category : 'OpenPonk-MarkovChains-Models',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Models'
}

{ #category : 'associating' }
OPMcVertex >> -> aVertex [
	^ OPMcTransition from: self to: aVertex
]

{ #category : 'associating' }
OPMcVertex >> graphmlType [
	^ self subclassResponsibility
]

{ #category : 'associating' }
OPMcVertex >> incoming [
	owner ifNil: [ ^ #() ].
	^ owner transitions select: [ :each | each target = self ]
]

{ #category : 'associating' }
OPMcVertex >> isFinal [
	^ false
]

{ #category : 'associating' }
OPMcVertex >> isInitial [
	^ false
]

{ #category : 'associating' }
OPMcVertex >> isNormal [
	^ false
]

{ #category : 'associating' }
OPMcVertex >> isState [
	^ true
]

{ #category : 'associating' }
OPMcVertex >> isTransition [
	^ false
]

{ #category : 'associating' }
OPMcVertex >> outgoing [
	owner ifNil: [ ^ #() ].
	^ owner transitions select: [ :each | each source = self ]
]

{ #category : 'associating' }
OPMcVertex >> relatedElements [
	^ (self incoming , self outgoing) asSet asOrderedCollection
]

{ #category : 'associating' }
OPMcVertex >> removedFrom: aDiagram [
	self
		removedFrom: aDiagram
		do: [ 
			self incoming do: [ :each | aDiagram remove: each ].
			self outgoing do: [ :each | aDiagram remove: each ] ]
]
