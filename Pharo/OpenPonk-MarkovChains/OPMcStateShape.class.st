"
Diagram element representing a Markov Chain state.
Manages the rendering details of its underlying Roassal shape, including the state label and bounding geometry.
"
Class {
	#name : 'OPMcStateShape',
	#superclass : 'OPMcAbstractStateShape',
	#instVars : [
		'label'
	],
	#category : 'OpenPonk-MarkovChains-DiagramElements',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'DiagramElements'
}

{ #category : 'accessing' }
OPMcStateShape >> attachedShapes [

	^ super attachedShapes , { label }
]

{ #category : 'removing' }
OPMcStateShape >> removeRender [

	super removeRender.
	label := nil
]

{ #category : 'rendering' }
OPMcStateShape >> renderBasicShape [

	^ RSCircle new
		  size: 50;
		  color: Color white;
		  border: (RSBorder new
				   color: Color black;
				   width: 1.5;
				   yourself);
		  yourself
]

{ #category : 'rendering' }
OPMcStateShape >> renderShapeDetails [

	super renderShapeDetails.

	label := RSLabel new
		         color: Color black;
		         height: 11;
		         model: self;
		         yourself.
	RSLocation new stick: label on: self roassalShape.
	self canvas add: label
]

{ #category : 'interactions' }
OPMcStateShape >> selectableInteraction [

	^ super selectableInteraction
		  highlightBorderColor: Color blue;
		  yourself
]

{ #category : 'rendering' }
OPMcStateShape >> updateRenderFromModel [

	label text: self modelElement name.
	super updateRenderFromModel.
	roassalShape signalUpdate
]
