%let pgm=cst_000makefile;

/*
                   _         __ _ _
   _ __ ___   __ _| | _____ / _(_) | ___
  | '_ ` _ \ / _` | |/ / _ \ |_| | |/ _ \
  | | | | | | (_| |   <  __/  _| | |  __/
  |_| |_| |_|\__,_|_|\_\___|_| |_|_|\___|

  MOdule cst_00.sas is the SAS makefile
  It 'compiles' all the modules needed to run the driver program.
  Users need to run this first and then they can run a short list
  of mudules using the 'module' driver.
  Users can also change and 'recompile' a module by editing the source
  located in the makefile. Highlight and submit highlighted code.

   Run
   Modules
   Sequentially

  %cst_000     * makefile - after running this you should be able to execute the module driver;
  %cst_050     * create directory structure
  %cst_100     * download all post 2010 cost report zip file and unzip them (2010-curret year-1)
  %cst_150_1   * convert all report csvs into a single sas table
  %cst_150_2   * convert all numeric variable csvs into a single sas table
  %cst_150_3   * convert all character variable csvs into a single sas table
  %cst_150_4   * combine report, numeric and character into one sas table note all data in one 40 byte char variable
  %cst_200     * for G000000 sheet sum for the four columns and add a fith columg to table from 4
  %cst_250     * add descriptions to every cell in the col_cel_describe table
  %cst_300     * transpose and add a label with the data from col_cel_describe
               * create a master template of all cell names incase the cells are not in the data
               * change the order of the variables for a more logical pdv
               * export to excel
               * users may want to globally adjust cell width to very wide and change
                 the '@' symbol in the header to an 'alt-enter' (change '@' to 'cntl-shift-J(at same time).
                 Finally do a global collapse cell widths to optimum widths
           _                        _
  _____  _| |_ ___ _ __ _ __   __ _| |___
 / _ \ \/ / __/ _ \ '__| '_ \ / _` | / __|
|  __/>  <| ||  __/ |  | | | | (_| | \__ \
 \___/_/\_\\__\___|_|  |_| |_|\__,_|_|___/
 _                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|

  1. Input externals that must exist before make file (cst_000.sas)

     a. ./cst/oto/cat_010.sas  (package of utility macros)

     b. all post 2010 cost report (currently 2011-2019)
        https://downloads.cms.gov/files/hcris/snf19fy2011-(curret year-1).zip (currently 9 years)

     c. .\cst\cst_025snfdescribe.sas7bdat  * descriptions for every cell in every worksheet below for SNF;
             _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|

    1.  Puf deliverable
        https://tinyurl.com/y9764qvd
        https://www.dropbox.com/s/qzocabam8hp5i7p/cst_300snfcst_300snfpuf20112019.xlsb?dl=0
    2.  Snowflake schema
 _
(_)___ ___ _   _  ___  ___
| / __/ __| | | |/ _ \/ __|
| \__ \__ \ |_| |  __/\__ \
|_|___/___/\__,_|\___||___/


  1. If a cell has not been poulated in all cost reports post 2010 then
     it will not appear in the output excel puf. It will be
     in the snowflake schema. All cells that have at least one poluated value
     post 2010 will be in the excel puf. This can be fixed because the
     col_describe table will habe meta data on the missing cell.

  2. Requires R (may change this if I can get sas url engine to work)

  3. May require 1980s classic SAS. msy not run in EG?

  4. I strongly suggest you put this string on a function key
     and highlight and run anytime SAS gets stuck (i have submit on left mouse button)
     ;;;;/*'*/ *);*};*];*/;/*"*/;%mend;run;quit;%end;end;run;endcomp;%utlfix;

*
 _           _ _     _                   _           _
