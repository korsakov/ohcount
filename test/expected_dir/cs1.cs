csharp	comment	// The Delegate declaration which defines the signature of methods which can be invoked
csharp	code	public delegate void ScoreChangeEventHandler (int newScore, ref bool cancel);
csharp	blank	
csharp	comment	// Class which makes the event
csharp	code	public class Game {
csharp	comment	    // Note the use of the event keyword
csharp	code	    public event ScoreChangeEventHandler ScoreChange;
csharp	blank	
csharp	code	    int score;
csharp	blank	
csharp	comment		// Score Property
csharp	code	    public int Score {
csharp	code	        get {
csharp	code	            return score;
csharp	code		    }
csharp	code	        set {
csharp	code	            if (score != value) {
csharp	code	                bool cancel = false;
csharp	code	                ScoreChange (value, ref cancel);
csharp	code	                if (! cancel)
csharp	code	                    score = value;
csharp	code	            }
csharp	code	        }
csharp	code	    }
csharp	code	}
csharp	blank	
csharp	comment	// Class which handles the event
csharp	code	public class Referee
csharp	code	{
csharp	code	    public Referee (Game game) {
csharp	comment	        // Monitor when a score changes in the game
csharp	code	        game.ScoreChange += new ScoreChangeEventHandler (game_ScoreChange);
csharp	code	    }
csharp	blank	
csharp	comment	    // Notice how this method signature matches the ScoreChangeEventHandler's signature
csharp	code	    private void game_ScoreChange (int newScore, ref bool cancel) {
csharp	code	        if (newScore < 100)
csharp	code	            System.Console.WriteLine ("Good Score");
csharp	code	        else {
csharp	code	            cancel = true;
csharp	code	            System.Console.WriteLine ("No Score can be that high!");
csharp	code	        }
csharp	code	    }
csharp	code	}
csharp	blank	
csharp	comment	// Class to test it all
csharp	code	public class GameTest
csharp	code	{
csharp	code	    public static void Main () {
csharp	code	        Game game = new Game ();
csharp	code	        Referee referee = new Referee (game);
csharp	code	        game.Score = 70;
csharp	code	        game.Score = 110;
csharp	code	    }
csharp	code	}
