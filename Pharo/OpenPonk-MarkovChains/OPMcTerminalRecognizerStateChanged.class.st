Class {
	#name : #OPMcTerminalRecognizerStateChanged,
	#superclass : #Announcement,
	#instVars : [
		'inputPosition',
		'inputState'
	],
	#category : #'OpenPonk-MarkovChains-Simulations'
}

{ #category : #accessing }
OPMcTerminalRecognizerStateChanged class >> at: anInteger to: aString [

	^ self new
		  inputPosition: anInteger;
		  inputState: aString;
		  yourself
]

{ #category : #accessing }
OPMcTerminalRecognizerStateChanged >> inputPosition [

	^ inputPosition
]

{ #category : #accessing }
OPMcTerminalRecognizerStateChanged >> inputPosition: anInteger [

	inputPosition := anInteger
]

{ #category : #accessing }
OPMcTerminalRecognizerStateChanged >> inputState [

	^ inputState
]

{ #category : #accessing }
OPMcTerminalRecognizerStateChanged >> inputState: aString [

	inputState := aString
]
