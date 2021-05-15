VOWELS = c("ü","i","ı","u","e","ö","a","o")

ALPHABET = c("a","b","c","ç","d","e","f","g","ğ","h","ı","i","j","k","l","m",
             "n","o","ö","p","r","s","ş","t","u","ü","v","y","z")

nvs <- list("1010"=c("leri","ları"),
            "101"=c("lar","ler","den","dan","ten","tan","nin","nın","nun","nün","miz","mız","muz","müz","niz","nız","nuz","nüz"),
            "10"=c("yi","yı","yu","yü","ye","ya","de","da","te","ta","ca","ce","ça","çe"),
            "01"=c("in","ın","un","ün","ım","im","sı","si"),
            "0"=c("i","ı","u","ü","e","a"),
            "1"=c("m","n"))

word_list <- scan("word-list.txt", what = "character", sep = "\n")

stemmer <- function(x){
  
  x <- tolower(x)
  if(foreignLetterCheck(x)) return(x)
  if(x %in% word_list) return(x)
  num_of_syllables <- findNumofSyllable(x)
  if(num_of_syllables == 1) return(x)
  
  syllables <- syllableExtractor(x)
  syllableList <- list()
  for(i in 1:length(syllables)){
    syllableList[i] <- syllables[i]
  }
  for(i in length(syllableList):2){
    tempSyllable <- unname(unlist(syllableList[i]))
    k <- length(unlist(strsplit(tempSyllable, split = character(0))))
    cosl <- convertBinary(tempSyllable)
    while(k > 0){
      if(tempSyllable %in% nvs[[cosl]]){
        syllableList[i] <- NULL
        tempWord <- unlist(strsplit(unname(unlist(syllableList)), split = character(0)))
        tempWord <- paste(tempWord, collapse = "")
        if(tempWord %in% word_list){
          return(tempWord)
        }else{
          return(stemmer(tempWord))
        }
      }else{
        last <- unname(unlist(syllableList[i]))
        previous <- unname(unlist(syllableList[i-1]))
        syllableList[i-1] <- addToRigth(previous,last)
        tempSyllable <- syllableList[i] <- dropFromLeft(last)
        cosl <- dropFromLeft(cosl)
        k <- k - 1
      }
      
    }
    return(x)
  }
}

# Finds number of syllables in a given word
findNumofSyllable <- function(x){
  x <- unlist(strsplit(x, split = character(0)))
  y <- sum(x %in% VOWELS)
  return(y)
}

# Extracting syllables
syllableExtractor <- function(word){
  # Change letters to lowercase
  # word <- tolower(word)
  # Split string into letters
  word <- unlist(strsplit(word, split = character(0)))
  # Variables to hold values
  j <- length(word)
  k <- 1
  wordCode <- out <- c()
  # Label letters with binary codes; 0=Vowel, 1=Consonants
  for(i in seq_len(j)){
    ifelse(word[i] %in% VOWELS, wordCode <- c(wordCode,"0"),
           wordCode <- c(wordCode,"1"))
  }
  #If the word consists of 1 or 2 letters print it without processing
  if(j < 3){
    out <- c(out, paste(word[1],word[2],sep=""))
  }else{
    while (k<=j) {
      codePart <- wordPart <- c()
      
      if((j - k) > 2){
        wordPart <- word[k:(k+3)]
        codePart <- c(codePart, paste(wordCode[k],wordCode[k+1],wordCode[k+2],wordCode[k+3], sep=""))
      }
      
      if((j - k) > 3 & wordCode[k]=="1" & wordCode[k+1]=="0" & wordCode[k+2]=="1" & 
         wordCode[k+3]=="1" & wordCode[k+4]=="1"){
        wordPart <- word[k:(k+4)]
        codePart <- c()
        codePart <- c(codePart, paste(wordCode[k],wordCode[k+1],wordCode[k+2],wordCode[k+3],wordCode[k+4], sep=""))
      }
      if((j - k) == 2){
        wordPart <- word[k:j]
        codePart <- c(codePart, paste(wordCode[k],wordCode[k+1],wordCode[k+2], sep=""))
      }
      if((j - k) == 1){
        wordPart <- word[k:j]
        codePart <- c(codePart, paste(wordCode[k],wordCode[k+1], sep=""))
      }
      if((j - k) == 0){
        wordPart <- word[k]
        codePart <- c(codePart, wordCode[k])
      }
      switch(codePart,
             "0010"={out <- c(out, word[k])
             k <- k + 1},
             "0100"={out <- c(out, word[k])
             k <- k + 1},
             "0101"={out <- c(out, word[k])
             k <- k + 1},
             "0110"={out <- c(out, paste(word[k],word[k+1],sep=""))
             k <- k + 2},
             "010"={out <- c(out, word[k])
             k <- k + 1},
             "0111"={out <- c(out, paste(word[k],word[k+1],word[k+2],sep=""))
             k <- k + 3},
             "1010"={out <- c(out, paste(word[k],word[k+1],sep=""))
             k <- k + 2},
             "1011"={out <- c(out, paste(word[k],word[k+1],word[k+2],sep=""))
             k <- k + 3},
             "1101"={out <- c(out, word[k])
             k <- k + 1},
             "1001"={out <- c(out, paste(word[k],word[k+1],sep=""))
             k <- k + 2},
             "10111"={out <- c(out, paste(word[k],word[k+1],word[k+2],word[k+3], sep=""))
             k <- k + 4},
             "110"={out <- c(out, word[k])
             k <- k + 1},
             "101"={out <- c(out, paste(word[k],word[k+1],word[k+2],sep=""))
             k <- k + 3},
             "100"={out <- c(out, paste(word[k],word[k+1],sep=""))
             k <- k + 2},
             "011"={out <- c(out, paste(word[k],word[k+1],word[k+2],sep=""))
             k <- k + 3},
             "001"={out <- c(out, word[k])
             k <- k + 1},
             "10"={out <- c(out, paste(word[k],word[k+1],sep=""))
             k <- k + 2},
             "01"={out <- c(out, paste(word[k],word[k+1],sep=""))
             k <- k + 2},
             "1"={out <- c(out[-length(out)], paste(out[length(out)], word[k],sep=""))
             k <- k + 1},
             "0"={out <- c(out, word[k])
             k <- k + 1},
             stop("undefined")
      )
    }
  }
  return(out)
}

addToRigth <- function(x,y){
  y <- unlist(strsplit(y, split = character(0)))
  x <- c(x,y[1])
  x <- paste(x,collapse="")
  return(x)
}

dropFromLeft <- function(x){
  x <- unlist(strsplit(x, split = character(0)))
  x <- x[-1]
  x <- paste(x, collapse = "")
  return(x)
}

convertBinary <- function(x){
  x <- unlist(strsplit(x, split = character(0)))
  code <- c()
  j <- length(x)
  for(i in seq_len(j) ){
    ifelse(x[i] %in% VOWELS, code <- c(code,"0"),
           code <- c(code,"1"))
  }
  return(paste(code, collapse = ""))
}

foreignLetterCheck <-  function(x){
  x <- unlist(strsplit(x, split = character(0)))
  if(length(x) == 1) return(TRUE)
  for(i in 1:length(x)){
    if(!(x[i] %in% ALPHABET)) return(TRUE)
  }
  return(FALSE)
}








