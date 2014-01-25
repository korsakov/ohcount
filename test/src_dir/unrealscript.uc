class foo extends Actor;

/** An UnrealScript 3 styled comment. */
var bool bFoo;

simulated function PostBeginPlay()
{
    // Comment
    log(self@"Hello World! Foo is"@bFoo); // Another comment
    /* A
    block
    comment */
    Super.PostBeginPlay();
}

defaultproperties
{
    bFoo = true
}
