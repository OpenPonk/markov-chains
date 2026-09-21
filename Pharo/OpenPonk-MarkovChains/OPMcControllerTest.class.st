Class {
	#name : 'OPMcControllerTest',
	#superclass : 'OPAbstractDiagramControllerTest',
	#category : 'OpenPonk-MarkovChains-Controllers',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Controllers'
}

{ #category : 'constants' }
OPMcControllerTest >> controllerClass [
	^ OPMcController
]

{ #category : 'accessing' }
OPMcControllerTest >> diagramModelClass [
	^ OPMc
]

{ #category : 'constants' }
OPMcControllerTest >> modelClass [
	^ OPMc
]

{ #category : 'tests' }
OPMcControllerTest >> testControllerFactory [
	self assert: controller controllerFactory isNotNil.
	self assert: (controller controllerFactory isKindOf: OPControllerFactory)
]

{ #category : 'tests' }
OPMcControllerTest >> testInitializePalette [
	| palette |
	palette := OPPalette new.
	controller initializePalette: palette.
	self denyCollection: palette items hasSameElements: #()
]
