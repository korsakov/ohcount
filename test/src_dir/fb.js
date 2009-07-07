function escapeHTML(value)
{
    return String(value).replace(/[<>&"']/g, replaceChars);
}

window.onerror = onError;

if (document.documentElement.getAttribute("debug") == "true")
    toggleConsole(true);
