Class {
	#name : 'OPMcTransitionController',
	#superclass : 'OPDirectionalRelationshipController',
	#category : 'OpenPonk-MarkovChains-Controllers',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPMcTransitionController >> diagramElementClass [

	^ OPMcTransitionShape
]

{ #category : 'construction' }
OPMcTransitionController >> ensureSourceAndTargetIn: aDiagramController [

	source ifNil: [ 
		self source:
			(aDiagramController showWithoutDependentInDiagramModel:
				 model source) ].
	target ifNil: [ 
		self target:
			(aDiagramController showWithoutDependentInDiagramModel:
				 model target) ]
]

{ #category : 'announcements' }
OPMcTransitionController >> internalSubscribeTo: aModel [

	super internalSubscribeTo: aModel.
	aModel
		when: OPElementRemoved
		send: #removeController
		to: self
]

{ #category : 'construction' }
OPMcTransitionController >> isHideable [
	^ true
]

{ #category : 'construction' }
OPMcTransitionController >> modelClass [
	^ OPMcTransition
]

{ #category : 'construction' }
OPMcTransitionController >> removeModel [
	self model announcer unsubscribe: self.
	self diagramController model remove: self model
]

{ #category : 'construction' }
OPMcTransitionController >> showInDiagram: aDiagramController [

	self ensureSourceAndTargetIn: aDiagramController.
	^ super showInDiagram: aDiagramController
]

{ #category : 'construction' }
OPMcTransitionController >> showWithoutDependentInDiagram: aDiagramController [

	self ensureSourceAndTargetIn: aDiagramController.
	^ super showWithoutDependentInDiagram: aDiagramController
]
