#include <cmqc.h>      /* MQ API header file       */
//

#define NUMBEROFSELECTORS  2

const MQHCONN Hconn = MQHC_DEF_HCONN;


static void InquireGetAndPut(char   *Message,
		PMQHOBJ pHobj,
		char   *Object)
{
	/*      Declare local variables                       */
	/*                                                    */
	MQLONG  SelectorCount = NUMBEROFSELECTORS;
	/* Number of selectors  */
	MQLONG  IntAttrCount  = NUMBEROFSELECTORS;
	/* Number of int attrs  */
	MQLONG  CharAttrLength = 0;
	/* Length of char attribute buffer  */
	MQCHAR *CharAttrs ;
	/* Character attribute buffer       */
	MQLONG  SelectorsTable[NUMBEROFSELECTORS];
	/* attribute selectors  */
	MQLONG  IntAttrsTable[NUMBEROFSELECTORS];
	/* integer attributes   */
	MQLONG  CompCode;             /* Completion code      */
	MQLONG  Reason;               /* Qualifying reason    */
	/*                                                    */
	/*     Open the queue.  If successful, do the inquire */
	/*     call.                                          */
	/*                                                    */
	/*                                                 */
	/*   Initialize the variables for the inquire      */
	/*   call:                                         */
	/*    - Set SelectorsTable to the attributes whose */
	/*      status is                                  */
	/*       required                                  */
	/*    - All other variables are already set        */
	/*                                                 */
	SelectorsTable[0] = MQIA_INHIBIT_GET;
	SelectorsTable[1] = MQIA_INHIBIT_PUT;
	/*                                                 */
	/*   Issue the inquire call                        */
	/*     Test the output of the inquire call. If the */
	/*     call failed, display an error message       */
	/*     showing the completion code and reason code,*/
	/*     otherwise display the status of the         */
	/*     INHIBIT-GET and INHIBIT-PUT attributes      */
	/*                                                 */
	MQINQ(Hconn,
			*pHobj,
			SelectorCount,
			SelectorsTable,
			IntAttrCount,
			IntAttrsTable,
			CharAttrLength,
			CharAttrs,
			&CompCode,
			&Reason);
	if (CompCode != MQCC_OK)
	{
		sprintf(Message, MESSAGE_4_E,
				ERROR_IN_MQINQ, CompCode, Reason);
		SetMsg(Message);
	}
	else
	{
		/* Process the changes */
	} /* end if CompCode */
