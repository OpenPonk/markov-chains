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

{ #category : 'accessing' }
OPMcState >> activations [

	^ activationCount
]

{ #category : 'actions' }
OPMcState >> counterAdd [

	activationCount ifNil: [ ^ activationCount := 1 ].
	activationCount := activationCount + 1
]

{ #category : 'actions' }
OPMcState >> counterDecrement [

	activationCount := activationCount < 2
		                   ifTrue: [ 0 ]
		                   ifFalse: [ activationCount - 1 ]
]

{ #category : 'actions' }
OPMcState >> counterReset [

	activationCount := 0
]

{ #category : 'DynaCASE-FSM-GraphML-accessing' }
OPMcState >> graphmlType [
	^ #regular
]

{ #category : 'testing' }
OPMcState >> isNormal [
	^ true
]
