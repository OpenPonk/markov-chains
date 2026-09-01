"
Container for simulation input represented by visual letter boxes (Morphs) for Markov Chain sequences.
"
Class {
	#name : 'OPMcTerminalPanelMorph',
	#superclass : 'Morph',
	#category : 'OpenPonk-MarkovChains-Simulations',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Simulations'
}

{ #category : 'accessing' }
OPMcTerminalPanelMorph >> changeBoxAt: anIndex to: aSymbol [

	self submorphs withIndexDo: [ :morph :index | 
		index < anIndex ifTrue: [ morph success ].
		index = anIndex ifTrue: [ morph perform: aSymbol ].
		index > anIndex ifTrue: [ morph normal ] ]
]

{ #category : 'accessing' }
OPMcTerminalPanelMorph >> data: aCollection [
	self submorphsDo: #delete.
	aCollection
		do: [ :terminal | self addMorphBack: (OPMcTerminalBoxMorph new terminal: terminal) ]
]

{ #category : 'accessing - defaults' }
OPMcTerminalPanelMorph >> defaultColor [
	^ Color transparent
]

{ #category : 'initialization' }
OPMcTerminalPanelMorph >> initialize [
	super initialize.
	self
		layoutPolicy: RowLayout new;
		hResizing: #spaceFill;
		vResizing: #shrinkWrap;
		cellInset: 5
]
