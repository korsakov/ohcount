// The Delegate declaration which defines the signature of methods which can be invoked
public delegate void ScoreChangeEventHandler (int newScore, ref bool cancel);

// Class which makes the event
public class Game {
    // Note the use of the event keyword
    public event ScoreChangeEventHandler ScoreChange;

    int score;

	// Score Property
    public int Score {
        get {
            return score;
	    }
        set {
            if (score != value) {
                bool cancel = false;
                ScoreChange (value, ref cancel);
                if (! cancel)
                    score = value;
            }
        }
    }
}

// Class which handles the event
public class Referee
{
    public Referee (Game game) {
        // Monitor when a score changes in the game
        game.ScoreChange += new ScoreChangeEventHandler (game_ScoreChange);
    }

    // Notice how this method signature matches the ScoreChangeEventHandler's signature
    private void game_ScoreChange (int newScore, ref bool cancel) {
        if (newScore < 100)
            System.Console.WriteLine ("Good Score");
        else {
            cancel = true;
            System.Console.WriteLine ("No Score can be that high!");
        }
    }
}

// Class to test it all
public class GameTest
{
    public static void Main () {
        Game game = new Game ();
        Referee referee = new Referee (game);
        game.Score = 70;
        game.Score = 110;
    }
}
