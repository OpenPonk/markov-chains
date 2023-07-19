Class {
	#name : #OPMcIncomingTransition,
	#superclass : #Object,
	#instVars : [
		'transition'
	],
	#category : #'OpenPonk-MarkovChains-Adapters'
}

{ #category : #'instance creation' }
OPMcIncomingTransition class >> of: aTransition [
	^ self ofTransition: aTransition
]

{ #category : #'instance creation' }
OPMcIncomingTransition class >> ofTransition: aTransition [
	^ self new
		transition: aTransition;
		yourself
]

{ #category : #comparing }
OPMcIncomingTransition >> = otherTransition [
	^ self represents: otherTransition
]

{ #category : #converting }
OPMcIncomingTransition >> asTransition [
	^ transition
]

{ #category : #updating }
OPMcIncomingTransition >> changed [
	^ transition changed
]

{ #category : #converting }
OPMcIncomingTransition >> doesNotUnderstand: aMessage [
	^ aMessage sendTo: transition
]

{ #category : #converting }
OPMcIncomingTransition >> hash [
	^ transition hash
]

{ #category : #converting }
OPMcIncomingTransition >> isTransition [

	^ true
]

{ #category : #converting }
OPMcIncomingTransition >> printOn: aStream [
	^ transition printOn: aStream
]

{ #category : #converting }
OPMcIncomingTransition >> represents: otherTransition [

	^ super = otherTransition or: [ 
		  transition == otherTransition or: [ transition = otherTransition ] ]
]

{ #category : #converting }
OPMcIncomingTransition >> transition: aTransition [
	transition := aTransition
]

{ #category : #converting }
OPMcIncomingTransition >> when: anAnnouncementClass send: aSelector to: anObject [
	^ transition when: anAnnouncementClass send: aSelector to: anObject
]
