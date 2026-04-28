c Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
c Copyright (C) 2013 - Scilab Enterprises - Cedric Delamarre
c
c Copyright (C) 2012 - 2016 - Scilab Enterprises
c
c This file is hereby licensed under the terms of the GNU GPL v2.0,
c pursuant to article 5.3.4 of the CeCILL v.2.1.
c This file was originally licensed under the terms of the CeCILL v2.1,
c and continues to be available under such terms.
c For more information, see the COPYING file which you should have received
c along with this program.
      function readinter(lunit,fmt)
c     interface for "file" gateway
        integer lunit, readinter
        character*(*) fmt
c
        read(lunit, fmt, err=20, end=30)
c
        readinter = 0
        return
   20   readinter = 2
        return
   30   readinter = 1
        return
      end
