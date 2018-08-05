Using dosubl instead of a macro to avoid numeric truncation;

128 bit floats would eliminate these 64bit issues.

github

https://tinyurl.com/y9dzonq2
https://github.com/rogerjdeangelis/utl_sharing_a_block_of_memory_with_dosubl

* for other dosubl repositories
https://tinyurl.com/yclfhwf3
https://github.com/rogerjdeangelis?utf8=%E2%9C%93&tab=repositories&q=dosubl&type=&language=

This is dumb example that can be done without a macro or dusubl but
I demonstrate passing a value to macro and to dusubl.
commonn macro on end.

   PROBLEM
   =======

     1. Incorrect macro result  1,000,000,000,000,000.00   '430C6BF526340000'x
     2 .Correct dosubl result   1,000,000,000,000,009.00   '430C6BF526340048'x


INPUT  (How we pass data)
==========================

 MACRO CALL

    %let number=%sysevalf(10*(10**(14) + .9));
    %wrong(&number);

 DOSUBL

    number=10*(10**(14) + .9);
    %commonn(number,action=INIT);
    DOSUBL

 EXAMPLE OUTPUTS (correct result is 1000000000000009.0000)


   MACRO INCORRECT  NUMBER=1000000000000000.0000 NUMBER=430C6BF526340000
   DOSUBL CORRECT   NUMBER=1000000000000009.0000 NUMBER=430C6BF526340048


PROCESS
=======

* MACRO;
%macro wrong(number);

  data want;

    retain number &number;
    output;

    put "MACRO INCORRECT  "  number= 21.17 number=  hex16.;

  run;quit;

%mend wrong;

%let number=%sysevalf(10*(10**(14) + .9));

%wrong(&number);

* DOSUBL;
data want;

    %commonn(number,action=INIT);

    number=10*(10**(14) + .9);

    rc=dosubl('
      data _null_;
         %commonn(number,action=GET);
         correct=number;
         put "DOSUBL CORRECT  "  correct= 21.17 correct=  hex16.;

      run;quit;
    ');

run;quit;

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

 * data is internal;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

see process;


%macro commonn(var,action=init,);
   %if %upcase(&action) = INIT %then %do;
      retain &var 0;
      call symputx("varadr",put(addrlong(&var.),hex16.),"G");
   %end;
   %else %if "%upcase(&action)" = "PUT" %then %do;
      call pokelong(&var,"&varadr."x);
   %end;
   %else %if "%upcase(&action)" = "GET" %then %do;
      &var = input(peekclong("&varadr."x,8),rb8.);
   %end;
%mend commonn;



