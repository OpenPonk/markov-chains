Class {
	#name : 'OPMcElementControllerTest',
	#superclass : 'OPAbstractElementControllerTest',
	#category : 'OpenPonk-MarkovChains-Controllers',
	#package : 'OpenPonk-MarkovChains',
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
