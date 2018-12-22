import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
/*
* Author: Randyll Bearer
* Email: rlb97@pitt.edu
*
**/


public class pw_check {
	static String[] masterArray311 = {"LLLNS","LLLSN", "LLNLS", "LLNSL", "LLSLN", "LLSNL", "LNLLS", "LNLSL", "LNSLL", "LSLLN", "LSLNL", "LSNLL", "NLLLS", "NLLSL", "NLSLL", "NSLLL", "SLLLN", "SLLNL", "SLNLL", "SNLLL" };
	static char[] letterArray = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};	//SIZE 26
	static char[] numberArray = {'0','1','2','3','4','5','6','7','8','9'};																	//SIZE 10
	static char[] symbolArray = {'!', '@', '$', '^', '_', '*'};																				//SIZE 6
	
	
	public static void main(String[] args){
		pw_check instance = new pw_check();	//static-from non static nonsense
		Scanner keyboard = new Scanner(System.in);
		DLBTrie allBad = instance.new DLBTrie();				// BAD DLB
		
		//GENERATE my_dictionary.txt + good_passwords.txt
		if(args.length == 1 && (args[0].equals("-g") || args[0].equals("-G"))){	// Okay so we are going to need to read-in the provided dictionary.				
			//GENERATE BAD PASSWORDS
			allBad = instance.generateBadPasswords(allBad);				//Non-static method / static BS
			System.out.println("\nNODE COUNT: " + allBad.getCount() + "\n");	//TEST
			
			//GENERATE GOOD PASSWORDS
			for(int i=0; i<20; i++){	//String in masterArray311
				StringBuilder masterPattern = new StringBuilder(masterArray311[i]);	//HOLDS STRING PATTERN "LLLNS"
				char[] masterCharacters = new char[5];
				masterPattern.getChars(0,4,masterCharacters,0);						//HOLDS CHAR PATTERN 'L','L','L','N','S'
				int masterPatternIndex = 0;		// Where am I at in the master pattern [Look up if L/N/S]
				
				instance.findPossible(masterCharacters, masterPatternIndex, "", allBad);
			}
		}
	}
	
	
	//Will read in from the dictionary.txt and produce my_dictionary.txt (If file location not found return boolean / false)
	public DLBTrie generateBadPasswords(DLBTrie dlbToComplete){	//accepts allBad DLB
		//Where will we create my_dictionary.txt at?
		boolean generatedFlag = false;
		Scanner keyboard = new Scanner(System.in);	//Input from user
		Scanner dictionaryIn = null;				//Input from dictionary.txt
		PrintWriter dictionaryOut = null;			//Write to my_dictionary.txt
		StringBuilder[] allOptions = null;			//Holds all possible illegal words to be printed to my_dictionary.txt
		
		
		//Find out where dictionary.txt is located and where my_dictionary.txt is to be written to
		while(generatedFlag == false){
			System.out.println("Please enter the path for dictionary.txt: ");
			String filename = keyboard.nextLine();
			File dictionaryFile = new File(filename);
			
			try{
				dictionaryIn = new Scanner(dictionaryFile);
				generatedFlag = true;
			}catch(FileNotFoundException fnfe){
				System.out.println("\nSorry but nothing could be found at that file location...\n");
			}
			
			if(generatedFlag == true){	//Did we get the first file?
				boolean generatedFlag2 = false;
				while(generatedFlag2 == false){
					System.out.println("Please enter the desired file where my_dictionary.txt should be stored: ");
					filename = keyboard.nextLine() + "\\my_dictionary.txt";
					
					try{
						File myDictionaryLocation = new File(filename);
						dictionaryOut = new PrintWriter(myDictionaryLocation);
						generatedFlag2 = true;
					}catch(IOException ioe){
						System.out.println("\nA file could not be created there.\n");
					}
				}
			}
			
		}
		
		//Generate the BadPasswords DLB + my_dictionary.txt from dictionary.txt
		while(dictionaryIn.hasNextLine()){
			//Read-in word and convert it to characters in an array.
			String tempWord = dictionaryIn.nextLine();
			if(tempWord.equals(null)){				//End of txtfile
				break;
			}
			tempWord = tempWord.toLowerCase();
			int wordLength = tempWord.length();		//Used in future for loops.
			if(tempWord.length() <= 5){				//Only ones of importance.
				char[] characterArray = new char[tempWord.length()];
				StringBuilder baseWord = new StringBuilder(tempWord);
				baseWord.getChars(0,tempWord.length()-1,characterArray,0);					// Puts the characters from the string into the characterArray array.
				allOptions = findIllegalAlternatives(baseWord, wordLength, dictionaryOut, dlbToComplete);	// allOptions now holds all possible alternatives to the word from dictionary
			}
		}
		dictionaryOut.flush();
		dictionaryOut.close();
		return dlbToComplete;
	}
	
	//Takes in a dictionary word and creates an array of illegalAlternates + prints those to my_dictionary.txt
	public static StringBuilder[] findIllegalAlternatives(StringBuilder wordToCheck, int stringLength, PrintWriter toDictionary, DLBTrie badDLB){	//Will find all illegal alternatives due to substitutions, must be converted from StringBuilder to String before returning.
		StringBuilder baseWord = new StringBuilder().append(wordToCheck);
		StringBuilder[] wordArray = new StringBuilder[32];
		wordArray[0] = baseWord;
		int size = 1;
		
		//baseWord = our stringBuilder word from dictionary
		//stringLength = the length of our word from dictionary
		//wordArray = array holding all possible words
		//size = number of words in array
		
		for(int i = 0; i<stringLength; i++){
			for(int j = 0; j<size; j++){
				StringBuilder tempWord = new StringBuilder (wordArray[j]); //Now we have the first word in the array
				char tempChar = tempWord.charAt(i);
				
				if(tempChar == 'o'){
					tempWord.deleteCharAt(i);
					tempWord.insert(i, '0');
					wordArray[size] = tempWord;
					size +=1;
				}else if(tempChar == 'l'){
					tempWord.deleteCharAt(i);
					tempWord.insert(i, '1');
					wordArray[size] = tempWord;
					size +=1;
				}else if(tempChar == 't'){
					tempWord.deleteCharAt(i);
					tempWord.insert(i, '7');
					wordArray[size] = tempWord;
					size +=1;
				}else if(tempChar == 'a'){
					tempWord.deleteCharAt(i);
					tempWord.insert(i, '4');
					wordArray[size] = tempWord;
					size +=1;
				}else if(tempChar == 'e'){
					tempWord.deleteCharAt(i);
					tempWord.insert(i, '3');
					wordArray[size] = tempWord;
					size +=1;
				}else if(tempChar == 'i'){
					tempWord.deleteCharAt(i);
					tempWord.insert(i, '1');
					wordArray[size] = tempWord;
					size +=1;
				}else if(tempChar == 's'){
					tempWord.deleteCharAt(i);
					tempWord.insert(i, '$');
					wordArray[size] = tempWord;
					size +=1;
				}
			}
		}
		for(int i=0; i<size; i++){
			System.out.println(wordArray[i]);	//TEST
			toDictionary.println(wordArray[i]);
		}
		
		//CREATE DLB
		for(int i=0; i<size; i++){								//WORD
			StringBuilder wordOption = new StringBuilder(wordArray[i]);	//Take the first option
			char[] characters = new char[stringLength];			//
			wordOption.getChars(0,stringLength,characters,0);	//Split it into characters [characters now holds each character in string, stringLength determines how many characters there are]
			
			DLBNode current = badDLB.getRoot();
			for(int j = 0; j<stringLength; j++){				//CHARACTER
				char currentChar = characters[j];
				if(badDLB.getRootKey() == ']' ){				//If this is the very first time
					badDLB.setRootKey(currentChar);				//So the root node now has a key
					if(j == stringLength - 1){					//If our word is one letter long
						badDLB.getRoot().setEndFlag(true);
					}
				}else{
					while(true){								//CHARACTER IN DLB
						if(current.getKey() == ']'){			//If we are starting on a fresh child node
							current.setKey(currentChar);
							if(j== stringLength -1){			//If this is our last word update and break out
								current.setEndFlag(true);
								break;
							}
							current.newChild();
							current = current.getChild();		//Update current and move down to next level
							badDLB.incrementCount();
							break;
						}else if(current.getKey() == currentChar){	//So we found our character
							if(j==stringLength-1){					//We are at the end of our word
								current.setEndFlag(true);
								break;
							}
							if(current.getChild() == null){			//If we currently have no child
								current.newChild();
								current = current.getChild();
								badDLB.incrementCount();
								break;
							}else{
								current = current.getChild();
								break;
							}
						}else if(current.getNext() == null){		// if our next node is null, then we have to add a new one + update it + make a child + make current = new child
							current.newNext();						// CREATE
							badDLB.incrementCount();
							current = current.getNext();
							current.setKey(currentChar);			// UPDATE
							if(j == stringLength-1){				//If this is the final node, don't bother with making a new child
								current.setEndFlag(true);
								break;
							}
							current.newChild();						//vMAKE CHILD
							current = current.getChild();			// MAKE CHILD CURRENT
							badDLB.incrementCount();
							break;
						}else{
							current = current.getNext();
						}
					}
				}	
			}	
		}
		return wordArray;
	}
	
	
	public void findPossible(char[] pattern, int patternIndex, String prefix, DLBTrie badDLBTrie){
		if(patternIndex == 4){				//If we are on our last index
			if(lookupPossible(prefix, badDLBTrie) == false){
				return;
			}
			System.out.println(prefix);		//WILL CHANGE TO PRINT OUT TO good_dictionary.txt
			return;
		}
		if(pattern[patternIndex] == 'L'){			//Do we need to increment a letter?
			for(int i=0; i<26; i++){
				String newPrefix = prefix + letterArray[i];
				if(lookupPossible(newPrefix, badDLBTrie) == false){	//FALSE = BAD PASSWORD CANNOT USE
					return;
				}
				findPossible(pattern, (patternIndex+1), newPrefix, badDLBTrie);
			}
			
		}else if(pattern[patternIndex] == 'N'){		//Do we need to increment a number?
			for(int i=0; i<10; i++){
				String newPrefix = prefix + numberArray[i];
				if(lookupPossible(newPrefix, badDLBTrie) == false){
					return;
				}
				findPossible(pattern, (patternIndex+1), newPrefix, badDLBTrie);
			}
			
		}else if(pattern[patternIndex] == 'S'){		//Do we need to increment a symbol?
			for(int i=0; i<6; i++){
				String newPrefix = prefix + numberArray[i];
				if(lookupPossible(newPrefix, badDLBTrie) == false){
					return;
				}
				findPossible(pattern, (patternIndex+1), newPrefix, badDLBTrie);
			}
			
		}
	}
	
	//This method is really just an intermediary step
	public boolean lookupPossible(String prefixToCheck, DLBTrie badTrie){
		boolean result = true;	//DEFAULT = TRUE = GOOD PASSWORD
		int prefixLength = prefixToCheck.length();
		
		if(prefixLength == 1){
			result = lookupPossible1(prefixToCheck, prefixLength, badTrie);
		}else if(prefixLength == 2){
			result = lookupPossible2(prefixToCheck, prefixLength, badTrie);
		}else if(prefixLength == 3){
			result = lookupPossible3(prefixToCheck, prefixLength, badTrie);
		}else if(prefixLength == 4){
			result = lookupPossible4(prefixToCheck, prefixLength, badTrie);
		}else if(prefixLength == 5){
			result = lookupPossible5(prefixToCheck, prefixLength, badTrie);
		}
		
		return result;
	}
	
	public boolean lookupPossible1(String prefixToLookup, int length, DLBTrie badPasswordTrie){	//COMPLETE IN THEORY
		//TRUE = GOOD PASSWORD     FALSE = BAD PASSWORD
		StringBuilder temp = new StringBuilder(prefixToLookup);
		char character = temp.charAt(0);
		DLBNode current = badPasswordTrie.getRoot();
		
		//Lookup 1
		while(true){
			if(current.getKey() == character && current.getEndFlag() == true){
				return false;
			}else if(current.getKey() == character && current.getEndFlag() == false){
				return true;
			}else if(current.getNext() == null){
				return true;	//If the character wasn't found in bad passwords, it must be good password
			}else{
				current = current.getNext();
			}
		}
	}
	
	public boolean lookupPossible2(String prefixToLookup, int length, DLBTrie badPasswordTrie){	//INCOMPLETE
		boolean result = true;
		StringBuilder temp = new StringBuilder(prefixToLookup);
		DLBNode current = badPasswordTrie.getRoot();
		
		//Lookup 2
		char currentCharacter = temp.charAt(1);
		while(true){
			if(current.getKey() == currentCharacter && current.getEndFlag() == true){
				return false;
			}else if(current.getKey() == currentCharacter && current.getEndFlag() == true){
				break;
			}else if(current.getNext() == null){
				break;
			}else{
				current = current.getNext();
			}
		}
		
		currentCharacter = temp.charAt(1);
		
		return true;
	}
	
	public boolean lookupPossible3(String prefixToLookup, int length, DLBTrie badPasswordTrie){	//INCOMPLETE
		boolean result = true;
		
		
		return result;
	}
	
	public boolean lookupPossible4(String prefixToLookup, int length, DLBTrie badPasswordTrie){	//INCOMPLETE
		boolean result = true;
		
		
		return result;
	}
	
	public boolean lookupPossible5(String prefixToLookup, int length, DLBTrie badPasswordTrie){	//INCOMPLETE
		boolean result = true;
		
		
		return result;
	}
	
	public class DLBNode{
		private char key =']';						// The letter being stored.  DEFAULT
		private boolean endFlag = false;			// Is this the last letter in a word?
		private DLBNode next = null;		// Next horizontal option in LinkedList.
		private DLBNode child = null;		// Next vertical option in LinkedList.
		
		//CONSTRUCTORS
		public DLBNode(){
			endFlag = false;
		}
		
		public DLBNode(char newKey){		// This will be the most often used constructor.
			key = newKey;
		}
		
		public DLBNode(char newKey, boolean newEndFlag, DLBNode newNext, DLBNode newChild){
			key = newKey;
			endFlag = newEndFlag;
			next = newNext;
			child = newChild;
		}
		
		//GETTERS + SETTERS
		public void setKey(char newKey){
			key = newKey;
		}
		
		public void setEndFlag(boolean newEndFlag){
			endFlag = newEndFlag;
		}
		
		public void setNext(DLBNode newNext){
			next = newNext;
		}
		
		public void newNext(){
			next = new DLBNode();
		}
		
		public void setChild(DLBNode newChild){
			child = newChild;
		}
		
		public void newChild(){
			child = new DLBNode();
		}
		
		public char getKey(){
			return key;
		}
		
		public boolean getEndFlag(){
			return endFlag;
		}
		
		public DLBNode getNext(){
			return next;
		}
		
		public DLBNode getChild(){
			return child;
		}
	}
	
	/*
	* So the idea is, we are just navigating the "DLBNode current" down-and-to-the-right of the tree, until we find what we need or find a place we need to add to.
	*
	**/
	public class DLBTrie{
		private DLBNode root;			// This is where we will start our inserts/searches.
		private int nodeCount = 0;
		
		//CONSTRUCTORS
		public DLBTrie(){						// Should only really ever use this one.
			root = new DLBNode();
		}
		
		public DLBTrie(DLBNode newNode){
			root = newNode;
		}
		
		//METHODS
		public void setRootKey(char newRootKey){// Should only ever be ran once at the first insert of a new DLBTrie.
			root.setKey(newRootKey);
		}
		
		
		public DLBNode getRoot(){
			return root;
		}
		
		public char getRootKey(){
			return root.getKey();
		}
		
		public void incrementCount(){
			nodeCount +=1;
		}
		
		public int getCount(){
			return nodeCount;
		}
		
		
	}
	
}