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
		'de' -> 'German'.
		'ine-pro' -> 'Proto-Indo-European'.
	}
]

{ #category : #accessing }
EtWord class >> supportedLang: lang [
	^ (self langCodeToName) at: lang ifPresent: [true] ifAbsent: [false]
]

{ #category : #accessing }
EtWord >> fetchEtymology [
	^ EtFetcher fetchWordEtymology: self
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

{ #category : #accessing }
EtWord >> page [
	(lang endsWith: '-pro') ifTrue: [
		^ 'Reconstruction:', self langName, '/', headword
	].
	^ headword
]
