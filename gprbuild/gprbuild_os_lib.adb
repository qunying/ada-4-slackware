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

with Interfaces.C.Strings; use Interfaces.C.Strings;

package body Gprbuild_OS_Lib is

   procedure Set_Executable (Name : String; Mode : Positive := S_Owner) is
      procedure C_Set_Executable (Name : chars_ptr; Mode : Integer);
      pragma Import (C, C_Set_Executable, "gprbuild_gnat_set_executable");
   begin
      C_Set_Executable (New_String (Name), Mode);
   end Set_Executable;

   procedure Set_File_Last_Modify_Time_Stamp (Name : String; Time : OS_Time) is
      procedure C_Set_File_Time (Name : chars_ptr; Time : OS_Time);
      pragma Import (C, C_Set_File_Time, "gprbuild_gnat_set_file_time_name");
   begin
      C_Set_File_Time (New_String (Name), Time);
   end Set_File_Last_Modify_Time_Stamp;

   function GM_Time_Of
     (Year   : Year_Type;
      Month  : Month_Type;
      Day    : Day_Type;
      Hour   : Hour_Type;
      Minute : Minute_Type;
      Second : Second_Type) return OS_Time
   is
      function To_OS_Time (Year, Month, Day, Hours, Mins, Secs : Integer)
        return OS_Time;
      pragma Import (C, To_OS_Time, "gprbuild_gnat_to_os_time");
   begin
      return To_OS_Time (Year - 1900, Month - 1, Day, Hour, Minute, Second);
   end GM_Time_Of;
end Gprbuild_OS_Lib;
