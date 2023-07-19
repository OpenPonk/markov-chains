Class {
	#name : #OPMcTransitionLabel,
	#superclass : #OPEdgeLabel,
	#category : #'OpenPonk-MarkovChains-DiagramElements'
}

{ #category : #adding }
OPMcTransitionLabel >> defaultAnchorConstraintPosition [

	^ OPRSAnchorConstraintBalanceReference balance: 0.2
]

{ #category : #adding }
OPMcTransitionLabel >> defaultMinDistance [

	^ 5
]

{ #category : #adding }
OPMcTransitionLabel >> defaultText [

	^ self modelElement name
]

{ #category : #adding }
OPMcTransitionLabel >> renderShapeDetails [

	super renderShapeDetails.
	self roassalShape
		when: RSMouseDoubleClick
		do: [ :evt | OPRenameElementCommand executeOn: self modelElement ]
]
