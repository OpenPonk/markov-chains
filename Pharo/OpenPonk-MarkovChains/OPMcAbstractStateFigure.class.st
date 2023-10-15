Class {
	#name : #OPMcAbstractStateFigure,
	#superclass : #OPShape,
	#instVars : [
		'adornmentCreationBlock'
	],
	#category : #'OpenPonk-MarkovChains-DiagramElements'
}

{ #category : #accessing }
OPMcAbstractStateFigure >> adornmentCreationBlock: aBlock [

	adornmentCreationBlock := aBlock
]

{ #category : #hooks }
OPMcAbstractStateFigure >> selectableInteraction [

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

{ #category : #rendering }
OPMcAbstractStateFigure >> shouldBePositionableByUser [

	^ true
]
