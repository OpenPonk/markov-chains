"
A model command that calculates and displays asymptotic state probability predictions for the active Markov Chain.
"
Class {
	#name : 'OPMcOpenPredictedSimulationCommand',
	#superclass : 'OPMcCommand',
	#category : 'OpenPonk-MarkovChains-Commands',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Commands'
}

{ #category : 'activation' }
OPMcOpenPredictedSimulationCommand class >> modelMenuActivation [
	<classAnnotation>
	^ OPModelMenuActivation
		byItemOf: OPModelBasicMenuGroup
		order: 40
		for: OPEditor
]

{ #category : 'accessing' }
OPMcOpenPredictedSimulationCommand >> defaultMenuIcon [
	"Answers the icon form for the predicted simulation command."
	^ OPMcIcons opMcDiagramIcon
]

{ #category : 'accessing' }
OPMcOpenPredictedSimulationCommand >> defaultMenuItemName [
	"Answers the display name of the predicted simulation command."
	^ 'Open Predicted Simulation'
]

{ #category : 'execution' }
OPMcOpenPredictedSimulationCommand >> execute [
	"Opens the Markov Chains predicted simulation on the active diagram controller."
	OPMcPredictedSimulation new openOn: self diagramController
]
