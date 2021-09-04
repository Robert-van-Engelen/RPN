' RPN COMPLEX CALCULATOR FOR THE SHARP PC-G850 - V2.1
' Emulates HP 15C

' Author: Dr. Robert A. van Engelen, 2020

' RUN      to start, clears registers
' GOTO*R   to resume without clearing registers

' Note: alphabetic keys can be associated with user-defined functions by
'       modifying lines 165 (A) to 190 (Z) and 465 (SHIFT-A) to 490 (SHIFT-Z)
' Note: locked in RADIAN mode

' Stack registers with real and imag values:
'  T,S (top row)
'  Z,K
'  Y,J
'  X,I (bottom row)
'
'  L,M last-x value (not displayed)
'
' Registers with real and imag values:
'  R(0)~R(9),I(0)~I(9)

' Keys for number entry
'  0~9     digit
'  .       period
'  Exp/E   x10^
'  I       enter imag part / back to real part
'  J       same as I (for engineers)
'  SPACE   (or SHIFT minus) change sign
'  BS      delete
'  LEFT    delete
'  ENTER   push on stack

' Keys for operations and functions:
'  A       abs, |XI| -> XI
'  C       ceiling, ceil(XI) -> XI
'  F       fraction, frac(XI) -> XI
'  G       GCD, gcd(Y,X) -> X
'  H       hyp prefix to [arc]sin,[arc]cos,[arc]tan
'  I       enter imag part / back to real part
'  J       same as I (for engineers)
'  L       linear regression, slope and intercept -> Y,X
'  M       mean of y and x -> Y,X
'  N       floor, floor(XI) -> XI
'  Q       quotient and remainder of Y/X -> X,Y (quotient in X, remainder in Y)
'  R       rational, X -> Y,X such that Y/X approximates the given X within 1E-10
'  S       stddev Sy and Sx -> Y,X
'  T       truncate, trunc(XI) -> XI
'  V       variance of y and x -> Y,X
'  Y       linear estimation of r and y given X=x -> Y,X
'  ^       raise, YJ^XI -> XI
'  +       add, YJ+XI -> XI
'  -       subtract, YJ-XI -> XI
'  *       multiply, YJ*XI -> XI
'  /       divide, YJ/XI -> XI
'  !       factorial/gamma, fact(X) gamma(X+1) -> X
'  %       percentage, X/100*YJ -> XI
'  ?       same as RND, push random 0<x<1 -> X
'  2ndF    SHIFT
'  SHIFT   does not operate
'  CLS     clear entry
'  CA      clear all, reset
'  SPACE   (or SHIFT minus) change sign, -XI -> XI
'  RIGHT   swap XI with YJ
'  UP      roll stack up
'  DOWN    roll stack down
'  RCM     last-x, push LM -> XI
'  S-CONST (SHIFT CONST) display registers (press key to continue)
'  CONST   STO [+|-|*|/] #register (press digit, or op then digit)
'  ANS     RCL [+|-|*|/] #register (press digit, or op then digit)
'  F<->E   re<->im, swap X with I,
'  ->DEG   hh.mmss X -> degree X
'  ->DMS   degree X ->hh.mmss X
'  PI      push pi -> X
'  RND     random, push random 0<x<1 -> X
'  MDF     round towards zero, round(XI) -> XI
'  STAT    clear stat registers R2 to R7
'  M+      stat add Y,X (updates registers R2 to R7 as per HP-15C stat)
'  M-      stat remove Y,X
'  =       enter Basic expression
'  SIN ... any PC-G850 calculator function key such as SIN

' VARIABLES
'  R(9)    registers 0 to 9 real part
'  I(9)    registers 0 to 9 imag part
'  AA$     number entry
'  D,E     position in AA$ of . and E
'  F       number entry flag, F=0 no entry, F=1 real part, F=2 imag part
'  H       hyp flag
'  P       push flag
'  N,O,U,W scratch

10 CLEAR: DIM R(9),I(9)
11 *R: RADIAN: CLS: WAIT 0: USING: GOTO 40

' briefly display error, then continue
15 LOCATE 0,0: WAIT 100: PRINT "ERROR!","": WAIT 0: GOTO 40

' push new row on the stack with NO -> XI and continue
20 T=Z,Z=Y,Y=X,X=N,S=K,K=J,J=I,I=O: GOTO 50

