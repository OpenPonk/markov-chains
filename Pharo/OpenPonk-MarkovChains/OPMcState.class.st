Class {
	#name : 'OPMcState',
	#superclass : 'OPMcVertex',
	#instVars : [
		'activationCount'
	],
	#category : 'OpenPonk-MarkovChains-Models',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Models'
}

{ #category : 'as yet unclassified' }
OPMcState >> activations [
	^ activationCount 
]

{ #category : 'as yet unclassified' }
OPMcState >> counterAdd [
	activationCount 
		ifNotNil: [ activationCount := activationCount +1 ] 
		ifNil: [ activationCount  := 0.
					activationCount := activationCount + 1 ] 
]

{ #category : 'as yet unclassified' }
OPMcState >> counterDecrement [
	activationCount = 1 | (activationCount = 0)
		ifFalse: [ activationCount := activationCount - 1 ] 
		ifTrue: [ activationCount  := 0 ] 
]

{ #category : 'as yet unclassified' }
OPMcState >> counterReset [
	activationCount := 0
]

{ #category : 'as yet unclassified' }
OPMcState >> graphmlType [
	^ #regular
]

{ #category : 'as yet unclassified' }
OPMcState >> isNormal [
	^ true
]
