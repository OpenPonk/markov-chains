"
Deprecated serializer for older versions of Markov Chain models.
Maintained for backward compatibility.
"
Class {
	#name : 'OPMcModelDeprecatedSerializer',
	#superclass : 'OPMcModelSerializer',
	#category : 'OpenPonk-MarkovChains-Serialization',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Serialization'
}

{ #category : 'accessing' }
OPMcModelDeprecatedSerializer class >> fileExtensions [

	^ #( #ston )
]

{ #category : 'formatting' }
OPMcModelDeprecatedSerializer class >> formatName [

	^ #'graphml-ston'
]