' pop YJ from stack, swap XI with LM, and continue
30 Y=Z,Z=T,N=X,X=L,L=N,J=K,K=S,O=I,I=M,M=O

' when a number is to be entered, push it as a new entry
40 P=1

' display the stack and reset number entry and hyp flags
50 LOCATE 0,0: PRINT "    T,Z,Y,X:","    S,K,J,I:",T,S,Z,K,Y,J,X,I," ","": F=0,H=0: GOTO 90

' number entry: set F=1 entry flag, then add char A to AA$, push new row when P=1
60 D=2,E=0,AA$="0": GOTO 69
63 D=0,E=2,AA$="1": GOTO 69
66 D=0,E=0,AA$=""
69 F=1: IF P LET T=Z,Z=Y,Y=X,S=K,K=J,J=I: LOCATE 0,0: PRINT "    T,Z,Y,X:","    S,K,J,I:",T,S,Z,K,Y,J
70 GOTO 79

' . is pressed when F=1 or F=1
72 IF D OR E GOTO 90
73 D=LEN AA$+1: GOTO 79

' E is pressed when F=1 or F=2
75 IF E GOTO 90
76 E=LEN AA$+1

' digit is pressed when F=1 or F=2
79 AA$=AA$+CHR$ A

' display number entry, right justified
80 N=12-LEN AA$: LOCATE 12*(F-1),4: PRINT LEFT$("           0",-N*(N>0));AA$;: IF N<=0 PRINT " ";
81 IF F=2 LET I=VAL AA$: GOTO 90
82 X=VAL AA$

' reset timeout, annunciate
90 W=1E4: LOCATE 0,0: PRINT " ";CHR$(32+H*40)
91 IF INKEY$<>"" GOTO 91

' wait on key press, times out to prevent the computer from never sleeping
100 A=ASC INKEY$: W=W-1: IF W=0 CLS: WAIT: PRINT "Press ENTER to continue": WAIT 0: GOTO 50
101 ON A/16 GOTO 116,132,148,164,180,,,228,244,,,,,,340: IF A=0 GOTO 100

' -----------
' KEY MAPPING
' -----------

' CLS/C.CE: clear XI
102 IF A=2 LET X=0,I=0,P=0: GOTO 50
' UP: roll stack up
104 IF A=4 LET N=T,T=Z,Z=Y,Y=X,X=N,O=S,S=K,K=J,J=I,I=O: GOTO 40
' DOWN: roll stack down
105 IF A=5 LET N=X,X=Y,Y=Z,Z=T,T=N,O=I,I=J,J=K,K=S,S=O: GOTO 40
' ANS: RCL [op] #register
107 IF A=7 GOTO 910
' BASIC/CAL: exit
108 IF A<10 LET W=1: GOTO 100
' TAB/INS/DEL unassigned
111 IF A<12 GOTO 90
' CONST: STO [op] #register
112 IF A=12 GOTO 900
' ENTER
113 IF A=13 LET N=X,O=I,P=0: GOTO 20
' RIGHT: swap XI with YJ
114 IF A=14 LET N=X,X=Y,Y=N,O=I,I=J,J=O: GOTO 40
' LEFT: same as BS
115 A=23: GOTO 122

' 2ndF: SHIFT
116 IF A=16 GOTO 390
' CAPS unassigned
' 121 REM
' BS
122 IF A=23 IF F LET N=LEN AA$: IF N>1 LET AA$=LEFT$(AA$,N-1),D=-D*(D<N),E=-E*(E<N): GOTO 80
123 IF A=23 LET A=2: GOTO 102
' RCM: last-x, push LM -> XI
124 IF A=24 LET N=L,O=M,P=1: GOTO 20
' M+: stat add Y,X: update registers R2=n, R3=sum X, R4=sum X^2, R5=sum Y, R6=sum Y^2, R7=sum X*Y
125 IF A=25 LET R(2)=R(2)+1,R(3)=R(3)+X,R(4)=R(4)+SQU X,R(5)=R(5)+Y,R(6)=R(6)+SQU Y,R(7)=R(7)+X*Y,X=R(2),I=0: GOTO 40
126 IF A<26 GOTO 90
' +/-: -X -> X
127 IF F=0 LET X=-X: GOTO 40
128 IF E=0 IF ASC AA$=45 LET AA$=MID$(AA$,2,16),D=D+(D>0): GOTO 80
129 IF E=0 LET AA$="-"+AA$,D=D-(D>0): GOTO 80
130 IF MID$(AA$,E+1,1)="-" LET AA$=LEFT$(AA$,E)+MID$(AA$,E+2,16): GOTO 80
131 AA$=LEFT$(AA$,E)+"-"+MID$(AA$,E+1,16): GOTO 80

