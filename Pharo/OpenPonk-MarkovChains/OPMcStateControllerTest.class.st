Class {
	#name : 'OPMcStateControllerTest',
	#superclass : 'OPMcElementControllerTest',
	#category : 'OpenPonk-MarkovChains-Controllers',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Controllers'
}

{ #category : 'accessing' }
OPMcStateControllerTest class >> diagramElementClass [
	^ OPMcStateShape
]

{ #category : 'constants' }
OPMcStateControllerTest >> controllerClass [
	^ OPMcStateController
]

{ #category : 'constants' }
OPMcStateControllerTest >> modelClass [
	^ OPMcState
]
