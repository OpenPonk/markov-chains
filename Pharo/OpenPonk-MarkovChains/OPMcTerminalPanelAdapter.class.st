Class {
	#name : 'OPMcTerminalPanelAdapter',
	#superclass : 'SpAbstractMorphicAdapter',
	#instVars : [
		'morph'
	],
	#category : 'OpenPonk-MarkovChains-Simulations',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Simulations'
}

{ #category : 'accessing' }
OPMcTerminalPanelAdapter class >> adaptingName [

	^ self name copyReplaceAll: 'Morphic' with: ''
]

{ #category : 'factory' }
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
			morph changeBoxAt: event inputPosition to: event inputState ] for: self;
		whenDataChangedDo: [ :event | morph data: event data ] for: self.
	^ morph
]