' SPACE: -X -> X
132 IF A=32 GOTO 127
' ( ) unassigned
' 140 REM
' 141 REM
' *: YJ*XI -> XI
142 IF A=42 LET L=X*Y-I*J,M=X*J+Y*I: GOTO 30
' +: YJ+XI -> XI
143 IF A=43 LET L=Y+X,M=J+I: GOTO 30
' , unassigned
144 IF A<45 GOTO 90
' -: YJ-XI -> XI
145 IF A=45 LET L=Y-X,M=J-I: GOTO 30
' .
146 IF A=46 ON F+1 GOTO 60,72,72
' /: YJ/XI -> XI
147 GOTO 720

' 0~9
148 IF A<58 ON F+1 GOTO 66,79,79
' ; unassigned
159 IF A<61 GOTO 90
' =: enter Basic expression
161 IF P LET T=Z,Z=Y,Y=X,X=0,S=K,K=J,J=I: LOCATE 0,0: PRINT "    T,Z,Y,X:","    S,K,J,I:",T,S,Z,K,Y,J,X,I
162 LOCATE 0,4: INPUT "<Basic expr>",X: LOCATE 0,4: PRINT X,"": LOCATE 12,4: INPUT "<Basic expr>",I
163 GOTO 50

164 REM
' A: |XI| -> XI
165 IF A=65 GOSUB 820: X=N,I=0: GOTO 40
' B unassigned
' 166 REM
' C: ceil(XI) -> XI
167 IF A=67 LET X=-INT -X,I=-INT -I: GOTO 40
' D unassigned
' 168 REM
' E
169 IF A=69 ON F+1 GOTO 63,75,75
' F: frac(XI) -> XI
170 IF A=70 LET X=X-FIX X,I=I-FIX I: GOTO 40
' G: gcd(Y,X) -> X
171 IF A=71 GOTO 700
' H: hyp prefix
172 IF A=72 LET H=1-H: GOTO 90
' I: switch to/from imag part of number entry
' J: same as I (for engineers)
174 IF A=73 OR A=74 LET F=1-(F<2),D=0,E=0,AA$="": GOTO 80
' K unassigned
' 175 REM
' L: linear regression, slope and intercept -> Y,X
176 IF A=76 IF R(2)>0 LET X=(R(7)-R(3)*R(5)/R(2))/(R(4)-SQU R(3)/R(2)),I=0,N=(R(5)-X*R(3))/R(2),O=0,P=1: GOTO 20
' M: mean of y and x -> Y,X
177 IF A=77 IF R(2)>0 LET X=R(5)/R(2),I=0,N=R(3)/R(2),O=0,P=1: GOTO 20
' N: floor(XI) -> XI
178 IF A=78 LET X=INT X,I=INT I: GOTO 40
' O unassigned
179 GOTO 90

' P unassigned
180 REM
' Q: quotient and remainder of Y/X -> X,Y (quotient in X, remainder in Y)
181 IF A=81 GOTO 830
' R: rational approximation of X -> Y,X such that Y/X approximates the given X within 1E-10
182 IF A=82 GOTO 840
' S: stddev Sy and Sx -> Y,X
183 IF A=83 IF R(2)>1 LET X=SQR((R(6)-SQU R(5)/R(2))/(R(2)-1)),I=0,N=SQR((R(4)-SQU R(3)/R(2))/(R(2)-1)),O=0,P=1: GOTO 20
' T: trunc(XI) -> XI
184 IF A=84 LET X=FIX X,I=FIX I: GOTO 40
' U unassigned
' V: variance of y and x -> Y,X
186 IF A=86 IF R(2)>0 LET X=(R(6)-SQU R(5)/R(2))/R(2),I=0,N=(R(4)-SQU R(3)/R(2))/R(2),O=0,P=1: GOTO 20
' W~X unassigned
' Y: linear estimation of r and y given X=x -> Y,X
189 IF A=89 IF R(2)>0 LET N=R(7)-R(3)*R(5)/R(2),O=R(4)-SQU R(3)/R(2),U=N/SQR(O*(R(6)-SQU R(5)/R(2))),N=(X-R(3)/R(2))*N/O+R(5)/R(2),O=0,X=U,I=0,P=1: GOTO 20
' Z unassigned
190 IF A<94 GOTO 90
' ^: YJ^XI -> XI
194 IF Y=0 IF X<=0 GOTO 15
195 IF Y=0 LET L=0,M=0: GOTO 30
196 IF I=0 IF J=0 IF Y>0 OR X=INT X LET L=Y^X,M=0: GOTO 30
197 IF I=0 IF J=0 IF RCP X=2*INT RCP(2*X)+1 LET L=Y^X,M=0: GOTO 30
198 IF Y>0 IF J=0 LET N=Y^X,M=I*LN Y,L=N*COS M,M=N*SIN M: GOTO 30
199 IF I=0 GOSUB 800: N=X^Y,L=N*COS(Y*I),M=N*SIN(Y*I): GOTO 30
200 GOTO 15

