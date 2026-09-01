"
Controller for Markov Chain transitions.
Manages the diagram lifecycle and interactions for directional edges connecting states.
"
Class {
	#name : 'OPMcTransitionController',
	#superclass : 'OPDirectionalRelationshipController',
	#category : 'OpenPonk-MarkovChains-Controllers',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPMcTransitionController class >> diagramElementClass [

	^ OPMcTransitionShape
]

{ #category : 'accessing' }
OPMcTransitionController class >> viewModelClass [
	^ OPMcTransitionViewModel
]
