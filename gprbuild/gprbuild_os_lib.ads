------------------------------------------------------------------------------
-- Some procedures from gnat GPL 2014 compiler components system.os_lib     --
--                                                                          --
--          Copyright (C) 1995-2014, Free Software Foundation, Inc.         --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.                                     --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------

with System.OS_Lib; use System.OS_Lib;

package Gprbuild_OS_Lib is

   S_Owner  : constant := 1;
   S_Group  : constant := 2;
   S_Others : constant := 4;
   --  Constants for use in Mode parameter to Set_Executable

   procedure Set_Executable (Name : String; Mode : Positive := S_Owner);
   --  Change permissions on the file given by Name to make it executable
   --  for its owner, group or others, according to the setting of Mode.
   --  As indicated, the default if no Mode parameter is given is owner.

   procedure Set_File_Last_Modify_Time_Stamp (Name : String; Time : OS_Time);
   --  Given the name of a file or directory, Name, set the last modification
   --  time stamp. This function must be used for an unopened file.

   function GM_Time_Of
     (Year   : Year_Type;
      Month  : Month_Type;
      Day    : Day_Type;
      Hour   : Hour_Type;
      Minute : Minute_Type;
      Second : Second_Type) return OS_Time;
   --  Analogous to the Time_Of routine in Ada.Calendar, takes a set of time
   --  component parts and returns an OS_Time. Returns Invalid_Time if the
   --  creation fails.
end Gprbuild_OS_Lib;
