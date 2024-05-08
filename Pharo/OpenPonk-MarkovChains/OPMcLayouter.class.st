Class {
	#name : 'OPMcLayouter',
	#superclass : 'OPLayouter',
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

{ #category : 'accessing' }
OPMcLayouter >> defaultLayout [
	self gridLayout
]
