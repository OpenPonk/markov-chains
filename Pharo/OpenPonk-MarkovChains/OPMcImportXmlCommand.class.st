"
A model command that parses and imports a Markov Chain model structure from an XML document.
"
Class {
	#name : 'OPMcImportXmlCommand',
	#superclass : 'OPMcCommand',
	#category : 'OpenPonk-MarkovChains-Commands',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Commands'
}

{ #category : 'activation' }
OPMcImportXmlCommand class >> modelMenuActivation [
	<classAnnotation>
	^ OPModelMenuActivation
		byItemOf: OPModelBasicMenuGroup
		order: 20
		for: OPEditor
]

{ #category : 'accessing' }
OPMcImportXmlCommand >> defaultMenuIcon [
	"Answers the icon form for the MC import command."
	^ OPCoreIcons opDiagramIcon
]

{ #category : 'accessing' }
OPMcImportXmlCommand >> defaultMenuItemName [
	"Answers the display name of the MC import command."
	^ 'Import as xmi'
]

{ #category : 'execution' }
OPMcImportXmlCommand >> execute [
	"Imports XMI model data into the active Markov Chains domain model and updates diagram."
	OPMcGraphML importToModel: self model inEditor: self editor
]
