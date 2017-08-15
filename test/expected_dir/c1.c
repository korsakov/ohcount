c	code	#include <cmqc.h>      /* MQ API header file       */
c	comment	//
c	blank	
c	code	#define NUMBEROFSELECTORS  2
c	blank	
c	code	const MQHCONN Hconn = MQHC_DEF_HCONN;
c	blank	
c	blank	
c	code	static void InquireGetAndPut(char   *Message,
c	code			PMQHOBJ pHobj,
c	code			char   *Object)
c	code	{
c	comment		/*      Declare local variables                       */
c	comment		/*                                                    */
c	code		MQLONG  SelectorCount = NUMBEROFSELECTORS;
c	comment		/* Number of selectors  */
c	code		MQLONG  IntAttrCount  = NUMBEROFSELECTORS;
c	comment		/* Number of int attrs  */
c	code		MQLONG  CharAttrLength = 0;
c	comment		/* Length of char attribute buffer  */
c	code		MQCHAR *CharAttrs ;
c	comment		/* Character attribute buffer       */
c	code		MQLONG  SelectorsTable[NUMBEROFSELECTORS];
c	comment		/* attribute selectors  */
c	code		MQLONG  IntAttrsTable[NUMBEROFSELECTORS];
c	comment		/* integer attributes   */
c	code		MQLONG  CompCode;             /* Completion code      */
c	code		MQLONG  Reason;               /* Qualifying reason    */
c	comment		/*                                                    */
c	comment		/*     Open the queue.  If successful, do the inquire */
c	comment		/*     call.                                          */
c	comment		/*                                                    */
c	comment		/*                                                 */
c	comment		/*   Initialize the variables for the inquire      */
c	comment		/*   call:                                         */
c	comment		/*    - Set SelectorsTable to the attributes whose */
c	comment		/*      status is                                  */
c	comment		/*       required                                  */
c	comment		/*    - All other variables are already set        */
c	comment		/*                                                 */
c	code		SelectorsTable[0] = MQIA_INHIBIT_GET;
c	code		SelectorsTable[1] = MQIA_INHIBIT_PUT;
c	comment		/*                                                 */
c	comment		/*   Issue the inquire call                        */
c	comment		/*     Test the output of the inquire call. If the */
c	comment		/*     call failed, display an error message       */
c	comment		/*     showing the completion code and reason code,*/
c	comment		/*     otherwise display the status of the         */
c	comment		/*     INHIBIT-GET and INHIBIT-PUT attributes      */
c	comment		/*                                                 */
c	code		MQINQ(Hconn,
c	code				*pHobj,
c	code				SelectorCount,
c	code				SelectorsTable,
c	code				IntAttrCount,
c	code				IntAttrsTable,
c	code				CharAttrLength,
c	code				CharAttrs,
c	code				&CompCode,
c	code				&Reason);
c	code		if (CompCode != MQCC_OK)
c	code		{
c	code			sprintf(Message, MESSAGE_4_E,
c	code					ERROR_IN_MQINQ, CompCode, Reason);
c	code			SetMsg(Message);
c	code		}
c	code		else
c	code		{
c	comment			/* Process the changes */
c	code		} /* end if CompCode */
