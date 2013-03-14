exh-computer-controller
======================

This is application uses the LSC API cache endpoint to remotely control computers and appications. The process is as follows...

1. A user installs the client on the machine
2. On client startup the machine creates a key (the key is the computer id) in the EXHCOMPUTERCOMMAND group
2. A user clicks a "shutdown down" button on the web interface.
3. The web interface posts the command to the corresponding enpoint key (the computer ID)
4. Every 60 seconds the client checks that endpoint and if a new command is present excutes that command


Commands
======================
The commands that are posted are as follow

* `CMD:SHUTDOWN` - shutdowns the computer.
* `CMD:RESTART` - restarts the computer
* `EVAL:%COMMANDS%` - excutes the %COMMANDS% (for instance if on a windows machine. Newline is represented by |newline|. An example would be `EVAL:MOUSEMOVE,400,400|newline|Msgbox,done`)


Clients
======================
Each operating systems has a different client software

Windows - Windows uses autohotkey for client. If you wish to compile the AHK to exe you have to download the compiler. 


Installation
======================
For more information see trac: http://trac.lsc.org/wiki/Tech/Exhibits/computercontroller