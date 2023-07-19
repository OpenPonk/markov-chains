Class {
	#name : #OPMcTransitionShape,
	#superclass : #OPEdge,
	#category : #'OpenPonk-MarkovChains-DiagramElements'
}

{ #category : #initialization }
OPMcTransitionShape >> createOwnedElementsWithoutController [

	self ownedElements ifNotEmpty: [ ^ self ].
	OPMcTransitionLabel in: self
]

{ #category : #initialization }
OPMcTransitionShape >> renderBasicShape [

	^ (self source = self target
		   ifTrue: [ OPRSBezier ]
		   ifFalse: [ OPRSPolyline ]) new
		  markerEnd: OPRSMarkerBuilder arrow;
		  attachPoint: (RSBorderAttachPoint new offset: -10);
		  controlPointsController: OPRSDraggableCPController new;
		  addInteraction: OPRSDraggableControlPoints;
		  color: Color black;
		  from: self source roassalShape;
		  to: self target roassalShape;
		  yourself
]
