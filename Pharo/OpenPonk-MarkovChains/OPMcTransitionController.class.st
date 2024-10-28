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

{ #category : 'announcements' }
OPMcTransitionController >> internalSubscribeTo: aModel [

	super internalSubscribeTo: aModel.
	aModel weakWhen: OPElementRemoved send: #removeControllerAndDiagramElement to: self
]

{ #category : 'construction' }
OPMcTransitionController >> isHideable [
	^ true
]

{ #category : 'construction' }
OPMcTransitionController >> modelClass [
	^ OPMcTransition
]

{ #category : 'destruction' }
OPMcTransitionController >> removeModel [

	self diagramController model remove: self model.
	super removeModel
]
