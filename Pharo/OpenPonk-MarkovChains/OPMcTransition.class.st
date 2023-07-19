Class {
	#name : #OPMcTransition,
	#superclass : #OPModelObject,
	#instVars : [
		'source',
		'target',
		'matchBlock'
	],
	#category : #'OpenPonk-MarkovChains-Models'
}

{ #category : #'instance creation' }
OPMcTransition class >> from: aSource to: aTarget [
	^ self new
		source: aSource;
		target: aTarget;
		yourself
]

{ #category : #'instance creation' }
OPMcTransition class >> from: aSource to: aTarget named: aString [
	^ self new
		source: aSource;
		target: aTarget;
		name: aString;
		yourself
]

{ #category : #comparing }
OPMcTransition >> = otherTransition [
	^ (otherTransition respondsTo: #isTransition)
		and: [ otherTransition isTransition
				and: [ otherTransition represents: self ] ]
]

{ #category : #comparing }
OPMcTransition >> asTransition [
	^ self
]

{ #category : #comparing }
OPMcTransition >> detach [
	super detach.
	source := nil.
	target := nil
]

{ #category : #comparing }
OPMcTransition >> initialize [
	super initialize.
	matchBlock := [ :aValue | (self name splitOn: ',') includes: aValue asString ]
]

{ #category : #comparing }
OPMcTransition >> isState [
	^ false
]

{ #category : #comparing }
OPMcTransition >> isTransition [
	^ true
]

{ #category : #comparing }
OPMcTransition >> matchBlock [
	^ matchBlock
]

{ #category : #comparing }
OPMcTransition >> matchBlock: aOneArgBlock [
	matchBlock := aOneArgBlock.
	self changed
]

{ #category : #comparing }
OPMcTransition >> matches: aValue [
	^ matchBlock value: aValue
]

{ #category : #comparing }
OPMcTransition >> represents: otherTransition [
	^ super = otherTransition
]

{ #category : #comparing }
OPMcTransition >> source [
	^ source
]

{ #category : #comparing }
OPMcTransition >> source: aVertex [
	source := aVertex
]

{ #category : #comparing }
OPMcTransition >> target [
	^ target
]

{ #category : #comparing }
OPMcTransition >> target: aVertex [
	target := aVertex
]
