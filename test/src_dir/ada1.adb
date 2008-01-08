		 with Ada.Text_IO; use Ada.Text_IO;

		 procedure Get_Name is

			 Name   : String (1..80);
			 Length : Integer;

		 begin
			 -- no variables needed here :)
			 
			 Put ("Enter your first name> ");
			 Get_Line (Name, Length);
			 New_Line;
			 Put ("Hello ");
			 Put (Name (1..Length));
			 Put (", we hope that you enjoy learning Ada!");

		 end Get_Name;
