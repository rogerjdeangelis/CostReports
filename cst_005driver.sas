%let pgm=cst_005driver;

*    _      _
  __| |_ __(_)_   _____ _ __
 / _` | '__| \ \ / / _ \ '__|
| (_| | |  | |\ V /  __/ |
 \__,_|_|  |_| \_/ \___|_|

;
/*
%cst_100     * download all post 2010 cost report zip file and unzip them (2010-curret year-1)
%cst_150_1   * convert all report csvs into a single sas table
%cst_150_2   * convert all numeric variable csvs into a single sas table
%cst_150_3   * convert all character variable csvs into a single sas table
%cst_150_4   * combine report, numeric and character into one sas table note all data in one 40 byte char variable
%cst_200     * for G000000 sheet sum for the four columns and add a fifth column to table
%cst_250     * add descriptions to every cell in the col_cel_describe table
%cst_300     * transpose and add a label with the data from col_cel_describe
             * create a master template of all cell names incase the cells are not in the data
             * change the order of the variables for a more logical pdv
             * export to excel
             * users may want to globally adjust cell width to very wide and change
               the '@' symbol in the header to an 'alt-enter' (change '@' to 'cntl-shift-J(at same time).
               Fianlly do a global collapse cell widths to optimum widths
*/

*                 __ _
  ___ ___  _ __  / _(_) __ _
 / __/ _ \| '_ \| |_| |/ _` |
| (_| (_) | | | |  _| | (_| |
 \___\___/|_| |_|_| |_|\__, |
                       |___/
;

%symdel gbl_tok gbl_typ gbl_yrs gbl_root gbl_oto gbl_sd1 / nowarn;

%let gbl_tok    =  cst                 ;   * project token;
%let gbl_typ    =  snf                 ;   * skilled nursing facilities;
%let gbl_yrs    =  2019-2019           ;   * years to process;
%let gbl_root   =  c                   ;   * where things are;
%let gbl_oto    =  &gbl_root.:/cst/oto ;   * autocall library;
%let gbl_sd1    =  &gbl_root.:/cst     ;   * schema for cost report tables;

* gbl_exe is used with systask fro parallel processing may be needed for slower laptops not need with my system;
%let gbl_exe   =  %sysfunc(compbl(&_r\PROGRA~1\SASHome\SASFoundation\9.4\sas.exe -sysin nul -log nul -work &_r\wrk
                  -rsasuser -autoexec &_r\oto\tut_Oto.sas -nosplash -sasautos &_r\oto -RLANG -config &_r\cfg\sasv9.cfg));
*_       _ _
(_)_ __ (_) |_
| | '_ \| | __|
| | | | | | |_
|_|_| |_|_|\__|
;

* status switches these switches bemore '1' if the corresponding module executed without error;
* I choose to leave of '%if &cst_050=1 %then execute module cst_100 for most modules now';

%let cst_050   =0;
%let cst_100   =0;
%let cst_150   =0;
%let cst_150_1 =0;
%let cst_150_2 =0;
%let cst_150_3 =0;
%let cst_150_3 =0;
%let cst_150_4 =0;
%let cst_250   =0;
%let cst_200   =0;
%let cst_300   =0;
%let cst_350   =0;

libname cst "&gbl_root:/cst";             * location of snowflake schema;
options sasautos=(sasautos,"&gbl_oto");   * autocall library;

* Download all post 2010 cost report zip file and unzip them (2010-curret year-1);
%cst_100(
    cst=&gbl_typ
    ,root=&gbl_root
    ,year=&gbl_yrs
);

/*
    * minutes  for 2011-2019 ;
    * all timings are for 2011-2019;

   %put &=cst_100;
   CST_100=1  (error free)
*/

* convert 2011-2019 reports csvs to one sas table;
%cst_150_1(
    cst=&gbl_typ
    ,root=&gbl_root
    ,yrs=&gbl_yrs
    ,out=cst_150&gbl_typ.rpt
);

/*
    5 seconds
   %put &=cst_150_1;
   CST_150_1=1  (error free)
*/

* convert 2011-2019 numeric csvs to one sas table;
%cst_150_2(
     cst=&gbl_typ
    ,root=&gbl_root
    ,yrs=&gbl_yrs
    ,out=cst_150&gbl_typ.num
);
/*
    5 minutes
   %put &=cst_150_2;
   CST_150_2=1  (error free)
*/

* convert 2011-2019 character csvs to one sas table;
%cst_150_3(
     cst=&gbl_typ
    ,root=&gbl_root
    ,yrs=&gbl_yrs
    ,out=cst_150&gbl_typ.alp
);
/*
    1 minute
   %put &=cst_150_3;
   CST_150_3=1  (error free)
*/

* combine report, numeric and charater data into a single sas table - one 40 byte column
  has both numeric and character values;
%cst_150_4(
    num   = cst_150&gbl_typ.num
    ,alpha = cst_150&gbl_typ.alp
    ,rpt   = cst_150&gbl_typ.rpt
    ,out   = cst_150&gbl_typ.numalp
);

/*
    4 minutes
   %put &=cst_150_4;
   CST_150_4=1  (error free)
*/

* for G000000 sheet sum four columns and add a fifth column to table;
%cst_200(
     typ    = &gbl_typ
    ,yrs    = &gbl_yrs
    ,inp    = cst_150&gbl_typ.numalp
    ,outfiv = cst_200&gbl_typ.fiv
);
/*
    9 minutes
   %put &=cst_200;
   CST_200=1  (error free)
*/

* add descriptions to every cell in the col_cel_describe table;
%cst_250(
     typ    = &gbl_typ
    ,yrs    = &gbl_yrs
    ,inpsd1 = cst_200&gbl_typ.fiv
    ,coldes = cst_025&gbl_typ.describe  /* this is an external input */
    ,outsd1 = cst_250&gbl_typ.fac
   );

* create excek puf;
%cst_300(
     typ    = &gbl_typ
    ,yrs    = &gbl_yrs
    ,root   = &gbl_root
    ,inpsd1 = cst_250&gbl_typ.fac
    ,outxpo = cst_300&gbl_typ.xpo
    ,outmax = cst_300&gbl_typ.max
    ,outxls = cst_300&gbl_typ.puf
);

/*
   8 minutes


%utlnopts;
%put &=cst_100   ;
%put &=cst_150   ;
%put &=cst_150_1 ;
%put &=cst_150_2 ;
%put &=cst_150_3 ;
%put &=cst_150_3 ;
%put &=cst_150_4 ;
%put &=cst_250   ;
%put &=cst_300   ;
%put &=cst_350   ;
%utlopts;


