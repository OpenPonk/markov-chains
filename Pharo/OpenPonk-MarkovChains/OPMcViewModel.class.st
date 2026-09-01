"
View model for the top-level Markov Chain model.
Provides essential child models and icon definitions for the workbench tree and UI integration.
"
Class {
	#name : 'OPMcViewModel',
	#superclass : 'OPModelObjectViewModel',
	#category : 'OpenPonk-MarkovChains-ViewModels',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPMcViewModel class >> commonModelClassPrefix [

	^ 'OPMc'
]

{ #category : 'accessing' }
OPMcViewModel class >> modelClass [ ^ OPMc
]

{ #category : 'accessing' }
OPMcViewModel >> childrenModels [ ^ self model states
]

{ #category : 'accessing' }
OPMcViewModel >> essentialChildrenModels [
			^ self model elements asArray
]

{ #category : 'accessing' }
OPMcViewModel >> icon [ ^ OPCoreIcons opMcDiagramIcon
]

{ #category : 'accessing' }
OPMcViewModel >> modelRootViewModel [

	^ self
]
