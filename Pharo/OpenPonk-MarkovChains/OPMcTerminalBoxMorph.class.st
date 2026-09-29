"
Visual box (Morph) representing a single terminal symbol or step in the Markov Chain simulation input sequence.
"
Class {
	#name : 'OPMcTerminalBoxMorph',
	#superclass : 'BorderedMorph',
	#instVars : [
		'colors'
	],
	#category : 'OpenPonk-MarkovChains-Simulations',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Simulations'
}

{ #category : 'accessing - defaults' }
OPMcTerminalBoxMorph >> defaultBorderColor [
	^ Color black
]

{ #category : 'accessing - defaults' }
OPMcTerminalBoxMorph >> defaultBorderWidth [
	^ 1
]

{ #category : 'accessing - defaults' }
OPMcTerminalBoxMorph >> defaultBounds [
	^ 0 @ 0 corner: 25 @ 25
]

{ #category : 'accessing - defaults' }
OPMcTerminalBoxMorph >> defaultColor [

	^ self theme windowColor
]

{ #category : 'updating' }
OPMcTerminalBoxMorph >> failure [
	self borderColor: Color red.
	self color: (colors at: #failure)
]

{ #category : 'initialization' }
OPMcTerminalBoxMorph >> initialize [
	super initialize.
	self initializeColorScheme.
	self
		layoutPolicy: StackLayout new;
		cellPositioning: #center;
		cellInset: 5.
]

{ #category : 'initialization' }
OPMcTerminalBoxMorph >> initializeColorScheme [

	colors := {
		          (#normal -> self theme windowColor).
		          (#processed -> Color paleOrange).
		          (#failure -> Color paleRed).
		          (#success -> Color paleGreen) } asDictionary.
	self theme class = PharoDarkTheme ifTrue: [
			colors := {
				          (#normal -> self theme windowColor).
				          (#processed -> Color paleOrange muchDarker).
				          (#failure -> Color paleRed muchDarker).
				          (#success -> Color paleGreen muchDarker) } asDictionary ]
]

{ #category : 'accessing' }
OPMcTerminalBoxMorph >> morphForTerminal: aSymbol [
	^ aSymbol asMorph
]

{ #category : 'updating' }
OPMcTerminalBoxMorph >> normal [
	self borderColor: Color black.
	self color: (colors at: #normal)
]

{ #category : 'updating' }
OPMcTerminalBoxMorph >> processed [
	self borderColor: Color orange.
	self color: (colors at: #processed)
]

{ #category : 'updating' }
OPMcTerminalBoxMorph >> success [
	self borderColor: Color green muchDarker.
	self color: (colors at: #success)
]

{ #category : 'accessing' }
OPMcTerminalBoxMorph >> terminal: aSymbol [
	self submorphsDo: #delete.
	self addMorph: (self morphForTerminal: aSymbol).
	self bounds: (self submorphs last bounds expandBy: 4)
]
