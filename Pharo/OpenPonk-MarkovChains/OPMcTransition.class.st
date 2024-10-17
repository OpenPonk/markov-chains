Class {
	#name : 'OPMcTransition',
	#superclass : 'OPModelObject',
	#instVars : [
		'source',
		'target',
		'matchBlock'
	],
	#category : 'OpenPonk-MarkovChains-Models',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Models'
}

{ #category : 'instance creation' }
OPMcTransition class >> from: aSource to: aTarget [
	^ self new
		source: aSource;
		target: aTarget;
		yourself
]

{ #category : 'instance creation' }
OPMcTransition class >> from: aSource to: aTarget named: aString [
	^ self new
		source: aSource;
		target: aTarget;
		name: aString;
		yourself
]

{ #category : 'comparing' }
OPMcTransition >> = otherTransition [
	^ (otherTransition respondsTo: #isTransition)
		and: [ otherTransition isTransition
				and: [ otherTransition represents: self ] ]
]

{ #category : 'converting' }
OPMcTransition >> asTransition [
	^ self
]

{ #category : 'removing' }
OPMcTransition >> detach [
	super detach.
	source := nil.
	target := nil
]

{ #category : 'initialization' }
OPMcTransition >> initialize [
	super initialize.
	matchBlock := [ :aValue | (self name splitOn: ',') includes: aValue asString ]
]

{ #category : 'testing' }
OPMcTransition >> isState [
	^ false
]

{ #category : 'testing' }
OPMcTransition >> isTransition [
	^ true
]

{ #category : 'accessing' }
OPMcTransition >> matchBlock [
	^ matchBlock
]

{ #category : 'accessing' }
OPMcTransition >> matchBlock: aOneArgBlock [
	matchBlock := aOneArgBlock.
	self changed
]

{ #category : 'testing' }
OPMcTransition >> matches: aValue [
	^ matchBlock value: aValue
]

{ #category : 'testing' }
OPMcTransition >> represents: otherTransition [
	^ super = otherTransition
]

{ #category : 'accessing' }
OPMcTransition >> source [
	^ source
]

{ #category : 'accessing' }
OPMcTransition >> source: aVertex [
	source := aVertex
]

{ #category : 'accessing' }
OPMcTransition >> target [
	^ target
]

{ #category : 'accessing' }
OPMcTransition >> target: aVertex [
	target := aVertex
]
