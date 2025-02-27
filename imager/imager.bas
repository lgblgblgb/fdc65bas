0 REM ** MS-DOS DISK IMAGER FOR MEGA65 **
1 REM    PROOF-OF-CONCEPT IN BASIC
2 REM    (C)2025 LGB GABOR LENART

10 IF (PEEK($D60F) AND 32) > 0 THEN MOUNT : REM MAKE SURE U8 IS UNMOUNTED ON REAL HARDWARE
20 BANK 128 : BORDER 15 : BACKGROUND 6
25 IF (PEEK($D031) AND 128) = 0 THEN PRINT CHR$(27)+"X"
30 SCNCLR : PRINT CHR$(5);CHR$(142);"INSERT AN MS-DOS DISK AND PRESS SPACE"
40 GETKEY A$ : IF A$ <> " " THEN 40
50 PRINT
60 BU=$FFD6C00 : TG=$8000000 : TS=TG
70 POKE $D689, PEEK($D689) AND $7F

100 PRINT "READING BOOT RECORD"
110 TR=0:SC=1:HE=0:GOSUB 9000
115 POKE $D080,0
120 IF E<>0 THEN PRINT "SORRY." : END

130 MT=80 : REM ASSUMING 80 TRACKS
132 MS=WPEEK(BU+$18) : MH=WPEEK(BU+$1A) : CP=MT*MH*MS/2

140 PRINT "TRACKS=";MT;"SECTORS=";MS;"HEADS=";MH;"CAPACITY=";CP;"K"
150 IF CP<>720 AND CP<>1440 THEN PRINT "BAD CAPACITY. NOT AN MS-DOS DISK?" : END
155 GOSUB 9500 : REM SHOW DIRECTORY ... WELL PART OF IT ;)
157 POKE $D080,0
160 PRINT "<PRESS SPACE TO START THE PROCESS - OR - STOP KEY TO ABORT>"
170 GETKEY A$ : IF A$ <> " " THEN 170
180 EC=0

199 PRINT : PRINT "READING ALL THE DISK OF";MT;"TRACKS. PLEASE WAIT" : PRINT
200 FOR TR=0 TO MT-1
210 FOR HE=0 TO MH-1
220 FOR SC=1 TO MS
230 GOSUB 9000
232 IF E=0 THEN PRINT CHR$(145); : REM CURSOR UP
234 IF E<>0 THEN PRINT "ERROR COUNTER:";EC
240 IF E=0 THEN EDMA 0,512,BU,TG : ELSE EDMA 3,512,$E5,TG
250 TG=TG+512
300 NEXT SC : NEXT HE : NEXT TR

1000 PRINT : PRINT : PRINT "END. NUMBER OF ERRORS:";EC
1005 LN=TG-TS
1010 PRINT "DATA IS SAVED INTO ATTIC RAM: $";HEX$(TS);"-$";HEX$(TG-1); " ";(LN);"BYTES"
1020 POKE $D080,0:PRINT CHR$(7);:END:RUN

9000 REM *** READ A SECTOR ***
9010 IF (PEEK($D080) AND $20) <> 0 THEN 9050 : REM MOTOR IS ALREADY ON
9020 PRINT "SPINNING UP"
9030 POKE $D080, $20 : POKE $D081, $20
9040 IF (PEEK($D082) AND $80) <> 0 THEN 9040
9050 PRINT "READING HEAD";STR$(HE);" TRACK";STR$(TR);" SECTOR";STR$(SC);" ... ";
9100 POKE $D084,TR : POKE $D085,SC
9110 POKE $D086, HE
9115 IF HE = 0 THEN POKE $D080,$20 : ELSE POKE $D080,$28
9120 POKE $D081, $41
9130 E=PEEK($D082) : IF (E AND $80) <> 0 THEN 9130
9140 E=E AND $18
9150 IF E=0 THEN PRINT CHR$(30);"OK";CHR$(5) : RETURN
9160 PRINT CHR$(28);"ERROR:";E;CHR$(5)
9165 EC=EC+1
9170 RETURN

9500 REM *** SOME RUDIMENTARY DUMP FROM THE DIRECTORY ***
9505 REM FIXME! ONLY WORKS WITH STD 720K DISKS
9510 PRINT "READING DIRECTORY" : SC=8 : GOSUB 9000
9520 IF E<>0 THEN PRINT "CANNOT READ DIRECTORY" : RETURN
9525 PRINT
9530 FOR A=0 TO 511
9540 A2=A AND 31
9550 IF A2 > 10 THEN 9580
9555 C=PEEK(BU+A)
9557 IF A2 = 0 THEN PRINT "    ";CHR$(18);
9560 IF C > 31 AND C < 91 THEN PRINT CHR$(C); : ELSE PRINT " ";
9565 IF A2 = 7 THEN PRINT " ";CHR$(30);
9570 IF A2 = 10 THEN PRINT CHR$(5);CHR$(146);"    ";
9580 NEXT A
9590 PRINT : PRINT
9600 RETURN
