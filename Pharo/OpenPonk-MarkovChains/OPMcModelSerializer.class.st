Class {
	#name : 'OPMcModelSerializer',
	#superclass : 'OPModelSerializer',
	#category : 'OpenPonk-MarkovChains-Serialization',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Serialization'
}

{ #category : 'as yet unclassified' }
OPMcModelSerializer class >> exportVersion [

	^ 1
]

{ #category : 'as yet unclassified' }
OPMcModelSerializer class >> formatName [

	^ #'graphml-ston'
]

{ #category : 'as yet unclassified' }
OPMcModelSerializer class >> minImportVersion [

	^ 1
]

{ #category : 'formatting' }
OPMcModelSerializer >> formatName [
	^ 'ston'
]

{ #category : 'formatting' }
OPMcModelSerializer >> materializeDiagramFrom: aString [
	^ STON fromString: aString
]

{ #category : 'formatting' }
OPMcModelSerializer >> materializeModelFrom: aStream [
	^ self materializeModelFromString: aStream contents
]

{ #category : 'formatting' }
OPMcModelSerializer >> materializeModelFromString: aString [

	^ OPMcGraphML new import: aString into: OPMc new
]

{ #category : 'formatting' }
OPMcModelSerializer >> modelExtension [
	^ 'graphml'
]

{ #category : 'formatting' }
OPMcModelSerializer >> serializeDiagram: aDiagramMemento [
	^ STON toStringPretty: aDiagramMemento
]

{ #category : 'formatting' }
OPMcModelSerializer >> serializeModel: aModel [
	^ OPMcGraphML new export: aModel
]

{ #category : 'formatting' }
OPMcModelSerializer >> serializeModel: aModel to: aStream [
	^ aStream << (self serializeModel: aModel)
]
