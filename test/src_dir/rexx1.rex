/* REXX    FLTTBL     Cloned from DUMPTBL 960619 to produce a flat
                      version (up to 32K characters wide) of any ISPF
                      table.
 
           Written by Frank Clarke, Oldsmar, FL
 
     Impact Analysis
.    SYSPROC   LA
.    SYSPROC   TRAPOUT
 
     Modification History
     19960918 fxc added some error-checking
     19970115 fxc upgrade REXXSKEL from v.960606 to v.970113; add
                  RESTARTability;
     19991231 fxc upgrade REXXSKEL from v.970113 to v.19991109;
                  RXSKLY2K; DECOMM; LRECL reduced from 32K to "min
                  needed";
 
*/ arg argline
address TSO                            /* REXXSKEL ver.19991109      */
arg parms "((" opts
 
signal on syntax
signal on novalue
 
call TOOLKIT_INIT                      /* conventional start-up     -*/
rc     = Trace(tv)
info   = parms                         /* to enable parsing          */
 
if \sw.inispf  then do
   arg line
   line = line "((  RESTARTED"         /* tell the next invocation   */
   "ISPSTART CMD("exec_name line")"    /* Invoke ISPF if nec.        */
   exit                                /* ...and restart it          */
   end
 
call A_INIT                            /*                           -*/
 
"NEWSTACK"
                                    if \sw.0error_found then,
call C_TABLE_OPS                       /*                           -*/
                                    if \sw.0error_found then,
call D_PUMP_TBL                        /*                           -*/
 
"DELSTACK"
 
if sw.restarted then do
   rc = OutTrap("ll.")
   exit 4
   end
 
exit                                   /*@ FLTTBL                    */
/*
.  ----------------------------------------------------------------- */
A_INIT:                                /*@                           */
   if branch then call BRANCH
   address TSO
 
   call AA_KEYWDS                      /*                           -*/
   parse var info  $tn$    .           /* table-name required        */
   if $tn$ = "" then do
      helpmsg = "Tablename is required."
      call HELP
      end
 
   parse value outdsn "FLATTBLS."$tn$     with,
               outdsn  .
 
   xefef     = "efef"x
   if tblds = "" then do
      call AB_FIND_LIBRARY             /*                           -*/
      if tblds = "" then do
         helpmsg = "Table" $tn$ "was not found in ISPTLIB.  Please",
                   "restart specifying a library name as shown below."
         call HELP                     /* ...and don't come back     */
         end
      end
   else,
   if Left(tblds,1) = "'" then tblds = Strip(tblds,,"'")
                          else tblds = Userid()"."tblds
 
return                                 /*@ A_INIT                    */
/*
.  ----------------------------------------------------------------- */
AA_KEYWDS:                             /*@                           */
   if branch then call BRANCH
   address TSO
 
   tblds       = KEYWD("IN")
   outdsn      = KEYWD("OUTPUT")
   sortseq     = KEYWD("SORT")
   sw.0purge   = SWITCH("DELETEBEHIND")
 
   parse value KEYWD("ADD") "0"  with  bytes_to_add  .
 
return                                 /*@ AA_KEYWDS                 */
/*
   <tblds> was not specified.  Locate the table in ISPTLIB.
.  ----------------------------------------------------------------- */
AB_FIND_LIBRARY:                       /*@                           */
   if branch then call BRANCH
   address TSO
 
   "NEWSTACK"
   "LA ISPTLIB ((STACK LINE"
   pull tliblist
   "DELSTACK"
 
   do Words(tliblist)                  /* each library               */
      parse var tliblist  tblds  tliblist
      if Sysdsn("'"tblds"("$tn$")'") = "OK" then return
   end                                 /* tliblist                   */
   tblds = ""
 
return                                 /*@ AB_FIND_LIBRARY           */
/*
.  ----------------------------------------------------------------- */
C_TABLE_OPS:                           /*@                           */
   if branch then call BRANCH
   address ISPEXEC
 
   call CA_OPEN_TBL                    /*                           -*/
   call CS_SPIN_TBL                    /*                           -*/
   call CZ_DROP_TBL                    /*                           -*/
 
