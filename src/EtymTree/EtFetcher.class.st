Class {
	#name : #EtFetcher,
	#superclass : #Object,
	#category : #EtymTree
}

{ #category : #accessing }
EtFetcher class >> fetchWordText: word [
	"Fetch the word from Wiktionary and returns its wikitext.
	Returns an empty string if the word is not found."
	| dict wikitext sections langIndex from body json |

	(EtWord supportedLang: (word lang)) ifFalse: [^ '' asWideString].
	
	body := ZnClient new get: (self getUrl: word).
	json := STON fromString: body.
	json at: 'error' ifPresent: [^ '' asWideString].
	
	dict := json at: 'parse'.
	wikitext := dict at: 'wikitext' at: '*'.
	sections := dict at: 'sections'.
	" Find the index of the language section."
	langIndex := sections detectIndex: [:s |
		(s at: 'line') = word langName and:
		[(s at: 'toclevel') = 1]].
	from := ((sections at: langIndex) at: 'byteoffset') + 1.
	" Find the next top-level section. "
	langIndex + 1 to: sections size do: [:i |
		| section |
		section := sections at: i.
		(section at: 'toclevel') = 1 ifTrue: [
			" We found the next top-level section, return the text in between. "
			^ wikitext sliceFrom: from to: (section at: 'byteoffset').
		]
	].
	" There is no more top-level section, return all the remaining text. "
	^ wikitext sliceFrom: from.
]

{ #category : #accessing }
EtFetcher class >> getUrl: word [
	^ 'https://en.wiktionary.org/w/api.php?action=parse&format=json&prop=wikitext|sections&page=', word page urlEncoded
]
