Class {
	#name : #BaselineOfEtymTree,
	#superclass : #BaselineOf,
	#category : #BaselineOfEtymTree
}

{ #category : #loading }
BaselineOfEtymTree class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'EtymTree' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : #baseline }
BaselineOfEtymTree >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'EtymTree'
		]
]
