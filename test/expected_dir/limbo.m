limbo	code	Htmlent: module {
limbo	code		PATH:	con "/dis/lib/htmlent.dis";
limbo	code		entities:	array of (string, int);
limbo	blank	
limbo	code		init:	fn();
limbo	code		lookup:	fn(name: string): int;
limbo	code		conv:	fn(s: string): string;
limbo	code	};
