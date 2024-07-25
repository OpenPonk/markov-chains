Class {
	#name : 'OPMcModelDeprecatedSerializer',
	#superclass : 'OPMcModelSerializer',
	#category : 'OpenPonk-MarkovChains-Serialization',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Serialization'
}

{ #category : 'accessing' }
OPMcModelDeprecatedSerializer class >> fileExtension [

	^ #ston
]

{ #category : 'as yet unclassified' }
OPMcModelDeprecatedSerializer class >> formatName [

	^ #'graphml-ston'
]
