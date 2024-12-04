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

{ #category : 'hooks' }
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

{ #category : 'rendering' }
OPMcAbstractStateShape >> shouldBePositionableByUser [

	^ true
]
