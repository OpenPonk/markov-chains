"
Applies automated layout algorithms to Markov Chain diagrams, positioning states and routing transitions for optimal visual structure.
"
Class {
	#name : 'OPMcLayouter',
	#superclass : 'OPNodesAndEdgesLayouter',
	#category : 'OpenPonk-MarkovChains-Plugin',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Plugin'
}

{ #category : 'accessing' }
OPMcLayouter >> allEdges [
	^ diagramController controllers
		select: [ :ctrl | ctrl isKindOf: OPMcTransitionController ]
		thenCollect: #roassalShape 
]

{ #category : 'accessing' }
OPMcLayouter >> allNodes [
	^ diagramController controllers
		select: [ :ctrl | ctrl isKindOf: OPMcVertexController ]
		thenCollect: #roassalShape
]

{ #category : 'layouts' }
OPMcLayouter >> defaultLayout [
	self gridLayout
]
