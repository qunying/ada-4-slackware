/**************************************************************************** 
 * Some missing functions for GCC 4.9.2                                     *
 * from gnat gpl 2014 adaint.c                                              *
 *                                                                          *
 *          Copyright (C) 1992-2014, Free Software Foundation, Inc.         *   
 *                                                                          *   
 * GNAT is free software;  you can  redistribute it  and/or modify it under *   
 * terms of the  GNU General Public License as published  by the Free Soft- *   
 * ware  Foundation;  either version 3,  or (at your option) any later ver- *   
 * sion.  GNAT is distributed in the hope that it will be useful, but WITH- *   
 * OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY *   
 * or FITNESS FOR A PARTICULAR PURPOSE.                                     *   
 *                                                                          *   
 * You should have received a copy of the GNU General Public License and    *   
 * a copy of the GCC Runtime Library Exception along with this program;     *   
 * see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    *   
 * <http://www.gnu.org/licenses/>.                                          *   
 *                                                                          *   
 * GNAT was originally developed  by the GNAT team at  New York University. *   
 * Extensive contributions were provided by Ada Core Technologies Inc.      *   
 *                                                                          *   
 ****************************************************************************/

#define _LARGEFILE64_SOURCE

#include <sys/stat.h>
#include <utime.h>
#include <time.h>

#define S_OWNER  1
#define S_GROUP  2
#define S_OTHERS 4

void
gprbuild_gnat_set_executable (char *name, int mode)
{
    struct stat64 statbuf;

    if (stat64 (name, &statbuf) == 0) {
        if (mode & S_OWNER)
            statbuf.st_mode |= S_IXUSR;
        if (mode & S_GROUP)
            statbuf.st_mode |= S_IXGRP;
        if (mode & S_OTHERS)
            statbuf.st_mode |= S_IXOTH;
        chmod (name, statbuf.st_mode);
    } // end if
} // end gprbuild_gnat_set_executable

typedef long OS_Time;

void
gprbuild_gnat_set_file_time_name (char *name, time_t time_stamp)
{
    struct utimbuf utimbuf;
    time_t t;

    /* Set modification time to requested time.  */
    utimbuf.modtime = time_stamp;

    /* Set access time to now in local time.  */
    t = time ((time_t) 0);
    utimbuf.actime = mktime (localtime (&t));

    utime (name, &utimbuf);
} // end gprbuild_gnat_set_file_time_name

OS_Time
gprbuild_gnat_to_os_time (int year, int month, int day,
			  int hours, int mins, int secs)
{
  struct tm v;

  v.tm_year  = year;
  v.tm_mon   = month;
  v.tm_mday  = day;
  v.tm_hour  = hours;
  v.tm_min   = mins;
  v.tm_sec   = secs;
  v.tm_isdst = 0;

  /* returns -1 of failing, this is s-os_lib Invalid_Time */

  return (OS_Time) mktime (&v);
} // end gprbuild_gnat_to_os_time

/* vim: set ts=8 sts=4 sw=4 smarttab expandtab spell : */

