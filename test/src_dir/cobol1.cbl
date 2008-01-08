000010 IDENTIFICATION DIVISION.                       
000020 PROGRAM-ID. LINE-NO-PROG.                        
000030 AUTHOR.     TIM R P BROWN.    
000040****************************************************
000050* Program to add line numbers to typed code        *    
000060* Allows for comment asterisk, solidus, or hyphen ,*     
000070* moving it into position 7.                       *  
000080*                                                  *  
000090****************************************************  
000100                              
000110 ENVIRONMENT DIVISION.              
000120 INPUT-OUTPUT SECTION.              
000130 FILE-CONTROL.                 
000140     SELECT IN-FILE ASSIGN TO 'INPUT.TXT'     
000150        ORGANIZATION IS LINE SEQUENTIAL.  
000160     SELECT OUT-FILE ASSIGN TO 'OUTPUT.COB'      
000170        ORGANIZATION IS LINE SEQUENTIAL. 
000180 
000185*****************************************************
000187                    
000190 DATA DIVISION.                     
000200 FILE SECTION.                   
000210             
000220 FD IN-FILE.                      
