# PC-1475

`RUN` to start and clear all registers.

`DEF-A` to resume execution without clearing registers.

| key    | assigned to
| ------ | ---------------------------------------------------------------------
| 0~9    | digit
| .      | period
| EXP    | x10^
| E      | smae as EXP, x10^
| I      | enter imag part or back to real part
| J      | same as I (for engineers)
| +/-    | change sign
| SPC    | same as +/-, change sign
| BS     | delete
| LEFT   | delete
| SPC    | change sign
| RIGHT  | swap XI with YJ
| UP     | roll stack up
| DOWN   | roll stack down
| ENTER  | push on stack
| =      | enter BASIC expression
| CLS    | clear entry
| CA     | clear all, reset
| SIN    | any PC-1475 calculator function key such as SIN
| A      | abs, |XI| -\> XI
| B      | nPr(Y,X) -\> X
| C      | ceiling, ceil(XI) -\> XI
| D      | round towards zero, round(XI) -\> XI
| F      | fraction, frac(XI) -\> XI
| G      | GCD, gcd(Y,X) -\> X
| H      | hyp prefix to [arc]sin,[arc]cos,[arc]tan
| I      | enter imag part / back to real part
| J      | same as I (for engineers)
| K      | nCr(Y,X) -\> X
| L      | STO #register (press digit)
| M      | mean of y and x -\> Y,X
| N      | floor, floor(XI) -\> XI
| Q      | quotient and remainder of Y/X -\> X,Y (quotient in X, remainder in Y)
| R      | rational, X -\> Y,X such that Y/X approximates the given X within 1E-10
| S      | stddev Sy and Sx -\> Y,X
| T      | truncate, trunc(XI) -\> XI
| V      | variance of y and x -\> Y,X
| X      | last-x, push LM -\> XI
| Y      | linear estimation of r and y given X=x -\> Y,X
| Z      | linear regression, slope and intercept -\> Y,X
| HYP    | hyp prefix to [arc]sin,[arc]cos,[arc]tan
| SHIFT  | shift (indicared by S- below)
| S-0    | mean of y -\> X
| S-1    | mean of x -\> X
| S-2    | Sx -\> X
| S-3    | stddev of x -\> X
| S-4    | sum of xy -\> X
| S-5    | sum of y -\> X
| S-6    | sum of y^2 -\> X
| S-7    | n -\> X
| S-8    | sum of x -\> X
| S-9    | sum of x^2 -\> X
| S-+/-  | Sy -\> X
| S-.    | stddev of y -\> X
| S-B    | linear regression intercept a -\> X
| S-M    | linear estimation of x given X=y -\> X
| S-N    | linear regression slope b -\> X
| S-V    | linear regression coefficient r -\> X
| S-SPC  | linear estimation of y given X=x -\> X
| ^      | raise
| +      | add
| -      | subtract
| \*     | multiply
| /      | divide
| !      | factorial/gamma(x+1), fact(X) gamma(X+1) -\> X
| %      | percentage, X/100\*YJ -\> XI
| (      | STO (followed optionally by +, -, \* or /) and then digit to store #register
| )      | RCL (followed optionally by +, -, \* or /) and then digit to recall #register
| ,      | same as ), RCL #register
| ?      | push random 0\<x\<1 -\> X
| -\>DEG | hh.mmss -\> degree
| -\>DMS | degree -\> hh.mmss
| PI     | push pi -\> X
| STAT   | (S-=) clear stat registers R2 to R7
| INS    | stat add Y,X (updates registers R2 to R7 as per HP-15C stat)
| DEL    | stat remove Y,X (updates registers R2 to R7 as per HP-15C stat)

