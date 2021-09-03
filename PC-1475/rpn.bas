' RPN COMPLEX CALCULATOR
' Emulates HP 15C

' Author: Dr. Robert A. van Engelen, 2020

' RUN      to start, clears registers
' DEF-A    to resume without clearing registers

' Stack registers with real and imag values:
'  T,S
'  Z,K
'  Y,J
'  X,I (bottom row)
'
'  L,M last value

' Keys for operations and functions:
'  A       abs, |XI| -> XI
'  B       nPr(Y,X) -> X
'  C       ceiling, ceil(XI) -> XI
'  D       round towards zero, round(XI) -> XI
'  F       fraction, frac(XI) -> XI
'  G       GCD, gcd(Y,X) -> X
'  H       hyp prefix to [arc]sin,[arc]cos,[arc]tan
'  I       enter imag part / back to real part
'  J       same as I (for engineers)
'  K       nCr(Y,X) -> X
'  L       STO #register (press digit)
'  M       mean of y and x -> Y,X
'  N       floor, floor(XI) -> XI
'  Q       quotient and remainder of Y/X -> X,Y (quotient in X, remainder in Y)
'  R       rational, X -> Y,X such that Y/X approximates the given X within 1E-10
'  S       stddev Sy and Sx -> Y,X
'  T       truncate, trunc(XI) -> XI
'  V       variance of y and x -> Y,X
'  X       last-x, push LM -> XI
'  Y       linear estimation of r and y given X=x -> Y,X
'  Z       linear regression, slope and intercept -> Y,X
'  HYP     hyp prefix to [arc]sin,[arc]cos,[arc]tan
'  SHIFT   shift (S-)
'  S-0     mean of y -> X
'  S-1     mean of x -> X
'  S-2     Sx -> X
'  S-3     stddev of x -> X
'  S-4     sum of xy -> X
'  S-5     sum of y -> X
'  S-6     sum of y^2 -> X
'  S-7     n -> X
'  S-8     sum of x -> X
'  S-9     sum of x^2 -> X
'  S-+/-   Sy -> X
'  S-.     stddev of y -> X
'  S-B     linear regression intercept a -> X
'  S-M     linear estimation of x given X=y -> X
'  S-N     linear regression slope b -> X
'  S-V     linear regression coefficient r -> X
'  S-SPC   linear estimation of y given X=x -> X
'  CLS     clear entry
'  CA      clear all, reset
'  +/-     change sign
'  SPC     change sign
'  RIGHT   swap XI with YJ
'  UP      roll stack up
'  DOWN    roll stack down
'  ^       raise
'  +       add
'  -       subtract
'  *       multiply
'  /       divide
'  !       factorial/gamma(x+1), fact(X) gamma(X+1) -> X
'  %       percentage, X/100*YJ -> XI
'  (       STO #register (press digit, or op then digit)
'  )       RCL #register (press digit, or op then digit)
'  ,       RCL #register (press digit)
'  ?       push random 0<x<1 -> X
'  ->DEG   hh.mmss -> degree
'  ->DMS   degree -> hh.mmss
'  PI      push pi -> X
'  STAT    (S-=) clear stat registers R2 to R7
'  INS     stat add Y,X (updates registers R2 to R7 as per HP-15C stat)
'  DEL     stat remove Y,X (updates registers R2 to R7 as per HP-15C stat)
'  =       enter expression (Basic)
'  ...     any PC-1475 calculator function key such as SIN

' Keys for number entry
'  0~9     digit
'  .       period
'  EXP     x10^
'  E       x10^
'  I       enter imag part / back to real part
'  J       same as I (for engineers)
'  +/-     change sign
'  SPC     change sign
'  BS      delete
'  LEFT    delete
'  ENTER   push on stack

' VARIABLES
'  R(9)    registers 0 to 9 real part
'  I(9)    registers 0 to 9 imag part
'  AA$     number entry
'  D,E     position in AA$ of . and E
'  F       number entry flag, F=0 no entry, F=11 real part, F=12 imag part
'  H       hyp flag
'  P       push flag
'  N,O,U,W scratch

10 CLEAR: DIM R(9),I(9)
11 "A" RADIAN: CLS: WAIT 0: USING

