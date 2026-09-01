"
Diagram element representing a label attached to a Markov Chain transition edge.
Manages the textual rendering, anchoring, and positioning along the transition's underlying Roassal shape.
"
Class {
	#name : 'OPMcTransitionLabel',
	#superclass : 'OPEdgeLabel',
	#category : 'OpenPonk-MarkovChains-DiagramElements',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'DiagramElements'
}

{ #category : 'adding' }
OPMcTransitionLabel >> defaultAnchorConstraintPosition [

	^ OPRSAnchorConstraintBalanceReference balance: 0.2
]

{ #category : 'adding' }
OPMcTransitionLabel >> defaultMinDistance [

	^ 5
]

{ #category : 'accessing' }
OPMcTransitionLabel >> defaultText [

	^ self modelElement name
]

{ #category : 'rendering' }
OPMcTransitionLabel >> renderShapeDetails [

	super renderShapeDetails.
	self roassalShape
		when: RSMouseDoubleClick
		do: [ :evt | OPRenameElementCommand executeOn: self modelElement ]
		for: self
]
