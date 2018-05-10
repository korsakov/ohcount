rexx	comment	/* REXX    FLTTBL     Cloned from DUMPTBL 960619 to produce a flat
rexx	comment	                      version (up to 32K characters wide) of any ISPF
rexx	comment	                      table.
rexx	blank	 
rexx	comment	           Written by Frank Clarke, Oldsmar, FL
rexx	blank	 
rexx	comment	     Impact Analysis
rexx	comment	.    SYSPROC   LA
rexx	comment	.    SYSPROC   TRAPOUT
rexx	blank	 
rexx	comment	     Modification History
rexx	comment	     19960918 fxc added some error-checking
rexx	comment	     19970115 fxc upgrade REXXSKEL from v.960606 to v.970113; add
rexx	comment	                  RESTARTability;
rexx	comment	     19991231 fxc upgrade REXXSKEL from v.970113 to v.19991109;
rexx	comment	                  RXSKLY2K; DECOMM; LRECL reduced from 32K to "min
rexx	comment	                  needed";
rexx	blank	 
rexx	code	*/ arg argline
rexx	code	address TSO                            /* REXXSKEL ver.19991109      */
rexx	code	arg parms "((" opts
rexx	blank	
rexx	code	signal on syntax
rexx	code	signal on novalue
rexx	blank	
rexx	code	call TOOLKIT_INIT                      /* conventional start-up     -*/
rexx	code	rc     = Trace(tv)
rexx	code	info   = parms                         /* to enable parsing          */
rexx	blank	
rexx	code	if \sw.inispf  then do
rexx	code	   arg line
rexx	code	   line = line "((  RESTARTED"         /* tell the next invocation   */
rexx	code	   "ISPSTART CMD("exec_name line")"    /* Invoke ISPF if nec.        */
rexx	code	   exit                                /* ...and restart it          */
rexx	code	   end
rexx	blank	
rexx	code	call A_INIT                            /*                           -*/
rexx	blank	
rexx	code	"NEWSTACK"
rexx	code	                                    if \sw.0error_found then,
rexx	code	call C_TABLE_OPS                       /*                           -*/
rexx	code	                                    if \sw.0error_found then,
rexx	code	call D_PUMP_TBL                        /*                           -*/
rexx	blank	
rexx	code	"DELSTACK"
rexx	blank	
rexx	code	if sw.restarted then do
rexx	code	   rc = OutTrap("ll.")
rexx	code	   exit 4
rexx	code	   end
rexx	blank	
rexx	code	exit                                   /*@ FLTTBL                    */
rexx	comment	/*
rexx	comment	.  ----------------------------------------------------------------- */
rexx	code	A_INIT:                                /*@                           */
rexx	code	   if branch then call BRANCH
rexx	code	   address TSO
rexx	blank	
rexx	code	   call AA_KEYWDS                      /*                           -*/
rexx	code	   parse var info  $tn$    .           /* table-name required        */
rexx	code	   if $tn$ = "" then do
rexx	code	      helpmsg = "Tablename is required."
rexx	code	      call HELP
rexx	code	      end
rexx	blank	
rexx	code	   parse value outdsn "FLATTBLS."$tn$     with,
rexx	code	               outdsn  .
rexx	blank	
rexx	code	   xefef     = "efef"x
rexx	code	   if tblds = "" then do
rexx	code	      call AB_FIND_LIBRARY             /*                           -*/
rexx	code	      if tblds = "" then do
rexx	code	         helpmsg = "Table" $tn$ "was not found in ISPTLIB.  Please",
rexx	code	                   "restart specifying a library name as shown below."
rexx	code	         call HELP                     /* ...and don't come back     */
rexx	code	         end
rexx	code	      end
rexx	code	   else,
rexx	code	   if Left(tblds,1) = "'" then tblds = Strip(tblds,,"'")
rexx	code	                          else tblds = Userid()"."tblds
rexx	blank	
rexx	code	return                                 /*@ A_INIT                    */
rexx	comment	/*
rexx	comment	.  ----------------------------------------------------------------- */
rexx	code	AA_KEYWDS:                             /*@                           */
rexx	code	   if branch then call BRANCH
rexx	code	   address TSO
rexx	blank	
rexx	code	   tblds       = KEYWD("IN")
rexx	code	   outdsn      = KEYWD("OUTPUT")
rexx	code	   sortseq     = KEYWD("SORT")
rexx	code	   sw.0purge   = SWITCH("DELETEBEHIND")
rexx	blank	
rexx	code	   parse value KEYWD("ADD") "0"  with  bytes_to_add  .
rexx	blank	
rexx	code	return                                 /*@ AA_KEYWDS                 */
rexx	comment	/*
rexx	comment	   <tblds> was not specified.  Locate the table in ISPTLIB.
rexx	comment	.  ----------------------------------------------------------------- */
rexx	code	AB_FIND_LIBRARY:                       /*@                           */
rexx	code	   if branch then call BRANCH
rexx	code	   address TSO
rexx	blank	
rexx	code	   "NEWSTACK"
rexx	code	   "LA ISPTLIB ((STACK LINE"
rexx	code	   pull tliblist
rexx	code	   "DELSTACK"
rexx	blank	
rexx	code	   do Words(tliblist)                  /* each library               */
rexx	code	      parse var tliblist  tblds  tliblist
rexx	code	      if Sysdsn("'"tblds"("$tn$")'") = "OK" then return
rexx	code	   end                                 /* tliblist                   */
rexx	code	   tblds = ""
rexx	blank	
rexx	code	return                                 /*@ AB_FIND_LIBRARY           */
rexx	comment	/*
rexx	comment	.  ----------------------------------------------------------------- */
rexx	code	C_TABLE_OPS:                           /*@                           */
rexx	code	   if branch then call BRANCH
rexx	code	   address ISPEXEC
rexx	blank	
rexx	code	   call CA_OPEN_TBL                    /*                           -*/
rexx	code	   call CS_SPIN_TBL                    /*                           -*/
rexx	code	   call CZ_DROP_TBL                    /*                           -*/
rexx	blank	
rexx	code	return                                 /*@ C_TABLE_OPS               */
rexx	comment	/*
rexx	comment	.  ----------------------------------------------------------------- */
rexx	code	CA_OPEN_TBL:                           /*@                           */
rexx	code	   if branch then call BRANCH
rexx	code	   address ISPEXEC
rexx	blank	
rexx	code	   "LIBDEF ISPTLIB DATASET ID('"tblds"')  STACK"
rexx	code	   "TBSTATS" $tn$ "STATUS1(s1) STATUS2(s2) ROWCURR(rowct)"
rexx	code	   if s1 > 1 then do
rexx	code	      say "Table" $tn$ "not available."
rexx	code	      sw.0error_found = "1"; return
rexx	code	      end; else,
rexx	code	   if s2 = 1 then,                     /* not open                   */
rexx	code	      "TBOPEN " $tn$ "NOWRITE"
rexx	code	   else "TBTOP" $tn$
rexx	code	   "LIBDEF ISPTLIB"
rexx	code	                                       if sw.0error_found then return
rexx	code	   "TBQUERY" $tn$  "KEYS(keylist)",
rexx	code	                   "NAMES(nmlist)"
rexx	code	   parse var keylist "(" keylist ")"
rexx	code	   parse var  nmlist "("  nmlist ")"
rexx	code	   namelist = keylist nmlist
rexx	blank	
rexx	code	   if sortseq <> "" then "TBSORT" $tn$ "FIELDS("sortseq")"
rexx	blank	
rexx	code	return                                 /*@ CA_OPEN_TBL               */
rexx	comment	/*
rexx	comment	.  Given: <namelist> contains all the defined names for this table.
rexx	comment	   The table has been TOPped.
rexx	comment	.  ----------------------------------------------------------------- */
rexx	code	CS_SPIN_TBL: Procedure expose,         /*@ hide everything           */
rexx	code	      expose (tk_globalvars),          /* except these               */
rexx	code	      $tn$  namelist  xefef  tblds  rows  keylist  nmlist  maxlen
rexx	code	                                                        cs_tv = Trace()
rexx	code	   if branch then call BRANCH
rexx	code	   address ISPEXEC
rexx	blank	
rexx	code	   maxlen = 0                          /* maximum line length        */
rexx	code	   do forever
rexx	code	      "TBSKIP" $tn$ "SAVENAME(xvars)"
rexx	code	      if rc > 0 then leave             /* we're done...              */
rexx	code	      line  = ""                       /* set empty                  */
rexx	comment	                           /* add blocks of "var .. varvalue .."     */
rexx	code	      do cx = 1 to Words(namelist)
rexx	code	         thiswd = Word(namelist,cx)
rexx	code	         line = line thiswd xefef Value(thiswd) xefef
rexx	code	      end                              /* cx                         */
rexx	code	      rc = Trace("O"); rc = Trace(cs_tv)
rexx	code	      parse var xvars "(" xvars ")"
rexx	comment	                           /* add a block of "XVARS .. xvarlist .."  */
rexx	code	      line = line "XVARS" xefef xvars xefef
rexx	comment	                           /* add blocks of "xvar .. xvarvalue .."   */
rexx	code	      do cx = 1 to Words(xvars)
rexx	code	         thiswd = Word(xvars,cx)
rexx	code	         line = line thiswd xefef Value(thiswd) xefef
rexx	code	      end                              /* cx                         */
rexx	code	      rc = Trace("O"); rc = Trace(cs_tv)
rexx	code	      maxlen  = Max(maxlen,Length(line))
rexx	code	      queue line
rexx	code	   end                                 /* forever                    */
rexx	blank	
rexx	code	   lines_in_stack = queued()
rexx	code	   line = "Contents of" $tn$ "in" tblds,
rexx	code	          "("lines_in_stack" rows)  KEYS("keylist")  NAMES("nmlist")."
rexx	code	   push line                           /* make it the first line     */
rexx	code	   maxlen  = Max(maxlen,Length(line))
rexx	code	   if monitor then say "Maximum line length is" maxlen
rexx	blank	
rexx	code	return                                 /*@ CS_SPIN_TBL               */
rexx	comment	/*
rexx	comment	.  ----------------------------------------------------------------- */
rexx	code	CZ_DROP_TBL:                           /*@                           */
rexx	code	   if branch then call BRANCH
rexx	code	   address ISPEXEC
rexx	blank	
rexx	code	   if s2 = 1 then,                     /* table was not open at start*/
rexx	code	      "TBEND" $tn$
rexx	blank	
rexx	code	return                                 /*@ CZ_DROP_TBL               */
rexx	comment	/*
rexx	comment	.  ----------------------------------------------------------------- */
rexx	code	D_PUMP_TBL:                            /*@                           */
rexx	code	   if branch then call BRANCH
rexx	code	   address TSO
rexx	blank	
rexx	code	   if monitor then say,
rexx	code	      "Writing text."
rexx	blank	
rexx	code	   maxlen = maxlen + 4 + bytes_to_add  /* set LRECL                  */
rexx	code	   vbmax.0   = "NEW CATALOG UNIT(SYSDA) SPACE(1 5) TRACKS",
rexx	code	                    "RECFM(V B) LRECL("maxlen") BLKSIZE(0)"
rexx	code	   vbmax.1   = "SHR"                   /* if it already exists...    */
rexx	blank	
rexx	code	   tempstat = Sysdsn(outdsn) = "OK"    /* 1=exists, 0=missing        */
rexx	code	   "ALLOC FI($TMP) DA("outdsn") REU" vbmax.tempstat
rexx	code	   rcx = rc
rexx	code	   "EXECIO" queued() "DISKW $TMP (FINIS"
rexx	code	   rcx = max(rcx,rc)
rexx	code	   "FREE  FI($TMP)"
rexx	blank	
rexx	code	   if rcx = 0 & sw.0purge then do
rexx	code	      address ISPEXEC
rexx	code	      "LIBDEF  ISPTLIB  DATASET  ID('"tblds"')  STACK"
rexx	code	      "TBERASE" $tn$
rexx	code	      if rc = 0 then say $tn$ "was deleted"
rexx	code	      "LIBDEF  ISPTLIB"
rexx	code	      end
rexx	blank	
rexx	code	return                                 /*@ D_PUMP_TBL                */
rexx	comment	/*
rexx	comment	.  ----------------------------------------------------------------- */
rexx	code	LOCAL_PREINIT:                         /*@ customize opts            */
rexx	code	   if branch then call BRANCH
rexx	code	   address TSO
rexx	blank	
rexx	blank	
rexx	code	return                                 /*@ LOCAL_PREINIT             */
rexx	comment	/*
rexx	comment	.  ----------------------------------------------------------------- */
rexx	code	HELP:                                  /*@                           */
rexx	code	address TSO;"CLEAR"
rexx	code	if helpmsg <> "" then do ; say helpmsg; say ""; end
rexx	code	ex_nam = Left(exec_name,8)             /* predictable size           */
rexx	code	say "  "ex_nam"      produces a flattened version of any ISPF table    "
rexx	code	say "                into a VB-form dataset of minimum necessary LRECL."
rexx	code	say "                                                                  "
rexx	code	say "   The field contents are written in KEYPHRS format               "
rexx	code	say "             (var .. varval ..)                                   "
rexx	code	say "   key-fields first, followed by name-fields, followed by the     "
rexx	code	say "   names of any extension variables key-phrased by 'XVARS',       "
rexx	code	say "   followed by the extension variables themselves in KEYPHRS      "
rexx	code	say "   format.                                                        "
rexx	code	say "                                                                  "
rexx	code	say "   The first record on the file identifies the table name, the    "
rexx	code	say "   source library, the number of rows processed, and the key- and "
rexx	code	say "   name-fields.                                                   "
rexx	code	say "                                                                  "
rexx	code	say "                                             more....             "
rexx	code	pull
rexx	code	"CLEAR"
rexx	code	say "  Syntax:   "ex_nam"  <tbl>                             (Required)"
rexx	code	say "                      <IN     libdsn>                             "
rexx	code	say "                      <OUTPUT outdsn>                   (Defaults)"
rexx	code	say "                      <SORT   sortspec>                           "
rexx	code	say "                      <ADD    bytes>                    (Defaults)"
rexx	code	say "                                                                          "
rexx	code	say "            <tbl>     identifies the table to be dumped.                  "
rexx	code	say "                                                                          "
rexx	code	say "            <libdsn>  identifies the ISPF Table library which holds <tbl>."
rexx	code	say "                      If <libdsn> is not specified, ISPTLIB will be       "
rexx	code	say "                      searched to find the correct dataset.               "
rexx	code	say "                                                                          "
rexx	code	say "            <outdsn>  (default: FLATTBLS.<tbl>) names the output file.    "
rexx	code	say "                      <outdsn> will be created if it does not exist.      "
rexx	code	say "                                                                          "
rexx	code	say "            <sortspec> causes the table to be sorted as indicated before  "
rexx	code	say "                      being dumped.                                       "
rexx	code	say "                                                                          "
rexx	code	say "            <bytes>   (default=0) causes the LRECL of the output dataset  "
rexx	code	say "                      to be extended to enable updating.                  "
rexx	code	pull
rexx	code	"CLEAR"
rexx	code	say "   Debugging tools provided include:                              "
rexx	code	say "                                                                  "
rexx	code	say "        MONITOR:  displays key information throughout processing. "
rexx	code	say "                  Displays most paragraph names upon entry.       "
rexx	code	say "                                                                  "
rexx	code	say "        NOUPDT:   by-pass all update logic.                       "
rexx	code	say "                                                                  "
rexx	code	say "        BRANCH:   show all paragraph entries.                     "
rexx	code	say "                                                                  "
rexx	code	say "        TRACE tv: will use value following TRACE to place the     "
rexx	code	say "                  execution in REXX TRACE Mode.                   "
rexx	code	say "                                                                  "
rexx	code	say "                                                                  "
rexx	code	say "   Debugging tools can be accessed in the following manner:       "
rexx	code	say "                                                                  "
rexx	code	say "        TSO "ex_nam"  parameters     ((  debug-options            "
rexx	code	say "                                                                  "
rexx	code	say "   For example:                                                   "
rexx	code	say "                                                                  "
rexx	code	say "        TSO "ex_nam" vt2231 add 17 (( MONITOR TRACE ?R            "
rexx	code	address ISPEXEC "CONTROL DISPLAY REFRESH"
rexx	code	exit                                   /*@ HELP                      */
rexx	comment	/*   REXXSKEL back-end removed for space   */
