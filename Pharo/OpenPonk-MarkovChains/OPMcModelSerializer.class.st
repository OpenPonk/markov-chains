"
Handles serialization and materialization of Markov Chain models, converting between in-memory objects and persisted string formats.
"
Class {
	#name : 'OPMcModelSerializer',
	#superclass : 'OPModelSerializer',
	#category : 'OpenPonk-MarkovChains-Serialization',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Serialization'
}

{ #category : 'accessing' }
OPMcModelSerializer class >> exportVersion [

	^ 1
]

{ #category : 'accessing' }
OPMcModelSerializer class >> fileExtensions [

	^ #( #xml )
]

{ #category : 'formatting' }
OPMcModelSerializer class >> formatName [

	^ #graphml
]

{ #category : 'accessing' }
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
