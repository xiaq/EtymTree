Class {
	#name : #EtWord,
	#superclass : #Object,
	#instVars : [
		'headword',
		'lang'
	],
	#category : #EtymTree
}

{ #category : #accessing }
EtWord class >> langCodeToName [
	^ Dictionary newFrom: {
		'la' -> 'Latin'.
		'en' -> 'English'.
	}
]

{ #category : #accessing }
EtWord >> fetchEtymology [
	^ EtFetcher fetchWord: self
]

{ #category : #accessing }
EtWord >> headword [
	^ headword
]

{ #category : #accessing }
EtWord >> headword: a lang: b [
	headword := a.
	lang := b
]

{ #category : #accessing }
EtWord >> lang [
	^ lang
]

{ #category : #accessing }
EtWord >> langName [
	^ (EtWord langCodeToName) at: lang
]