' PC-1475 supports error trapping
12 ON ERROR GOTO 13: GOTO 40

' catch calculation errors then continue
13 IF ERN<>2 STOP

' briefly display error, then continue
15 CURSOR 0: PAUSE "ERROR!","": GOTO 40

' push new row on the stack with NO -> XI and continue
20 T=Z,Z=Y,Y=X,X=N,S=K,K=J,J=I,I=O: GOTO 50

' pop YJ from stack, swap XI with LM, and continue
30 Y=Z,Z=T,N=X,X=L,L=N,J=K,K=S,O=I,I=M,M=O

' when a number is to be entered, push it as a new entry
40 P=1

' display bottom two rows of the stack and reset number entry and hyp flags
' NOTE: PC-1350
' 50 "A" CURSOR 0: PRINT T,S,Z,K,Y,J,X,I: F=0,H=0: GOTO 90
50 CURSOR 0: PRINT Y,J,X,I: F=0,H=0: GOTO 90

' number entry: set F=11 entry flag, then add char A to AA$, push new row when P=1
60 D=2,E=0,AA$="0": GOTO 69
63 D=0,E=2,AA$="1": GOTO 69
66 D=0,E=0,AA$=""
' NOTE: PC-1350
' 69 F=11: IF P LET T=Z,Z=Y,Y=X,S=K,K=J,J=I: CURSOR 0: PRINT T,S,Z,K,Y,J
69 F=11: IF P LET T=Z,Z=Y,Y=X,S=K,K=J,J=I: CURSOR 0: PRINT Y,J
70 GOTO 79

' . is pressed when F=11 or F=12
71 REM
72 IF D OR E GOTO 90
73 D=LEN AA$+1: GOTO 79

' E is pressed when F=11 or F=12
74 REM
75 IF E GOTO 90
76 E=LEN AA$+1

' digit is pressed when F=11 or F=12
77 REM
78 REM
79 AA$=AA$+CHR$ A

' display number entry, right justified
' NOTE: PC-1350
' 80 N=12-LEN AA$: CURSOR 12*F-60: PRINT LEFT$("           0",N*(N>0));AA$
80 N=12-LEN AA$: CURSOR 12*F-108: PRINT LEFT$("           0",N*(N>0));AA$
81 IF F=12 LET I=VAL AA$: GOTO 90
82 X=VAL AA$

' reset timeout, set HYP annunciator, clear SHIFT annunciator
90 W=1E3

' wait on key press, times out to prevent the computer from never sleeping
100 A=ASC INKEY$: W=W-1: IF W GOTO 100+A
101 CLS: WAIT: PRINT "ENTER to continue": WAIT 0: GOTO 50

' -----------
' KEY MAPPING
' -----------

