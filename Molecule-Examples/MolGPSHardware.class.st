Class {
	#name : #MolGPSHardware,
	#superclass : #Object,
	#traits : 'MolComponentImpl + MolGPSData + MolGPSDataServices',
	#classTraits : 'MolComponentImpl classTrait + MolGPSData classTrait + MolGPSDataServices classTrait',
	#instVars : [
		'componentConnector',
		'componentName',
		'sendCurrentPositionThread'
	],
	#category : #'Molecule-Examples-GPS Example'
}

{ #category : #'component life cycle' }
MolGPSHardware >> componentActivate [ 

	"Start a thread to simulate sending of a fixed geo position each 2 seconds"
	sendCurrentPositionThread := [
	 	[true] whileTrue:[
		
			(Delay forSeconds: 2) wait.
			self getMolGPSDataEventsNotifier currentPositionChanged: 1@1.
		].
	] forkAt: Processor userBackgroundPriority.
]

{ #category : #'private component accessing' }
MolGPSHardware >> componentConnector [
	^componentConnector 
]

{ #category : #'private component accessing' }
MolGPSHardware >> componentConnector: aConnector [
	componentConnector := aConnector.
]

{ #category : #'private component accessing' }
MolGPSHardware >> componentName [
	^componentName
]

{ #category : #'private component accessing' }
MolGPSHardware >> componentName: aName [
	componentName := aName
]

{ #category : #'component life cycle' }
MolGPSHardware >> componentPassivate [ 
	
	sendCurrentPositionThread ifNotNil:[ :e | e terminate ].
	sendCurrentPositionThread := nil.
]

{ #category : #services }
MolGPSHardware >> getAccuracyRadiusInMeters [
	"Get and return the accuracy of the GPS depending quality of signal and quantity of connected satellites"
	
	"convert precision in feet to meters"
	^(self precision * 0.3048)
]

{ #category : #'component accessing' }
MolGPSHardware >> getMolGPSDataEventsNotifier [
	^self eventsNotifiers at: MolGPSDataEvents ifAbsent: [nil]
]

{ #category : #'GPS hardware existing API' }
MolGPSHardware >> precision [

	"Return GPS hardware precision (in feet)"

	^3
]