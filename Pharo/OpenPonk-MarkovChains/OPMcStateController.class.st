Class {
	#name : #OPMcStateController,
	#superclass : #OPMcVertexController,
	#category : #'OpenPonk-MarkovChains-Controllers'
}

{ #category : #forms }
OPMcStateController >> buildEditorForm: aForm [
	super buildEditorForm: aForm.
]

{ #category : #forms }
OPMcStateController >> diagramElementClass [

	^ OPFsmStateShape
]

{ #category : #forms }
OPMcStateController >> modelClass [
	^ OPMcState
]
