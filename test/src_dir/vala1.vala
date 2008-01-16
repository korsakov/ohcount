using GLib;



// Class which makes the event
public class Game : Object {
    // Note the use of the signal keyword
    public signal void score_change (int newScore, ref bool cancel);

    int _score;

	// Score Property
    public int score {
        get {
            return _score;
	    }
        set {
            if (_score != value) {
                bool cancel = false;
                score_change (value, ref cancel);
                if (! cancel)
                    _score = value;
            }
        }
    }
}

// Class which handles the event
public class Referee : Object
{
    public Game game { get; construct; }

    public Referee (construct Game game) {
    }

    construct {
        // Monitor when a score changes in the game
        game.score_change += game_score_change;
    }

    // Notice how this method signature matches the score_change signal's signature
    private void game_score_change (Game game, int new_score, ref bool cancel) {
        if (new_score < 100)
            stdout.printf ("Good Score\n");
        else {
            cancel = true;
            stdout.printf ("No Score can be that high!\n");
        }
    }
}

// Class to test it all
public class GameTest : Object
{
    public static void main () {
        var game = new Game ();
        var referee = new Referee (game);
        game.score = 70;
        game.score = 110;
    }
}
