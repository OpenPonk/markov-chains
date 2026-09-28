"
A model command that exports the Markov Chain state and transition matrix into XML format.
"
Class {
	#name : 'OPMcExportXmlCommand',
	#superclass : 'OPMcCommand',
	#category : 'OpenPonk-MarkovChains-Commands',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Commands'
}

{ #category : 'activation' }
OPMcExportXmlCommand class >> modelMenuActivation [
	<classAnnotation>
	^ OPModelMenuActivation
		byItemOf: OPModelBasicMenuGroup
		order: 10
		for: OPEditor
]

{ #category : 'accessing' }
OPMcExportXmlCommand >> defaultMenuIcon [
	"Answers the icon form for the MC export command."
	^ OPCoreIcons opDiagramIcon
]

{ #category : 'accessing' }
OPMcExportXmlCommand >> defaultMenuItemName [
	"Answers the display name of the MC export command."
	^ 'Export as xmi'
]

{ #category : 'execution' }
OPMcExportXmlCommand >> execute [
	"Exports the Markov Chains domain model to an XMI file."
	OPMcGraphML exportPackage: self model
]
