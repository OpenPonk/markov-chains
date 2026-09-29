"
Spec presenter for the Markov Chain simulation terminal panel.
Manages the data and UI logic for displaying the input sequence and prediction steps during simulation.
"
Class {
	#name : 'OPMcTerminalPanelPresenter',
	#superclass : 'SpAbstractWidgetPresenter',
	#instVars : [
		'data'
	],
	#category : 'OpenPonk-MarkovChains-Simulations',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Simulations'
}

{ #category : 'specs' }
OPMcTerminalPanelPresenter class >> adapterName [

	^ #OPMcTerminalPanelAdapter
]

{ #category : 'accessing' }
OPMcTerminalPanelPresenter >> changeBoxAt: aPosition to: aState [

	self announce:
		(OPMcTerminalRecognizerStateChanged at: aPosition to: aState)
]

{ #category : 'accessing' }
OPMcTerminalPanelPresenter >> data [

	^ data
]

{ #category : 'accessing' }
OPMcTerminalPanelPresenter >> data: aString [

	data := aString.
	self announce: (OPMcTerminalDataChanged data: data)
]

{ #category : 'accessing' }
OPMcTerminalPanelPresenter >> whenDataChangedDo: aBlock [

	self announcer
		when: OPMcTerminalDataChanged
		do: aBlock
		for: aBlock receiver
]

{ #category : 'accessing' }
OPMcTerminalPanelPresenter >> whenRecognizerStateChangedDo: aBlock [

	self announcer
		when: OPMcTerminalRecognizerStateChanged
		do: aBlock
		for: aBlock receiver
]
