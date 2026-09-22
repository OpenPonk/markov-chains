"
Defines the plugin configuration for Markov Chains. Maps top-level controllers, models, view models, and serializers for the OpenPonk framework.
"
Class {
	#name : 'OPMcPlugin',
	#superclass : 'OPPlugin',
	#category : 'OpenPonk-MarkovChains-Plugin',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Plugin'
}

{ #category : 'accessing' }
OPMcPlugin >> diagramControllerClass [
	^ OPMcController
]

{ #category : 'templates' }
OPMcPlugin >> exampleProjectTemplates [
	"Answers example project templates for Markov Chains."

	^ { 
		(OPProjectTemplate
			named: 'Markov Chain'
			icon: self icon
			modelFactory: [ OPMcExamples exampleMarkovChain ]
			isExample: true).
		(OPProjectTemplate
			named: 'Markov Weather'
			icon: self icon
			modelFactory: [ OPMcExamples exampleMarkovWeather ]
			isExample: true) }
]

{ #category : 'accessing' }
OPMcPlugin >> icon [
	^ OPCoreIcons opMcDiagramIcon
]

{ #category : 'accessing' }
OPMcPlugin >> layouterClass [
	^ OPMcLayouter
]

{ #category : 'accessing' }
OPMcPlugin >> modelClass [
	^ OPMc
]

{ #category : 'accessing' }
OPMcPlugin >> modelSerializerClass [
	^ OPMcModelSerializer
]

{ #category : 'accessing' }
OPMcPlugin >> name [
	^ 'MC Diagram'
]

{ #category : 'testing' }
OPMcPlugin >> supportsHidingElements [
	^ true
]
