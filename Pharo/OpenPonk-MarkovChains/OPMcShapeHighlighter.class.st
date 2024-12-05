Class {
	#name : 'OPMcShapeHighlighter',
	#superclass : 'Object',
	#category : 'OpenPonk-MarkovChains-DiagramElements',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'DiagramElements'
}

{ #category : 'api - highlight' }
OPMcShapeHighlighter class >> highlight: aShapedObject with: aColor [
	aShapedObject isNode
		ifTrue: [ self highlightNode: aShapedObject with: aColor ].
	aShapedObject isLine
		ifTrue: [ self highlightLine: aShapedObject with: aColor ]
]

{ #category : 'api - highlight' }
OPMcShapeHighlighter class >> highlightLine: aLine with: aColor [

	self unhighlightNode: aLine.
	aLine propertyAt: self name put: aLine color.
	aLine color: aColor.
	aLine signalUpdate
]

{ #category : 'api - highlight' }
OPMcShapeHighlighter class >> highlightNode: aNode with: aColor [

	self unhighlightNode: aNode.
	aNode propertyAt: self name put: aNode borderColor.
	aNode borderColor: aColor.
	aNode signalUpdate
]

{ #category : 'api - highlight' }
OPMcShapeHighlighter class >> unhighlight: aShapedObject [
	aShapedObject isNode
		ifTrue: [ self unhighlightNode: aShapedObject ].
	aShapedObject isLine
		ifTrue: [ self unhighlightLine: aShapedObject ]
]

{ #category : 'api - highlight' }
OPMcShapeHighlighter class >> unhighlightLine: aLine [

	aLine shape color: (aLine propertyAt: self name ifAbsent: [ ^ self ]).
	aLine removePropertyAt: self name.
	aLine signalUpdate
]

{ #category : 'api - highlight' }
OPMcShapeHighlighter class >> unhighlightNode: aNode [

	aNode shape borderColor:
		(aNode propertyAt: self name ifAbsent: [ ^ self ]).
	aNode removePropertyAt: self name.
	aNode signalUpdate
]
