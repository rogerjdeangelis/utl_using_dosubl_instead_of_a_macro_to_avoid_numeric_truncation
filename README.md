# utl_using_dosubl_instead_of_a_macro_to_avoid_numeric_truncation
Using dosubl instead of a macro to avoid numeric truncation.  Keywords: sas sql join merge big data analytics macros oracle teradata mysql sas communities stackoverflow statistics artificial inteligence AI Python R Java Javascript WPS Matlab SPSS Scala Perl C C# Excel MS Access JSON graphics maps NLP natural language processing machine learning igraph DOSUBL DOW loop stackoverflow SAS community.

    Using dosubl instead of a macro to avoid numeric truncation;

    128 bit floats would eliminate these 64bit issues.

    githubs
    https://tinyurl.com/y8ez3hey
    https://github.com/rogerjdeangelis/utl_using_dosubl_instead_of_a_macro_to_avoid_numeric_truncation
    and
    https://tinyurl.com/y9dzonq2
    https://github.com/rogerjdeangelis/utl_sharing_a_block_of_memory_with_dosubl
    and
    * for other dosubl repositories
    https://tinyurl.com/yclfhwf3
    https://github.com/rogerjdeangelis?utf8=%E2%9C%93&tab=repositories&q=dosubl&type=&language=

    This is dumb example that can be done without a macro or dusubl but
    I demonstrate passing a value to macro and to dusubl.
    commonn macro on end.


    PROBLEM ( I need to eliminate the loss of precision associated with %sysevalf )
    ================================================================================

         1. Incorrect macro result  1,000,000,000,000,000.00   '430C6BF526340000'x
         2 .Correct dosubl result   1,000,000,000,000,009.00   '430C6BF526340048'x


    INPUT  (How we pass data)
    ==========================

     MACRO

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

    OUTPUT
    ======

    EXAMPLE OUTPUTS (correct result is 1000000000000009.0000)

      MACRO INCORRECT  NUMBER=1000000000000000.0000 NUMBER=430C6BF526340000
      DOSUBL CORRECT   NUMBER=1000000000000009.0000 NUMBER=430C6BF526340048


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
    *
      ___ ___  _ __ ___  _ __ ___   ___  _ __  _ __
     / __/ _ \| '_ ` _ \| '_ ` _ \ / _ \| '_ \| '_ \
    | (_| (_) | | | | | | | | | | | (_) | | | | | | |
     \___\___/|_| |_| |_|_| |_| |_|\___/|_| |_|_| |_|

    ;

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