| |__  _   _(_) | __| |  _ __  _ __ ___ (_) ___  ___| |_
| '_ \| | | | | |/ _` | | '_ \| '__/ _ \| |/ _ \/ __| __|
| |_) | |_| | | | (_| | | |_) | | | (_) | |  __/ (__| |_
|_.__/ \__,_|_|_|\__,_| | .__/|_|  \___// |\___|\___|\__|
                  __ _  |_|           |__/
  ___ ___  _ __  / _(_) __ _
 / __/ _ \| '_ \| |_| |/ _` |
| (_| (_) | | | |  _| | (_| |
 \___\___/|_| |_|_| |_|\__, |
                       |___/
*/

%let gbl_tok   =  cst                 ;   * toten and part of root;
%let gbl_typ   =  snf                 ;   * skilled nursing facilities;
%let gbl_dir   =  0                   ;   * if 1 then build directory structure;
%let gbl_dirsub=  0                   ;   * if 1 then build sub directories;
%let gbl_ext   =  0                   ;   * get externals;
%let gbl_yrs   =  2011-2019           ;   * years to process;
%let gbl_root  =  d                   ;   * where things are;
%let gbl_oto   =  &gbl_root:/cst/oto  ;   * autocall library;
%let gbl_sd1   =  &gbl_root:/cst      ;   * schema for cost report tables;

%put &=gbl_oto;

* sas utilities;
%let gbl_utlinp=  https://raw.githubusercontent.com/rogerjdeangelis/CostReports/master/cst_010.sas; /* utilities */
%let gbl_utlout=  &gbl_root:/cst/oto/cst_010.sas; /* autocall folder */

%let gbl_desinp=  https://raw.githubusercontent.com/rogerjdeangelis/CostReports/master/cst_025snfdescribe_sas7bdat.b64; /* col des */
%let gbl_desout=  &gbl_root:/cst/cst_025snfdescribe.sas7bdat;

* gbl_exe is used with systask for parallel processin. May be needed for slower laptops not needed with my system;
%let gbl_exe   =  %sysfunc(compbl(&_r\PROGRA~1\SASHome\SASFoundation\9.4\sas.exe -sysin nul -log nul -work &_r\wrk
                  -rsasuser -autoexec &_r\oto\tut_Oto.sas -nosplash -sasautos &_r\oto -RLANG -config &_r\cfg\sasv9.cfg));

%put &gbl_tok;
%put &gbl_sd1;
*_       _ _
(_)_ __ (_) |_
| | '_ \| | __|
| | | | | | |_
|_|_| |_|_|\__|

;

* status switches these switches are '1' if the corresponding module executed without error;
* I choose to leave of '%if &cst_050=1 %then execute module cst_100 fornow;

%let cst_050   =0;
%let cst_100   =0;
%let cst_150   =0;
%let cst_150_1 =0;
%let cst_150_2 =0;
%let cst_150_3 =0;
%let cst_150_3 =0;
%let cst_150_4 =0;
%let cst_200   =0;
%let cst_250   =0;
%let cst_300   =0;
%let cst_350   =0;

* create create autocall folder in .cst/oto;

%if &gbl_dir %then %do;

  data _null_;

      newdir=dcreate('cst',"&gbl_root:/");
      newdir=dcreate('oto',"&gbl_root:/cst");   * autocall folder;

  run;quit;

%end /* create dir */;


%if &gbl_dirsub %then %do;

*         _       ___  ____   ___
  ___ ___| |_    / _ \| ___| / _ \
 / __/ __| __|  | | | |___ \| | | |
| (__\__ \ |_   | |_| |___) | |_| |
 \___|___/\__|___\___/|____/ \___/
            |_____|

This copies the macro below to your autocall library.
Create directory structure for costreports
;

* Note you can edit the code below and it will
  de decompiled and copied to your autocall library;

%utl_macrodelete(cst_050);

filename ft15f001 clear;
filename ft15f001 "&gbl_oto/cst_050.sas";
parmcards4;
%macro cst_050(
         root=&gbl_root /* for development ./dev/cst and for production .prd/cst */
         )/ des="create directory structure for costreports";

  %global cst_050;

  %let cst_050=0;
  %put &=cst_050;
  data _null_;

    newdir=dcreate('utl',"&root:/");
    newdir=dcreate('ver',"&root:/");
    newdir=dcreate('xls',"&root:/cst/");
    newdir=dcreate('csv',"&root:/cst/");
    newdir=dcreate('fmt',"&root:/cst/");
    newdir=dcreate('pdf',"&root:/cst/");
    newdir=dcreate('zip',"&root:/cst/");
    newdir=dcreate('doc',"&root:/cst/");
    newdir=dcreate('ppt',"&root:/cst/");
    newdir=dcreate('log',"&root:/cst/");
    newdir=dcreate('lst',"&root:/cst/");
    newdir=dcreate('rtf',"&root:/cst/");
    newdir=dcreate('vdo',"&root:/cst/");
    newdir=dcreate('rtf',"&root:/cst/");
    newdir=dcreate('rda',"&root:/cst/");
    newdir=dcreate('b64',"&root:/cst/");

  run;quit;

  %if &syserr=0 %then %do;
      %let cst_050=1;  * success;
  %end;
  %else %do;
      %let cst_050=0;
  %end;

%mend cst_050;
;;;;
run;quit;

%cst_050(root=&gbl_root);

%end;

*                          _
 ___  __ _ ___  __ _ _   _| |_ ___  ___
/ __|/ _` / __|/ _` | | | | __/ _ \/ __|
\__ \ (_| \__ \ (_| | |_| | || (_) \__ \
|___/\__,_|___/\__,_|\__,_|\__\___/|___/

;
libname cst "&gbl_root:/cst";             * location of snowflake schema;
options sasautos=(sasautos,"&gbl_oto");   * autocall library;


%if &gbl_ext %then %do;

    /*
                _               _                        _
      __ _  ___| |_    _____  _| |_ ___ _ __ _ __   __ _| |___
     / _` |/ _ \ __|  / _ \ \/ / __/ _ \ '__| '_ \ / _` | / __|
    | (_| |  __/ |_  |  __/>  <| ||  __/ |  | | | | (_| | \__ \
     \__, |\___|\__|  \___/_/\_\\__\___|_|  |_| |_|\__,_|_|___/
     |___/ _   _   _     _
     _   _| |_(_) (_) |_(_) ___  ___
    | | | | __| | | | __| |/ _ \/ __|
    | |_| | |_| | | | |_| |  __/\__ \
     \__,_|\__|_|_|_|\__|_|\___||___/

    */

    * if you dont have R do this manually;

    filename _bcot "&gbl_utlout";
    proc http
       method='get'
       url="&gbl_utlinp"
       out= _bcot;
    run;quit;

    filename cin "&gbl_utlout" lrecl=4096 recfm=v;
    %inc cin / nosource;

    /*               _        _     _
     ___  __ _ ___  | |_ __ _| |__ | | ___
    / __|/ _` / __| | __/ _` | '_ \| |/ _ \
    \__ \ (_| \__ \ | || (_| | |_) | |  __/
    |___/\__,_|___/  \__\__,_|_.__/|_|\___|
    */

    filename _bcot "d:/tmp/cst_025snfdescribe_sas7bdat.b64";
    proc http
       method='get'
       url="&gbl_desinp"
       out= _bcot;
    run;quit;

    * Only run if descrition table changes;
    %*utl_b64encode(d:/cst/cst_025snfdescribe.sas7bdat,d:/cst/b64/cst_025snfdescribe_sas7bdat.b64);

    %utl_b64decode(d:/tmp/cst_025snfdescribe_sas7bdat.b64,&gbl_desout);


%end;

*               _   _       _ _
  ___ _ __   __| | (_)_ __ (_) |_
 / _ \ '_ \ / _` | | | '_ \| | __|
|  __/ | | | (_| | | | | | | | |_
 \___|_| |_|\__,_| |_|_| |_|_|\__|

;

*                    _       _
 _ __ ___   ___   __| |_   _| | ___  ___
| '_ ` _ \ / _ \ / _` | | | | |/ _ \/ __|
| | | | | | (_) | (_| | |_| | |  __/\__ \
|_| |_| |_|\___/ \__,_|\__,_|_|\___||___/
          _       _  __    __
  ___ ___| |_    / |/ _ \ / _ \
 / __/ __| __|   | | | | | | | |
| (__\__ \ |_    | | |_| | |_| |
 \___|___/\__|___|_|\___/ \___/
            |_____|
;

%utl_macrodelete(cst_100);

filename ft15f001 "&gbl_oto/cst_100.sas";
parmcards4;
%macro cst_100(
       cst=&gbl_typ
      ,root=&gbl_root
      ,year=&gbl_years
       )/ des="Programtically download and unzip costreport data";

     * delete status dataset;
     proc datasets lib=cst nolist;
        delete cst_100;
     run;quit;

     %global numjob cst_100;;

     %local dwnlod zip alpha nmrc rpt beg end csvs;

     /* for checking without macro
        %let cst=snf;
        %let year=2011-2019;
     */

     %let beg=%scan(&year,1,%str(-));
     %let end=%scan(&year,2,%str(-));

     %let csvs=%eval(1 + (&end - &beg));

     %put &=csvs;
     %let numjob=0;

     %do yr=&beg %to &end;

         %utlnopts;
         %let dwnlod = https://downloads.cms.gov/files/hcris/&cst.10fy&yr..zip;
         %let zip    = &root:/cst/zip/&cst.10fy&yr..zip;
         %let alpha  = &root:/cst/csv/&cst.10_&yr._alpha.csv;;
         %let nmrc   = &root:/cst/csv/&cst.10_&yr._nmrc.csv;
         %let rpt    = &root:/cst/csv/&cst.10_&yr._rpt.csv;

         %put &=dwnlod ;
         %put &=zip    ;
         %put &=alpha  ;
         %put &=nmrc   ;
         %put &=rpt    ;

         * delete if exist;
         %utlfkil(&zip  );
         %utlfkil(&alpha);
         %utlfkil(&nmrc );
         %utlfkil(&rpt  );

         * call R to download and unzip - had issues with SAS;
         %utl_submit_r64("
         activity_url <- '&dwnlod';
         download.file(activity_url, '&zip');
         unzip('&zip',exdir='&root:/cst/csv');
         ");

          data _null_;

             length zipchk $64;
             zipchk   = ifc(fileexist("&zip")  , "Created &zip"   , "Failed &zip");
             alphachk = ifc(fileexist("&alpha"), "Created &alpha" , "Failed &alpha");
             nmrcchk  = ifc(fileexist("&nmrc") , "Created &nmrc"  , "Failed &nmrc");
             rptchk   = ifc(fileexist("&rpt")  , "Created &rpt"   , "Failed &rpt");
             if  Sum(
                fileexist("&zip")   +
                fileexist("&alpha") +
                fileexist("&nmrc")  +
                fileexist("&rpt"))=4 then do;

                  putlog //  "===================================" /
                             zipchk   = /
                             alphachk = /
                             nmrcchk  = /
                             rptchk   = /
                             "===================================" //;
                  call symputx("one",1);
                  rc=dosubl('%let numjob=%eval(&numjob + &one);' );
             end;

          run;quit;

     %end; /* years */

     %put &=numjob;
     %put &=csvs;

     %if &numjob=&csvs %then %let cst_100=1;
     %else %let cst_100=0;

%mend cst_100;
;;;;
run;quit;

/*
    %cst_100(
           cst=&gbl_typ
          ,root=&gbl_root
          ,year=&gbl_yrs
           );

%put &=cst_100;
*/

*         _       _ ____   ___
  ___ ___| |_    / | ___| / _ \
 / __/ __| __|   | |___ \| | | |
| (__\__ \ |_    | |___) | |_| |
 \___|___/\__|___|_|____/ \___/
            |_____|
            _
 _ __ _ __ | |_
| '__| '_ \| __|
| |  | |_) | |_
|_|  | .__/ \__|
     |_|
;



%utl_macrodelete(cst_150_1);

filename ft15f001 "&gbl_oto/cst_150_1.sas";
parmcards4;
%macro cst_150_1(
      cst=&gbl_typ
      ,root=
      ,yrs=&gbl_yrs
      ,out=
      )/des="create on report table with all years";

    options compress=char;

    /* for testing wiithout macro
       %let cst=snf;
       %let beg=2011;
       %let end=2011;
       %let yr=2011;
       %let out=cst_150&gbl_typ.rpt;
       &_r:\snf\csv\snf10_2011_rpt.csv
       %put &=cst;
    */

    %let out=&out%sysfunc(compress(&gbl_yrs,%str(-)));
    %put &=out;

    %local beg end yr;

    %let beg=%qscan(&yrs,1,%str(-));
    %let end=%qscan(&yrs,2,%str(-));

    %put &=beg;
    %put &=end;

    %let csvs=%eval(1 + (&end - &beg));

    %put &=csvs;
    %let numjob=0;

    %do yr = &beg %to &end;

        proc datasets lib=work nolist;
          delete _rpt&yr. ;
        run;quit;

        * prior to first year concatenation delete the base file;
        %if &yr=&beg %then %do;
          proc datasets lib=cst nolist;
            delete &out ;
          run;quit;
        %end;

        data _rpt&yr.;

        retain yer "  ";

        LENGTH
          rpt_rec_num 5
          prvdr_ctrl_type_cd 3
          prvdr_num $7
          rpt_stus_cd 3
          initl_rpt_sw $1
          last_rpt_sw $1
          trnsmtl_num $1
          fi_num $5
          adr_vndr_cd 3
          util_cd $1
          spec_ind $1
          yer      $2
          ;
        LABEL
            rpt_rec_num         ="Report Record Number"
            prvdr_ctrl_type_cd  ="Provider Control Type Code"
            prvdr_num           ="Provider Number"
            npi                 ="National Provider Identifier"
            rpt_stus_cd         ="Report Status Code"
            fy_bgn_dt           ="Fiscal Year Begin Date"
            fy_end_dt           ="Fiscal Year End Date"
            proc_dt             ="HCRIS Process Date"
            initl_rpt_sw        ="Initial Report Switch"
            last_rpt_sw         ="Last Report Switch"
            trnsmtl_num         ="Transmittal Number"
            fi_num              ="Fiscal Intermediary Number"
            adr_vndr_cd         ="Automated Desk Review Vendor Code"
            fi_creat_dt         ="Fiscal Intermediary Create Date"
            util_cd             ="Utilization Code"
            npr_dt              ="Notice of Program Reimbursement Date"
            spec_ind            ="Special Indicator"
            fi_rcpt_dt          ="Fiscal Intermediary Receipt Date"
            yer                 ="Year of CSV file from CMS wweb data"
        ;
        FORMAT
            fy_bgn_dt   MMDDYYS10.
            fy_end_dt   MMDDYYS10.
            proc_dt     MMDDYYS10.
            fi_creat_dt MMDDYYS10.
            npr_dt      MMDDYYS10.
            fi_rcpt_dt  MMDDYYS10.
        ;

        INFORMAT
          rpt_rec_num         best.
          prvdr_ctrl_type_cd  best.
          prvdr_num           $7.
          rpt_stus_cd         best.
          initl_rpt_sw        $1.
          last_rpt_sw         $1.
          trnsmtl_num         $1.
          fi_num              $5.
          adr_vndr_cd         best.
          util_cd             $1.
          spec_ind            $1.
          fy_bgn_dt           MMDDYY10.
          fy_end_dt           MMDDYY10.
          proc_dt             MMDDYY10.
          fi_creat_dt         MMDDYY10.
          npr_dt              MMDDYY10.
          fi_rcpt_dt          MMDDYY10.
        ;

        infile "&root:\cst\csv\&cst.10_&yr._rpt.csv" delimiter = ',' TRUNCOVER DSD LRECL=32767;

        INPUT
            rpt_rec_num
            prvdr_ctrl_type_cd
            prvdr_num
            npi
            rpt_stus_cd
            fy_bgn_dt
            fy_end_dt
            proc_dt
            initl_rpt_sw
            last_rpt_sw
            trnsmtl_num
            fi_num
            adr_vndr_cd
            fi_creat_dt
            util_cd
            npr_dt
            spec_ind
            fi_rcpt_dt
        ;

       yer = put(&yr - 2000,2.);

       %put &=numjob;
       %put &=csvs;

       run;quit;

     proc append data=_rpt&yr base=cst.&out ;
     ;run;quit;

     %let numjob=%eval(&numjob + %eval(&syserr = 0));

    %end;  /* yr end */

    %if &numjob=&csvs %then %let cst_150_1=1;
    %else %let cst_100_1=0;


 /*
   Middle Observation(3103 ) of Last dataset = HSP.HSP_WEB_RP14YER - Total Obs 6207

    -- CHARACTER --
   PRVDR_NUM            C    7       161363    Provider Number
   INITL_RPT_SW         C    1       N         Initial Report Switch
   LAST_RPT_SW          C    1       N         Last Report Switch
   TRNSMTL_NUM          C    1       G         Transmittal Number
   FI_NUM               C    5       05001     Fiscal Intermediary Number
   UTIL_CD              C    1       F         Utilization Code
   SPEC_IND             C    1                 Special Indicator

    -- NUMERIC --
   RPT_REC_NUM          N    5       566534    Report Record Number
   PRVDR_CTRL_TYPE_CD   N    3       9         Provider Control Type Code
   RPT_STUS_CD          N    3       1         Report Status Code
   ADR_VNDR_CD          N    3       4         Automated Desk Review Vendor Code
   NPI                  N    8       .         National Provider Identifier
   FY_BGN_DT            N    8       19905     Fiscal Year Begin Date
   FY_END_DT            N    8       20269     Fiscal Year End Date
   PROC_DT              N    8       20425     HCRIS Process Date
   FI_CREAT_DT          N    8       20425     Fiscal Intermediary Create Date
   NPR_DT               N    8       .         Notice of Program Reimbursement Date
   FI_RCPT_DT           N    8       20417     Fiscal Intermediary Receipt Date
 */

%mend cst_150_1;
;;;;
run;quit;


/*
   * report csvs;
   %cst_150_1(
       cst=&gbl_typ
       ,root=&gbl_root
       ,yrs=&gbl_yrs
       ,out=cst_150&gbl_typ.rpt
       );

%put &=cst_150_1;
*/

*
 _ __  _ __ ___  _ __ ___
| '_ \| '_ ` _ \| '__/ __|
| | | | | | | | | | | (__
|_| |_|_| |_| |_|_|  \___|

;
%utl_macrodelete(cst_150_2);

filename ft15f001 "&gbl_oto/cst_150_2.sas";
parmcards4;
%macro cst_150_2(
      cst=&gbl_typ
      ,root=&gbl_root
      ,yrs=&gbl_yrs
      ,out=
      )/des="create on character numerics table with all years";

    /*
    CREATE TABLE <subsystem>_RPT_NMRC (
           RPT_REC_NUM          NUMBER NOT NULL,
           WKSHT_CD             CHAR(7) NOT NULL,
           LINE_NUM             CHAR(5) NOT NULL,
           CLMN_NUM             CHAR(5) NOT NULL for HOSP10
           ITM_VAL_NUM          NUMBER NOT NULL
    );
    */

    %let out=&out%sysfunc(compress(&gbl_yrs,%str(-)));
    %put &=out;
    %local beg end yr;

    %let beg=%qscan(&yrs,1,%str(-));
    %let end=%qscan(&yrs,2,%str(-));

    %let csvs=%eval(1 + (&end - &beg));

    %put &=csvs;
    %let numjob=0;

    %do yr = &beg %to &end;

        proc datasets lib=work nolist;
          delete _num&yr. ;
        run;quit;

        * prior to first year concatenation delete the base file;
        %if &yr=&beg %then %do;
          proc datasets lib=cst nolist;
            delete &out ;
          run;quit;
        %end;

        data _num&yr;

          retain yer "  ";

          length clmn_num $5;

          infile "&root:\cst\csv\&cst.10_&yr._nmrc.csv" delimiter = ',' TRUNCOVER DSD lrecl=32767 ;
             informat
                RPT_REC_NUM          best.
                WKSHT_CD             $CHAR7.
                LINE_NUM             $CHAR5.
                CLMN_NUM             $CHAR5.
                ITM_VAL_NUM          best.
                yer                  $2.
              ;
           input
                RPT_REC_NUM
                WKSHT_CD
                LINE_NUM
                CLMN_NUM
                ITM_VAL_NUM
           ;

           yer = put(&yr - 2000,2.);

        run;quit;

        proc append data=_num&yr base=cst.&out ;
        ;run;quit;

     %let numjob=%eval(&numjob + %eval(&syserr = 0));

    %end;  /* yr end */

    %if &numjob=&csvs %then %let cst_150_2=1;
    %else %let cst_100_2=0;

    run;quit;

%mend cst_150_2;
;;;;
run;quit;

/*
%cst_150_2(
    cst=&gbl_typ
    ,root=&gbl_root
    ,yrs=&gbl_yrs
    ,out=cst_150&gbl_typ.num
    );

%put &cst_100_2;
*/


*      _       _
  __ _| |_ __ | |__   __ _
 / _` | | '_ \| '_ \ / _` |
| (_| | | |_) | | | | (_| |
 \__,_|_| .__/|_| |_|\__,_|
        |_|
;

%utl_macrodelete(cst_150_3);

filename ft15f001 "&gbl_oto/cst_150_3.sas";
parmcards4;
%macro cst_150_3(
      cst=&gbl_typ
      ,root=&gbl_root
      ,yrs=&gbl_yrs
      ,out=
      )/des="create on character numerics table with all years";


    %local beg end yr;

    %let out=&out%sysfunc(compress(&gbl_yrs,%str(-)));
    %put &=out;

    %let beg=%qscan(&yrs,1,%str(-));
    %let end=%qscan(&yrs,2,%str(-));

    %let csvs=%eval(1 + (&end - &beg));

    %put &=csvs;
    %let numjob=0;

    %let csvs=%eval(1 + (&end - &beg));

    %put &=csvs;
    %let numjob=0;


    %do yr = &beg %to &end;

        proc datasets lib=work nolist;
          delete _alp&yr. ;
        run;quit;

        * prior to first year concatenation delete the base file;
        %if &yr=&beg %then %do;
          proc datasets lib=cst nolist;
            delete &out ;
          run;quit;
        %end;

        data _alp&yr;
           retain yer "  ";
           infile "&root:\cst\csv\&cst.10_&yr._alpha.csv"  delimiter = ',' TRUNCOVER DSD lrecl=32767 ;
               informat
                  RPT_REC_NUM          best.
                  WKSHT_CD             $CHAR7.
                  LINE_NUM             $CHAR5.
                  CLMN_NUM             $CHAR5.
                  ALPHNMRC_ITM_TXT     $CHAR40.
                  yer                  $2.
                ;
            input
                  RPT_REC_NUM
                  WKSHT_CD
                  LINE_NUM
                  CLMN_NUM
                  ALPHNMRC_ITM_TXT
             ;
           yer = put(&yr - 2000,2.);

        run;quit;

        proc append data=_alp&yr base=cst.&out ;
        ;run;quit;

     %let numjob=%eval(&numjob + %eval(&syserr = 0));

    %end;  /* yr end */

    %if &numjob=&csvs %then %let cst_150_3=1;
    %else %let cst_100_3=0;

    run;quit;

%mend cst_150_3;
;;;;
run;quit;

options compress=char;

/*
   * report csvs;
   %cst_150_3(
       cst=&gbl_typ
       ,root=&gbl_root
       ,yrs=&gbl_yrs
       ,out=cst_150&gbl_typ.alp
       );

%put &=cst_150_3;
*/

*                            _       _
 _ __  _   _ _ __ ___   __ _| |_ __ | |__   __ _
| '_ \| | | | '_ ` _ \ / _` | | '_ \| '_ \ / _` |
| | | | |_| | | | | | | (_| | | |_) | | | | (_| |
|_| |_|\__,_|_| |_| |_|\__,_|_| .__/|_| |_|\__,_|
                              |_|
;
%utl_macrodelete(cst_150_4);

filename ft15f001 "&gbl_oto/cst_150_4.sas";
parmcards4;
%macro cst_150_4(
       num   = cst_150&gbl_typ.num
      ,alpha = cst_150&gbl_typ.alp
      ,rpt   = cst_150&gbl_typ.rpt
      ,out   = cst_150&gbl_typ.numalp
      )/des="create on character numerics table with all years";

     %local dfx ;

     %let sfx=%sysfunc(compress(&gbl_yrs,%str(-)));

     %let alpha =&alpha&sfx;
     %let num   =&num&sfx;
     %let rpt   =&rpt&sfx;
     %let out   =&out&sfx;

    proc datasets lib=work nolist;
      delete _nrm;
    run;quit;

    proc datasets lib=cst nolist;
      delete &out;
    run;quit;

    options compress=char;
    data  _nrm (drop=itm_val_num alphnmrc_itm_txt);

      length RPT_REC_NUM 4;

      set
        cst.&num(in=newn )
        cst.&alpha(in=newc )
      ;

      length itm_txt $40;

      select;
        when (newn) do;typ='N';itm_txt=put(itm_val_num, best15. -l);end;
        when (newc) do;typ='C';itm_txt=alphnmrc_itm_txt;            end;
      end;

      label
        typ="Numeric and Character data in the same 40 byte character field"
        itm_txt = "Cell Value as Text ie ie for S31_C2_11 Workskeet S300001 Col 2 Row 11"
      ;

    run;quit;

    /*

    NOTE: Compressing data set WORK._NRM decreased size by 31.73 percent.
          Compressed is 99996 pages; un-compressed would require 146468 pages.
    NOTE: DATA statement used (Total process time):
          real time           1:35.95


    Up to 40 obs from snf_web_nrm total obs=23,213,299

                RPT_REC_
         Obs       NUM      CLMN_NUM    WKSHT_CD    LINE_NUM    ITM_TXT    TYP

           1     534105      00200      A000000      00100      1494791     N
           2     534105      00300      A000000      00100      1494791     N
           3     534105      00400      A000000      00100      1128275     N
           4     534105      00500      A000000      00100      2623066     N
           5     534105      00600      A000000      00100      17295       N
           6     534105      00700      A000000      00100      2640361     N
           7     534105      00400      A000000      00200      16494       N
           8     534105      00500      A000000      00200      16494       N
           9     534105      00600      A000000      00200      4240        N
          10     534105      00700      A000000      00200      20734       N
    */

    proc sql;
      create
        table cst.&out as
      select
        l.*
       ,r.*
      from
        _nrm as l, cst.&rpt as r
      where
        l.rpt_rec_num = r.rpt_rec_num
    ;quit;

    /*
    NOTE: PROCEDURE SQL used (Total process time):
         real time           2:42.05
    */

    %if &sqlobs=0 %then %let cst_150_4=0;
    %else %let cst_150_4=1;

%mend cst_150_4;
;;;;
run;quit;

/*

%cst_150_4(
       num   = cst_150&gbl_typ.num
      ,alpha = cst_150&gbl_typ.alp
      ,rpt   = cst_150&gbl_typ.rpt
      ,out   = cst_150&gbl_typ.numalp
    );

*/

*         _       ____   ___   ___
  ___ ___| |_    |___ \ / _ \ / _ \
 / __/ __| __|     __) | | | | | | |
| (__\__ \ |_     / __/| |_| | |_| |
 \___|___/\__|___|_____|\___/ \___/
            |_____|
;


%utl_macrodelete(cst_200);

filename ft15f001 "&gbl_oto/cst_200.sas";
parmcards4;
%macro cst_200(
     typ    = snf
    ,yrs    = 2011-2019
    ,inp    = cst_150&typ.numalp
    ,outfiv = cst_200&typ.fiv
   ) / des="Create column five in G0 financial worksheet";

     /*
        %let typ    = snf;
        %let yrs    = 2011-2019;
        %let outfiv = cst_200gbl_typ.fiv;
        %let inp    = cst_150Gbl_typ.numalp;
     */


     %let yrscmp=%sysfunc(compress(&yrs,%str(-)));
     %put &yrscmp;

     %let inpfix=%sysfunc(compress(&inp&yrscmp));
     %put &=inpfix;

     %let outfivfix=%sysfunc(compress(&outfiv&yrscmp));
     %put &=outfiv;

     proc datasets lib=work nolist mt=data mt=view;
        delete cstvu &pgm.cstcsvsrt &pgm.sumcol;
     run;quit;

     data cstvu/view=cstvu;
       length wkslynrec $20 csvdatkey $21;
       set cst.&inpfix (
         keep=yer rpt_rec_num prvdr_num WKSHT_CD CLMN_NUM LINE_NUM TYP itm_txt
         rename=itm_txt=csvdatval
       );
       csvdatkey=catx('_',strip(WKSHT_CD),strip(LINE_NUM),strip(CLMN_NUM),TYP);
       wkslynrec=cats(WKSHT_CD,LINE_NUM,rpt_rec_num);
       keep wkslynrec csvdatkey csvdatval rpt_rec_num prvdr_num yer;
     run;quit;

     * sort the view so G0 columns are together;
     proc sort data=cstvu out=&pgm.cstcsvsrt noequals sortsize=80g;
     by yer wkslynrec csvdatkey;
     run;quit;

     /*
     NOTE: PROCEDURE SORT used (Total process time):
     real time           3:35.17
     WORK.CST_200CSTCSVSRT has 149543692 observations and 6 variables
     */

     * add totals for G000000 workbook  index=(reckey=(rpt_rec_num cstnam)/unique;
     * unique to worksheet G000000;
     * sum the four columns in the csv file;
     data cst.&outfiv&yrscmp (sortedby=yer wks rename=(csvdatkey=cstnam csvdatval=cstval));
       retain typ "&typ"  amt 0 wks;
       length wks $7;
       set &pgm.cstcsvsrt;
       by yer wkslynrec csvdatkey;
       typ=upcase(typ);
       wks=substr(wkslynrec,1,7);
       if (substr(wkslynrec,1,7) ne 'G000000') then output;
       else do;
           select;
             when (first.wkslynrec and last.wkslynrec) do;
                   output;
                   substr(csvdatkey,17,1)='5';
                   output;
             end;
             when (first.wkslynrec ) do;output;amt=sum(input(csvdatval,?? best18.),0);end;
             when (last.wkslynrec  ) do;
                output;
                amt=sum(amt,input(csvdatval,?? best18.));
                substr(csvdatkey,17,1)='5';
                csvdatval=put(amt,best18. -l);
                output;
             end;
             otherwise do; amt=sum(amt,input(csvdatval,?? best18.)); output; end;
           end;
       end;
       drop amt wkslynrec;
     run;quit;

     /*
     NOTE: The data set CST.CST_200SNFFIV has 152634402 observations and 7 variables.
     NOTE: DATA statement used (Total process time):
           real time           2:37.40
     */

    %if &syserr=0 %then %let cst_200=1;
    %else %let cst_200=0;

%mend cst_200;
;;;;
run;quit;

/*
options obs=max;
%cst_200(
     typ    = &gbl_typ
    ,yrs    = &gbl_yrs
    ,inp    = cst_150&gbl_typ.numalp
    ,outfiv = cst_200&gbl_typ.fiv
   );
*/

*         _       ____  ____   ___
  ___ ___| |_    |___ \| ___| / _ \
 / __/ __| __|     __) |___ \| | | |
| (__\__ \ |_     / __/ ___) | |_| |
 \___|___/\__|___|_____|____/ \___/
            |_____|
;

%utl_macrodelete(cst_250);

filename ft15f001 "&gbl_oto/cst_250.sas";
parmcards4;
%macro cst_250(
     typ    = snf
    ,yrs    = 2011-2019
    ,inpsd1 = cst_200&typ.fiv
    ,coldes = cst_025&typ.describe
    ,outsd1 = cst_250&typ.fac
   ) / des="Create sas table and excel deliverables";

     /* Run without macro

        %let typ    = snf;
        %let yrs    = 2011-2019;
        %let inpsd1 = cst_200&typ.fiv;
        %let outsd1 = cst_250&typ.fac;
        %let coldes = cst_025&typ.describe;
     */


     %let yrscmp=%sysfunc(compress(&yrs,%str(-)));
     %put &yrscmp;

     %let inpSd1Fix=%sysfunc(compress(&inpsd1&yrscmp));
     %put &=inpsd1fix;

     %let outSd1fix=%sysfunc(compress(&outsd1&yrscmp));
     %put &=outsd1fix;

     proc datasets lib=cst;
        delete &outsd1fix;
     run;quit;

     proc datasets lib=work nolist mt=data mt=view;
        delete cst_250jynprp;
     run;quit;

     proc sql noprint;
         select
            quote(col_cel_name)
         into
            :_cel separated by ","
         from
            cst.&coldes
     ;quit;

    * fact table have both _N and _C but describe table does not so generate both, only one will match;
    data cst_250jynprp;
        length col_cel_name $21;
        set cst.cst_025&typ.describe;
        col_cel_name =cats(substr(col_cel_name,1,19),'_N') ; output ;
        col_cel_name =cats(substr(col_cel_name,1,19),'_C') ; output ;
    run;quit;

    options compress=char;
    * join descriptions to fact table (all cells from csv);

       /*
         %let yer      =11;
         %let inpsd1fix=&inpsd1fix;
         %let outsd1fix=&outsd1fix;
         %let coldes   =&coldes;
       */

       %utlnopts;
       %let st=%sysfunc(time()));
       options compress=char;

       * only the cells that I have discriptions for;
       data cst.&outsd1fix (drop=_rc sortedby=yer wks);

         length col_cel_description $255 ;

         if _n_=1 then
           do;
             if 0 then set cst_250jynprp;
             dcl hash h(dataset:'cst_250jynprp');
             _rc=h.defineKey('col_cel_name');
             _rc=h.definedata('col_cel_description');
             _rc=h.defineDone();
             call missing(col_cel_description);
           end;

         set cst.&inpsd1fix(where=(cstnam in ( &_cel )));
         by yer wks;

         if h.find(key:cstnam)=0 then output;
         else do; COL_CEL_DESCRIPTION="TBD"; output; end;

         drop col_cel_name;

       run;quit;

       %if &syserr=0 %then %let cst_250=1;
       %else %let cst_250=0;

       %let lap=%sysevalf(%sysfunc(time()) - &st);
       %put &=lap;

       %utlopts;


    /*  Possible parallelization

    NOTE: The data set CST.CST_250SNFFAC20112019 has 152634402 observations and 8 variables.
    NOTE: DATA statement used (Total process time):
          real time           1:17.75
    */

%mend cst_250;
;;;;
run;quit;

/*
options obs=max;
%cst_250(
     typ    = &gbl_typ
    ,yrs    = &gbl_yrs
    ,inpsd1 = cst_200&gbl_typ.fiv
    ,coldes = cst_025&gbl_typ.describe  /* this is an external input */
    ,outsd1 = cst_250&gbl_typ.fac
   );
   %put &=cst_250;

   * 1 minute;
*/

*         _       _____  ___   ___
  ___ ___| |_    |___ / / _ \ / _ \
 / __/ __| __|     |_ \| | | | | | |
| (__\__ \ |_     ___) | |_| | |_| |
 \___|___/\__|___|____/ \___/ \___/
            |_____|
;

%utl_macrodelete(cst_300);

filename ft15f001 "&gbl_oto/cst_300.sas";
parmcards4;
%macro cst_300(
     typ    = &gbl_typ
    ,yrs    = &gbl_yrs
    ,root   = &gbl_root
    ,inpsd1 = cst_250&gbl_typ.fac
    ,outxpo = cst_300&gbl_typ.xpo
    ,outmax = cst_300&gbl_typ.max
    ,outxls = cst_300&gbl_typ.puf
   ) / des="Create excel puf";

     /*
        * if run without calling macro;

        %let typ    = &gbl_typ;
        %let yrs    = &gbl_yrs;
        %let root   = &gbl_root;       ;
        %let inpsd1 = cst_250&gbl_typ.fac;
        %let outxpo = cst_300&gbl_typ.xpo;
        %let outmax = cst_300&gbl_typ.max;
        %let outxls = cst_300&gbl_typ.puf;

        %put &=typ   ;
        %put &=yrs   ;
        %put &=inpsd1;
        %put &=outxpo;
        %put &=outmax;
        %put &=outxls;
     */

    %local S2 S3 G0 G2 G3 s7 s4 c0 C0 O0 A0 A7 E0 _yrsn ;

    %let yrscmp=%sysfunc(compress(&yrs,%str(-)));
    %put &yrscmp;

    %let inpSd1Fix=%sysfunc(compress(&inpsd1&yrscmp));
    %put &=inpsd1fix;

    %let outmaxFix=%sysfunc(compress(&outmax&yrscmp));
    %put &=outmaxfix;

    %let outxpoFix=%sysfunc(compress(&outxpo&yrscmp));
    %put &=outxpofix;

    %let outxlsfix=%sysfunc(compress(&outxls&yrscmp));
    %put &=outxlsfix;

    proc datasets lib=cst nolist;
       delete &outxpofix &outmaxfix ;
    run;quit;

    %utlfkil(&root:\cst\xls\cst_300&typ&outxlsfix..xlsx);

    %utlnopts;
    %array(xyrs,values=&yrs);

    * chk array;
    %put &=xyrsn;
    %put &=xyrs1;
    %utlopts;

    proc sort data=cst.&inpsd1fix out=cst_300srt noequals
        sortsize=80gb;
        by yer rpt_rec_num prvdr_num wks cstnam;
    run;quit;

    /*
     NOTE: PROCEDURE SORT used (Total process time):
         real time           55.64 seconds
         user cpu time       59.48 seconds
    */

    proc transpose data=cst_300srt
             out=cst_300xpo(drop=_name_ _label_);
       by yer rpt_rec_num prvdr_num ;
       var cstval;
       id cstnam;
       idlabel col_cel_description;
    run;quit;

    /*
    NOTE: PROCEDURE TRANSPOSE used (Total process time):
          real time           3:11.83
    */

   * get all cell names populated or not;
   * get single record max value for ever cell;
   proc sql;
     create
        table cst.&outmaxfix (rename=(_TEMG001=cstnam  _TEMG003=maxLenVal)) as
     select
       distinct
        max(cstnam)
       ,max(lengthn(cstval))
     from
        cst_300srt
     group
        by cstnam
     having
        lengthn(cstval) = max(lengthn(cstval))
   ;quit;

   /*

    * if a cell is missing n the final puf it does not exist in the 9 years of data;

    data chk;
      set cst.&outmaxfix(where=(cstnam=:'G000000_02000'));
    run;quit;


    28653!     quit;
    NOTE: PROCEDURE SQL used (Total process time):
          real time           36.37 seconds
          user cpu time       42.39 seconds
   */

    proc transpose data=cst.&outmaxfix out=cst_300oneXpo;
      var maxlenval;
      id cstnam;
    run;quit;


    %utlnopts;
    %let A0=%varlist(cst_300onexpo,prx=/^A0/i);
    %let A7=%varlist(cst_300onexpo,prx=/^A7/i);
    %let E0=%varlist(cst_300onexpo,prx=/^E0/i);
    %let S2=%varlist(cst_300onexpo,prx=/^S2/i);
    %let S3=%varlist(cst_300onexpo,prx=/^S3/i);
    %let s4=%varlist(cst_300onexpo,prx=/^S4/i);
    %let G0=%varlist(cst_300onexpo,prx=/^G0/i);
    %let G2=%varlist(cst_300onexpo,prx=/^G2/i);
    %let G3=%varlist(cst_300onexpo,prx=/^G3/i);
    %let s7=%varlist(cst_300onexpo,prx=/^S7/i);
    %let c0=%varlist(cst_300onexpo,prx=/^C0/i);
    %let O0=%varlist(cst_300onexpo,prx=/^O0/i);
    %utlopts;

    %*put &=s4;

    data cst.&outxpofix (rename=(rpt_rec_num=Report_Record  prvdr_num=Provider_CCN));
      retain
         Cost_Report Year rpt_rec_num  prvdr_num ;
      attrib
         &s2
         &s3
          A000000_10000_00100_N
          A000000_10000_00200_N
          C000000_10000_00200_N
          C000000_10000_00100_N
          E00A181_00100_00100_N
          E00A181_00200_00100_N
          E00A181_00600_00100_N
         &E0
         &G0
         &G2
         &G3
         &s7
         &s4
         &A0
         &A7
         &c0
              length=$40;
      keep
         Cost_Report year rpt_rec_num  prvdr_num
         &s2
         &s3
          A000000_10000_00100_N
          A000000_10000_00200_N
          C000000_10000_00200_N
          C000000_10000_00100_N
          E00A181_00100_00100_N
          E00A181_00200_00100_N
          E00A181_00600_00100_N
         &E0
         &G0
         &G2
         &G3
         &s7
         &s4
         &A0
         &A7
         &c0;

    set cst_300xpo(obs=max);

    year=2000 + input(yer,3.);

    Cost_Report=upcase("&typ");

    run;quit;

    %if &syserr=0 %then %let cst_300=1;
    %else %let cst_300=0;

    * 8 seconds;

   %utlnopts;
   options label;
   proc export data=cst.&outxpofix
       outfile="&root:\cst\xls\cst_300&typ&outxlsfix..xlsx"
       label dbms=xlsx
       replace;
   run;quit;

%mend cst_300;
;;;;
run;quit;

/*

%symdel S2 S3 G0 G2 G3 s7 s4 c0 C0 O0 A0 A7 E0 xyrsn / nowarn;

options obs=1000000;

%cst_300(
     typ    = &gbl_typ
    ,yrs    = &gbl_yrs
    ,root   = &gbl_root
    ,inpsd1 = cst_250&gbl_typ.fac
    ,outxpo = cst_300&gbl_typ.xpo
    ,outmax = cst_300&gbl_typ.max
    ,outxls = cst_300&gbl_typ.puf
   );

   %put &=cst_300;
*/

*               _
  ___ _ __   __| |
 / _ \ '_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

;
