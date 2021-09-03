# PC-G850(V)(S)

`RUN` to start and clear all registers.

`GOTO*R` to resume execution without clearing regusters.

| key    | assigned to
| ------ | ---------------------------------------------------------------------
| 0~9    | digit
| .      | decimal period
| Exp    | x10^
| E      | same as Exp, x10^
| I      | enter imag part or back to real part
| J      | same as I (for engineers)
| F<-\>E | re<-\>im, swap X with I,
| SPACE  | or (-) SHIFT minus, change sign
| BS     | delete
| LEFT   | delete
| RIGHT  | swap XI with YJ
| UP     | roll stack up
| DOWN   | roll stack down
| ENTER  | push on stack
| =      | enter BASIC expression
| CLS    | clear entry
| CA     | clear all, reset
| SIN    | any PC-G850 calculator function key such as SIN
| A      | abs, |XI| -\> XI
| C      | ceiling, ceil(XI) -\> XI
| F      | fraction, frac(XI) -\> XI
| G      | GCD, gcd(Y,X) -\> X
| H      | hyp prefix to [arc]sin,[arc]cos,[arc]tan
| I      | enter imag part / back to real part
| J      | same as I (for engineers)
| L      | linear regression, slope and intercept -\> Y,X
| M      | mean of y and x -\> Y,X
| N      | floor, floor(XI) -\> XI
| Q      | quotient and remainder of Y/X -\> X,Y (quotient in X, remainder in Y)
| R      | rational, X -\> Y,X such that Y/X approximates the given X within 1E-10
| S      | stddev Sy and Sx -\> Y,X
| T      | truncate, trunc(XI) -\> XI
| V      | variance of y and x -\> Y,X
| Y      | linear estimation of r and y given X=x -\> Y,X
| ^      | raise, YJ^XI -\> XI
| +      | add, YJ+XI -\> XI
| -      | subtract, YJ-XI -\> XI
| \*     | multiply, YJ\*XI -\> XI
| /      | divide, YJ/XI -\> XI
| !      | factorial/gamma, fact(X) gamma(X+1) -\> X
| %      | percentage, X/100\*YJ -\> XI
| 2ndF   | SHIFT
| SHIFT  | does not operate
| RCM    | last-x, push LM -\> X
| S-CONST| (SHIFT CONST) display registers (press key to continue)
| CONST  | STO (followed optionally by +, -, \* or /) and then digit to store #register
| ANS    | RCL (followed optionally by +, -, \* or /) and then digit to recall #register
| -\>DEG | hh.mmss X -\> degree X
| -\>DMS | convert degree X -\> hh.mmss X
| PI     | push pi -\> X
| RND    | random, push random 0\<x\<1
| ?      | same as RND, push random 0\<x\<1 -\> X
| MDF    | round towards zero
| STAT   | clear stat registers R2 to R7
| M+     | stat add Y,X (updates registers R2 to R7 as per HP-15C stat)
| M-     | stat remove Y,X

