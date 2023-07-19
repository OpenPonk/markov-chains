Class {
	#name : #OPMcTerminalPanelAdapter,
	#superclass : #SpAbstractMorphicAdapter,
	#instVars : [
		'morph'
	],
	#category : #'OpenPonk-MarkovChains-Simulations'
}

{ #category : #accessing }
OPMcTerminalPanelAdapter class >> adaptingName [

	^ self name copyReplaceAll: 'Morphic' with: ''
]

{ #category : #factory }
OPMcTerminalPanelAdapter >> buildWidget [

	morph := OPMcTerminalPanelMorph new
		         data: self presenter data;
		         listDirection: #leftToRight;
		         layoutPolicy: RowLayout new;
		         hResizing: #spaceFill;
		         vResizing: #shrinkWrap;
		         cellInset: 5;
		         yourself.
	self model
		whenRecognizerStateChangedDo: [ :event | 
			morph changeBoxAt: event inputPosition to: event inputState ];
		whenDataChangedDo: [ :event | morph data: event data ].
	^ morph
]
