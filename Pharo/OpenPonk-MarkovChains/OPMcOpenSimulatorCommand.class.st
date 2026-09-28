"
A model command that launches the probabilistic transition simulator for the active Markov Chain diagram.
"
Class {
	#name : 'OPMcOpenSimulatorCommand',
	#superclass : 'OPMcCommand',
	#category : 'OpenPonk-MarkovChains-Commands',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Commands'
}

{ #category : 'activation' }
OPMcOpenSimulatorCommand class >> modelMenuActivation [
	<classAnnotation>
	^ OPModelMenuActivation
		byItemOf: OPModelBasicMenuGroup
		order: 30
		for: OPEditor
]

{ #category : 'accessing' }
OPMcOpenSimulatorCommand >> defaultMenuIcon [
	"Answers the icon form for the MC simulator command."
	^ OPMcIcons opMcDiagramIcon
]

{ #category : 'accessing' }
OPMcOpenSimulatorCommand >> defaultMenuItemName [
	"Answers the display name of the MC simulator command."
	^ 'Open Simulator'
]

{ #category : 'execution' }
OPMcOpenSimulatorCommand >> execute [
	"Opens the Markov Chains simulator on the active diagram controller."
	OPMcSimulator new openOn: self diagramController
]
