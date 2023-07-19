Class {
	#name : #OPMcVertexController,
	#superclass : #OPElementController,
	#category : #'OpenPonk-MarkovChains-Controllers'
}

{ #category : #connecting }
OPMcVertexController >> canBeSourceFor: aController [
	^ (aController respondsTo: #modelClass) and: [ aController modelClass = OPMcTransition ]
]

{ #category : #connecting }
OPMcVertexController >> canBeTargetFor: aController [
	^ self canBeSourceFor: aController
]

{ #category : #connecting }
OPMcVertexController >> createTransitionAdornmentBy: builder [

	builder
		addIconShape: (RSSVGPath new
				 color: Color black;
				 svgPath: 'M-6.3,7 L4,-3.3 L4,2 L7,-7 L-2,-4 L3.3,-4 L-7,6.3 z';
				 size: 14;
				 yourself)
		action: [ 
			| tool |
			(tool := OPConnectionCreationTool new)
				palette: self diagramController editor palette;
				factory: [ OPMcTransitionController new ].
			self diagramController editor palette selectTool: tool.
			tool selectedControllers: { self } ]
]

{ #category : #connecting }
OPMcVertexController >> createVertexAdornmentBy: builder [

	builder
		addIconShape: (RSCircle new
				 color: Color transparent;
				 borderColor: Color black;
				 size: 14;
				 yourself)
		action: [ 
			| tool |
			(tool := OPCreationTool new)
				palette: self diagramController editor palette;
				factory: [ OPMcStateController new ];
				whenCreated: [ :ctrl | 
					| t2 |
					t2 := OPConnectionCreationTool new
						      palette: self diagramController editor palette;
						      factory: [ OPMcTransitionController new ].
					self diagramController editor palette selectTool: t2.
					t2
						selectedControllers: { self };
						selectedControllers: { ctrl }.
					self diagramController editor palette selectedTool 
						selectedControllers: { ctrl } ].
			self diagramController editor palette selectTool: tool ]
]

{ #category : #connecting }
OPMcVertexController >> dependentElements [
	^ (model incoming , model outgoing) asSet
]

{ #category : #connecting }
OPMcVertexController >> hookDiagramElement [

	super hookDiagramElement.
	
	self diagramElement adornmentCreationBlock: [ :builder | 
		self
			createVertexAdornmentBy: builder;
			createTransitionAdornmentBy: builder ]
]

{ #category : #connecting }
OPMcVertexController >> internalSubscribeTo: aModel [
	super internalSubscribeTo: aModel.
	aModel when: OPElementRemoved do: [ :e | self removeController ]
]

{ #category : #connecting }
OPMcVertexController >> isHideable [
	^ true
]

{ #category : #connecting }
OPMcVertexController >> modelAsParent [
	^ self model owner
]

{ #category : #connecting }
OPMcVertexController >> removeModel [
	self model announcer unsubscribe: self.
	self diagramController model remove: self model
]
