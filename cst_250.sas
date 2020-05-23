*****************************************************************************************************************;
*                                                                                                               *;
*; %let pgm=cst_250;                                                                                            *;
*                                                                                                               *;
*  OPSYS  WIN 10 64bit SAS 9.4M6(64bit)  (This code will not run in lockdown)                                   *;
*                                                                                                               *;
*; %let purpose=Create the fact table to the snowflake schema;                                                 ;*;
*                                                                                                               *;
*  Github repository (sample input, output and code is at)                                                      *;
*                                                                                                               *;
*  https://github.com/rogerjdeangelis/CostReports                                                               *;
*                                                                                                               *;
*  PROJECT TOKEN = cst                                                                                          *;
*                                                                                                               *;
*  This is the fourth  module in the Cost Report Project                                                        *;
*                                                                                                               *;
*; %let _r=d; * home directory;                                                                                ;*;
*                                                                                                               *;
*;libname cst "&_r:/cst"; /* Where the schema tables and intermediary tables is stored */                       *;
*;libname  cstfmt "&_r:/cst/fmt";                                                                               *;
*                                                                                                               *;
*; options fmtsearch=(work.formats cst.cst_fmtv1a) sasautos="&_r:/oto" ;                                        *;
*                                                                                                               *;
*  worksheet descriptions                                                                                       *;
*  https://www.costreportdata.com/worksheet_formats.html                                                        *;
*                                                                                                               *;
* INTERNAL MACROS                                                                                               *;
* ===============                                                                                               *;
*                                                                                                               *;
*  cst_250 - first module in cost report analysis                                                               *;
*                                                                                                               *;
* EXTERNAL MACROS IN AUTOCALL LIBRARY                                                                           *;
* ====================================                                                                          *;
*                                                                                                               *;
*  INPUTS (works for all cost reports here is input for SNF)                                                    *;
*  =========================================================                                                    *;
*                                                                                                               *;
*  The cost report token (example)                                                                              *;
*  The years to process must be sequential                                                                      *;
*                                                                                                               *;
*  typ    = snf                                                                                                 *;
*  yrs    = 2011-2019                                                                                           *;
*                                                                                                               *;
*  Output from cst_200 macro                                                                                    *;
*                                                                                                               *;
*  &_r:\cst\CST_200SnfFiv20112019.sas7bdat                                                                      *;
*                                                                                                               *;
*  This is a external you need before rnning the code (this is outside the project)                             *;
*                                                                                                               *;
*  &_r:\cst\xls\cst_025snfrug.xlsx    * Descriptions for rug codes lost web link;                               *;
*                                                                                                               *;
*                                                                                                               *;
*  PROCESS                                                                                                      *;
*  =======                                                                                                      *;
*                                                                                                               *;
*    1. Check status of previous module, cst_200.                                                               *;
*                                                                                                               *;
*       If previous module executed without error then this table will exist                                    *;
*                                                                                                               *;
*       &_r:\cst\cst_200.sas7badat                                                                              *;
*                                                                                                               *;
*       else                                                                                                    *;
*                                                                                                               *;
*       it will not exist                                                                                       *;
*                                                                                                               *;
*       If it does not exist go into sytax check mode                                                           *;
*                                                                                                               *;
*                                                                                                               *;
*  OUTPUTS (works for all cost reports here is input for SNF)                                                   *;
*  =========================================================                                                    *;
*                                                                                                               *;
*  TBD                                                                                                          *;
*                                                                                                               *;
*                                                                                                               *;
*  Background Information                                                                                       *;
*                                                                                                               *;
*  WorkSheet                                                                                                    *;
*                                                                                                               *;
*  S1,S2, S3 CERTIFICATION AND SETTLEMENT SUMMARY                                                               *;
*                                                                                                               *;
*  S41       SNF-BASED HOME HEALTH AGENCY                                                                       *;
*                                                                                                               *;
*  O01       ANALYSIS OF HOSPITAL-BASED HOSPICE COSTS                                                           *;
*                                                                                                               *;
*  S7        PROSPECTIVE PAYMENT FOR SNF STATISTICAL DATA                                                       *;
*  A0        RECLASSIFICATION AND ADJUSTMENT OF TRIAL BALANCE OF EXPENSES                                       *;
*                                                                                                               *;
*  A7        RECONCILIATION OF CAPITAL COSTS CENTERS                                                            *;
*                                                                                                               *;
*  C0        COMPUTATION OF RATIO OF COSTS TO CHARGES                                                           *;
*  O0        ANALYSIS OF HOSPITAL-BASED HOSPICE COSTS                                                           *;
*                                                                                                               *;
*  E00A181   CALCULATION OF REIMBURSEMENT SETTLEMENT TITLE XVIII                                                *;
*  E00A192   ANALYSIS OF PAYMENTS TO PROVIDERS FOR SERVICES RENDERED                                            *;
*                                                                                                               *;
*  G0        BALANCE SHEET                                                                                      *;
*  G2        STATEMENT OF PATIENT REVENUES AND OPERATING EXPENSES                                               *;
*  G3        STATEMENT OF REVENUES AND EXPENSES                                                                 *;
*                                                                                                               *;
*****************************************************************************************************************;
*                                                                                                               *;
* CHANGE HISTORY                                                                                                *;
*                                                                                                               *;
*  1. Roger Deangelis              19JMAY2019   Creation                                                        *;
*     rogerjdeangelis@gamil.com                                                                                 *;
*                                                                                                               *;
*****************************************************************************************************************;


