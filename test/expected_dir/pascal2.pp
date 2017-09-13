pascal	comment	{***************************************************************
pascal	comment	 *
pascal	comment	 * Unit Name: pndefs
pascal	comment	 * Purpose  : Various Definitions and functions...
pascal	comment	 * Author   : Simon Steele
pascal	comment	 * Copyright: This Source Code is Copyright © 1998-2000 Echo
pascal	comment	 *            Software and Simon Steele. Please read the license 
pascal	comment	 *			  agreement at www.pnotepad.org/press/psidx.html.
pascal	comment	 **************************************************************}
pascal	code	unit pndefs;
pascal	blank	
pascal	code	interface
pascal	blank	
pascal	code	uses SysUtils;
pascal	blank	
pascal	code	function CreatePNFile(filename : string; Text : pChar) : Boolean;
pascal	code	function StripNewLines(aString: string): string;
pascal	code	procedure ConvertTypes(filename : string);
pascal	blank	
pascal	code	const strFileTypes : PChar = ('.txt');
pascal	code	   strOpenTypes : PChar = ('%2|Text files (*.txt)|*.txt|0|0|0|LOG files (*.log)|*.log|0|0|0|Executable Files (*.exe, *.com, *.dll)|*.exe;*.com;*.dll|0|0|0');
pascal	code	   sepChar = '|';
pascal	code	   verChar = '%';
pascal	code	   CurrFileVer = '2';
pascal	blank	
pascal	code	implementation
pascal	blank	
pascal	code	function CreatePNFile(filename : string; Text : pChar) : Boolean;
pascal	code	var F : TextFile;
pascal	code	begin
pascal	comment	   {$I-}
pascal	code	   AssignFile(F, filename);
pascal	code	   Rewrite(F);
pascal	code	   Write(F, Text);
pascal	code	   CloseFile(F);
pascal	code	   If IOResult <> 0 Then Result := False
pascal	code	                    Else Result := True;
pascal	comment	   {$I+}
pascal	code	end;
pascal	blank	
pascal	code	function StripNewLines(aString: string): string;
pascal	code	var i : longint;
pascal	code	begin
pascal	code	   result := '';
pascal	code	   i      := 1;
pascal	code	   while i <= length(aString) do
pascal	code	   begin
pascal	code	      if aString[i] = #13 then result := result + ' ' else
pascal	code	      if aString[i] <> #10 then result := result + aString[i];
pascal	code	      inc(i);
pascal	code	   end;
pascal	code	end;
pascal	blank	
pascal	code	procedure ConvertTypes(filename : string);
pascal	code	var t        : TextFile;
pascal	code	    s        : string;
pascal	code	    ps       : string; {part of string}
pascal	code	    Part     : integer;
pascal	code	    ipos     : integer;
pascal	code	    OutStr   : string;
pascal	code	const Desc   = 1;
pascal	code	      Files  = 2;
pascal	code	      Parser = 3;
pascal	code	      Unix   = 4;
pascal	code	begin
pascal	comment	   // This assumes that it is being passed one of the old style type definition
pascal	comment	   // files. We'll set the status on the main form to indicate this as well...
pascal	code	   OutStr := VerChar + CurrFileVer;
pascal	code	   if not fileexists(filename) then
pascal	code	   begin
pascal	code	      CreatePNFile(filename, strOpenTypes);
pascal	code	      exit;
pascal	code	   end;
pascal	code	   Assignfile(t, FileName);
pascal	code	   Reset(t);
pascal	code	   repeat
pascal	code	      Readln(t, s)
pascal	code	   until (Length(s) > 0) or EOF(t);
pascal	code	   CloseFile(t);
pascal	code	   if s = '' then Exit;
pascal	code	   part := Desc;
pascal	code	   repeat
pascal	code	      iPos := Pos(SepChar, s);
pascal	code	      if (iPos = 0) and (Length(s) > 0) then
pascal	code	      begin
pascal	code	         ps := s;
pascal	code	         s := '';
pascal	code	      end else
pascal	code	         ps := Copy(s, 1, ipos - 1);
pascal	code	      s := Copy(S, ipos + 1, Length(s));
pascal	code	      case part of
pascal	code	         Desc : begin
pascal	code	                  OutStr := OutStr + SepChar + ps;
pascal	code	                  part := Files;
pascal	code	                end;
pascal	code	         Files : begin
pascal	code	                   OutStr := OutStr + SepChar + ps;
pascal	code	                   part := Parser;
pascal	code	                 end;
pascal	code	         Parser : begin
pascal	code	                    OutStr := OutStr + SepChar + ps + SepChar + '0' + SepChar + '0';
pascal	code	                    part := Desc;
pascal	code	                  end;
pascal	code	      end;
pascal	code	   until Length(s) < 1;
pascal	code	   Assignfile(t, filename);
pascal	code	   Rewrite(t);
pascal	code	   Write(t, OutStr);
pascal	code	   CloseFile(t);
pascal	code	end;
pascal	blank	
pascal	code	end.
pascal	blank	
pascal	code	class function Test.Run: Boolean;
pascal	blank	
pascal	code	#include <test.rh>