228 REM
' RCP: 1/XI -> XI
235 IF A=135 GOTO 730
' SQU: XI^2 -> XI
236 N=X,X=X*X-I*I,I=2*N*I: GOTO 40

244 REM
' LN: ln(XI) -> XI
245 IF A=145 GOSUB 810: IF X LET X=LN X: GOTO 40
' LOG: log10(XI) -> XI
246 IF A=146 GOSUB 810: IF X LET X=LOG X,I=I/2.302585093: GOTO 40
' [HYP]SIN: sin[h](XI) -> XI
249 IF A=149 GOTO 740
' [HYP]COS: cos[h](XI) -> XI
250 IF A=150 GOTO 750
' [HYP]TAN: tan[h](XI) -> XI
251 IF A=151 GOTO 760
' DEG: hh.mmss X -> degree X
255 IF A=155 LET X=DEG X,I=0: GOTO 40
' F<->E: swap X with I
256 IF A=156 LET O=X,X=I,I=O: GOTO 40
' NPR: NPR(Y,X) -> X
257 IF A=157 IF I=0 IF J=0 IF Y>0 IF Y=INT Y IF X>=0 IF X<=Y IF X=INT X LET L=NPR(Y,X),M=0: GOTO 30
' MDF: round(XI) -> XI
258 IF A=158 LET X=INT(X+0.5),I=INT(I+0.5): GOTO 40
259 GOTO 15

340 REM
' PI: push pi -> X
351 IF A=251 LET N=PI,O=0,P=1: GOTO 20
' SQR: sqrt(XI) -> XI
352 IF I=0 IF X>=0 LET X=SQR X: GOTO 40
353 IF I=0 LET I=SQR -X,X=0: GOTO 40
354 GOSUB 820: I=SGN I*SQR((N-X)/2),X=SQR((N+X)/2): GOTO 40

' ----------------
' 2ndF+KEY MAPPING
' ----------------

' reset timeout, annunciate
390 W=1E4: LOCATE 0,0: PRINT "S";CHR$(32+H*40)
391 IF INKEY$ GOTO 391

' wait on key press after 2ndF, times out to prevent the computer from never sleeping
400 A=ASC INKEY$: W=W-1: IF W=1 GOTO 100
401 ON A/16 GOTO 416,432,448,464,480,,,528,544,,,,,,640: IF A=0 GOTO 400

' CA: reset
402 IF A=2 GOTO 10
' S-UP unassigned
' 404 REM
' S-DOWN unassigned
405 IF A<8 GOTO 90
' S-BASIC/S-CAL: exit
408 IF A<11 LET W=1: GOTO 100
' S-INS/S-DEL unassigned
' 411 REM
' S-CONST: display registers
412 IF A=12 GOTO 920
' S-ENTER unassigned
' 413 REM
' S-RIGHT unassigned
' 414 REM
' S-LEFT unassigned
415 GOTO 90

' 2ndF: un-SHIFT
416 REM
' S-CAPS unassigned
' 421 REM
' S-BS unassigned
' 423 REM
' S-RCM unassigned
' 424 REM
' M-: stat remove Y,X: update registers R2=n, R3=sum X, R4=sum X^2, R5=sum Y, R6=sum Y^2, R7=sum X*Y
425 IF A=25 LET R(2)=R(2)-1,R(3)=R(3)-X,R(4)=R(4)-SQU X,R(5)=R(5)-Y,R(6)=R(6)-SQU Y,R(7)=R(7)-X*Y,X=R(2),I=0: GOTO 40
431 GOTO 90

