"
Verifies GraphML model roundtrip persistence through streams and strings as well as serializer format metadata and deprecated format compatibility for Markov chain models.
"
Class {
	#name : 'OPMcModelSerializerTest',
	#superclass : 'OPModelSerializerTest',
	#category : 'OpenPonk-MarkovChains-Tests-Serialization',
	#package : 'OpenPonk-MarkovChains-Tests',
	#tag : 'Serialization'
}

{ #category : 'accessing' }
OPMcModelSerializerTest >> newModel [

	^ OPMcExamples exampleMarkovWeather
]

{ #category : 'accessing' }
OPMcModelSerializerTest >> serializerClass [

	^ OPMcModelSerializer
]

{ #category : 'running' }
OPMcModelSerializerTest >> tearDown [

	model := nil.
	serializer := nil.
	stream := nil.
	super tearDown
]

{ #category : 'tests' }
OPMcModelSerializerTest >> testMetadataAndFormatIdentifiers [

	| matchingInfo mismatchedFormatInfo mismatchedVersionInfo |
	self assert: OPMcModelSerializer formatName equals: #graphml.
	self assert: OPMcModelSerializer exportVersion equals: 1.
	self assert: OPMcModelSerializer minImportVersion equals: 1.
	self assert: OPMcModelSerializer exportSubject equals: #model.
	self assertCollection: OPMcModelSerializer fileExtensions hasSameElements: #( #xml ).

	matchingInfo := OPMcModelSerializer exportInfo.
	self
		assert: (OPMcModelSerializer supportsExportInfo: matchingInfo)
		description: 'Serializer must support its own export metadata'.

	mismatchedFormatInfo := OPExportInfo new
		                        subject: #model;
		                        format: #ston;
		                        version: 1;
		                        yourself.
	self
		deny: (OPMcModelSerializer supportsExportInfo: mismatchedFormatInfo)
		description: 'Serializer must reject a different format name'.

	mismatchedVersionInfo := OPExportInfo new
		                         subject: #model;
		                         format: #graphml;
		                         version: 2;
		                         yourself.
	self
		deny: (OPMcModelSerializer supportsExportInfo: mismatchedVersionInfo)
		description: 'Serializer must reject an unsupported version'.

	self assert: serializer formatName equals: #graphml.
	self assert: serializer fileExtension equals: #xml.
	self assert: OPMcModelDeprecatedSerializer formatName equals: #'graphml-ston'.
	self assertCollection: OPMcModelDeprecatedSerializer fileExtensions hasSameElements: #( #ston )
]

{ #category : 'tests' }
OPMcModelSerializerTest >> testRoundtrip [

	| materializedModel |
	serializer serializeModel: model to: stream.
	self assert: (stream contents includesSubstring: '<graphml') description: 'Serialized stream must contain GraphML XML'.

	materializedModel := serializer materializeModelFrom: stream.
	self deny: materializedModel identicalTo: model.
	self assert: materializedModel class identicalTo: OPMc.
	self assert: materializedModel uuid equals: model uuid.
	self assert: materializedModel name equals: model name.
	self
		assertCollection: (materializedModel states collect: [ :eachState | eachState uuid -> eachState name ])
		hasSameElements: (model states collect: [ :eachState | eachState uuid -> eachState name ]).
	self
		assertCollection: (materializedModel transitions collect: [ :eachTransition |
					 eachTransition uuid -> {
						 eachTransition name.
						 eachTransition source uuid.
						 eachTransition target uuid } ])
		hasSameElements: (model transitions collect: [ :eachTransition |
					 eachTransition uuid -> {
						 eachTransition name.
						 eachTransition source uuid.
						 eachTransition target uuid } ])
]

{ #category : 'tests' }
OPMcModelSerializerTest >> testSerializeAndMaterializeModelStringAndEmptyModel [

	| emptyModel emptyXml restoredEmpty weatherXml restoredWeather |
	emptyModel := OPMcExamples emptyModel.
	emptyXml := serializer serializeModel: emptyModel.
	restoredEmpty := serializer materializeModelFromString: emptyXml.
	self deny: restoredEmpty identicalTo: emptyModel.
	self assert: restoredEmpty class identicalTo: OPMc.
	self assert: restoredEmpty uuid equals: emptyModel uuid.
	self assert: restoredEmpty name equals: 'New Markov Chain Diagram'.
	self assertEmpty: restoredEmpty states.
	self assertEmpty: restoredEmpty transitions.

	weatherXml := serializer serializeModel: model.
	restoredWeather := serializer materializeModelFromString: weatherXml.
	self deny: restoredWeather identicalTo: model.
	self assert: restoredWeather uuid equals: model uuid.
	self assert: restoredWeather states size equals: 3.
	self assert: restoredWeather transitions size equals: 9
]
