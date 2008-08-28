pike	comment	//
pike	comment	// LPD.pmod: an implementation of the BSD lpd protocol (RFC 1179).
pike	comment	// This is a module for pike.
pike	comment	// 3 July 1998 <hww3@riverweb.com> Bill Welliver
pike	comment	//
pike	comment	// $Id: LPD.pmod,v 1.10 2008/01/13 17:02:43 nilsson Exp $
pike	comment	//
pike	blank	
pike	code	#pike __REAL_VERSION__
pike	blank	
pike	comment	//! A client for communicating with printers and print spoolers that
pike	comment	//! support the BSD lpd protocol (RFC 1179).
pike	code	class client {
pike	code	  string host;
pike	code	  int port;
pike	code	  private object conn;
pike	code	  int jobnum;
pike	code	  string jobtype;
pike	code	  string jobname;
pike	blank	
pike	code	  private int connect(string host, int port)
pike	code	  {
pike	code	    int a=random(10);
pike	comment	    // try to open one of the "official" local socket ports.
pike	comment	    // not having one doesn't seem to be a problem with most LPD 
pike	comment	    // servers, but we should at least try. will probably fail
pike	comment	    // if two try to open the same local port at once. ymmv.
pike	code	    int res=conn->open_socket(721 + a);
pike	blank	
pike	code	    return conn->connect(host, port);
pike	code	  }
pike	blank	
pike	comment	//! @decl int set_job_type(string type)
pike	comment	//! Set the type of job to be sent to the printer to @i{type@}.
pike	comment	//! Valid types are: text, postscript and raw.
pike	code	  int set_job_type(string type)
pike	code	  {
pike	code	    type=lower_case(type);
pike	blank	
pike	code	    switch (type) { 
pike	code	     case "f":
pike	code	     case "text":
pike	code	      jobtype="f";
pike	code	      break;
pike	blank	
pike	code	     case "o":
pike	code	     case "postscript":
pike	code	     case "ps":
pike	code	      jobtype="o";
pike	code	      break;
pike	blank	
pike	code	     default:
pike	code	     case "l":
pike	code	     case "raw":
pike	code	      jobtype="l";
pike	code	      break;
pike	code	    }
pike	code	    return 1;
pike	code	  }
pike	blank	
pike	comment	//! @decl int set_job_name(string name)
pike	comment	//! Sets the name of the print job to @i{name@}.
pike	code	  int set_job_name(string name)
pike	code	  {
pike	code	    jobname=name;
pike	code	    return 1;
pike	code	  }
pike	blank	
pike	comment	//! @decl int start_queue(string queue)
pike	comment	//! Start the queue @i{queue@} if not already printing.
pike	comment	//! @returns
pike	comment	//! Returns 0 if unable to connect, 1 otherwise. 
pike	code	  int start_queue(string queue)
pike	code	  {
pike	code	    if(!queue) return 0;
pike	blank	
pike	code	    if(!connect(host, port))
pike	code	      return 0;
pike	blank	
pike	code	    conn->write(sprintf("%c%s\n", 01, queue));
pike	code	    string resp= conn->read();
pike	code	    conn->close();
pike	code	    return 1;
pike	code	  }
pike	blank	
pike	comment	//! @decl string|int send_job(string queue, string job)
pike	comment	//! Send print job consisting of data @i{job@} to printer @i{queue@}.
pike	comment	//! @returns
pike	comment	//! Returns 1 if success, 0 otherwise.
pike	code	  int send_job(string queue, string job)
pike	code	  {
pike	code	    string resp;
pike	blank	
pike	code	    if(!queue) return 0;
pike	blank	
pike	code	    if(!connect(host, port))
pike	code	      return 0;
pike	comment	    // werror("connected to " + host + "\n");
pike	blank	
pike	code	    string control="";
pike	code	    control+="H"+gethostname()+"\n";
pike	code	#if constant(getuid) && constant(getpwuid)
pike	code	    control+="P"+(getpwuid(getuid())[0]||"nobody")+"\n";
pike	code	#else
pike	code	    control+="P-1\n";
pike	code	#endif
pike	code	    control+=(jobtype||"l")+"dfA"+ sprintf("%03d%s", jobnum, gethostname())+"\n";
pike	code	    if(jobname)
pike	code	    {
pike	code	      control+="J" + jobname + "\n";
pike	code	      control+="N" + jobname + "\n";
pike	code	    }
pike	code	    else
pike	code	    { 
pike	code	      control+="JPike LPD Client Job " + jobnum + "\n";
pike	code	      control+="NPike LPD Client Job " + jobnum + "\n";
pike	code	    }
pike	code	    jobnum++;
pike	code	werror("job file:\n\n" + control  + "\n\n");
pike	blank	
pike	code	    conn->write(sprintf("%c%s\n", 02, queue));
pike	code	    resp=conn->read(1);
pike	code	    if((int)resp !=0)
pike	code	    {
pike	code	      werror("receive job failed.\n");
pike	code	      return 0;
pike	code	    }
pike	blank	
pike	code	    conn->write(sprintf("%c%s cfA%03d%s\n", 02, (string)sizeof(control),
pike	code				jobnum,gethostname()));
pike	blank	
pike	code	    resp=conn->read(1);
pike	code	    if((int)resp !=0)
pike	code	    {
pike	code	      werror("request receive control failed.\n");
pike	code	      return 0;
pike	code	    }
pike	blank	
pike	code	    conn->write(sprintf("%s%c", control, 0));
pike	blank	
pike	code	    resp=conn->read(1);
pike	code	    if((int)resp !=0)
pike	code	    {
pike	code	      werror("send receive control failed.\n");
pike	code	      return 0;
pike	code	    }
pike	blank	
pike	code	    conn->write(sprintf("%c%s dfA%03d%s\n", 03, (string)sizeof(job), jobnum,
pike	code				gethostname()));
pike	code	    resp=conn->read(1);
pike	code	    if((int)resp !=0)
pike	code	    {
pike	code	      werror("request receive job failed.\n");
pike	code	      return 0;
pike	code	    }
pike	blank	
pike	blank	
pike	code	    conn->write(sprintf("%s%c", job, 0));
pike	blank	
pike	code	    resp=conn->read(1);
pike	code	    if((int)resp !=0)
pike	code	    {
pike	code	      werror("send receive job failed.\n");
pike	code	      return 0;
pike	code	    }
pike	blank	
pike	blank	
pike	blank	
pike	comment	    // read the response. 
pike	blank	
pike	comment	//    resp=conn->read();
pike	code	    if((int)(resp)!=0) 
pike	code	    { 
pike	code	      conn->close();
pike	code	      return 0;
pike	code	    }
pike	code	    conn->close();
pike	comment	//    start_queue(queue);
pike	code	    return 1;
pike	code	  }
pike	blank	
pike	comment	//! @decl int delete_job(string queue, int|void job)
pike	comment	//! Delete job @i{job@} from printer @i{queue@}.
pike	comment	//! @returns
pike	comment	//! Returns 1 on success, 0 otherwise.
pike	code	  int delete_job(string queue, int|void job)
pike	code	  {
pike	code	    if(!queue) return 0;
pike	blank	
pike	code	    if(!connect(host, port))
pike	code	      return 0;
pike	blank	
pike	code	#if constant(getpwuid) && constant(getuid)
pike	code	    string agent=(getpwuid(getuid())[0]||"nobody");
pike	code	#else
pike	code	    string agent="nobody";
pike	code	#endif
pike	blank	
pike	code	    if(job)
pike	code	      conn->write(sprintf("%c%s %s %d\n", 05, queue, agent, job));
pike	code	    else
pike	code	      conn->write(sprintf("%c%s %s\n", 05, queue, agent));
pike	code	    string resp= conn->read();
pike	code	    conn->close();
pike	code	    return 1;
pike	code	  }
pike	blank	
pike	blank	
pike	comment	//! @decl string|int status(string queue)
pike	comment	//! Check the status of queue @i{queue@}.
pike	comment	//! @returns
pike	comment	//! Returns 0 on failure, otherwise returns the status response from the printer.
pike	code	  string|int status(string queue)
pike	code	  {
pike	code	    if(!queue) return 0;
pike	blank	
pike	code	    if(!connect(host, port))
pike	code	      return 0;
pike	blank	
pike	code	    conn->write(sprintf("%c%s\n", 04, queue));
pike	code	    string resp= conn->read();
pike	code	    conn->close();
pike	code	    return resp;
pike	code	  }
pike	blank	
pike	comment	//! Create a new LPD client connection.
pike	comment	//! @param hostname
pike	comment	//! Contains the hostname or ipaddress of the print host.
pike	comment	//! if not provided, defaults to @i{localhost@}.
pike	comment	//! @param portnum
pike	comment	//! Contains the port the print host is listening on.
pike	comment	//! if not provided, defaults to port @i{515@}, the RFC 1179 standard.
pike	code	  void create(string|void hostname, int|void portnum)
pike	code	  {
pike	code	    host=hostname || "localhost";
pike	code	    port=portnum || 515;
pike	code	    conn=Stdio.File();
pike	code	    jobnum=1;
pike	code	  }
pike	code	}
pike	blank	
