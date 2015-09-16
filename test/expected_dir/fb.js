javascript	code	function escapeHTML(value)
javascript	code	{
javascript	code	    return String(value).replace(/[<>&"']/g, replaceChars);
javascript	code	}
javascript	blank	
javascript	code	window.onerror = onError;
javascript	blank	
javascript	code	if (document.documentElement.getAttribute("debug") == "true")
javascript	code	    toggleConsole(true);
