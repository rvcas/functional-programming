My lectures are based on Dr. Gary Leavens' lecture notes for COP4020.  I have made
many changes.  

Below is his orginal README.txt:
-------------------------------------------------------------------
These lecture notes are copyright (c) 2006-2007 by Gary T. Leavens.
Permission is granted for you to make copies for educational and scholarly
purposes, but not for direct commercial advantage, provided this notice
appears on all copies.  All other rights reserved.

The lecture notes in this directory are organized hierarchically.

The units are described in the file Outline-units.txt.
The format of Outline-units is that lines beginning with a * name units,
those with one asterisk (*) are major units,
those with two (**) are subunits, etc.
Each unit name that begins with a lower-case letter (a-z) is also the name
of a directory found in this directory that contains the lecture notes on
that unit.

To get the names of the unit directories in their proper order,
execute the command
	~leavens/bin/lecture-units.

The files in a unit directory are described in the file Outline-files.txt
found in that directory.
The format of Outline-files is that lines beginning with a * name topics,
those with one asterisk (*) are major topics,
those with two (**) are subtopics, etc.
Each topic name that begins with a lower-case letter (a-z) is also the name
of a file found in the unit directory that contains lecture notes on
that topic.

To get the names of the files in a unit in their proper order,
execute the command
	~leavens/bin/unit files
There are also commands to extract the outline of a unit (unit outline)
any examples (enclosed in pairs of lines of the form -------) (unit examples)
and handouts that combine the outline with the examples and questions
(unit handouts).  For all but the examples and dump options of unit
 you'll need to have ~leavens/bin/${MACHINE}/emacs_std_outline in your PATH,
where ${MACHINE} is the kind of machine you're running (e.g., a hp9000).

The outline style of the topic files follows the same style as above
(emacs outline format).  There is a command, ~leavens/bin/note,
that understands the format of individual note files.
For example to extract the standard outline of a file, execute
	~leavens/bin/note outline
(You'll need to have ~leavens/bin/${MACHINE}/emacs_std_outline in your PATH.)
