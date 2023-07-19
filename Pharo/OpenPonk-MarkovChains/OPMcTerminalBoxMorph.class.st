Class {
	#name : #OPMcTerminalBoxMorph,
	#superclass : #BorderedMorph,
	#instVars : [
		'colors'
	],
	#category : #'OpenPonk-MarkovChains-Simulations'
}

{ #category : #'accessing - defaults' }
OPMcTerminalBoxMorph >> defaultBorderColor [
	^ Color black
]

{ #category : #'accessing - defaults' }
OPMcTerminalBoxMorph >> defaultBorderWidth [
	^ 1
]

{ #category : #'accessing - defaults' }
OPMcTerminalBoxMorph >> defaultBounds [
	^ 0 @ 0 corner: 25 @ 25
]

{ #category : #'accessing - defaults' }
OPMcTerminalBoxMorph >> defaultColor [
	^ Smalltalk ui theme windowColor
]

{ #category : #'accessing - defaults' }
OPMcTerminalBoxMorph >> failure [
	self borderColor: Color red.
	self color: (colors at: #failure)
]

{ #category : #'accessing - defaults' }
OPMcTerminalBoxMorph >> initialize [
	super initialize.
	self initializeColorScheme.
	self
		layoutPolicy: StackLayout new;
		cellPositioning: #center;
		cellInset: 5.
]

{ #category : #'accessing - defaults' }
OPMcTerminalBoxMorph >> initializeColorScheme [

	colors := { 
		          (#normal -> Smalltalk ui theme windowColor).
		          (#processed -> Color paleOrange).
		          (#failure -> Color paleRed).
		          (#success -> Color paleGreen) } asDictionary.
	Smalltalk ui theme class = PharoDarkTheme ifTrue: [ 
		colors := { 
			          (#normal -> Smalltalk ui theme windowColor).
			          (#processed -> Color paleOrange muchDarker).
			          (#failure -> Color paleRed muchDarker).
			          (#success -> Color paleGreen muchDarker) } asDictionary ]
]

{ #category : #'accessing - defaults' }
OPMcTerminalBoxMorph >> morphForTerminal: aSymbol [
	^ aSymbol asMorph
]

{ #category : #'accessing - defaults' }
OPMcTerminalBoxMorph >> normal [
	self borderColor: Color black.
	self color: (colors at: #normal)
]

{ #category : #'accessing - defaults' }
OPMcTerminalBoxMorph >> processed [
	self borderColor: Color orange.
	self color: (colors at: #processed)
]

{ #category : #'accessing - defaults' }
OPMcTerminalBoxMorph >> success [
	self borderColor: Color green muchDarker.
	self color: (colors at: #success)
]

{ #category : #'accessing - defaults' }
OPMcTerminalBoxMorph >> terminal: aSymbol [
	self submorphsDo: #delete.
	self addMorph: (self morphForTerminal: aSymbol).
	self bounds: (self submorphs last bounds expandBy: 4)
]
