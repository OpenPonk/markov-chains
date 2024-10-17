Class {
	#name : 'OPMc',
	#superclass : 'OPModelObject',
	#category : 'OpenPonk-MarkovChains-Models',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Models'
}

{ #category : 'testing' }
OPMc >> isState [
	^ false
]

{ #category : 'testing' }
OPMc >> isTransition [
	^ false
]

{ #category : 'accessing' }
OPMc >> states [
	^ elements select: [ :each | each isState ]
]

{ #category : 'accessing' }
OPMc >> transitions [
	^ elements select: [ :each | each isTransition ]
]