' CLS/C.CE
102 X=0,I=0,P=0: GOTO 50
' UP roll stack
104 N=T,T=Z,Z=Y,Y=X,X=N,O=S,S=K,K=J,J=I,I=O: GOTO 40
' DOWN roll stack
105 N=X,X=Y,Y=Z,Z=T,T=N,O=I,I=J,J=K,K=S,S=O: GOTO 40
' ANS (PC-G850)
' 107 REM
' BASIC/CAL exit
108 REM
109 GOTO 101
' TAB (PC-G850)
' 110 REM
' INS: stat add Y,X: update registers R2=n, R3=sum X, R4=sum X^2, R5=sum Y, R6=sum Y^2, R7=sum X*Y
111 R(2)=R(2)+1,R(3)=R(3)+X,R(4)=R(4)+SQU X,R(5)=R(5)+Y,R(6)=R(6)+SQU Y,R(7)=R(7)+X*Y,X=R(2),I=0: GOTO 40
' DEL: state remove Y,X: update registers R2=n, R3=sum X, R4=sum X^2, R5=sum Y, R6=sum Y^2, R7=sum X*Y
112 R(2)=R(2)-1,R(3)=R(3)-X,R(4)=R(4)-SQU X,R(5)=R(5)-Y,R(6)=R(6)-SQU Y,R(7)=R(7)-X*Y,X=R(2),I=0: GOTO 40
' ENTER
113 N=X,O=I,P=0: GOTO 20
' RIGHT swap XI with YJ
114 N=X,X=Y,Y=N,O=I,I=J,J=O: GOTO 50
' LEFT is BS
115 GOTO 123
' SHIFT
116 GOTO 400-284*(INKEY$<>"")
' HYP
117 H=1: GOTO 90
' DEF/SML unassigned
118 REM
121 REM
122 GOTO 90
' BS
123 IF F LET N=LEN AA$: IF N>1 LET AA$=LEFT$(AA$,N-1),D=D*(D<N),E=E*(E<N): GOTO 80
124 GOTO 102
' +/-: -X -> X
126 IF NOT F LET X=-X: GOTO 40
127 IF NOT E IF ASC AA$=45 LET AA$=MID$(AA$,2,16),D=D-(D>0): GOTO 80
128 IF NOT E LET AA$="-"+AA$,D=D+(D>0): GOTO 80
129 IF MID$(AA$,E+1,1)="-" LET AA$=LEFT$(AA$,E)+MID$(AA$,E+2,16): GOTO 80
130 AA$=LEFT$(AA$,E)+"-"+MID$(AA$,E+1,16): GOTO 80
' EXP: same as E
131 A=69: GOTO 63+F
' SPC: -X -> X
132 GOTO 126
' (: STO #register
140 GOTO 476
' ): RCL #register
141 GOTO 444
' *: YJ*XI -> XI
142 L=X*Y-I*J,M=X*J+Y*I: GOTO 30
' +: YJ+XI -> XI
143 L=Y+X,M=J+I: GOTO 30
' ,: RCL #register
144 GOSUB 920: N=R(A),O=I(A),P=1: GOTO 20
' -: : YJ-XI -> XI
145 L=Y-X,M=J-I: GOTO 30
' .
146 GOTO 60+F
' /: YJ/XI -> XI
147 GOTO 720
' 0~9
148 REM
149 REM
150 REM
151 REM
152 REM
153 REM
154 REM
155 REM
156 REM
157 GOTO 66+F
' : (PC-1350) unassigned
158 REM
' ; (PC-1350) unassigned
159 REM
' =: enter Basic expression
' NOTE: PC-1350
' 161 IF P LET T=Z,Z=Y,Y=X,X=0,S=K,K=J,J=I: CURSOR 0: PRINT T,S,Z,K,Y,J,X,I
161 IF P LET T=Z,Z=Y,Y=X,X=0,S=K,K=J,J=I: CURSOR 0: PRINT Y,J,X,I
' NOTE: PC-1350
' 162 CURSOR 72: INPUT X: PRINT X,I: CURSOR 84: INPUT I
162 CURSOR 24: INPUT X: PRINT X,I: CURSOR 36: INPUT I
163 GOTO 50
' A: |XI| -> XI
165 GOSUB 820: X=N,I=0: GOTO 40
' B: nPr(Y,X)->X
166 L=NPR(Y,X),M=0: GOTO 30
' C: ceil(XI) -> XI
167 X=-INT -X,I=-INT -I: GOTO 40
' D: round(XI) -> XI
168 X=INT(X+0.5),I=INT(I+0.5): GOTO 40
' E
169 GOTO 63+F
' F: frac(XI) -> XI
170 X=X-SGN X*INT ABS X,I=I-SGN I*INT ABS I: GOTO 40
' G: gcd(Y,X) -> X
171 GOTO 700
' H: hyp prefix
172 H=1: GOTO 90
' I: switch to/from imag part of number entry
173 REM
' J: switch to/from imag part of number entry
' NOTE: PC-1350
' 174 F=11+(F<12),D=0,E=0,AA$="": CURSOR 72: PRINT X,I: GOTO 80
174 F=11+(F<12),D=0,E=0,AA$="": GOTO 80
' K: nCr(Y,X) -> X
175 L=NCR(Y,X),M=0: GOTO 30
' L: STO #register
176 GOSUB 920: R(A)=X,I(A)=I: GOTO 40
' M: mean of y and x -> Y,X
177 X=R(5)/R(2),I=0,N=R(3)/R(2),O=0,P=1: GOTO 20
' N: floor(XI) -> XI
178 X=INT X,I=INT I: GOTO 40
' O unassigned
179 GOTO 90
' P unassigned
180 GOTO 90
' Q: quotient and remainder of Y/X -> X,Y (quotient in X, remainder in Y)
181 GOTO 830
' R: rational approximation of X -> Y,X such that Y/X approximates the given X within 1E-10
182 GOTO 840
' S: stddev of y and x -> Y,X
183 X=SQR((R(6)-SQU R(5)/R(2))/(R(2)-1)),I=0,N=SQR((R(4)-SQU R(3)/R(2))/(R(2)-1)),O=0,P=1: GOTO 20
' T: trunc(XI) -> XI
184 X=SGN X*INT ABS X,I=SGN I*INT ABS I: GOTO 40
' U unassigned
185 GOTO 90
' V: variance of y and x -> Y,X
186 X=R(6)-SQU R(5)/R(2))/R(2),I=0,N=(R(4)-SQU R(3)/R(2))/R(2),O=0,P=1: GOTO 20
' W unassigned
187 GOTO 90
' X: last-x push LM -> XI
188 N=L,O=M,P=1: GOTO 20
' Y: linear estimation of r and y given X=x -> Y,X
189 N=R(7)-R(3)*R(5)/R(2),O=R(4)-SQU R(3)/R(2),U=N/SQR(O*(R(6)-SQU R(5)/R(2))),N=(X-R(3)/R(2))*N/O+R(5)/R(2),O=0,X=U,I=0,P=1: GOTO 20
' Z: linear regression, slope and intercept -> Y,X
190 X=(R(7)-R(3)*R(5)/R(2))/(R(4)-SQU R(3)/R(2)),I=0,N=(R(5)-X*R(3))/R(2),O=0,P=1: GOTO 20
' ^: YJ^XI -> XI
194 IF Y=0 IF X<=0 GOTO 15
195 IF Y=0 LET L=0,M=0: GOTO 30
196 IF I=0 IF J=0 IF Y>0 OR X=INT X LET L=Y^X,M=0: GOTO 30
197 IF I=0 IF J=0 IF RCP X=2*INT RCP(2*X)+1 LET L=Y^X,M=0: GOTO 30
198 IF Y>0 IF J=0 LET N=Y^X,M=I*LN Y,L=N*COS M,M=N*SIN M: GOTO 30
199 IF I=0 GOSUB 800: N=X^Y,L=N*COS(Y*I),M=N*SIN(Y*I): GOTO 30
200 GOTO 15
' HEX unassigned
233 GOTO 90
' RCP: 1/XI -> XI
235 GOTO 730
' SQU: XI^2 -> XI
236 N=X,X=X*X-I*I,I=2*N*I: GOTO 40
' LN: ln(XI) -> XI
245 IF SGN X OR SGN I GOSUB 810: X=LN X: GOTO 40
' LOG: log(XI) -> XI
246 IF SGN X OR SGN I GOSUB 810: X=LOG X,I=I/2.302585093: GOTO 40
247 GOTO 15
' SIN: sin(XI) -> XI
249 GOTO 740
' COS: cos(XI) -> XI
250 GOTO 750
' TAN: tan(XI) -> XI
251 GOTO 760
' DEG: hh.mmss X -> degree X
255 X=DEG X: GOTO 40
' SQR: sqrt(X) -> X
352 IF I=0 IF X>=0 LET X=SQR X: GOTO 40
353 IF I=0 LET I=SQR -X,X=0: GOTO 40
354 GOSUB 820: I=SGN I*SQR((N-X)/2),X=SQR((N+X)/2): GOTO 40

