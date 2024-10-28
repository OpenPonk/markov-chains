Class {
	#name : 'OPMcStateFigure',
	#superclass : 'OPMcAbstractStateFigure',
	#instVars : [
		'label'
	],
	#category : 'OpenPonk-MarkovChains-Shapes',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Shapes'
}

{ #category : 'removing' }
OPMcStateFigure >> removeRender [

	super removeRender.
	label := nil
]

{ #category : 'rendering' }
OPMcStateFigure >> renderBasicShape [

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
OPMcStateFigure >> renderShapeDetails [

	super renderShapeDetails.

	label := RSLabel new
		         color: Color black;
		         height: 11;
		         model: self;
		         yourself.
	RSLocation new stick: label on: self roassalShape.
	self canvas add: label.
	self roassalShape
		when: RSShapeRemovedEvent
		do: [ label remove ]
		for: self
]

{ #category : 'rendering' }
OPMcStateFigure >> selectableInteraction [

	^ super selectableInteraction
		  highlightBorderColor: Color blue;
		  yourself
]

{ #category : 'rendering' }
OPMcStateFigure >> updateRenderFromModel [

	label text: self modelElement name.
	super updateRenderFromModel.
	roassalShape signalUpdate
]