' S-SPACE unassigned
432 REM
' REC: rectangular(X,Y) -> XI
441 IF A=40 LET L=X*COS Y,M=X*SIN Y: GOTO 30
' S-* unassigned
' 442 REM
' S-+ unassigned
' 443 REM
' ?: same as RND, push random 0<x<1 -> X
444 IF A=44 LET A=251: GOTO 651
' 444 REM
' (-): -X -> X
445 IF A=45 GOTO 127
' S-. unassigned
' 446 REM
' S-/ unassigned
447 GOTO 90

' S-0~9 unassigned
448 REM
' 449 REM
' 450 REM
' 451 REM
' 452 REM
' 453 REM
' 454 REM
' 455 REM
' 456 REM
' 457 REM
' S-: (PC-1350) unassigned
' 458 REM
' S-; (PC-1350) unassigned
' 459 REM
' Exp: same as E
461 IF A=61 LET A=69: GOTO 169
463 GOTO 90

464 REM
' S-A~G unassigned
' 465 REM
' 466 REM
' 467 REM
' 468 REM
' 469 REM
' 470 REM
' 471 REM
' S-H: hyp prefix
472 IF A=72 LET H=1-H: GOTO 390
' PI (PC-1350)
' 473 GOTO 431
' S-J~N unassigned
' 474 REM
' 475 REM
' 476 REM
' 477 REM
' 478 REM
479 GOTO 90

' S-P unassigned
480 REM
' !: fact(X) gamma(X+1) -> X
481 IF A=81 GOTO 710
' S-R~S unassigned
' 482 REM
' 483 GOTO 90
' %: X/100*YJ -> XI
484 IF A=84 LET I=X/100*J,X=X/100*Y: GOTO 40
' S-U~Z unassigned
' 485 REM
' 486 REM
' 487 REM
' 488 REM
' 489 REM
' 490 REM
' POL: polar(XI) -> Y,X
494 IF A=94 GOSUB 810: N=X,O=0,X=I,I=0,P=1: GOTO 20
495 GOTO 90

528 REM
' n!: fact(X) gamma(X+1) -> X
535 IF A=135 GOTO 710
' CUB: XI^3 -> XI
536 N=SQU X,O=SQU I,X=X*(N-3*O),I=I*(3*N-O): GOTO 40

544 REM
' EXP: e^XI -> XI
545 IF A=145 IF X<231 LET N=EXP X,X=N*COS I,I=N*SIN I: GOTO 40
' TEN: 10^XI -> XI
546 IF A=146 IF X<100 LET N=TEN X,I=2.302585093*I,X=N*COS I,I=N*SIN I: GOTO 40
547 IF A=145 OR A=146 GOTO 15
' [HYP]ARCSIN: [hyp]arcsin(X) -> X, non-complex
549 IF A=149 GOTO 770
' [HYP]ARCCOS: [hyp]arccos(X) -> X, non-complex
550 IF A=150 GOTO 780
' [HYP]ARCTAN: [hyp]arctan(X) -> X, non-complex
551 IF A=151 GOTO 790
' DMS: degree X -> hh.mmss X
555 IF A=155 LET X=DMS X,I=0: GOTO 40
' NCR: NCR(Y,X) -> X
557 IF A=157 IF I=0 IF J=0 IF Y>0 IF Y=INT Y IF X>=0 IF X<=Y IF X=INT X LET L=NCR(Y,X),M=0: GOTO 30
' STAT: clear stat registers
558 IF A=158 LET R(2)=0,I(2)=0,R(3)=0,I(3)=0,R(4)=0,I(4)=0,R(5)=0,I(5)=0,R(6)=0,I(6)=0,R(7)=0,I(7)=0: GOTO 90
559 GOTO 15

640 REM
' RND: push random 0<x<1 -> X
651 IF A=251 LET N=RND 0,O=0,P=1: GOTO 20
' CUR: cuberoot(XI) -> XI
652 IF I=0 LET X=CUR X: GOTO 40
653 GOSUB 810: N=CUR X,I=I/3,X=N*COS I,I=N*SIN I: GOTO 40

' ---
' GCD
' ---

