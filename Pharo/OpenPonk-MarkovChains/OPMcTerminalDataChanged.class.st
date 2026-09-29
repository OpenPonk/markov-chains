"
Announcement triggered when the input data sequence changes within the Markov Chain terminal simulation UI.
"
Class {
	#name : 'OPMcTerminalDataChanged',
	#superclass : 'Announcement',
	#instVars : [
		'data'
	],
	#category : 'OpenPonk-MarkovChains-Simulations',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Simulations'
}

{ #category : 'accessing' }
OPMcTerminalDataChanged class >> data: aString [

	^ self new
		  data: aString;
		  yourself
]

{ #category : 'accessing' }
OPMcTerminalDataChanged >> data [

	^ data
]

{ #category : 'accessing' }
OPMcTerminalDataChanged >> data: aString [

	data := aString
]
