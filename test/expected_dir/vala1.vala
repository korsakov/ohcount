vala	code	using GLib;
vala	blank	
vala	blank	
vala	blank	
vala	comment	// Class which makes the event
vala	code	public class Game : Object {
vala	comment	    // Note the use of the signal keyword
vala	code	    public signal void score_change (int newScore, ref bool cancel);
vala	blank	
vala	code	    int _score;
vala	blank	
vala	comment		// Score Property
vala	code	    public int score {
vala	code	        get {
vala	code	            return _score;
vala	code		    }
vala	code	        set {
vala	code	            if (_score != value) {
vala	code	                bool cancel = false;
vala	code	                score_change (value, ref cancel);
vala	code	                if (! cancel)
vala	code	                    _score = value;
vala	code	            }
vala	code	        }
vala	code	    }
vala	code	}
vala	blank	
vala	comment	// Class which handles the event
vala	code	public class Referee : Object
vala	code	{
vala	code	    public Game game { get; construct; }
vala	blank	
vala	code	    public Referee (construct Game game) {
vala	code	    }
vala	blank	
vala	code	    construct {
vala	comment	        // Monitor when a score changes in the game
vala	code	        game.score_change += game_score_change;
vala	code	    }
vala	blank	
vala	comment	    // Notice how this method signature matches the score_change signal's signature
vala	code	    private void game_score_change (Game game, int new_score, ref bool cancel) {
vala	code	        if (new_score < 100)
vala	code	            stdout.printf ("Good Score\n");
vala	code	        else {
vala	code	            cancel = true;
vala	code	            stdout.printf ("No Score can be that high!\n");
vala	code	        }
vala	code	    }
vala	code	}
vala	blank	
vala	comment	// Class to test it all
vala	code	public class GameTest : Object
vala	code	{
vala	code	    public static void main () {
vala	code	        var game = new Game ();
vala	code	        var referee = new Referee (game);
vala	code	        game.score = 70;
vala	code	        game.score = 110;
vala	code	    }
vala	code	}