' gcd(X,Y) -> X, non-complex, max < 1E10
700 IF SGN I OR SGN J OR X<>INT X OR Y<>INT Y OR ABS X>=1E10 OR ABS Y>=1E10 GOTO 15
701 L=ABS X,M=ABS Y: IF L<M LET L=L+M
702 IF M LET N=L-M*INT(L/M),L=M,M=N: GOTO 702
703 M=0: GOTO 30

' -------------------
' FACT AND GAMMA(X+1)
' -------------------

' fact(X) gamma(X+1) -> X using Lanczos approximation with error 2x10^-10 at most, Numerical Recipes 2nd ed Ch6.1 gammln
710 IF X<0 OR X>69 OR SGN I GOTO 15
711 IF X=INT X LET X=FACT X: GOTO 40
712 X=EXP(LN((1+76.18009173/(X+2)-86.50532033/(X+3)+24.01409824/(X+4)-1.231739572/(X+5)+1.208650974E-3/(X+6)-5.395239385E-6/(X+7))*2.506628275/(X+1))+(X+1.5)*LN(X+6.5)-X-6.5): GOTO 40

' ---
' DIV
' ---

' YJ/XI -> XI, numerically stable
720 IF ABS X<ABS I LET N=X/I,M=X*N+I,L=(Y*N+J)/M,M=(J*N-Y)/M: GOTO 30
721 IF X LET N=I/X,M=X+I*N: IF M LET L=(Y+J*N)/M,M=(J-Y*N)/M: GOTO 30
722 GOTO 15

' 1/XI -> XI, numerically stable
730 IF ABS X<ABS I LET N=X/I,I=-RCP(X*N+I),X=-N*I: GOTO 40
731 IF X LET N=I/X,X=RCP(X+I*N),I=-X*N: GOTO 40
732 GOTO 15

' ----
' TRIG
' ----

' [hyp]sin(XI) -> XI
740 IF H IF X<231 LET N=EXP X,X=(N-RCP N)*COS I/2,I=(N+RCP N)*SIN I/2: GOTO 40
741 IF H=0 IF I<231 LET N=EXP I,I=(N-RCP N)*COS X/2,X=(N+RCP N)*SIN X/2: GOTO 40
742 GOTO 15

' [hyp]cos(XI) -> XI
750 IF H IF X<231 LET N=EXP X,X=(N+RCP N)*COS I/2,I=(N-RCP N)*SIN I/2: GOTO 40
751 IF H=0 IF I<231 LET N=EXP I,I=(RCP N-N)*SIN X/2,X=(N+RCP N)*COS X/2: GOTO 40
752 GOTO 15

' [hyp]tan(XI) -> XI
760 IF H IF X<116 LET N=EXP(2*X),O=COS(2*I)+(N+RCP N)/2: IF O LET X=(N-RCP N)/2/O,I=SIN(2*I)/O: GOTO 40
761 IF H=0 IF I<116 LET N=EXP(2*I),O=COS(2*X)+(N+RCP N)/2: IF O LET X=SIN(2*X)/O,I=(N-RCP N)/2/O: GOTO 40
762 GOTO 15

' [hyp]arcsin(X) -> X, non-complex
770 IF I GOTO 15
771 IF H LET X=AHS X: GOTO 40
772 IF ABS X<=1 LET X=ASN X: GOTO 40
773 GOTO 15

' [hyp]arccos(X) -> X, non-complex
780 IF I GOTO 15
781 IF H IF X<1 GOTO 15
782 IF H LET X=AHC X: GOTO 40
783 IF ABS X<=1 LET X=ACS X: GOTO 40
784 GOTO 15

' [hyp]arctan(X) -> X, non-complex
790 IF I GOTO 15
791 IF H IF ABS X>=1 GOTO 15
792 IF H LET X=AHT X: GOTO 40
793 X=ATN X: GOTO 40

' -----
' POLAR
' -----

' swap XI with YJ then convert XI to polar XI
800 N=X,X=Y,Y=N,O=I,I=J,J=O

' convert XI to polar while avoiding intermediate overflow
810 IF X=0 LET X=ABS I,I=SGN I*PI/2: RETURN
811 IF I=0 LET I=-(X<0)*PI,X=ABS X: RETURN
812 IF ABS X<ABS I LET N=X/I,N=ABS I*SQR(1+N*N): GOTO 814
813 N=I/X,N=ABS X*SQR(1+N*N)
814 IF X>0 LET I=ATN(I/X),X=N: RETURN
815 I=SGN I*PI/2-ATN(X/I),X=N: RETURN

