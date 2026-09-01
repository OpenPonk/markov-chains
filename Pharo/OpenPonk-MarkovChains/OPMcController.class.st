"
Controller for the top-level Markov Chain diagram. Manages the lifecycle, layout applications, and palette initialization.
"
Class {
	#name : 'OPMcController',
	#superclass : 'OPDiagramController',
	#category : 'OpenPonk-MarkovChains-Controllers',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Controllers'
}

{ #category : 'accessing' }
OPMcController class >> viewModelClass [

	^ OPMcViewModel
]

{ #category : 'userinterface' }
OPMcController >> applyLayout: anAlgorithm [

	| roassalShapes edges |
	roassalShapes := self controllers
		           select: [ :each | each isKindOf: OPMcVertexController ]
		           thenCollect: [ :each | each roassalShape ].
	edges := (roassalShapes flatCollect: #connectedLines) reject: [ :each |
		         each from = each to ].
	anAlgorithm on: roassalShapes asGroup edges: edges asGroup
]

{ #category : 'connecting' }
OPMcController >> canBeTargetFor: aController [
	^ (super canBeTargetFor: aController)
		or: [ aController isKindOf: OPMcVertexController ]
]

{ #category : 'accessing' }
OPMcController >> controllerFactory [

	^ super controllerFactory
		  register: OPMcStateController forModel: OPMcState;
		  register: OPMcTransitionController forModel: OPMcTransition
]

{ #category : 'ui interaction' }
OPMcController >> initializePalette: aPalette [
	aPalette
		newCreationTool: 'State' 
			factory: [ OPMcStateController new ] 
			icon: OPCoreIcons opFsmRegularStateIcon;
		newConnectionCreationTool: 'Transition'
			factory: [ OPMcTransitionController new ]
			icon: OPCoreIcons opFsmTransitionIcon
]

{ #category : 'controllers management' }
OPMcController >> newControllerFor: aModel [
	"IncomingTransition identifies itself as transition, but is not"

	^ super
		newControllerFor:
			(aModel isTransition
				ifTrue: [ aModel asTransition ]
				ifFalse: [ aModel ])
]
