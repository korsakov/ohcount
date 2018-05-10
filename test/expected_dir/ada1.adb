ada	code			 with Ada.Text_IO; use Ada.Text_IO;
ada	blank	
ada	code			 procedure Get_Name is
ada	blank	
ada	code				 Name   : String (1..80);
ada	code				 Length : Integer;
ada	blank	
ada	code			 begin
ada	comment				 -- no variables needed here :)
ada	blank	
ada	code				 Put ("Enter your first name> ");
ada	code				 Get_Line (Name, Length);
ada	code				 New_Line;
ada	code				 Put ("Hello ");
ada	code				 Put (Name (1..Length));
ada	code				 Put (", we hope that you enjoy learning Ada!");
ada	blank	
ada	code			 end Get_Name;
