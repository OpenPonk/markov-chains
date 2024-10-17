Class {
	#name : 'OPMcVertex',
	#superclass : 'OPModelObject',
	#category : 'OpenPonk-MarkovChains-Models',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Models'
}

{ #category : 'associating' }
OPMcVertex >> => aVertex [

	^ OPMcTransition from: self to: aVertex
]

{ #category : 'DynaCASE-FSM-GraphML-accessing' }
OPMcVertex >> graphmlType [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPMcVertex >> incoming [
	owner ifNil: [ ^ #() ].
	^ owner transitions select: [ :each | each target = self ]
]

{ #category : 'testing' }
OPMcVertex >> isFinal [
	^ false
]

{ #category : 'testing' }
OPMcVertex >> isInitial [
	^ false
]

{ #category : 'testing' }
OPMcVertex >> isNormal [
	^ false
]

{ #category : 'testing' }
OPMcVertex >> isState [
	^ true
]

{ #category : 'testing' }
OPMcVertex >> isTransition [
	^ false
]

{ #category : 'accessing' }
OPMcVertex >> outgoing [
	owner ifNil: [ ^ #() ].
	^ owner transitions select: [ :each | each source = self ]
]

{ #category : 'accessing' }
OPMcVertex >> relatedElements [
	^ (self incoming , self outgoing) asSet asOrderedCollection
]

{ #category : 'removing' }
OPMcVertex >> removedFrom: aDiagram [
	self
		removedFrom: aDiagram
		do: [ 
			self incoming do: [ :each | aDiagram remove: each ].
			self outgoing do: [ :each | aDiagram remove: each ] ]
]
