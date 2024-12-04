Class {
	#name : 'OPMcStateController',
	#superclass : 'OPMcVertexController',
	#category : 'OpenPonk-MarkovChains-Controllers',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Controllers'
}

{ #category : 'forms' }
OPMcStateController >> buildEditorForm: aForm [
	super buildEditorForm: aForm.
]

{ #category : 'construction' }
OPMcStateController >> diagramElementClass [

	^ OPMcStateShape
]

{ #category : 'accessing' }
OPMcStateController >> modelClass [
	^ OPMcState
]
