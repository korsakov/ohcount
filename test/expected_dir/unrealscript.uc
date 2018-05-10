unrealscript	code	class foo extends Actor;
unrealscript	blank	
unrealscript	comment	/** An UnrealScript 3 styled comment. */
unrealscript	code	var bool bFoo;
unrealscript	blank	
unrealscript	code	simulated function PostBeginPlay()
unrealscript	code	{
unrealscript	comment	    // Comment
unrealscript	code	    log(self@"Hello World! Foo is"@bFoo); // Another comment
unrealscript	comment	    /* A
unrealscript	comment	    block
unrealscript	comment	    comment */
unrealscript	code	    Super.PostBeginPlay();
unrealscript	code	}
unrealscript	blank	
unrealscript	code	defaultproperties
unrealscript	code	{
unrealscript	code	    bFoo = true
unrealscript	code	}
