Class {
	#name : #OPMc,
	#superclass : #OPModelObject,
	#category : #'OpenPonk-MarkovChains-Models'
}

{ #category : #testing }
OPMc >> isState [
	^ false
]

{ #category : #testing }
OPMc >> isTransition [
	^ false
]

{ #category : #testing }
OPMc >> states [
	^ elements select: [ :each | each isState ]
]

{ #category : #testing }
OPMc >> transitions [
	^ elements select: [ :each | each isTransition ]
]
