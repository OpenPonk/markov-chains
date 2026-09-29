"
Abstract base class for visual representations of Markov Chain states.
Provides basic adornment behavior and interaction definitions for the diagram.
"
Class {
	#name : 'OPMcAbstractStateShape',
	#superclass : 'OPBoundNode',
	#instVars : [
		'adornmentCreationBlock'
	],
	#category : 'OpenPonk-MarkovChains-DiagramElements',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'DiagramElements'
}

{ #category : 'accessing' }
OPMcAbstractStateShape >> adornmentCreationBlock: aBlock [

	adornmentCreationBlock := aBlock
]

{ #category : 'interactions' }
OPMcAbstractStateShape >> selectableInteraction [

	^ OPRSSelectable highlightAdornments: [ :builder |
		  builder horizontalLocation
			  outer;
			  right.
		  builder verticalLocation
			  inner;
			  middle.
		  builder directionDown.
		  adornmentCreationBlock value: builder ]
]
