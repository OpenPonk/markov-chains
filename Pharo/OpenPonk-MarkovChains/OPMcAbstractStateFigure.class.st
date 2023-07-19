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

{ #category : #rendering }
OPMcAbstractStateFigure >> renderShapeDetails [

	| selectable |
	selectable := OPRSSelectable new.
	self setupHighlight: selectable.
	self roassalShape @ selectable.
	self roassalShape @ OPRSSelectionDraggable
]

{ #category : #hooks }
OPMcAbstractStateFigure >> setupHighlight: aHighlightable [

	aHighlightable highlightAdornments: [ :builder | 
		builder horizontalLocation
			outer;
			right.
		builder verticalLocation
			inner;
			middle.
		builder directionDown.
		adornmentCreationBlock value: builder ]
]
