"
Controller for a Markov Chain state.
Manages the diagram lifecycle, valid connections, and interactions for state nodes.
"
Class {
	#name : 'OPMcStateController',
	#superclass : 'OPMcVertexController',
	#category : 'OpenPonk-MarkovChains-Controllers',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPMcStateController class >> diagramElementClass [

	^ OPMcStateShape
]

{ #category : 'accessing' }
OPMcStateController class >> viewModelClass [
	^ OPMcStateViewModel
]
