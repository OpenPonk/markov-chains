"
Tests diagram controller interactions, transition matrix coordination, and canvas events for Markov Chains.
"
Class {
	#name : 'OPMcControllerTest',
	#superclass : 'OPAbstractDiagramControllerTest',
	#category : 'OpenPonk-MarkovChains-Tests-Controllers',
	#package : 'OpenPonk-MarkovChains-Tests',
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

	| factory |
	factory := controller controllerFactory.
	self assert: factory class identicalTo: OPControllerFactory.
	self assert: (factory hasControllerFor: OPMcState new) description: 'Controller factory must register OPMcState'.
	self assert: (factory hasControllerFor: OPMcTransition new) description: 'Controller factory must register OPMcTransition'.
	self deny: (factory hasControllerFor: OPMc new) description: 'Controller factory must not register diagram model OPMc'
]

{ #category : 'tests' }
OPMcControllerTest >> testInitializePalette [

	| palette entries stateEntry transitionEntry |
	palette := OPPalette new.
	controller initializePalette: palette.
	self assert: palette items size equals: 4.
	entries := palette items select: [ :eachItem | eachItem isKindOf: OPPaletteEntry ].
	self assertCollection: (entries collect: #label) hasSameElements: #( 'Select' 'State' 'Transition' ).

	stateEntry := entries detect: [ :eachEntry | eachEntry label = 'State' ].
	transitionEntry := entries detect: [ :eachEntry | eachEntry label = 'Transition' ].
	stateEntry click.
	self assert: palette selectedTool class identicalTo: OPNodeCreationTool.
	self assert: (palette selectedTool instVarNamed: #factory) value class identicalTo: OPMcStateController.

	transitionEntry click.
	self assert: palette selectedTool class identicalTo: OPConnectionCreationTool.
	self assert: (palette selectedTool instVarNamed: #factory) value class identicalTo: OPMcTransitionController
]
