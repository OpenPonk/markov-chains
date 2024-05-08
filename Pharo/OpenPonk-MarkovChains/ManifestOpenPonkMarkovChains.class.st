"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestOpenPonkMarkovChains',
	#superclass : 'PackageManifest',
	#category : 'OpenPonk-MarkovChains-Manifest',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestOpenPonkMarkovChains class >> ruleAnySatisfyRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#OPMcPredictedSimulation #preconditions #false)) #'2023-07-13T11:24:22.815+02:00') )
]