' -------
' MODULUS
' -------

' sqrt(X*X+I*I) -> N avoiding intermediate overflow
820 IF X=0 LET N=ABS I: RETURN
821 IF I=0 LET N=ABS X: RETURN
822 IF ABS X<ABS I LET N=ABS I*SQR(1+SQU(X/I)): RETURN
823 N=ABS X*SQR(1+SQU(I/X)): RETURN

' --------
' RATIONAL
' --------

' quotient and remainder of Y/X -> X,Y (quotient in X, remainder in Y)
830 IF SGN I OR SGN J OR X=0 OR X<>INT X OR Y<>INT Y OR ABS X>=1E10 OR ABS Y>=1E10 GOTO 15
831 N=X,X=SGN X*INT(Y/ABS X),Y=Y-N*X: GOTO 40

' rational approximation by continued fractions X -> Y,X such that Y/X approximates the given X within 1E-10
840 IF I GOTO 15
841 IF X=INT X LET N=1,O=0,P=1: GOTO 20
842 I=0,L=1,O=1,M=0,W=X
843 N=INT W,W=W-N,U=N*L+I,I=L,L=U,U=N*M+O,O=M,M=U,N=L/M: IF W IF ABS(N-X)>1E-10 LET W=RCP W: GOTO 843
844 X=L,I=0,N=M,O=0,P=1: GOTO 20

' ---
' STO
' ---

' store [+|-|*|/] #register
900 GOSUB 930
901 IF A=43 GOSUB 930: A=VAL CHR$ A,R(A)=R(A)+X,I(A)=I(A)+I: GOTO 40
902 IF A=45 GOSUB 930: A=VAL CHR$ A,R(A)=R(A)-X,I(A)=I(A)-I: GOTO 40
903 IF A=42 GOSUB 930: A=VAL CHR$ A,N=R(A),R(A)=R(A)*X-I(A)*I,I(A)=N*I+X*I(A): GOTO 40
904 IF A<>47 LET A=VAL CHR$ A,R(A)=X,I(A)=I: GOTO 40
905 GOSUB 930: A=VAL CHR$ A
906 IF ABS X<ABS I LET N=X/I,O=X*N+I,W=R(A),R(A)=(W*N+I(A))/O,I(A)=(I(A)*N-W)/O: GOTO 40
907 IF X LET N=I/X,O=X+I*N,W=R(A),R(A)=(W+I(A)*N)/O,I(A)=(I(A)-W*N)/O: GOTO 40
908 GOTO 15

' ---
' RCL
' ---

' recall [+|-|*|/] #register
910 GOSUB 930
911 IF A=43 GOSUB 930: A=VAL CHR$ A,X=X+R(A),I=I+I(A): GOTO 40
912 IF A=45 GOSUB 930: A=VAL CHR$ A,X=X-R(A),I=I-I(A): GOTO 40
913 IF A=42 GOSUB 930: A=VAL CHR$ A,N=X,X=X*R(A)-I*I(A),I=N*I(A)+R(A)*I: GOTO 40
914 IF A<>47 LET A=VAL CHR$ A,N=R(A),O=I(A),P=1: GOTO 20
915 GOSUB 930: A=VAL CHR$ A,W=R(A),O=I(A)
916 IF ABS W<ABS O LET N=W/O,O=W*N+O,W=X,X=(X*N+I)/O,I=(I*N-X)/O: GOTO 40
917 IF W LET N=O/W,O=W+O*N,W=X,X=(X+I*N)/O,I=(I-W*N)/O: GOTO 40
918 GOTO 15

' ---
' REG
' ---

' display registers
920 CLS: PRINT "     R0..R4:","     I0..I4:",R(0),I(0),R(1),I(1),R(2),I(2),R(3),I(3),R(4),I(4)
921 GOSUB 931
922 CLS: PRINT "     R5..R9:","     I5..I9:",R(5),I(5),R(6),I(6),R(7),I(7),R(8),I(8),R(9),I(9)
923 GOSUB 931
924 CLS: GOTO 40

' ------
' GETKEY
' ------

930 LOCATE 0,0: PRINT "R?"
931 W=1E4: IF INKEY$ GOTO 931
932 A=ASC INKEY$: W=W-1: IF A OR W=0 RETURN
933 GOTO 932
