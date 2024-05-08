Class {
	#name : 'OPMcNavigatorAdapter',
	#superclass : 'OPNavigatorAdapter',
	#category : 'OpenPonk-MarkovChains-Adapters',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Adapters'
}

{ #category : 'accessing' }
OPMcNavigatorAdapter class >> priority [

	^ 10
]

{ #category : 'widget API' }
OPMcNavigatorAdapter >> childrenMapping [
	^ {(OPMc -> #states). 
	(OPMcVertex
		-> [ :o | 
			o outgoing
				, (o incoming collect: [ :each | OPMcIncomingTransition of: each ]) ]).
	(OPMcIncomingTransition -> #()).
	(OPMcTransition -> #())}
]

{ #category : 'widget API' }
OPMcNavigatorAdapter >> displayMapping [
	^ {(OPMc -> 'Diagram').
	(OPMcState -> 'State').
	(OPMcTransition -> 'Transition').
	(OPMcIncomingTransition -> 'Incoming transition')}
]

{ #category : 'widget API' }
OPMcNavigatorAdapter >> hasMappingFor: anObject in: aModel [

	^ { 
		  OPMc.
		  OPMcTransition.
		  OPMcIncomingTransition.
		  OPMcVertex } anySatisfy: [ :any | anObject isKindOf: any ]
]

{ #category : 'widget API' }
OPMcNavigatorAdapter >> iconMapping [ 
	^ {(OPMc -> OPCoreIcons opMcDiagramIcon).
	(OPMcIncomingTransition -> OPCoreIcons opFsmFlippedTransitionIcon).
	(OPMcTransition -> OPCoreIcons opFsmTransitionIcon).
	(OPMcState -> OPCoreIcons opFsmRegularStateIcon )}
]

{ #category : 'widget API' }
OPMcNavigatorAdapter >> sort: modelObjects [
	^ modelObjects
		sorted:
			[ :a :b | a name isNotNil and: [ b name isNil or: [ a name < b name ] ] ]
]

{ #category : 'widget API' }
OPMcNavigatorAdapter >> typesByDependency [
	^ {OPMc.
	OPMcVertex.
	OPMcTransition.
	OPMcIncomingTransition}
]
