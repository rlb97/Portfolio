package worldofsweets;
public class Deck
{
    private int size = -1;
    private Card[] deck = null;
    private int nextCard = -1;

    public Deck()
    {
      size = 0;
      nextCard = 0;
      basicDeck();
    }
	
    public Deck(String form)
    {
		if(form.equalsIgnoreCase("empty")){
			size = 0;
			nextCard = 0;
			deck = new Card[0];
		}else{
			size = 0;
			nextCard = 0;
			if(form.equalsIgnoreCase("skip"))
			addSkips();
			else if(form.equalsIgnoreCase("location"))
			addLocation();
			else if(form.equalsIgnoreCase("full"))
			{
				basicDeck();
				addSkips();
				addLocation();
			}
			else basicDeck();
		}
    }
	
    public void basicDeck()
    {
        for(int singles = 0;singles<10;singles++)
        {
          addCard(Card.Type.RED);
          addCard(Card.Type.YELLOW);
          addCard(Card.Type.BLUE);
          addCard(Card.Type.GREEN);
          addCard(Card.Type.ORANGE);
        }
        for(int doubles = 0;doubles<2;doubles++)
        {
          addCard(Card.Type.DOUBLERED);
          addCard(Card.Type.DOUBLEYELLOW);
          addCard(Card.Type.DOUBLEBLUE);
          addCard(Card.Type.DOUBLEGREEN);
          addCard(Card.Type.DOUBLEORANGE);
        }
    }
	
    public void addSkips()
    {
      for(int skips = 0;skips<5;skips++)
      {
        addCard(Card.Type.SKIP);
      }
    }
	
    public void addLocation()
    {
      addCard(Card.Type.GOTOBUBBLEGUM);
      addCard(Card.Type.GOTOCHOCOLATE);
      addCard(Card.Type.GOTOICECREAM);
      addCard(Card.Type.GOTOCANDYCORN);
      addCard(Card.Type.GOTOLABOONROOM);
    }
	
    public Card drawCard()
    {
        if(isEmpty()){
			shuffle();
		}
        nextCard++;
        return deck[nextCard-1];
    }

    public void addCard(Card.Type t)
    {
      Card[] d = new Card[size+1];
      for(int x = 0;x<size;x++)
      {
        d[x]=deck[x];
      }
      d[size] = new Card(t);
      size++;
      deck = d;
    }
	
    public void shuffle()
    {
        for(int x=size-1;x>0;x--)
        {
            int r = (int)(Math.random()*(x+1));
            Card temp = deck[x];
            deck[x] = deck[r];
            deck[r] = temp;
        }
        nextCard = 0;
    }

    public int getSize()
    {
        return size;
    }

    public boolean isEmpty()
    {
        return nextCard == size;
    }
}
