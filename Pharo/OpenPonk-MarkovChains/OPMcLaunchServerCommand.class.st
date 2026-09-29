"
A model command that initiates the Markov Chain analysis engine or remote computation worker.
"
Class {
	#name : 'OPMcLaunchServerCommand',
	#superclass : 'OPMcCommand',
	#category : 'OpenPonk-MarkovChains-Commands',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Commands'
}

{ #category : 'activation' }
OPMcLaunchServerCommand class >> modelMenuActivation [
	<classAnnotation>
	^ OPModelMenuActivation
		byItemOf: OPModelBasicMenuGroup
		order: 50
		for: OPEditor
]

{ #category : 'accessing' }
OPMcLaunchServerCommand >> defaultMenuIcon [
	"Answers the icon form for the launch server command."
	^ OPMcIcons opMcDiagramIcon
]

{ #category : 'accessing' }
OPMcLaunchServerCommand >> defaultMenuItemName [
	"Answers the display name of the launch server command."
	^ 'Launch Server'
]

{ #category : 'execution' }
OPMcLaunchServerCommand >> execute [
	"Launches the Zinc web server for Markov Chains on the active editor."
	OPMcServer new launch: self editor
]
