Class {
	#name : 'OPMcRecognizerEvent',
	#superclass : 'Announcement',
	#instVars : [
		'place'
	],
	#category : 'OpenPonk-MarkovChains-Simulations',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Simulations'
}

{ #category : 'accessing' }
OPMcRecognizerEvent class >> place: aPlace [
	^ self new
		place: aPlace;
		yourself
]

{ #category : 'accessing' }
OPMcRecognizerEvent >> place [
	^ place
]

{ #category : 'accessing' }
OPMcRecognizerEvent >> place: aStateOrTransition [
	place := aStateOrTransition
]
