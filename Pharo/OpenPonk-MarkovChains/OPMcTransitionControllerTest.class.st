Class {
	#name : 'OPMcTransitionControllerTest',
	#superclass : 'OPAbstractDirectionalRelationshipControllerTest',
	#category : 'OpenPonk-MarkovChains-Controllers',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Controllers'
}

{ #category : 'accessing' }
OPMcTransitionControllerTest class >> diagramElementClass [
	^ OPMcTransitionShape
]

{ #category : 'constants' }
OPMcTransitionControllerTest >> controllerClass [
	^ OPMcTransitionController
]

{ #category : 'constants' }
OPMcTransitionControllerTest >> diagramControllerClass [
	^ OPMcController
]

{ #category : 'constants' }
OPMcTransitionControllerTest >> diagramModelClass [
	^ OPMc
]

{ #category : 'constants' }
OPMcTransitionControllerTest >> modelClass [
	^ OPMcTransition
]

{ #category : 'constants' }
OPMcTransitionControllerTest >> sourceControllerClass [
	^ OPMcStateController
]

{ #category : 'constants' }
OPMcTransitionControllerTest >> sourceModelClass [
	^ OPMcState
]

{ #category : 'constants' }
OPMcTransitionControllerTest >> targetControllerClass [
	^ OPMcStateController
]