' -----------------
' SHIFT+KEY MAPPING
' -----------------

' wait on key press, times out to prevent the computer from never sleeping
400 A=ASC INKEY$: W=W-1: IF W GOTO 400+A
401 GOTO 101

' CA: reset
402 GOTO 10
' S-UP unassigned
404 REM
' S-DOWN unassigned
405 GOTO 90
' S-BASIC/S-CAL exit
408 REM
409 GOTO 101
' S-INS unassigned
411 REM
' S-DEL unassigned
412 REM
' S-ENTER unassigned
413 REM
' S-RIGHT unassigned
414 REM
' S-LEFT unassigned
415 GOTO 90
' SHIFT
416 GOTO 100+316*(INKEY$<>"")
' S-HYP
417 H=1: GOTO 400
' S-DEF/S-SML unassigned
418 REM
421 REM
' S-BS unassigned
423 GOTO 90
' S-+/-: Sy -> X
430 N=SQR(R(6)-SQU R(5)/R(2))/(R(2)-1)),O=0,P=1: GOTO 20
' PI
431 N=PI,O=0,P=1: GOTO 20
' S-SPC linear estimation of y given X=x -> X
432 X=(X-R(3)/R(2))*(R(7)-R(3)*R(5)/R(2))/(R(4)-SQU R(3)/R(2))+R(5)/R(2),I=0: GOTO 40
' REC: rectangular(X,Y) -> XI
440 L=X*COS Y,M=X*SIN Y: GOTO 30
' n!: fact(X) gamma(X+1) -> X
441 GOTO 710
' S-* unassigned
442 GOTO 90
' S-+: YJ^XI -> XI
443 GOTO 194
' S-, unassigned
444 GOTO 90
' S--: ^ (PC-1350): YJ^XI -> XI
445 GOTO 194
' S-.: stddev of y -> X
446 N=SQR(R(6)-SQU R(5)/R(2))/R(2)),O=0,P=1: GOTO 20
' S-/ unassigned
447 GOTO 90
' S-0: mean of y -> X
448 N=R(5)/R(2),O=0,P=1: GOTO 20
' S-1: mean of x -> X
449 N=R(3)/R(2),O=0,P=1: GOTO 20
' S-2: Sx -> X
450 N=SQR(R(4)-SQU R(3)/R(2))/(R(2)-1)),O=0,P=1: GOTO 20
' S-3: stddev of x -> X
451 N=SQR(R(4)-SQU R(3)/R(2))/R(2)),O=0,P=1: GOTO 20
' S-4: sum of xy -> X
452 N=R(7),O=0,P=1: GOTO 20
' S-5: sum of y -> X
453 N=R(5),O=0,P=1: GOTO 20
' S-6: sum of y^2 -> X
454 N=R(6),O=0,P=1: GOTO 20
' S-7: n -> X
455 N=R(2),O=0,P=1: GOTO 20
' S-8: sum of x -> X
456 N=R(3),O=0,P=1: GOTO 20
' S-9: sum of x^2 -> X
457 N=R(4),O=0,P=1: GOTO 20
' S-: (PC-1350) unassigned
' 458 REM
' S-; (PC-1350) unassigned
' 459 GOTO 90
' STAT: clear stat registers
461 R(2)=0,I(2)=0,R(3)=0,I(3)=0,R(4)=0,I(4)=0,R(5)=0,I(5)=0,R(6)=0,I(6)=0,R(7)=0,I(7)=0: GOTO 90
' S-A: unassigned
465 GOTO 90
' S-B: linear regression intercept a -> X
466 N=(R(7)-R(3)*R(5)/R(2))/(R(4)-SQU R(3)/R(2)),N=(R(5)-N*R(3))/R(2),O=0,P=1: GOTO 20
467 REM
468 REM
469 REM
470 REM
471 REM
472 GOTO 90
' S-I: PI (PC-1350) PI -> XI
' 473 GOTO 431
' S-J~L unassigned
474 REM
475 REM
476 GOTO 90
' S-M: linear estimation of x given X=y -> X
477 N=(R(7)-R(3)*R(5)/R(2))/(R(4)-SQU R(3)/R(2)),X=(X-(R(5)-N*R(3))/R(2))/N,I=0: GOTO 40
' S-N: linear regression slope b -> X
478 N=(R(7)-R(3)*R(5)/R(2))/(R(4)-SQU R(3)/R(2)),O=0,P=1: GOTO 20
' S-O: SQR (PC-1350) sqrt(XI) -> XI
' 479 GOTO 352
' S-P unassigned
480 GOTO 90
' !: (PC-1350) fact(X) gamma(X+1) -> X
' 481 GOTO 710
' S-R~S unassigned
482 REM
483 GOTO 90
' %: Y*X/100 -> X
484 GOTO 536
' ?: push random 0<x<1 -> X
485 N=RND 0,O=0,P=1: GOTO 20
' S-V: linear regression coefficient r -> X
486 N=(R(7)-R(3)*R(5)/R(2))/SQR((R(4)-SQU R(3)/R(2))*(R(6)-SQU R(5)/R(2))),O=0,P=1: GOTO 20
' S-W~Z unassigned
487 REM
488 REM
489 REM
490 GOTO 90
' ROT: YJ^(1/XI) -> XI
494 IF ABS X<ABS I LET N=X/I,I=-RCP(X*N+I),X=-N*I: GOTO 194
495 LET N=I/X,X=RCP(X+I*N),I=-X*N: GOTO 194
' DECI unassigned
533 GOTO 90
' POL: polar(XI) -> Y,X
535 GOSUB 810: N=X,O=0,X=I,I=0,P=1: GOTO 20
' %: Y*X/100 -> X
536 X=X/100*Y,I=0: GOTO 40
' EXP: e^XI -> XI
545 N=EXP X,X=N*COS I,I=N*SIN I: GOTO 40
' TEN: 10^XI -> XI
546 N=TEN X,I=2.302585093*I,X=N*COS I,I=N*SIN I: GOTO 40
' [HYP]ARCSIN: [hyp]arcsin(X) -> X
549 GOTO 770
' [HYP]ARCCOS: [hyp]arccos(X) -> X
550 GOTO 780
' [HYP]ARCTAN: [hyp]arctan(X) -> X
551 GOTO 790
' DMS: degree X -> hh.mmss X
555 X=DMS X: GOTO 40
' CUR: cuberoot(XI) -> XI
652 GOSUB 810: N=CUR X,I=I/3,X=N*COS I,I=N*SIN I: GOTO 40

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
' 710 IF X<0 OR X>69 OR SGN I GOTO 15
711 IF X=INT X LET X=FACT X: GOTO 40
712 X=EXP(LN((1+76.18009173/(X+2)-86.50532033/(X+3)+24.01409824/(X+4)-1.231739572/(X+5)+1.208650974E-3/(X+6)-5.395239385E-6/(X+7))*2.506628275/(X+1))+(X+1.5)*LN(X+6.5)-X-6.5): GOTO 40

