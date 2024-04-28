Class {
	#name : #EtFetcher,
	#superclass : #Object,
	#category : #EtymTree
}

{ #category : #accessing }
EtFetcher class >> fetchWord: word [
	| url body |
	url := self getUrl: word.
	body := ZnClient new get: url.
	^ (STON fromString: body) at: 'parse'.
]

{ #category : #accessing }
EtFetcher class >> fetchWordEtymology: word [
	| dict sections wikitext langIndex |
	dict := self fetchWord: word.
	wikitext := dict at: 'wikitext'.
	sections := dict at: 'sections'.
	" Find the section for the word language"
	langIndex := sections detectIndex: [:s | (s at: 'line') = word lang].
	^ sections at: langIndex
]

{ #category : #accessing }
EtFetcher class >> getUrl: word [
	^ 'https://en.wiktionary.org/w/api.php?action=parse&format=json&prop=wikitext|sections&page=', word headword
]
