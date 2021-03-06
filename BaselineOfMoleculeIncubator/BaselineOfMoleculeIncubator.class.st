"
Baseline of Molecule Incubator
Some UI tools to enhanced Component development, these tools are currently in development.
---
Metacello new
   baseline: 'MoleculeIncubator';
   repository: 'github://OpenSmock/Molecule';
   load.
"
Class {
	#name : #BaselineOfMoleculeIncubator,
	#superclass : #BaselineOf,
	#instVars : [
		'previousDynamicContractUpdateActivated'
	],
	#category : #BaselineOfMoleculeIncubator
}

{ #category : #baselines }
BaselineOfMoleculeIncubator >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [			
			"Pre and post load scripts"
			spec preLoadDoIt: #'preload:package:'.
			spec postLoadDoIt: #'postload:package:'.
			
			"Load dependencies"
			"Molecule IDE incubator use SVG capacities of Roassal not included in the Pharo image"
			self loadRoassal: spec.
						
			"Packages"
			spec
				package: 'Molecule';
				package: 'Molecule-IDE' with: [ spec requires: #('Molecule') ];
				package: 'Molecule-Examples' with: [ spec requires: #('Molecule') ];
				package: 'Molecule-Tests' with: [ spec requires: #('Molecule') ];
				package: 'Molecule-IDE-Tests' with: [ spec requires: #('Molecule-IDE') ];
				package: 'Molecule-IDE-Incubators' with: [ spec requires: #('Molecule-IDE') ];
				package: 'Molecule-IDE-Incubators-Tests' with: [ spec requires: #('Molecule-IDE-Incubators') ].
		 ]
]

{ #category : #'load scripts' }
BaselineOfMoleculeIncubator >> loadRoassal: spec [

	spec
		baseline: 'Roassal3' 
		with: [ spec repository: 'github://ObjectProfile/Roassal3' ]
]

{ #category : #'load scripts' }
BaselineOfMoleculeIncubator >> postload: loader package: packageSpec [
	"Reload new Molecule tools"

	(Smalltalk globals includesKey: #MolComponentManager) ifFalse:[ ^self ].
	(Smalltalk globals classNamed: #MolComponentManager) cleanUp.
	(previousDynamicContractUpdateActivated ifNil:[false]) ifFalse:[
		MolComponentFactory default activateDynamicContractUpdate.	
	].
]

{ #category : #'load scripts' }
BaselineOfMoleculeIncubator >> preload: loader package: packageSpec [
	"If a Molecule component system is running, confirm loading and cleanUp before installation of the new version"
	
	(Smalltalk globals includesKey: #MolComponentManager) ifFalse:[ ^self ].
	previousDynamicContractUpdateActivated := false.
	(Smalltalk globals classNamed: #MolComponentManager) isRunningComponents ifTrue:[ 
		(Smalltalk ui theme
		proceedIn: Morph new 
		text: 'Warning, you are going to modify Molecule then components are started, do you want to continue ?'
		title: 'Molecule - Loading a baseline') ifFalse:[ 
			self flag:'PLA : How to stop the loading ? For the moment you should close the debug windows opened when Halt is call'.	
			Halt now.
		].
	].
 
	(Smalltalk globals classNamed: #MolComponentManager) cleanUp.
	previousDynamicContractUpdateActivated := MolComponentFactory default isDynamicContractUpdateActivated.
	MolComponentFactory default deactivateDynamicContractUpdate.
]