' ---
' DIV
' ---

' YJ/XI -> XI, numerically stable
720 IF ABS X<ABS I LET N=X/I,M=X*N+I,L=(Y*N+J)/M,M=(J*N-Y)/M: GOTO 30
721 IF X LET N=I/X,M=X+I*N,L=(Y+J*N)/M,M=(J-Y*N)/M: GOTO 30
722 GOTO 15

' 1/XI -> XI, numerically stable
730 IF ABS X<ABS I LET N=X/I,I=-RCP(X*N+I),X=-N*I: GOTO 40
731 IF X LET N=I/X,X=RCP(X+I*N),I=-X*N: GOTO 40
732 GOTO 15

' ----
' TRIG
' ----

' [hyp]sin(XI) -> XI
740 IF H LET N=EXP X,X=(N-RCP N)*COS I/2,I=(N+RCP N)*SIN I/2: GOTO 40
741 N=EXP I,I=(N-RCP N)*COS X/2,X=(N+RCP N)*SIN X/2: GOTO 40

' [hyp]cos(XI) -> XI
750 IF H LET N=EXP X,X=(N+RCP N)*COS I/2,I=(N-RCP N)*SIN I/2: GOTO 40
751 N=EXP I,I=(RCP N-N)*SIN X/2,X=(N+RCP N)*COS X/2: GOTO 40