return                                 /*@ C_TABLE_OPS               */
/*
.  ----------------------------------------------------------------- */
CA_OPEN_TBL:                           /*@                           */
   if branch then call BRANCH
   address ISPEXEC
 
   "LIBDEF ISPTLIB DATASET ID('"tblds"')  STACK"
   "TBSTATS" $tn$ "STATUS1(s1) STATUS2(s2) ROWCURR(rowct)"
   if s1 > 1 then do
      say "Table" $tn$ "not available."
      sw.0error_found = "1"; return
      end; else,
   if s2 = 1 then,                     /* not open                   */
      "TBOPEN " $tn$ "NOWRITE"
   else "TBTOP" $tn$
   "LIBDEF ISPTLIB"
                                       if sw.0error_found then return
   "TBQUERY" $tn$  "KEYS(keylist)",
                   "NAMES(nmlist)"
   parse var keylist "(" keylist ")"
   parse var  nmlist "("  nmlist ")"
   namelist = keylist nmlist
 
   if sortseq <> "" then "TBSORT" $tn$ "FIELDS("sortseq")"
 
return                                 /*@ CA_OPEN_TBL               */
/*
.  Given: <namelist> contains all the defined names for this table.
   The table has been TOPped.
.  ----------------------------------------------------------------- */
CS_SPIN_TBL: Procedure expose,         /*@ hide everything           */
      expose (tk_globalvars),          /* except these               */
      $tn$  namelist  xefef  tblds  rows  keylist  nmlist  maxlen
                                                        cs_tv = Trace()
   if branch then call BRANCH
   address ISPEXEC
 
   maxlen = 0                          /* maximum line length        */
   do forever
      "TBSKIP" $tn$ "SAVENAME(xvars)"
      if rc > 0 then leave             /* we're done...              */
      line  = ""                       /* set empty                  */
                           /* add blocks of "var .. varvalue .."     */
      do cx = 1 to Words(namelist)
         thiswd = Word(namelist,cx)
         line = line thiswd xefef Value(thiswd) xefef
      end                              /* cx                         */
      rc = Trace("O"); rc = Trace(cs_tv)
      parse var xvars "(" xvars ")"
                           /* add a block of "XVARS .. xvarlist .."  */
      line = line "XVARS" xefef xvars xefef
                           /* add blocks of "xvar .. xvarvalue .."   */
      do cx = 1 to Words(xvars)
         thiswd = Word(xvars,cx)
         line = line thiswd xefef Value(thiswd) xefef
      end                              /* cx                         */
      rc = Trace("O"); rc = Trace(cs_tv)
      maxlen  = Max(maxlen,Length(line))
      queue line
   end                                 /* forever                    */
 
   lines_in_stack = queued()
   line = "Contents of" $tn$ "in" tblds,
          "("lines_in_stack" rows)  KEYS("keylist")  NAMES("nmlist")."
   push line                           /* make it the first line     */
   maxlen  = Max(maxlen,Length(line))
   if monitor then say "Maximum line length is" maxlen
 
return                                 /*@ CS_SPIN_TBL               */
/*
.  ----------------------------------------------------------------- */
CZ_DROP_TBL:                           /*@                           */
   if branch then call BRANCH
   address ISPEXEC
 
   if s2 = 1 then,                     /* table was not open at start*/
      "TBEND" $tn$
 
