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

{ #category : 'accessing' }
OPMcModelSerializer class >> fileExtension [

	^ #xml
]

{ #category : 'as yet unclassified' }
OPMcModelSerializer class >> formatName [

	^ #graphml
]

{ #category : 'as yet unclassified' }
OPMcModelSerializer class >> minImportVersion [

	^ 1
]

{ #category : 'serialize/materialize' }
OPMcModelSerializer >> materializeModelFrom: aStream [
	^ self materializeModelFromString: aStream contents
]

{ #category : 'serialize/materialize' }
OPMcModelSerializer >> materializeModelFromString: aString [

	^ OPMcGraphML new import: aString into: OPMc new
]

{ #category : 'serialize/materialize' }
OPMcModelSerializer >> serializeModel: aModel [
	^ OPMcGraphML new export: aModel
]

{ #category : 'serialize/materialize' }
OPMcModelSerializer >> serializeModel: aModel to: aStream [
	^ aStream << (self serializeModel: aModel)
]
