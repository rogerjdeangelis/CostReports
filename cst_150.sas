*****************************************************************************************************************;
*                                                                                                               *;
*; %let pgm=cst_150;  * Run this if #CONTINUE# was last line in module cst_100  log                                *;
*                                                                                                               *;
*  OPSYS  WIN 10 64bit SAS 9.4M6(64bit)  (This code will not run in lockdown)                                   *;
*                                                                                                               *;
*  %let purpose=Convert Cost Report CSVs files to a single SAS table                                            *;
*                                                                                                               *;
*  Github repository (sample input, output and code is at)                                                      *;
*                                                                                                               *;
*  https://github.com/rogerjdeangelis/CostReports                                                               *;
*                                                                                                               *;
*  PROJECT TOKEN = cst                                                                                          *;
*                                                                                                               *;
*  This is the second module in the Cost Report Project                                                         *;
*                                                                                                               *;
*; %let _r=d; * home directory;                                                                                ;*;
*                                                                                                               *;
*;libname cst "&_r:/cst"; /* Where the schema tables and intermediary tables is stored */                       *;
*;libname  cstfmt "&_r:/cst/fmt";                                                                               *;
*                                                                                                               *;
*; Options (fmtsearch=work.formats cst.cst_fmtV1A sasautos="&_r:/oto");                                         *;
*                                                                                                               *;
*                                                                                                               *;
* INTERNAL MACROS                                                                                               *;
* ===============                                                                                               *;
*                                                                                                               *;
*  cst_200 - first module in cost report analysis                                                               *;
*                                                                                                               *;
* EXTERNAL MACROS IN AUTOCALL LIBRARY                                                                           *;
* ====================================                                                                          *;
*                                                                                                               *;
*                                                                                                               *;
*                                                                                                               *;
*  INPUTS (works for all cost reports here is input for SNF)                                                    *;
*  =========================================================                                                    *;
*                                                                                                               *;
*  The cost report token (example)                                                                              *;
*  The years to process must be sequential                                                                      *;
*                                                                                                               *;
*  cnttok = snf                                                                                                 *;
*  yrs    = 2011-2019                                                                                           *;
*                                                                                                               *;
*  ---------------------------------------------                                                                *;
*                                                                                                               *;
*  The log file from module cst_100.sas                                                                         *;
*                                                                                                               *;
*  Logfile (sample run of SNF 2019                                                                              *;
*  &_r:\cst\log\cst_100snf2019csv.log                                                                           *;
*                                                                                                               *;
*  Wednesday 20MAY20 05:22 Roger SAS DMS Session                                                                *;
*                                                                                                               *;
*  Created d:/cst/zip/snf10fy2019.zip                                                                           *;
*  Created d:/cst/csv/snf10_2019_alpha.csv                                                                      *;
*  Created d:/cst/csv/snf10_2019_nmrc.csv                                                                       *;
*  Created d:/cst/csv/snf10_2019_rpt.csv                                                                        *;
*                                                                                                               *;
*  ##CONTINUE##  ==> Important                                                                                  *;
*                                                                                                               *;
*  ----------------------------------------------                                                               *;
*                                                                                                               *;
*  CSV files                                                                                                    *;
*                                                                                                               *;
*  &_r:\cst\csv\snf10_2010_alpha.csv                                                                            *;
*  &_r:\cst\csv\snf10_2011_alpha.csv                                                                            *;
*  &_r:\cst\csv\snf10_2012_alpha.csv                                                                            *;
*  &_r:\cst\csv\snf10_2013_alpha.csv                                                                            *;
*  &_r:\cst\csv\snf10_2014_alpha.csv                                                                            *;
*  &_r:\cst\csv\snf10_2015_alpha.csv                                                                            *;
*  &_r:\cst\csv\snf10_2016_alpha.csv                                                                            *;
*  &_r:\cst\csv\snf10_2017_alpha.csv                                                                            *;
*  &_r:\cst\csv\snf10_2018_alpha.csv                                                                            *;
*  &_r:\cst\csv\snf10_2019_alpha.csv                                                                            *;
*                                                                                                               *;
*  &_r:\cst\csv\snf10_2010_nmrc.csv                                                                             *;
*  &_r:\cst\csv\snf10_2011_nmrc.csv                                                                             *;
*  &_r:\cst\csv\snf10_2012_nmrc.csv                                                                             *;
*  &_r:\cst\csv\snf10_2013_nmrc.csv                                                                             *;
*  &_r:\cst\csv\snf10_2014_nmrc.csv                                                                             *;
*  &_r:\cst\csv\snf10_2015_nmrc.csv                                                                             *;
*  &_r:\cst\csv\snf10_2016_nmrc.csv                                                                             *;
*  &_r:\cst\csv\snf10_2017_nmrc.csv                                                                             *;
*  &_r:\cst\csv\snf10_2018_nmrc.csv                                                                             *;
*  &_r:\cst\csv\snf10_2019_nmrc.csv                                                                             *;
*                                                                                                               *;
*  &_r:\cst\csv\snf10_2010_rpt.csv                                                                              *;
*  &_r:\cst\csv\snf10_2011_rpt.csv                                                                              *;
*  &_r:\cst\csv\snf10_2012_rpt.csv                                                                              *;
*  &_r:\cst\csv\snf10_2013_rpt.csv                                                                              *;
*  &_r:\cst\csv\snf10_2014_rpt.csv                                                                              *;
*  &_r:\cst\csv\snf10_2015_rpt.csv                                                                              *;
*  &_r:\cst\csv\snf10_2016_rpt.csv                                                                              *;
*  &_r:\cst\csv\snf10_2017_rpt.csv                                                                              *;
*  &_r:\cst\csv\snf10_2018_rpt.csv                                                                              *;
*  &_r:\cst\csv\snf10_2019_rpt.csv                                                                              *;
*                                                                                                               *;
*  PROCESS                                                                                                      *;
*  =======                                                                                                      *;
*                                                                                                               *;
*                                                                                                               *;
*   *    _      _                                                                                               *;
*     __| |_ __(_)_   _____ _ __                                                                                *;
*    / _` | '__| \ \ / / _ \ '__|                                                                               *;
*   | (_| | |  | |\ V /  __/ |                                                                                  *;
*    \__,_|_|  |_| \_/ \___|_|                                                                                  *;
*                                                                                                               *;
*   ;                                                                                                           *;
*                                                                                                               *;
*   * report csvs;                                                                                              *;
*   %cst_150_1(                                                                                                 *;
*        cst=snf                                                                                                *;
*       ,yrs=2011-2019                                                                                          *;
*       ,out=&pgm.snfrpt20112019                                                                                *;
*       );                                                                                                      *;
*                                                                                                               *;
*   * numbers csvs;                                                                                             *;
*   %cst_150_2(                                                                                                 *;
*        cst=snf                                                                                                *;
*       ,yrs=2011-2019                                                                                          *;
*       ,out=&pgm.snfnum20112019                                                                                *;
*       );                                                                                                      *;
*                                                                                                               *;
*   * alpha csvs;                                                                                               *;
*   %cst_150_3(                                                                                                 *;
*        cst=snf                                                                                                *;
*       ,yrs=2011-2019                                                                                          *;
*       ,out=&pgm.snfalp20112019                                                                                *;
*       );                                                                                                      *;
*                                                                                                               *;
*   * put it all in one fact table;                                                                             *;
*   * 15gb;                                                                                                     *;
*   %cst_150_4(                                                                                                 *;
*          num   = cst.&pgm.snfnum20112019                                                                      *;
*         ,alpha = cst.&pgm.snfalp20112019                                                                      *;
*         ,rpt   = cst.&pgm.snfrpt20112019                                                                      *;
*         ,out   = cst.&pgm.snfnumalp20112019                                                                   *;
*       );                                                                                                      *;
*                                                                                                               *;
*                                                                                                               *;
*   cst.&pgm.snfnumalp20112019                                                                                  *;
*                                                                                                               *;
*   2011 thru 2019 reports, numbers and strings in one fact table                                               *;
*                                                                                                               *;
*   TOTOBS                  C16      149,540,000                                                                *;
*                                                                                                               *;
*    -- CHARACTER --                                                                                            *;
*   CLMN_NUM                C5       00600                                                                      *;
*   WKSHT_CD                C7       A700000                                                                    *;
*   LINE_NUM                C5       00900                                                                      *;
*   YER                     C2       16                                                                         *;
*   ITM_TXT                 C40      2591392                                                                    *;
*   TYP                     C1       C                                                                          *;
*   PRVDR_NUM               C7       155486                                                                     *;
*   INITL_RPT_SW            C1       N                                                                          *;
*   LAST_RPT_SW             C1       N                                                                          *;
*   TRNSMTL_NUM             C1                                                                                  *;
*   FI_NUM                  C5       08001                                                                      *;
*   UTIL_CD                 C1       F                                                                          *;
*   SPEC_IND                C1                                                                                  *;
*                                                                                                               *;
*                                                                                                               *;
*                                                                                                               *;
*    -- NUMERIC --                                                                                              *;
*   RPT_REC_NUM             N4       1170813                                                                    *;
*   PRVDR_CTRL_TYPE_CD      N3       4                                                                          *;
*   RPT_STUS_CD             N3       2                                                                          *;
*   ADR_VNDR_CD             N3       4                                                                          *;
*   NPI                     N8       .                                                                          *;
*   FY_BGN_DT               N8       20454                                                                      *;
*   FY_END_DT               N8       20819                                                                      *;
*   PROC_DT                 N8       21026                                                                      *;
*   FI_CREAT_DT             N8       21025                                                                      *;
*   NPR_DT                  N8       21025                                                                      *;
*   FI_RCPT_DT              N8       20978                                                                      *;
*                                                                                                               *;
*****************************************************************************************************************;
*                                                                                                               *;
* CHANGE HISTORY                                                                                                *;
*                                                                                                               *;
*  1. Roger Deangelis              19JMAY2019   Creation                                                        *;
*     rogerjdeangelis@gamil.com                                                                                 *;
*                                                                                                               *;
*****************************************************************************************************************;


*           _
 _ __ _ __ | |_
| '__| '_ \| __|
| |  | |_) | |_
|_|  | .__/ \__|
     |_|
;

%symdel tag beg end yr / nowarn;

%macro cst_150_1(
      cst=snf
      ,yrs=2011-2019
      ,out=
      )/des="create on report table with all years";


    /* for testing wiithout macro
       %let cst=snf;
       %let beg=2011;
       %let end=2011;
       %let yr=2011;
       &_r:\snf\csv\snf10_2011_rpt.csv
       %put &=cst;
    */

    %local beg end yr;

    %let beg=%qscan(&yrs,1,%str(-));
    %let end=%qscan(&yrs,2,%str(-));

    %put &=beg;
    %put &=end;

    %do yr = &beg %to &end;

        proc datasets lib=work nolist;
          delete _rpt&yr. ;
        run;quit;

        %if &yr=&beg %then %do;
          * prior to first year concatenation delete the base file;
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

        infile "&_r:\cst\csv\&cst.10_&yr._rpt.csv" delimiter = ',' TRUNCOVER DSD lrecl=32767;

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
       run;quit;

       proc append data=_rpt&yr base=cst.&out ;
       ;run;quit;

    %end;  /* yr end */

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

%*cst_150_1(
     cst=snf
    ,yrs=2011-2019
    ,out=&pgm.snfrpt20112019
    );

/* cst.&pgm.snf20112019 */

*
 _ __  _ __ ___  _ __ ___
| '_ \| '_ ` _ \| '__/ __|
| | | | | | | | | | | (__
|_| |_|_| |_| |_|_|  \___|

;

%macro cst_150_2(
      cst=snf
      ,yrs=2011-2019
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

    %local beg end yr;

    %let beg=%qscan(&yrs,1,%str(-));
    %let end=%qscan(&yrs,2,%str(-));

    %do yr = &beg %to &end;

        proc datasets lib=work nolist;
          delete _num&yr. ;
        run;quit;

        %if &yr=&beg %then %do;
          * prior to first year concatenation delete the base file;
          proc datasets lib=cst nolist;
            delete &out ;
          run;quit;
        %end;

        data _num&yr;

          retain yer "  ";

          length clmn_num $5;

          infile "&_r:\cst\csv\&cst.10_&yr._nmrc.csv" delimiter = ',' TRUNCOVER DSD lrecl=32767 ;
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

    %end;  /* yr end */

    run;quit;

%mend cst_150_2;

options compress=no;
%*cst_150_2(
     cst=snf
    ,yrs=2011-2019
    ,out=&pgm.snfnum20112019
    );

*      _       _
  __ _| |_ __ | |__   __ _
 / _` | | '_ \| '_ \ / _` |
| (_| | | |_) | | | | (_| |
 \__,_|_| .__/|_| |_|\__,_|
        |_|
;

%macro cst_150_3(
      cst=snf
      ,yrs=2011-2019
      ,out=
      )/des="create on character numerics table with all years";

   /*
    proc fslist file="&inpa10";
    run;quit;

    7,A000000,00100,0000,00100OLD CAP REL COSTS-BLDG & FIXT
    7,A000000,00200,0000,00200OLD CAP REL COSTS-MVBLE EQUIP
    7,A000000,00300,0000,00300NEW CAP REL COSTS-BLDG & FIXT
    7,A000000,00400,0000,00400NEW CAP REL COSTS-MVBLE EQUIP
    7,A000000,00500,0000,00500EMPLOYEE BENEFITS
    7,A000000,00600,0000,00600ADMINISTRATIVE & GENERAL
    7,A000000,00800,0000,00800OPERATION OF PLANT
    7,A000000,00900,0000,00900LAUNDRY & LINEN SERVICE
    7,A000000,01000,0000,01000HOUSEKEEPING
   */

    /*
    CREATE TABLE <subsystem>_RPT_ALPHA (
           RPT_REC_NUM          NUMBER NOT NULL,
           WKSHT_CD             CHAR(7) NOT NULL,
           LINE_NUM             CHAR(5) NOT NULL,
           CLMN_NUM             CHAR(5) NOT NULL for HOSP10
           ALPHNMRC_ITM_TXT     CHAR(40) NOT NULL
    );
    */

    %local beg end yr;

    %let beg=%qscan(&yrs,1,%str(-));
    %let end=%qscan(&yrs,2,%str(-));

    %do yr = &beg %to &end;

        proc datasets lib=work nolist;
          delete _alp&yr. ;
        run;quit;

        %if &yr=&beg %then %do;
          * prior to first year concatenation delete the base file;
          proc datasets lib=cst nolist;
            delete &out ;
          run;quit;
        %end;

        data _alp&yr;
           retain yer " ";
           infile "&_r:\cst\csv\&cst.10_&yr._alpha.csv"  delimiter = ',' TRUNCOVER DSD lrecl=32767 ;
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
                  yer
             ;
           yer = put(&yr - 2000,2.);

        run;quit;

        proc append data=_alp&yr base=cst.&out ;
        ;run;quit;

    %end;  /* yr end */

    run;quit;

%mend cst_150_3;

options compress=char;

%*cst_150_3(
     cst=snf
    ,yrs=2011-2019
    ,out=&pgm.snfalp20112019
    );

*                            _       _
 _ __  _   _ _ __ ___   __ _| |_ __ | |__   __ _
| '_ \| | | | '_ ` _ \ / _` | | '_ \| '_ \ / _` |
| | | | |_| | | | | | | (_| | | |_) | | | | (_| |
|_| |_|\__,_|_| |_| |_|\__,_|_| .__/|_| |_|\__,_|
                              |_|
;

%macro cst_150_4(
       num   = cst.&pgm.snfnum20112019
      ,alpha = cst.&pgm.snfalp20112019
      ,rpt   = cst.&pgm.snfrpt20112019
      ,out   = cst.&pgm.snfnumalp20112019
      )/des="create on character numerics table with all years";


    data  &pgm._nrm (drop=itm_val_num alphnmrc_itm_txt);

      length RPT_REC_NUM 4;

      set
        &num(in=newn )
        &alpha(in=newc )
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
        table &out as
      select
        l.*
       ,r.*
      from
        &pgm._nrm as l, &rpt as r
      where
        l.rpt_rec_num = r.rpt_rec_num
    ;quit;

%mend cst_150_4;

options compress=char;

%*st_150_4(
       num   = cst.&pgm.snfnum20112019
      ,alpha = cst.&pgm.snfalp20112019
      ,rpt   = cst.&pgm.snfrpt20112019
      ,out   = cst.&pgm.snfnumalp20112019
    );

*    _      _
  __| |_ __(_)_   _____ _ __
 / _` | '__| \ \ / / _ \ '__|
| (_| | |  | |\ V /  __/ |
 \__,_|_|  |_| \_/ \___|_|

;

* report csvs;
%cst_150_1(
     cst=snf
    ,yrs=2011-2019
    ,out=&pgm.snfrpt20112019
    );

* numbers;
%cst_150_2(
     cst=snf
    ,yrs=2011-2019
    ,out=&pgm.snfnum20112019
    );

* strings;
%cst_150_3(
     cst=snf
    ,yrs=2011-2019
    ,out=&pgm.snfalp20112019
    );

* put it all in one fact table;
* 15gb;
%cst_150_4(
       num   = cst.&pgm.snfnum20112019
      ,alpha = cst.&pgm.snfalp20112019
      ,rpt   = cst.&pgm.snfrpt20112019
      ,out   = cst.&pgm.snfnumalp20112019
    );

