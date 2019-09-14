# turkish-stemmeR
A Turkish language stemmer for R

All studies on Turkish language stemmers have a common statement: stemming of Turkish language is hard. Turkish is an agglutinative language with a highly rich morphological structure. Turkish words are composed of a stem and of affix(es) in the form of suffixes. Suffixes are affixed to the stem according to definite grammatical rules. In addition, both stem and suffixes may be transformed according to the harmony rules. Those rules and their exceptions make stemming harder for Turkish texts. For more about stemming Turkish language please see Eryiğit and Adalı's insightful article titled "An affix stripping morphological analyzer for Turkish."

All text analysis studies require a stemmer at one point. This R code attempts to stem Turkish words with a simple approach. It first extracts syllables of the given word and then tries to identify the stem by comparing syllables with a list of suffixes and their allomorphs. If any suffix is identified it is removed and then remaining word is searched in a list of Turkish words. If there is a match in the word list, it is returned as the stem. Otherwise function reiterates with the new word. If it can't stem, it returns the given word.

Once the functions are loaded into R environment you can begin to stem by using <code>stemmer</code> function: <pre>stemmer("kitaplar")</pre>
Currently, it stems only noun suffixes. That is because nouns are more interesting for text analysis purposes. The word list is highly important for the accuracy, so a better word list would definitely increase the quality of stemming. Finally, foreign words may cause problem, so it is better to remove them from the text before feeding it into the function.
