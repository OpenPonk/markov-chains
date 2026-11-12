"
Abstract base test suite providing shared assertions for Markov Chain element controllers.
"
Class {
	#name : 'OPMcElementControllerTest',
	#superclass : 'OPAbstractElementControllerTest',
	#category : 'OpenPonk-MarkovChains-Tests-Controllers',
	#package : 'OpenPonk-MarkovChains-Tests',
	#tag : 'Controllers'
}

{ #category : 'testing' }
OPMcElementControllerTest class >> isAbstract [
	^ self == OPMcElementControllerTest
]

{ #category : 'constants' }
OPMcElementControllerTest >> diagramControllerClass [
	^ OPMcController
]

{ #category : 'constants' }
OPMcElementControllerTest >> diagramModelClass [
	^ OPMc
]