return                                 /*@ CZ_DROP_TBL               */
/*
.  ----------------------------------------------------------------- */
D_PUMP_TBL:                            /*@                           */
   if branch then call BRANCH
   address TSO
 
   if monitor then say,
      "Writing text."
 
   maxlen = maxlen + 4 + bytes_to_add  /* set LRECL                  */
   vbmax.0   = "NEW CATALOG UNIT(SYSDA) SPACE(1 5) TRACKS",
                    "RECFM(V B) LRECL("maxlen") BLKSIZE(0)"
   vbmax.1   = "SHR"                   /* if it already exists...    */
 
   tempstat = Sysdsn(outdsn) = "OK"    /* 1=exists, 0=missing        */
   "ALLOC FI($TMP) DA("outdsn") REU" vbmax.tempstat
   rcx = rc
   "EXECIO" queued() "DISKW $TMP (FINIS"
   rcx = max(rcx,rc)
   "FREE  FI($TMP)"
 
   if rcx = 0 & sw.0purge then do
      address ISPEXEC
      "LIBDEF  ISPTLIB  DATASET  ID('"tblds"')  STACK"
      "TBERASE" $tn$
      if rc = 0 then say $tn$ "was deleted"
      "LIBDEF  ISPTLIB"
      end
 
return                                 /*@ D_PUMP_TBL                */
/*
.  ----------------------------------------------------------------- */
LOCAL_PREINIT:                         /*@ customize opts            */
   if branch then call BRANCH
   address TSO
 
 
return                                 /*@ LOCAL_PREINIT             */
/*
.  ----------------------------------------------------------------- */
HELP:                                  /*@                           */
address TSO;"CLEAR"
if helpmsg <> "" then do ; say helpmsg; say ""; end
ex_nam = Left(exec_name,8)             /* predictable size           */
say "  "ex_nam"      produces a flattened version of any ISPF table    "
say "                into a VB-form dataset of minimum necessary LRECL."
say "                                                                  "
say "   The field contents are written in KEYPHRS format               "
say "             (var .. varval ..)                                   "
say "   key-fields first, followed by name-fields, followed by the     "
say "   names of any extension variables key-phrased by 'XVARS',       "
say "   followed by the extension variables themselves in KEYPHRS      "
say "   format.                                                        "
say "                                                                  "
say "   The first record on the file identifies the table name, the    "
say "   source library, the number of rows processed, and the key- and "
say "   name-fields.                                                   "
say "                                                                  "
say "                                             more....             "
pull
"CLEAR"
say "  Syntax:   "ex_nam"  <tbl>                             (Required)"
say "                      <IN     libdsn>                             "
say "                      <OUTPUT outdsn>                   (Defaults)"
say "                      <SORT   sortspec>                           "
say "                      <ADD    bytes>                    (Defaults)"
say "                                                                          "
say "            <tbl>     identifies the table to be dumped.                  "
say "                                                                          "
say "            <libdsn>  identifies the ISPF Table library which holds <tbl>."
say "                      If <libdsn> is not specified, ISPTLIB will be       "
say "                      searched to find the correct dataset.               "
say "                                                                          "
say "            <outdsn>  (default: FLATTBLS.<tbl>) names the output file.    "
say "                      <outdsn> will be created if it does not exist.      "
say "                                                                          "
say "            <sortspec> causes the table to be sorted as indicated before  "
say "                      being dumped.                                       "
say "                                                                          "
say "            <bytes>   (default=0) causes the LRECL of the output dataset  "
say "                      to be extended to enable updating.                  "
pull
"CLEAR"
say "   Debugging tools provided include:                              "
say "                                                                  "
say "        MONITOR:  displays key information throughout processing. "
say "                  Displays most paragraph names upon entry.       "
say "                                                                  "
say "        NOUPDT:   by-pass all update logic.                       "
say "                                                                  "
say "        BRANCH:   show all paragraph entries.                     "
say "                                                                  "
say "        TRACE tv: will use value following TRACE to place the     "
say "                  execution in REXX TRACE Mode.                   "
say "                                                                  "
say "                                                                  "
say "   Debugging tools can be accessed in the following manner:       "
say "                                                                  "
say "        TSO "ex_nam"  parameters     ((  debug-options            "
say "                                                                  "
say "   For example:                                                   "
say "                                                                  "
say "        TSO "ex_nam" vt2231 add 17 (( MONITOR TRACE ?R            "
address ISPEXEC "CONTROL DISPLAY REFRESH"
exit                                   /*@ HELP                      */
/*   REXXSKEL back-end removed for space   */
