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

{ #category : 'accessing' }
OPMcPlugin >> supportsHidingElements [
	^ true
]