' [hyp]tan(XI) -> XI
760 IF H LET N=EXP(2*X),O=COS(2*I)+(N+RCP N)/2: IF O LET X=(N-RCP N)/2/O,I=SIN(2*I)/O: GOTO 40
761 IF NOT H LET N=EXP(2*I),O=COS(2*X)+(N+RCP N)/2: IF O LET X=SIN(2*X)/O,I=(N-RCP N)/2/O: GOTO 40
762 GOTO 15

' [hyp]arcsin(X) -> X, non-complex
770 IF I GOTO 15
771 IF H LET X=AHS X: GOTO 40
' 772 IF ABS X<=1 LET X=ASN X: GOTO 40
772 X=ASN X: GOTO 40
' 773 GOTO 15

' [hyp]arccos(X) -> X, non-complex
780 IF I GOTO 15
782 IF H LET X=AHC X: GOTO 40
' 783 IF ABS X<=1 LET X=ACS X: GOTO 40
783 X=ACS X: GOTO 40
' 784 GOTO 15

' [hyp]arctan(X) -> X, non-complex
790 IF I GOTO 15
' 791 IF H IF ABS X>=1 GOTO 15
792 IF H LET X=AHT X: GOTO 40
793 X=ATN X: GOTO 40

' -----
' POLAR
' -----