%macro cst_250(
     typ    = snf
    ,yrs    = 2011-2019
    .outyrs = 2019
    ,outwks = G
    ,inpsd1 = cst_200&typ.fiv
    ,inpmax = cst_200&typ.max
    ,coldes = cst_025&typ.describe
    ,inpxls = &_r:\cst\xls\cst_025snfrug.xlsx  /* this neeeds to exist before any module execution */
    ,outsd1 = cst_250&typ.fac
    ,outxls = &_r:\cst\xls\cst_025snfG0w.xlsx
   ) / des="Create sas table and excel deliverables";

     /*
        %let typ    = snf;
        %let yrs    = 2011-2019;
        %let outyrs = 2019;
        %let outwks = G;
        %let inpsd1 = cst_200&typ.fiv;
        %let inpmax = cst_200&typ.max;
        %let inpxls = &_r:\cst\xls\cst_025snfrug.xlsx;
        %let outxls = &_r:\cst\xls\cst_025snfG0w.xlsx;
        %let outsd1 = cst_250&typ.fac;
        %let coldes = cst_025&typ.describe;
     */

     %let yrscmp=%sysfunc(compress(&yrs,%str(-)));
     %put &yrscmp;

     %let inpSd1Fix=%sysfunc(compress(&inpsd1&yrscmp));
     %put &=inpsd1fix;

     %let outSd1fix=%sysfunc(compress(&outsd1&yrscmp));
     %put &=outsd1fix;

     %let inpmaxfix=%sysfunc(compress(&inpmax&yrscmp));
     %put &=inpmaxfix;

     %put &=outwkd;

     proc datasets lib=cst;
        delete cst_250;
     run;quit;

     /*
     proc datasets lib=work nolist mt=data mt=view;
        delete cstvu &pgm.cstcsvsrt &pgm.sumcol;
     run;quit;

     proc datasets lib=cst nolist;
        delete &outfiv &outmax cst_200;
     run;quit;
     */

     proc sort data=cst.&inpsd1fix (drop=csvdatlen where=(yer="%eval(&outyrs - 2000)")) out=cst_250&typ.srt sortsize=10gb;
        by rpt_rec_num prvdr_num cstnam;
     run;quit;

     /*
      Up to 40 obs from CST_250SNFSRT total obs=2,279,939

                                       RPT_REC_                                                    PRVDR_
       TYP           CSTNAM               NUM      YER    CSTVAL                                    NUM

       snf    A000000_00100_00000_C     1224087    19     0100CAP REL COSTS - BLDGS & FIXTURES     155158
       snf    A000000_00100_00200_N     1224087    19     268280                                   155158
       snf    A000000_00100_00300_N     1224087    19     268280                                   155158
       snf    A000000_00100_00500_N     1224087    19     268280                                   155158
     */

    data cst_250jynprp;
        length col_cel_name $21;
        set cst.cst_025&typ.describe;
        col_cel_name =cats(col_cel_name,'_N') ; output ;
        col_cel_name =cats(col_cel_name,'_C') ; output ;
    run;quit;

    proc sort data=cst_250jynprp out=cst_250jynprp(index=col_cel_name/unique);
    by col_cel_name;
    run;quit;

    data cst_250preRpt (drop=_rc);

      if _n_=1 then
        do;
          if 0 then set cst_250jynprp;
          dcl hash h(dataset:'cst_250jynprp');
          _rc=h.defineKey('col_cel_name');
          _rc=h.definedata('col_cel_description');
          _rc=h.defineDone();
        end;

      set cst_250&typ.srt;

      if h.find(key:cstnam)=0 then output;

    run;quit;

    proc transpose data=cst_250prerpt
             out=cst_250prerptxpo(drop=_name_);
       by rpt_rec_num prvdr_num;
       var cstval;
       id cstnam;
       idlabel col_cel_description;
    run;quit;

    options ls=384;
    options label;
    proc report data=cst_250prerptxpo(obs=1) list;
    run;quit;

    %local

    %utlnopts;
    %let S2=%varlist(cst_250prerptxpo,prx=/^S2/i);
    %let S3=%varlist(cst_250prerptxpo,prx=/^S3/i);
    %let G0=%varlist(cst_250prerptxpo,prx=/^G0/i);
    %let G2=%varlist(cst_250prerptxpo,prx=/^G2/i);
    %let G3=%varlist(cst_250prerptxpo,prx=/^G3/i);
    %let s7=%varlist(cst_250prerptxpo,prx=/^S7/i);
    %let s4=%varlist(cst_250prerptxpo,prx=/^S4/i);
    %let c0=%varlist(cst_250prerptxpo,prx=/^C0/i);
    %let C0=%varlist(cst_250prerptxpo,prx=/^C0/i);
    %let O0=%varlist(cst_250prerptxpo,prx=/^O0/i);
    %utlopts;

    %put &=o0;


    data cst_250ordcol;
      retain
         rpt_rec_num  prvdr_num
         &s2
         &s3
          A000000_10000_00100_N
          A000000_10000_00200_N
          C000000_10000_00200_N
          C000000_10000_00100_N
          E00A181_00100_00100_N
          E00A181_00200_00100_N
          E00A181_00600_00100_N
         &G0
         &G2
         &G3
         &s7
         &s4
         &c0
         &o0
     ;
     set cst_250prerptxpo;
   run;quit;


    ods listing close;
   options label;
   ods excel file="d:/cst/xls/cst_250all.xlsx" style=pearl;
   ods excel options(sheet_name="final" autofilter= 'yes' frozen_headers   = '3' );

   %utlopts;
   options label cpucount=16;

   proc report data=cst_250ordcol missing nowd split="@"
     style(column)={cellwidth=5in just=c protectspecialchars=on};
   run;quit;

   ods excel close;
   ods listing;

%mend cst_250;

%cst_250(
     typ    = snf
    ,yrs    = 2011-2019
    .outyrs = 2019
    ,outwks = S2 S3 A0 A0 C0 C0 E0 E0 E0 G0 G2 G3 S7 S4 C0 O0 /* output worksheets */
    ,inpsd1 = cst_200&typ.fiv
    ,inpmax = cst_200&typ.max
    ,coldes = cst_025&typ.describe
    ,inpxls = &_r:\cst\xls\cst_025snfrug.xlsx  /* this neeeds to exist before any module execution */
    ,outsd1 = cst_250&typ.fac
   ";
