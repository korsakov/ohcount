limbo	code	implement HgReadrevlog;
limbo	blank	
limbo	code	include "sys.m";
limbo	code		sys: Sys;
limbo	code		sprint: import sys;
limbo	code	include "draw.m";
limbo	code	include "arg.m";
limbo	code	include "string.m";
limbo	code		str: String;
limbo	code	include "mercurial.m";
limbo	code		mercurial: Mercurial;
limbo	code		Revlog, Repo, Entry, Nodeid, Change: import mercurial;
limbo	blank	
limbo	code	dflag: int;
limbo	blank	
limbo	code	HgReadrevlog: module {
limbo	code		init:	fn(nil: ref Draw->Context, args: list of string);
limbo	code	};
limbo	blank	
limbo	code	init(nil: ref Draw->Context, args: list of string)
limbo	code	{
limbo	code		sys = load Sys Sys->PATH;
limbo	code		arg := load Arg Arg->PATH;
limbo	code		str = load String String->PATH;
limbo	code		mercurial = load Mercurial Mercurial->PATH;
limbo	code		mercurial->init();
limbo	blank	
limbo	code		arg->init(args);
limbo	code		arg->setusage(arg->progname()+" [-d] path");
limbo	code		while((c := arg->opt()) != 0)
limbo	code			case c {
limbo	code			'd' =>	dflag++;
limbo	code				if(dflag > 1)
limbo	code					mercurial->debug++;
limbo	code			* =>	arg->usage();
limbo	code			}
limbo	code		args = arg->argv();
limbo	code		if(len args != 1)
limbo	code			arg->usage();
limbo	code		path := hd args;
limbo	blank	
limbo	code		(rl, err) := Revlog.open(path);
limbo	code		if(err != nil)
limbo	code			fail(err);
limbo	blank	
limbo	code		last: int;
limbo	code		(last, err) = rl.lastrev();
limbo	code		if(err != nil)
limbo	code			fail(err);
limbo	blank	
limbo	code		e: ref Entry;
limbo	code		for(i := 0; i <= last; i++) {
limbo	code			(e, err) = rl.findrev(i);
limbo	code			if(err != nil)
limbo	code				fail(err);
limbo	comment			#sys->print("entry %d:\n", i);
limbo	code			sys->print("%s\n", e.text());
limbo	code		}
limbo	code	}
limbo	blank	
limbo	code	fail(s: string)
limbo	code	{
limbo	code		sys->fprint(sys->fildes(2), "%s\n", s);
limbo	code		raise "fail:"+s;
limbo	code	}
