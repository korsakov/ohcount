implement HgReadrevlog;

include "sys.m";
	sys: Sys;
	sprint: import sys;
include "draw.m";
include "arg.m";
include "string.m";
	str: String;
include "mercurial.m";
	mercurial: Mercurial;
	Revlog, Repo, Entry, Nodeid, Change: import mercurial;

dflag: int;

HgReadrevlog: module {
	init:	fn(nil: ref Draw->Context, args: list of string);
};

init(nil: ref Draw->Context, args: list of string)
{
	sys = load Sys Sys->PATH;
	arg := load Arg Arg->PATH;
	str = load String String->PATH;
	mercurial = load Mercurial Mercurial->PATH;
	mercurial->init();

	arg->init(args);
	arg->setusage(arg->progname()+" [-d] path");
	while((c := arg->opt()) != 0)
		case c {
		'd' =>	dflag++;
			if(dflag > 1)
				mercurial->debug++;
		* =>	arg->usage();
		}
	args = arg->argv();
	if(len args != 1)
		arg->usage();
	path := hd args;

	(rl, err) := Revlog.open(path);
	if(err != nil)
		fail(err);

	last: int;
	(last, err) = rl.lastrev();
	if(err != nil)
		fail(err);

	e: ref Entry;
	for(i := 0; i <= last; i++) {
		(e, err) = rl.findrev(i);
		if(err != nil)
			fail(err);
		#sys->print("entry %d:\n", i);
		sys->print("%s\n", e.text());
	}
}

fail(s: string)
{
	sys->fprint(sys->fildes(2), "%s\n", s);
	raise "fail:"+s;
}