' swap XI with YJ then convert XI to polar XI
800 N=X,X=Y,Y=N,O=I,I=J,J=O

' convert XI to polar while avoiding intermediate overflow
810 IF X=0 LET X=ABS I,I=SGN I*PI/2: RETURN
811 IF I=0 LET I=(X<0)*PI,X=ABS X: RETURN
812 IF ABS X<ABS I LET N=ABS I*SQR(1+SQU(X/I)): GOTO 814
813 N=ABS X*SQR(1+SQU(I/X))
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

' ----
' COMB
' ----

' NPR(Y,X) -> X
' 850 IF I=0 IF J=0 IF Y>0 IF Y=INT Y IF X>=0 IF X<=Y IF X=INT X LET L=NPR(Y,X),M=0: GOTO 30
' 851 GOTO 15

' NCR(Y,X) -> X
' 860 IF I=0 IF J=0 LET L=NCR(Y,X),M=0: GOTO 30
' 861 GOTO 15

' ---
' STO
' ---

' store [+|-|*|/] #register
' 900 GOSUB 920
' 901 IF A=43 GOSUB 920: A=VAL CHR$ A,R(A)=R(A)+X,I(A)=I(A)+I: GOTO 40
' 902 IF A=45 GOSUB 920: A=VAL CHR$ A,R(A)=R(A)-X,I(A)=I(A)-I: GOTO 40
' 903 IF A=42 GOSUB 920: A=VAL CHR$ A,N=R(A),R(A)=R(A)*X-I(A)*I,I(A)=N*I+X*I(A): GOTO 40
' 904 IF A<>47 LET A=VAL CHR$ A,R(A)=X,I(A)=I: GOTO 40
' 905 GOSUB 920: A=VAL CHR$ A
' 906 IF ABS X<ABS I LET N=X/I,O=X*N+I,W=R(A),R(A)=(W*N+I(A))/O,I(A)=(I(A)*N-W)/O: GOTO 40
' 907 N=I/X,O=X+I*N,W=R(A),R(A)=(W+I(A)*N)/O,I(A)=(I(A)-W*N)/O: GOTO 40

' ---
' RCL
' ---

' recall [+|-|*|/] #register
' 910 GOSUB 920: A=VAL CHR$ A,N=R(A),O=I(A),P=1: GOTO 20
' 910 GOSUB 920
' 911 IF A=43 GOSUB 920: A=VAL CHR$ A,X=X+R(A),I=I+I(A): GOTO 40
' 912 IF A=45 GOSUB 920: A=VAL CHR$ A,X=X-R(A),I=I-I(A): GOTO 40
' 913 IF A=42 GOSUB 920: A=VAL CHR$ A,N=X,X=X*R(A)-I*I(A),I=N*I(A)+R(A)*I: GOTO 40
' 914 IF A<>47 LET A=VAL CHR$ A,N=R(A),O=I(A),P=1: GOTO 20
' 915 GOSUB 920: A=VAL CHR$ A,W=R(A),O=I(A)
' 916 IF ABS W<ABS O LET N=W/O,O=W*N+O,W=X,X=(X*N+I)/O,I=(I*N-X)/O: GOTO 40
' 917 N=O/W,O=W+O*N,W=X,X=(X+I*N)/O,I=(I-W*N)/O: GOTO 40

' --------
' GETDIGIT
' --------

920 W=1E4: IF INKEY$ GOTO 920
921 A=ASC INKEY$: W=W-1: IF NOT A IF W GOTO 921
922 A=VAL CHR$ A: RETURN
