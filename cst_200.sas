*****************************************************************************************************************;
*                                                                                                               *;
*; %let pgm=cst_200;                                                                                            *;
*                                                                                                               *;
*  OPSYS  WIN 10 64bit SAS 9.4M6(64bit)  (This code will not run in lockdown)                                   *;
*                                                                                                               *;
*  %let purpose=Sum columns 1 thru 4 in worksheet G0;                                                           *;
*                                                                                                               *;
*  Github repository (sample input, output and code is at)                                                      *;
*                                                                                                               *;
*  https://github.com/rogerjdeangelis/CostReports                                                               *;
*                                                                                                               *;
*  PROJECT TOKEN = cst                                                                                          *;
*                                                                                                               *;
*  This is the third  module in the Cost Report Project                                                         *;
*                                                                                                               *;
*; %let _r=d; * home directory;                                                                                ;*;
*                                                                                                               *;
*;libname cst "&_r:/cst"; /* Where the schema tables and intermediary tables is stored */                       *;
*;libname  cstfmt "&_r:/cst/fmt";                                                                               *;
*                                                                                                               *;
*; options fmtsearch=(work.formats cst.cst_fmtv1a) sasautos="&_r:/oto" ;                                        *;
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
*  typ    = snf                                                                                                 *;
*  yrs    = 2011-2019                                                                                           *;
*                                                                                                               *;
*  Output from cst_150 macro (2011-201 SNF all data from all CSVs(                                              *;
*                                                                                                               *;
*  &_r:\cst\CST_150SNFNUMALP20112019.sas7bdat                                                                   *;
*                                                                                                               *;
*  PROCESS                                                                                                      *;
*  =======                                                                                                      *;
*                                                                                                               *;
*    1. Check status of previous module, cst_150.                                                               *;
*                                                                                                               *;
*       If previous module executed without error then this table will exist                                    *;
*                                                                                                               *;
*       &_r:\cst\cst_150.sas7badat                                                                              *;
*                                                                                                               *;
*       else                                                                                                    *;
*                                                                                                               *;
*       it will not exist                                                                                       *
*                                                                                                               *;
*       If it does not exist go into sytax check mode                                                           *;
*                                                                                                               *;
*    2. Sum columns 1-4 in G0 worksheet and add create column 5                                                 *;
*                                                                                                               *;
*       example (creates a worksheet column 5 that does not exist in original work sheet)                       *;
*                                                                                                               *;
*        Worsheet Line                                                                                          *;
*                                                                                                               *;
*        G000000_01200_00500 =                                                                                  *;
*                                                                                                               *;
*         G000000_01200_00100 +                                                                                 *;
*         G000000_01200_00200 +                                                                                 *;
*         G000000_01200_00300 +                                                                                 *;
*         G000000_01200_00400                                                                                   *;
*                                                                                                               *;
*                                                                                                               *;
*  OUTPUTS (works for all cost reports here is input for SNF)                                                   *;
*  =========================================================                                                    *;
*                                                                                                               *;
*  1. Skinny fact table with addded column 5 in G0 worksheet                                                    *;
*                                                                                                               *;
*      &_r:\cst\CST_200Fiv20112019.sas7bdat                                                                     *;
*                                                                                                               *;
*  2. One record with the max value for every cell for all Years of SNF                                         *;
*                                                                                                               *;
*      &_r:\cst\CST_200Max20112019.sas7bdat                                                                     *;
*                                                                                                               *;
*  3. If code ran sucessfully create sas table                                                                  *;
*                                                                                                               *;
*     &_r:\cst\CST_200.sas7bdat                                                                                 *;
*                                                                                                               *;
*                                                                                                               *;
*****************************************************************************************************************;
*                                                                                                               *;
* CHANGE HISTORY                                                                                                *;
*                                                                                                               *;
*  1. Roger Deangelis              19JMAY2019   Creation                                                        *;
*     rogerjdeangelis@gamil.com                                                                                 *;
*                                                                                                               *;
*  2. O record for every cell in   19JMAY2019   Creation                                                        *;
*     rogerjdeangelis@gamil.com                                                                                 *;
*                                                                                                               *;
*****************************************************************************************************************;

%symdel typ yrs outfiv outmax inp;

%macro cst_200(
     typ    = snf
    ,yrs    = 2011-2019
    ,inp    = cst_150&typ.numalp
    ,outfiv = cst_200&typ.fiv
    ,outmax = cst_200&typ.max
   ) / des="Create column fu=ive in G0 financial worksheet";

     /*
        %let typ    = snf;
        %let yrs    = 2011-2019;
        %let outfiv = cst_200&typ.fiv;
        %let outmax = cst_200&typ.max;
        %let inp    = cst_150&typ.numalp;
     */

     %let yrscmp=%sysfunc(compress(&yrs,%str(-)));
     %put &yrscmp;

     %let inpfix=%sysfunc(compress(&inp&yrscmp));
     %put &=inpfix;

     %let outfiv=%sysfunc(compress(&outfiv&yrscmp));
     %put &=outfiv;

     %let outmax=%sysfunc(compress(&outmax&yrscmp));
     %put &=outmax;


     proc datasets lib=work nolist mt=data mt=view;
        delete cstvu &pgm.cstcsvsrt &pgm.sumcol;
     run;quit;

     proc datasets lib=cst nolist;
        delete &outfiv &outmax cst_200;
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
     by wkslynrec csvdatkey;
     run;quit;

     * add totals for G000000 workbook  index=(reckey=(rpt_rec_num cstnam)/unique;
     * unique to worksheet G000000;
     * sum the four columns in the csv file;
     data &pgm.sumcol (rename=(csvdatkey=cstnam csvdatval=cstval));
       retain typ "&typ" amt 0;
       set &pgm.cstcsvsrt;
       by wkslynrec csvdatkey;
       csvdatlen=lengthn(strip(csvdatval));
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

     proc sort data=&pgm.sumcol out=cst.&outfiv noequals force;
     by cstnam descending csvdatlen;
     run;quit;

     data cst.&outmax;
        set cst.&outfiv;
        by cstnam descending csvdatlen;
        if first.cstnam;
        keep rpt_rec_num cstnam cstval;
     run;quit;

     %if &syserr=0 %then %do;
        data cst.cst_200;
        run;quit;
     %end;

%mend cst_200;

options obs=max;
%cst_200(
     typ    = snf
    ,yrs    = 2011-2019
    ,inp    = cst_150&typ.numalp
    ,outfiv = cst_200&typ.fiv
    ,outmax = cst_200&typ.max
   );


















































%utl_optlen(inp=cst.cst_150snfnumalp20112019,out=work.cst_150snfnumalp20112019);




















%let yer=14;
%let pgm=snf_2&yer.;

*******************************************************************************************************************;
*                                                                                                                 *;
*  PROJECT TOKEN = snf                                                                                            *;
*                                                                                                                 *;
*; %let purpose=Create a cost report relational schema to hold all cost reports except hospital;                  *;
*                                                                                                                 *;
*  THIS IS A WORK IN PROGRESS AND MAY BE VERY BUGGY (DRAFT MODEL)                                                 *;
*                                                                                                                 *;
*  github                                                                                                         *;
*  https://tinyurl.com/ybz3a643                                                                                   *;
*                                                                                                                 *;
*  run snf_114 first                                                                                              *;
*                                                                                                                 *;
*                                                                                                                 *;
*;      libname snf "d:/snf";                                                                                     *;
*;      libname lup "d:/lup";                                                                                     *;
*;      options compress=binary validvarname=v7;                                                                  *;
*;      options fmtsearch=(snf.snffmt_a  work.formats);                                                           *;
*                                                                                                                 *;
*  Windows Local workstation SAS 9.3M1(64bit) Win 7(64bit) Dell T7610 126gb dual nvme drives 32core               *;
*                                                                                                                 *;
*  PROGRAM VERSIONSING c:\ver                                                                                     *;
*                                                                                                                 *;
*                                                                                                                 *;
*  OVERVIEW                                                                                                       *;
*  ========                                                                                                       *;
*                                                                                                                 *;
*   This program creates a snowflake schema for all cost report                                                   *;
*                                                                                                                 *;
*   SNF, HHA, RNF, HOS, HCL, FQH, RHC, and CMF Cost Reports.                                                      *;
*                                                                                                                 *;
*   Excel cost report pufs are minor output.                                                                      *;
*                                                                                                                 *;
*   There will be more intersest in the schema that the filtered excel pufs.                                      *;
*                                                                                                                 *;
*   For Skilled Nursing Facilities all data and meta data is extracted for these worksheets                       *;
*                                                                                                                 *;
*    S200001 G000000 G200001 G200002 S300001 S300002 S300003 S300004                                              *;
*    S300005 S400000 S700001 A700000 A000000 C000000 E00A181 O010000                                              *;
*                                                                                                                 *;
*   I capture all sources of funding and the total. Only the total is available currently?                        *;
*                                                                                                                 *;
*  Macros                                                                                                         *;
*                                                                                                                 *;
*    extract_page     Python code to extract meta data from worksheet pages                                       *;
*    fixtxt           Clean up extracted page                                                                     *;
*    utl_ymrlan100    template for PDF and PPT slides                                                             *;
*    utl_b64encode    base 64 encoding to cut and paste more than 10mb to ccw                                     *;
*    utl_b64decode    base 64 decode bacl to binaly (ie sas7bdats,cdats and xlsx)                                 *;
*    pdfbeg           start slide creation                                                                        *;
*    pdfend           end slide preparation                                                                       *;
*    utlopts          turn options on                                                                             *;
*    utlnopts         turn options off                                                                            *;
*    varlist          create list of variable names                                                               *;
*    do_over          SAS %do in open code                    ( https://tinyurl.com/ybz3a643)                     *;
*    array            used with do_over but can be used alone ( https://tinyurl.com/ybz3a643)                     *;
*    greenbar         highlight alternate rows in proc report                                                     *;
*    tut_sly          like SASWEAVE or knitr https://github.com/rogerjdeangelis/SASweave                          *;
*    voodoo           validation and verification of table columns and rows                                       *;
*                        (https://github.com/rogerjdeangelis/voodoo                                               *;
*    renamel          https://github.com/rogerjdeangelis/utl_rename_coordinated_lists_of_variables                *;
*                                                                                                                 *;
*  DEPENDENCIES  (autocall library and autoexec with password)                                                    *;
*  =============                                                                                                  *;
*  autocall c://oto                                                                                               *;
*                                                                                                                 *;
* ================================================================================================================*;
*                                                                                                                 *;
*  INPUTS                                                                                                         *;
*  =======            snf.snf_100_numalp11_18yer                                                                  *;
*                                                                                                                 *;
*                                                                                                                 *;
*   1. d:/snf/snf_100_numalp11_18yer.sas7bdat                                                                     *;
*      All data from snf cost reports 2011-2018 Csvs.  created by c/utl/snf_100.sas                               *;
*      This is used to create a template we acn be sure to have all cells, even 100 percent missing.              *;
*                                                                                                                 *;
*   2. d:/snf/pdf/snf.pdf                                                                                         *;
*      Python extracts line and coluum descriptions and and assigns the meta data to                              *;
*      S200001_00100_00200_N  Worksheet_line_coluun type                                                          *;
*                                                                                                                 *;
*   3. d:/snf/snf2015_p145269.pdf  (same as 2)                                                                    *;
*      Filed out snf forms for provider 145269, this is used for QC                                               *;
*                                                                                                                 *;
*   5. d:/snf/snf.snf_100_rpx15.sas7bat (crea
ted by program snf_100  direct exract from CSVs                      *;
*      Filed out snf forms for provider 145269, this is used for QC                                               *;
*                                                                                                                 *;
*   6. d:/snf/xls/rug.xlsx                                                                                        *;
*      RUG descriptions from cms.gov                                                                              *;
*                                                                                                                 *;
*   7. d:/lup/snf.snf_100_numalp11_18yer (ALL DATA IN 8 YEARS)                                                    *;
*                                                                                                                 *;
*   8. d:/lup/snf_060sumcol (adds G000000 sums cols 1-4)                                                          *;
*                                                                                                                 *;
*  OUTPUTS                                                                                                        *;
*  ===========================                                                                                    *;
*                                                                                                                 *;
*   1. d:/xls/snf_060full.xlsx                                                                                    *;
*       Excel PUF with 676 columns from 16 worsheets                                                              *;
*                                                                                                                 *;
*   2. d:/xls/snf_060partial.xlsx                                                                                 *;
*       Filtered PUF. (TBD)                                                                                       *;
*                                                                                                                 *;
*   3. Relational Schema for easy production of Excel PUFS for all cost reports                                   *;
*     Single set of tables that hold all Cost Reports except Hospital Cost Reports                                *;
*     This Schema contains: SNF, HHA, RNF, HOS, HCL, FQH, RHC, and CMF Cost Reports.                              *;
*                                                                                                                 *;
*   4. Lookup formats                                                                                             *;
*        d:/snf/snffmt_vI.sas7bcat                                                                                *;
*        d:/snf/snffmt_vI/rug2des.formatc                                                                         *;
*        d:/snf/snffmt_vI/cel_name2des.formatc                                                                    *;
*        d:/snf/snffmt_vI/cel_reportkey2des.infmt                                                                 *;
*                                                                                                                 *;
*   5. d:/snf/pdf/&pgm.slides.pdf                                                                                 *;
*      Slides and entity diagrams                                                                                 *;
*                                                                                                                 *;
*******************************************************************************************************************;

/*


NF Number of Beds      S3-Part1-Line-2-Column-1
NF Bed Days Available      S3-Part1-Line-2-Column-2
NF Days Title V      S3-Part1-Line-2-Column-3
NF Days Title XIX      S3-Part 1-Line-2-Column-5
NF Days Other      S3-Part1-Line-2-Column-6
NF Days Total      S3-Part1-Line-2-Column-7
NF Discharges Title V      S3-Part1-Line-2-Column-8
NF Discharges Title XIX      S3-Part1-Line-2-Column-10
NF Discharges Title Other      S3-Part1-Line-2-Column-11
NF Discharges Total      S3-Part1-Line-2-Column-12
NF Average Length of Stay Title V      S3-Part1-Line-2-Column-13
NF Average Length of Stay Title XIX      S3-Part1-Line-2-Column-15
NF Average Length of Stay Total      S3-Part1-Line-2-Column-16
NF Admissions Other      S3-Part1-Line-2-Column-20
NF Admissions Total      S3-Part1-Line-2-Column-21

NF Admissions Title V      S3-Part1-Line-1-Column-17
NF Admissions Title XIX      S3-Part1-Line-1-Column-19

* you only need to run this once. It has anll snf data from 2011 thru 2018;
data snfvu/view=snfvu;
  length wkslynrec $20;
  set snf.snf_100_numalp11_18yer(
    keep=yer rpt_rec_num prvdr_num WKSHT_CD CLMN_NUM LINE_NUM TYP itm_txt
    rename=itm_txt=csvdatval
  );
  csvdatkey=catx('_',strip(WKSHT_CD),strip(LINE_NUM),strip(CLMN_NUM),TYP);
  wkslynrec=cats(WKSHT_CD,LINE_NUM,rpt_rec_num);
  keep wkslynrec csvdatkey csvdatval rpt_rec_num prvdr_num yer;
run;quit;


proc sort data=snfvu out=snf.&pgm.snfcsvsrt noequals sortsize=80g;
by wkslynrec csvdatkey;
run;quit;

* add totals for G000000 workbook  index=(reckey=(rpt_rec_num snfnam)/unique;
* unique to worksheet G000000;
* sum the four columns in the csv file;
data snf.&pgm.sumcol (rename=(csvdatkey=snfnam csvdatval=snfval));
  retain amt 0 ;
  set snf.&pgm.snfcsvsrt;
  by wkslynrec csvdatkey;
  csvdatlen=lengthn(strip(csvdatval));
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

proc sort data=snf.&pgm.sumcol out=snf.&pgm.sumcolsrt noequals force;
by snfnam descending csvdatlen;
run;quit;

data snf.&pgm.maxval;
   set snf.&pgm.sumcolsrt;
   by snfnam descending csvdatlen;
   if first.snfnam;
   keep rpt_rec_num snfnam snfval;
run;quit;


proc sql;
  create index yer on lup.snf_060sumcol
;quit;


data chk;
  set snf.&pgm.numalp&yer.yersrt(where=(prvdr_num = '145269' and SNFNAM in: ( 'G300000_03')));
run;quit;

data chk2;
  set snf.&pgm.preRpt(where=(provider_ccn = '145269' and cel_name in: ( 'S200001_00')));
run;quit;

data chk2;
  set snf.&pgm.preRpt(where=(provider_ccn = '145269' and cel_name in: ( 'S200001_00')));
run;quit;


RPT_REC_                                     PRVDR_
   NUM      YER    SNFVAL                     NUM             SNFNAM            CSVDATLEN

 1129122    15     4343 KENNEDY DRIVE        145269    S200001_00100_00100_C        18
 1129122    15     EAST MOLINE               145269    S200001_00200_00100_C        11
 1129122    15     IL                        145269    S200001_00200_00200_C         2
 1129122    15     61244                     145269    S200001_00200_00300_C         5
 1129122    15     ROCK ISLAND               145269    S200001_00300_00100_C        11
 1129122    15     19340                     145269    S200001_00300_00200_C         5
 1129122    15     U                         145269    S200001_00300_00300_C         1
 1129122    15     HOPE CREEK CARE CENTER    145269    S200001_00400_00100_C        22
 1129122    15     145269                    145269    S200001_00400_00200_C         6
 1129122    15     10/01/1997                145269    S200001_00400_00300_C        10
 1129122    15     N                         145269    S200001_00400_00400_C         1
 1129122    15     P                         145269    S200001_00400_00500_C         1
 1129122    15     N                         145269    S200001_00400_00600_C         1

*/

*    _             _
 ___| |_ __ _ _ __| |_
/ __| __/ _` | '__| __|
\__ \ || (_| | |  | |_
|___/\__\__,_|_|   \__|

;

/*
Roger,

Here are the corrections (there are others that I need to make myself to the definitions):

#1) These two variables are missing in the 2014 and 2015 tabs.

NF Admissions Title V   S3-Part1-Line-2-Column-17
NF Admissions Title XIX S3-Part1-Line-2-Column-19


#2) Total Assets appears 2 times in the 2014 and 2015 tabs. The Accounts payable is missing.

Accounts payable G-Line-35-Columns-1 thru 4


#3) Some of the titles of the definitions have changed, and I forgot to tell you. These are the variables:

NEW                                                      Old Definition

SNF Admissions Other                               SNF Admissions Title Other
SNF Admissions Total                               SNF Admissions Title Total

Facility Name                                      Hospital Name
*/



* Note this has all snf raw data from 3011 to 2018;

proc sort data=lup.snf_060sumcol(where=(yer="&yer")) out=snf.&pgm.numalp&yer.yersrt sortsize=10gb;
   by rpt_rec_num prvdr_num snfnam;
run;quit;

/*
proc print data=snf.&pgm.numalp&yer.yersrt(obs=100 where=(snfnam=:"S300001_00200_01700_N "));
run;quit;

            RPT_REC_                     PRVDR_
     Obs       NUM      YER    SNFVAL     NUM             SNFNAM            CSVDATLEN

13628466     1136351    14       2       445116    S300001_00200_01700_N        1
14139898     1141353    14       2       445069    S300001_00200_01700_N        1
14262840     1142485    14       4       445099    S300001_00200_01700_N        1
14581348     1143496    14       4       445088    S300001_00200_01700_N        1
15629222     1144991    14       2       445180    S300001_00200_01700_N        1
16368697     1146219    14       12      445111    S300001_00200_01700_N        2
16545859     1146626    14       14      445004    S300001_00200_01700_N        2
16566567     1146641    14       4       445098    S300001_00200_01700_N        1
16568063     1146642    14       1       445191    S300001_00200_01700_N        1
17159373     1147663    14       3       445076    S300001_00200_01700_N        1
17182796     1147746    14       1       445002    S300001_00200_01700_N        1
17189026     1147750    14       15      445109    S300001_00200_01700_N        2
17409415     1148162    14       11      445094    S300001_00200_01700_N        2
18587110     1152327    14       15      445101    S300001_00200_01700_N        2
18931797     1177787    14       1       445108    S300001_00200_01700_N        1
18950495     1181092    14       29      445130    S300001_00200_01700_N        2


proc print data=snf.col_coldescribe(obs=100 where=(col_cel_name=:"S300001_00200_01700_N"));
run;quit;

proc print data=snf.&pgm.preRpt(obs=100 where=(cel_name=:"G300000_02"));
run;quit;

S300001_00200_01700_N
S300001_00200_01900_N
G000000_03500_00500_N



*/

data snf.col_colDescribe(index=(col_cel_name/unique) sortedby=col_cel_name);

      set lup.snf_060x000000xlsRptFmt(
               drop=end fmtname
               rename=(start=col_cel_name label=col_description));
run;quit;


/*
proc print data=snf.col_coldescribe(where=(col_cel_name=:"S300001_00200_01700"));
run;quit;
*/



proc sql;
  create
     table snf.&pgm.preRpt as
  select
      l.rpt_rec_num as cel_reportKey
     ,l.prvdr_num as Provider_CCN length=9
     ,r.col_description
     ,l.snfnam as cel_name
     ,coalesce(l.snfval,"  ") as cel_value length 255
  from
     snf.&pgm.numalp&yer.yersrt l,
     snf.col_coldescribe as r
  where
     substr(l.snfnam,1,19)  = substr(r.col_cel_name,1,19)  and
     substr(l.snfnam ,1,19) in (
        'S200001_00400_00200'
       ,'S200001_00400_00100'
       ,'S200001_00100_00100'
       ,'S200001_00200_00100'
       ,'S200001_00200_00200'
       ,'S200001_00200_00300'
       ,'S200001_00300_00100'
       ,'S200001_00300_00200'
       ,'S200001_00300_00300'
       ,'S200001_00300_00400'
       ,'S200001_01500_00100'
       ,'S200001_01400_00100'
       ,'S200001_01400_00200'
       ,'S300001_00800_00300'
       ,'S300001_00800_00400'
       ,'S300001_00800_00500'
       ,'S300001_00800_00600'
       ,'S300001_00800_00700'
       ,'S300001_00800_00100'
       ,'S300001_00800_00200'
       ,'S300001_00800_00800'
       ,'S300001_00800_00900'
       ,'S300001_00800_01000'
       ,'S300001_00800_01100'
       ,'S300001_00800_01200'
       ,'S300001_00100_01300'
       ,'S300001_00100_01400'
       ,'S300001_00100_01500'
       ,'S300001_00100_01600'
       ,'S300001_00100_01700'
       ,'S300001_00100_01800'
       ,'S300001_00100_01900'
       ,'S300001_00100_02000'
       ,'S300001_00100_02100'
       ,'S700000_10000_00200'
       ,'S300001_00100_00300'
       ,'S300001_00100_00400'
       ,'S300001_00100_00500'
       ,'S300001_00100_00600'
       ,'S300001_00100_00700'
       ,'S300001_00100_00100'
       ,'S300001_00100_00200'
       ,'S300001_00100_00800'
       ,'S300001_00100_00900'
       ,'S300001_00100_01000'
       ,'S300001_00100_01100'
       ,'S300001_00100_01200'
       ,'S300001_00200_00100'
       ,'S300001_00200_00200'
       ,'S300001_00200_00300'
       ,'S300001_00200_00500'
       ,'S300001_00200_00600'
       ,'S300001_00200_00700'
       ,'S300001_00200_00800'
       ,'S300001_00200_01000'
       ,'S300001_00200_01100'
       ,'S300001_00200_01200'
       ,'S300001_00200_01300'
       ,'S300001_00200_01500'
       ,'S300001_00200_01600'
       ,'S300001_00200_01700'
       ,'S300001_00200_01800'
       ,'S300001_00200_01900'
       ,'S300001_00200_02000'
       ,'S300001_00200_02100'
       ,'A000000_10000_00100'
       ,'A000000_10000_00200'
       ,'C000000_10000_00200'
       ,'C000000_10000_00100'
       ,'S300002_02200_00300'
       ,'S300002_00100_00300'
       ,'S300002_01400_00300'
       ,'G000000_00100_00500'
       ,'G000000_00200_00500'
       ,'G000000_00300_00500'
       ,'G000000_00400_00500'
       ,'G000000_00600_00500'
       ,'G000000_00700_00500'
       ,'G000000_00800_00500'
       ,'G000000_00900_00500'
       ,'G000000_01100_00500'
       ,'G000000_01200_00500'
       ,'G000000_01300_00500'
       ,'G000000_01500_00500'
       ,'G000000_01700_00500'
       ,'G000000_01900_00500'
       ,'G000000_02300_00500'
       ,'G000000_02500_00500'
       ,'G000000_02800_00500'
       ,'G000000_02900_00500'
       ,'G000000_03200_00500'
       ,'G000000_03300_00500'
       ,'G000000_03400_00500'
       ,'G000000_03500_00500'
       ,'G000000_03600_00500'
       ,'G000000_03700_00500'
       ,'G000000_03800_00500'
       ,'G000000_03900_00500'
       ,'G000000_04200_00500'
       ,'G000000_04300_00500'
       ,'G000000_04400_00500'
       ,'G000000_04500_00500'
       ,'G000000_04600_00500'
       ,'G000000_04800_00500'
       ,'G000000_05000_00500'
       ,'G000000_05100_00500'
       ,'G000000_05200_00100'
       ,'G000000_05900_00500'
       ,'G000000_06000_00500'
       ,'G200001_00500_00100'
       ,'G200001_01400_00100'
       ,'G200001_01400_00200'
       ,'G300000_00100_00100'
       ,'G300000_00200_00100'
       ,'G300000_00300_00100'
       ,'G300000_00400_00100'
       ,'G300000_00500_00100'
       ,'G300000_02500_00100'
       ,'G300000_02600_00100'
       ,'G300000_03000_00100'
       ,'G300000_03100_00100'
       ,'E00A181_00100_00100'
       ,'E00A181_00200_00100'
       ,'E00A181_00600_00100'
       )
  order
     by cel_reportKey, Provider_CCN, cel_name  descending ;
;quit;

/*
proc print data=snf.col_coldescribe(where=(col_cel_name=:"S300001_00200_017"));
run;quit;
*/

data snf.&pgm.finaddjef;
  retain fmtname "$jefmta";
  merge snf.snf_060AddJeffix(rename=snfnamfix=snfnam) snf.finAddJef(drop=snfnam) end=dne;
  start=snfnam;
  label=snflab;
  if start in (
          "S300001_00200_00100"
          "S300001_00200_00200"
          "S300001_00200_00300"
          "S300001_00200_00500"
          "S300001_00200_00600"
          "S300001_00200_00700"
          "S300001_00200_00800"
          "S300001_00200_01000"
          "S300001_00200_01100"
          "S300001_00200_01200"
          "S300001_00200_01300"
          "S300001_00200_01500"
          "S300001_00200_01600"
          "S300001_00200_01700"
          "S300001_00200_01900"
          "S300001_00200_02000"
          "S300001_00200_02100"
          "G000000_03000_00100"
          "S300001_00100_01300"
          "S300001_00100_01400"
          "S300001_00100_01500"
          "S300001_00100_01600"
          "S300001_00100_01700"
          "S300001_00100_01800"
          "S300001_00100_01900"
          "S300001_00100_02000"
          "S300001_00100_02100" ) then delete;
  output;
  if dne then do;
     label="NF Number of Beds                     "; start="S300001_00200_00100"; output ;
     label="NF Bed Days Available                 "; start="S300001_00200_00200"; output ;
     label="NF Days Title V                       "; start="S300001_00200_00300"; output ;
     label="NF Days Title XIX                     "; start="S300001_00200_00500"; output ;
     label="NF Days Other                         "; start="S300001_00200_00600"; output ;
     label="NF Days Total                         "; start="S300001_00200_00700"; output ;
     label="NF Discharges Title V                 "; start="S300001_00200_00800"; output ;
     label="NF Discharges Title XIX               "; start="S300001_00200_01000"; output ;
     label="NF Discharges Title Other             "; start="S300001_00200_01100"; output ;
     label="NF Discharges Total                   "; start="S300001_00200_01200"; output ;
     label="NF Average Length of Stay Title V     "; start="S300001_00200_01300"; output ;
     label="NF Average Length of Stay Title XIX   "; start="S300001_00200_01500"; output ;
     label="NF Average Length of Stay Total       "; start="S300001_00200_01600"; output ;
     label="NF Admissions Title V                 "; start="S300001_00200_01700"; output ;
     label="NF Admissions Title XIX               "; start="S300001_00200_01900"; output ;
     label="NF Admissions Other                   "; start="S300001_00200_02000"; output ;
     label="NF Admissions Total                   "; start="S300001_00200_02100"; output ;

     label="Not in CVS Files                      "; start="G000000_03000_00100"; output ;
     label="SNF Average Length of Stay Title V    "; start="S300001_00100_01300"; output ;
     label="SNF Average Length of Stay Title XVIII"; start="S300001_00100_01400"; output ;
     label="SNF Average Length of Stay Title XIX  "; start="S300001_00100_01500"; output ;
     label="SNF Average Length of Stay Total      "; start="S300001_00100_01600"; output ;
     label="SNF Admissions Title V                "; start="S300001_00100_01700"; output ;
     label="SNF Admissions Title XVIII            "; start="S300001_00100_01800"; output ;
     label="SNF Admissions Title XIX              "; start="S300001_00100_01900"; output ;
     label="SNF Admissions Title Other            "; start="S300001_00100_02000"; output ;
     label="SNF Admissions Title Total            "; start="S300001_00100_02100"; output ;
  end;
;;;;
run;quit;

/*
Average Length of Stay Title V        SNF Average Length of Stay Title V        S300001_00100_01300_N
Average Length of Stay Title XVIII    SNF Average Length of Stay Title XVIII    S300001_00100_01400_N
Average Length of Stay Title XIX      SNF Average Length of Stay Title XIX      S300001_00100_01500_N
Average Length of Stay Total          SNF Average Length of Stay Total          S300001_00100_01600_N
Admissions Title V                    SNF Admissions Title V                    S300001_00100_01700_N
Admissions Title XVIII                SNF Admissions Title XVIII                S300001_00100_01800_N
Admissions Title XIX                  SNF Admissions Title XIX                  S300001_00100_01900_N
Admissions Title Other                SNF Admissions Title Other                S300001_00100_02000_N
Admissions Title Total                SNF Admissions Title Total                S300001_00100_02100_N
*/

proc sort data=snf.&pgm.finaddjef nodupkey;
by start label;
run;quit;

proc format lib=snf.snffmt_a cntlin=snf.&pgm.finaddjef;
run;quit;

data chk;
  x="S200001_00200_00300";
  x="S300001_00200_01700";
  put x $jefmta.;
run;quit;

proc transpose data=snf.&pgm.preRpt
         out=snf.&pgm.preRptXpo(drop=_name_);
   by cel_reportKey Provider_CCN;
   var cel_value;
   id cel_name;
   idlabel col_description;
run;quit;

data snf.&pgm.xpoJef ; /* has issue */

 if _n_=0 then do; %let rc=%sysfunc(dosubl('
   data snf.&pgm.jefrow;
      length provider_ccn $8  S200001_00200_00300_C $6.;
      set snf.&pgm.preRptXpo(obs=1);
      array nams _character_;
      cel_reportKey = 'Cel_Repor_tKey';
      do over nams;
         nams = put(substr(vname(nams),1,19),$jefmta.);
      end;
      output;
      set snf.&pgm.preRptXpo(where=(provider_ccn="145269"));
      output;
   run;quit;
   '));
 end;
 length provider_ccn $8 S200001_00200_00300_C $6.; ;
 set
  snf.&pgm.jefrow
  snf.&pgm.preRptXpo;

  S200001_00200_00300_C  = cats('09'x,S200001_00200_00300_C);
  S200001_00300_00200_C  = cats('09'x,S200001_00300_00200_C);
  Provider_CCN           = cats('09'x,Provider_CCN);

run;quit;

/*

proc print data=snf.col_coldescribe(where=(col_cel_name="S300001_00200_01700_N"));
run;quit;

data chk6;
  set snf.&pgm.xpoJef(where=(S200001_00400_00200_C=:'145269'));
run;quit;

data chk3;
 set lup.snf_060jefrow(where=(Provider_CCN='145269'));
run;quit;
run;quit;

data chk4;
    set snf.&pgm.preRptXpo(where=(Provider_CCN='145269'));
run;quit;

lup.snf_060jefrow

*/


*     _
__  _| |___
\ \/ / / __|
 >  <| \__ \
/_/\_\_|___/

;

/*
S200001_00400_00200_C            C    37      146176              Provider CCN@S200001_00400_00200_C
*/

%utl_optlen(inp=snf.&pgm.xpoJef,out=snf.&pgm.xpoJef);


ods listing close;

%utlfkil(d:/snf/xls/&pgm.adhoc6.xlsx);

* need to add provider number;

ods excel file="d:/snf/xls/&pgm.adhoc6.xlsx" style=pearl;
ods excel options(sheet_name="final" autofilter= 'yes' frozen_headers   = '3' );

%utlnopts;
options label;

proc report data=snf.&pgm.xpoJef (obs=50)  missing nowd split="@"
  style(column)={cellwidth=5in just=c protectspecialchars=on};
cols cel_reportKey /*  Provider_CCN */
S200001_00400_00200_C
S200001_00400_00100_C
S200001_00100_00100_C
S200001_00200_00100_C
S200001_00200_00200_C
S200001_00200_00300_C
S200001_00300_00100_C
S200001_00300_00200_C
S200001_00300_00300_C
S200001_00300_00400_C
S200001_01500_00100_N
S200001_01400_00100_C
S200001_01400_00200_C
S300001_00800_00300_N
S300001_00800_00400_N
S300001_00800_00500_N
S300001_00800_00600_N
S300001_00800_00700_N
S300001_00800_00100_N
S300001_00800_00200_N
S300001_00800_00800_N
S300001_00800_00900_N
S300001_00800_01000_N
S300001_00800_01100_N
S300001_00800_01200_N
S300001_00100_01300_N
S300001_00100_01400_N
S300001_00100_01500_N
S300001_00100_01600_N
S300001_00100_01700_N
S300001_00100_01800_N
S300001_00100_01900_N
S300001_00100_02000_N
S300001_00100_02100_N
S700000_10000_00200_N
S300001_00100_00300_N
S300001_00100_00400_N
S300001_00100_00500_N
S300001_00100_00600_N
S300001_00100_00700_N
S300001_00100_00100_N
S300001_00100_00200_N
S300001_00100_00800_N
S300001_00100_00900_N
S300001_00100_01000_N
S300001_00100_01100_N
S300001_00100_01200_N
S300001_00200_00100_N
S300001_00200_00200_N
S300001_00200_00300_N
S300001_00200_00500_N
S300001_00200_00600_N
S300001_00200_00700_N
S300001_00200_00800_N
S300001_00200_01000_N
S300001_00200_01100_N
S300001_00200_01200_N
S300001_00200_01300_N
S300001_00200_01500_N
S300001_00200_01600_N
S300001_00200_01700_N
S300001_00200_01900_N
S300001_00200_02000_N
S300001_00200_02100_N
A000000_10000_00100_N
A000000_10000_00200_N
C000000_10000_00200_N
C000000_10000_00100_N
S300002_02200_00300_N
S300002_00100_00300_N
S300002_01400_00300_N
G000000_00100_00500_N
G000000_00200_00500_N
G000000_00300_00500_N
G000000_00400_00500_N
G000000_00600_00500_N
G000000_00700_00500_N
G000000_00800_00500_N
G000000_00900_00500_N
G000000_01100_00500_N
G000000_01200_00500_N
G000000_01300_00500_N
G000000_01500_00500_N
G000000_01700_00500_N
G000000_01900_00500_N
G000000_02300_00500_N
G000000_02500_00500_N
G000000_02800_00500_N
G000000_02900_00500_N
G000000_03200_00500_N
G000000_03300_00500_N
G000000_03400_00500_N
G000000_03500_00500_N
G000000_03600_00500_N
G000000_03700_00500_N
G000000_03800_00500_N
G000000_03900_00500_N
G000000_04200_00500_N
G000000_04300_00500_N
G000000_04400_00500_N
G000000_04500_00500_N
G000000_04600_00500_N
G000000_04800_00500_N
G000000_05000_00500_N
G000000_05100_00500_N
G000000_05200_00100_N
G000000_05900_00500_N
G000000_06000_00500_N
G200001_00500_00100_N
G200001_01400_00100_N
G200001_01400_00200_N
G300000_00100_00100_N
G300000_00200_00100_N
G300000_00300_00100_N
G300000_00400_00100_N
G300000_00500_00100_N
G300000_02500_00100_N
G300000_02600_00100_N
G300000_03000_00100_N
G300000_03100_00100_N
E00A181_00100_00100_N
E00A181_00200_00100_N
E00A181_00600_00100_N
;
compute provider_ccn;
      if provider_ccn = '145269' then call define(_row_, "Style", "Style = [background = yellow]");
endcomp;
run;quit;

ods excel close;
ods listing;
%utlopts;

*                      _                    _
 _ __   _____      __ | |__   ___  __ _  __| | ___ _ __
| '_ \ / _ \ \ /\ / / | '_ \ / _ \/ _` |/ _` |/ _ \ '__|
| | | |  __/\ V  V /  | | | |  __/ (_| | (_| |  __/ |
|_| |_|\___| \_/\_/   |_| |_|\___|\__,_|\__,_|\___|_|

;

proc transpose data=snf.&pgm.xpoJef(Obs=1 drop=cel_reportKey)  out=snf.&pgm.xponam;
  var _all_;
run;quit;

proc sql;
  select
      Cats(_name_,'=',cats('"',scan(col1,1,'@'),'"'))
  into
      :ren separated by " "
  from
      snf.&pgm.xponam
;quit;


data snf.&pgm.xpoJeflbl;
  length S200001_00200_00300_C $6.;
  set snf.&pgm.xpoJef;
  label
    &ren
  ;
run;quit;


%utl_optlen(inp=snf.&pgm.xpoJeflbl,out=snf.&pgm.xpoJeflbl);

ods listing close;

%utlfkil(d:/snf/xls/&pgm.adhoclbl6.xlsx);

* need to add provider number;

options label;
ods excel file="d:/snf/xls/&pgm.adhoclblyer.xlsx" style=pearl;
ods excel options(sheet_name="final" autofilter= 'yes' frozen_headers   = '3' );

%utlopts;
options label cpucount=16;

proc report data=snf.&pgm.xpoJeflbl (obs=max firstobs=2)  missing nowd
  style(column)={cellwidth=5in just=c protectspecialchars=on};
cols Cel_ReportKey /* Provider_CCN */
S200001_00400_00200_C
S200001_00400_00100_C
S200001_00100_00100_C
S200001_00200_00100_C
S200001_00200_00200_C
S200001_00200_00300_C
S200001_00300_00100_C
S200001_00300_00200_C
S200001_00300_00300_C
S200001_01500_00100_N
S200001_01400_00100_C
S200001_01400_00200_C
S300001_00800_00300_N
S300001_00800_00400_N
S300001_00800_00500_N
S300001_00800_00600_N
S300001_00800_00700_N
S300001_00800_00100_N
S300001_00800_00200_N
S300001_00800_00800_N
S300001_00800_00900_N
S300001_00800_01000_N
S300001_00800_01100_N
S300001_00800_01200_N
S300001_00100_01300_N
S300001_00100_01400_N
S300001_00100_01500_N
S300001_00100_01600_N
S300001_00100_01700_N
S300001_00100_01800_N
S300001_00100_01900_N
S300001_00100_02000_N
S300001_00100_02100_N
S700000_10000_00200_N
S300001_00100_00300_N
S300001_00100_00400_N
S300001_00100_00500_N
S300001_00100_00600_N
S300001_00100_00700_N
S300001_00100_00100_N
S300001_00100_00200_N
S300001_00100_00800_N
S300001_00100_00900_N
S300001_00100_01000_N
S300001_00100_01100_N
S300001_00100_01200_N
S300001_00200_00100_N
S300001_00200_00200_N
S300001_00200_00300_N
S300001_00200_00500_N
S300001_00200_00600_N
S300001_00200_00700_N
S300001_00200_00800_N
S300001_00200_01000_N
S300001_00200_01100_N
S300001_00200_01200_N
S300001_00200_01300_N
S300001_00200_01500_N
S300001_00200_01600_N
S300001_00200_01700_N
S300001_00200_01900_N
S300001_00200_02000_N
S300001_00200_02100_N
A000000_10000_00100_N
A000000_10000_00200_N
C000000_10000_00200_N
C000000_10000_00100_N
S300002_02200_00300_N
S300002_00100_00300_N
S300002_01400_00300_N
G000000_00100_00500_N
G000000_00200_00500_N
G000000_00300_00500_N
G000000_00400_00500_N
G000000_00600_00500_N
G000000_00700_00500_N
G000000_00800_00500_N
G000000_00900_00500_N
G000000_01100_00500_N
G000000_01200_00500_N
G000000_01300_00500_N
G000000_01500_00500_N
G000000_01700_00500_N
G000000_01900_00500_N
G000000_02300_00500_N
G000000_02500_00500_N
G000000_02800_00500_N
G000000_02900_00500_N
G000000_03200_00500_N
G000000_03300_00500_N
G000000_03400_00500_N
G000000_03500_00500_N
G000000_03600_00500_N
G000000_03700_00500_N
G000000_03800_00500_N
G000000_03900_00500_N
G000000_04200_00500_N
G000000_04300_00500_N
G000000_04400_00500_N
G000000_04500_00500_N
G000000_04600_00500_N
G000000_04800_00500_N
G000000_05000_00500_N
G000000_05100_00500_N
G000000_05200_00100_N
G000000_05900_00500_N
G000000_06000_00500_N
G200001_00500_00100_N
G200001_01400_00100_N
G200001_01400_00200_N
G300000_00100_00100_N
G300000_00200_00100_N
G300000_00300_00100_N
G300000_00400_00100_N
G300000_00500_00100_N
G300000_02500_00100_N
G300000_02600_00100_N
G300000_03100_00100_N
E00A181_00100_00100_N
E00A181_00200_00100_N
E00A181_00600_00100_N
;
define Cel_ReportKey         / display "Report Record Number";
define S200001_00200_00300_C / display "Zip Code";
define S200001_00400_00100_C / display "Facility Name";
define S300001_00100_02000_N / display "SNF Admissions Other";
define S300001_00100_02100_N / display "SNF Admissions Total";
define S300001_00200_01700_N / display "NF Admissions Title V";
define S300001_00200_01900_N / display "NF Admissions Title XIX";
define G000000_03500_00500_N / display "Accounts payable";
run;quit;

ods excel close;
ods listing;
%utlopts;


/*
G300000_03000_00100_N

ERROR: Variable S300001_00200_01700_N is not on file SNF.SNF_2015XPOJEFLBL.
ERROR: Variable S300001_00200_01900_N is not on file SNF.SNF_2015XPOJEFLBL.
ERROR: Variable G000000_03500_00500_N is not on file SNF.SNF_2015XPOJEFLBL.
*/
*____   ___  _ ____
|___ \ / _ \/ | ___|
  __) | | | | |___ \
 / __/| |_| | |___) |
|_____|\___/|_|____/

;

%let pgm=snf_2015;


%utl_optlen(inp=snf.&pgm.xpoJeflbl,out=snf.&pgm.xpoJeflbl);

ods listing close;

%utlfkil(d:/snf/xls/&pgm.adhoclbl6.xlsx);

* need to add provider number;

options label;
ods excel file="d:/snf/xls/&pgm.adhoclblyer.xlsx" style=pearl;
ods excel options(sheet_name="final" autofilter= 'yes' frozen_headers   = '3' );

%utlopts;
options label;

proc report data=snf.&pgm.xpoJeflbl (obs=max firstobs=2)  missing nowd
  style(column)={cellwidth=5in just=c protectspecialchars=on};
cols Cel_ReportKey /* Provider_CCN */
S200001_00400_00200_C
S200001_00400_00100_C
S200001_00100_00100_C
S200001_00200_00100_C
S200001_00200_00200_C
S200001_00200_00300_C
S200001_00300_00100_C
S200001_00300_00200_C
S200001_00300_00300_C
S200001_01500_00100_N
S200001_01400_00100_C
S200001_01400_00200_C
S300001_00800_00300_N
S300001_00800_00400_N
S300001_00800_00500_N
S300001_00800_00600_N
S300001_00800_00700_N
S300001_00800_00100_N
S300001_00800_00200_N
S300001_00800_00800_N
S300001_00800_00900_N
S300001_00800_01000_N
S300001_00800_01100_N
S300001_00800_01200_N
S300001_00100_01300_N
S300001_00100_01400_N
S300001_00100_01500_N
S300001_00100_01600_N
S300001_00100_01700_N
S300001_00100_01800_N
S300001_00100_01900_N
S300001_00100_02000_N
S300001_00100_02100_N
S700000_10000_00200_N
S300001_00100_00300_N
S300001_00100_00400_N
S300001_00100_00500_N
S300001_00100_00600_N
S300001_00100_00700_N
S300001_00100_00100_N
S300001_00100_00200_N
S300001_00100_00800_N
S300001_00100_00900_N
S300001_00100_01000_N
S300001_00100_01100_N
S300001_00100_01200_N
S300001_00200_00100_N
S300001_00200_00200_N
S300001_00200_00300_N
S300001_00200_00500_N
S300001_00200_00600_N
S300001_00200_00700_N
S300001_00200_00800_N
S300001_00200_01000_N
S300001_00200_01100_N
S300001_00200_01200_N
S300001_00200_01300_N
S300001_00200_01500_N
S300001_00200_01600_N
S300001_00200_01700_N
S300001_00200_01900_N
S300001_00200_02000_N
S300001_00200_02100_N
A000000_10000_00100_N
A000000_10000_00200_N
C000000_10000_00200_N
C000000_10000_00100_N
S300002_02200_00300_N
S300002_00100_00300_N
S300002_01400_00300_N
G000000_00100_00500_N
G000000_00200_00500_N
G000000_00300_00500_N
G000000_00400_00500_N
G000000_00600_00500_N
G000000_00700_00500_N
G000000_00800_00500_N
G000000_00900_00500_N
G000000_01100_00500_N
G000000_01200_00500_N
G000000_01300_00500_N
G000000_01500_00500_N
G000000_01700_00500_N
G000000_01900_00500_N
G000000_02300_00500_N
G000000_02500_00500_N
G000000_02800_00500_N
G000000_02900_00500_N
G000000_03200_00500_N
G000000_03300_00500_N
G000000_03400_00500_N
G000000_03500_00500_N
G000000_03600_00500_N
G000000_03700_00500_N
G000000_03800_00500_N
G000000_03900_00500_N
G000000_04200_00500_N
G000000_04300_00500_N
G000000_04400_00500_N
G000000_04500_00500_N
G000000_04600_00500_N
G000000_04800_00500_N
G000000_05000_00500_N
G000000_05100_00500_N
G000000_05200_00100_N
G000000_05900_00500_N
G000000_06000_00500_N
G200001_00500_00100_N
G200001_01400_00100_N
G200001_01400_00200_N
G300000_00100_00100_N
G300000_00200_00100_N
G300000_00300_00100_N
G300000_00400_00100_N
G300000_00500_00100_N
G300000_02500_00100_N
G300000_02600_00100_N
G300000_03100_00100_N
E00A181_00100_00100_N
E00A181_00200_00100_N
E00A181_00600_00100_N
;
define Cel_ReportKey         / display "Report Record Number";
define S200001_00200_00300_C / display "Zip Code";
define S200001_00400_00100_C / display "Facility Name";
define S300001_00100_02000_N / display "SNF Admissions Other";
define S300001_00100_02100_N / display "SNF Admissions Total";
define S300001_00200_01700_N / display "NF Admissions Title V";
define S300001_00200_01900_N / display "NF Admissions Title XIX";
define G000000_03500_00500_N / display "Accounts payable";
run;quit;

ods excel close;
ods listing;
%utlopts;
















*_                       _       _
| |_ ___ _ __ ___  _ __ | | __ _| |_ ___
| __/ _ \ '_ ` _ \| '_ \| |/ _` | __/ _ \
| ||  __/ | | | | | |_) | | (_| | ||  __/
 \__\___|_| |_| |_| .__/|_|\__,_|\__\___|
                  |_|
;

data snf.&pgm.tpl;
  retain rpt_rec_num 9999999 ;
  set snf.&pgm.maxval(drop=rpt_rec_num
         where=(snfnam in: (
             "S200001"
            ,"G000000"
            ,"G200001"
            ,"G200002"
            ,"S300001"
            ,"S300002"
            ,"S300003"
            ,"S300004"
            ,"S300005"
            ,"S400000"
            ,"S700001"
            ,"A700000"
            ,"A000000"
            ,"C000000"
            ,"E00A181"
            ,"O010000"
         )));

  snfval="  ";
  snfform=put(snfnam,$snffmt.);
run;quit;

data snf.&pgm.x000000xlsadd;
   length snfform $255;
   set
       snf.&pgm.tpl
       snf.&pgm.X000000xls
   ;
run;quit;

* get data;
proc sql;
  create
     table snf.&pgm.X000000xls030 as
  select
      l.rpt_rec_num
     ,input(put(l.rpt_rec_num,7.),snfRecPrvdr.) as Provider
     ,catx('@',l.snfform,l.snfnam) as snfform  length=255
     ,l.snfnam
     ,coalesce(r.snfval,"  ") as snfval
  from
     snf.&pgm.x000000xlsadd as l
         left join snf.&pgm.numalp14yersrt as r
  on
     l.rpt_rec_num = r.rpt_rec_num and
     l.snfnam  = r.snfnam
  order
     by l.rpt_rec_num, l.snfnam ;
;quit;

*                      _
__   ____ _ _ __ ___  | |_ ___    _ __ ___   __ _  ___
\ \ / / _` | '__/ __| | __/ _ \  | '_ ` _ \ / _` |/ __|
 \ V / (_| | |  \__ \ | || (_) | | | | | | | (_| | (__
  \_/ \__,_|_|  |___/  \__\___/  |_| |_| |_|\__,_|\___|

;

%utlnopts;

%let ssn=100;
%let vsn-2000;

%arraydelete(ss);
%arraydelete(vs);

* dimensions;
proc sql;
  select
     distinct
         snfnam
     into :ss1-
  from
     snf.&pgm.X000000xls030 /*(where=(snfnam in "S200001_00400_00100_C"))*/
  where
         snfnam in (
             'S200001_00100_00100_C'
            ,'S200001_00200_00100_C'
            ,'S200001_00200_00200_C'
            ,'S200001_00200_00300_C'
            ,'S200001_00300_00100_C'
            ,'S200001_00300_00200_C'
            ,'S200001_00300_00300_C'
            ,'S200001_00400_00100_C'
            ,'S200001_00400_00200_C'
            ,'S200001_00400_00300_C'
            ,'S200001_00400_00400_C'
            ,'S200001_00400_00500_C'
            ,'S200001_00400_00600_C'
            ,'S200001_01400_00100_C'
            ,'S200001_01400_00200_C'
            ,'S200001_01500_00100_N'
            )
;quit;

%let ssn=&sqlobs;

%put &=ssn;

* facts;
proc sql;
  select
     distinct
         snfnam
     into :vs1-
  from
     snf.&pgm.X000000xls030
  where
     strip(put(snfnam,$snffmt.)) ne strip(snfnam) /* and
         snfnam not in (
             'S200001_00100_00100_C'
            ,'S200001_00200_00100_C'
            ,'S200001_00200_00200_C'
            ,'S200001_00200_00300_C'
            ,'S200001_00300_00100_C'
            ,'S200001_00300_00200_C'
            ,'S200001_00300_00300_C'
            ,'S200001_00400_00100_C'
            ,'S200001_00400_00200_C'
            ,'S200001_00400_00300_C'
            ,'S200001_00400_00400_C'
            ,'S200001_00400_00500_C'
            ,'S200001_00400_00600_C'
            ,'S200001_01400_00100_C'
            ,'S200001_01400_00200_C'
            ,'S200001_01500_00100_N'
            ) */
  order
     by snfnam
;quit;

%let vsn=&sqlobs;

%put &=vsn;


*                                                      __       _
__   ____ _ _ __ ___    __ _  ___ _ __ ___  ___ ___   / _| __ _| |_
\ \ / / _` | '__/ __|  / _` |/ __| '__/ _ \/ __/ __| | |_ / _` | __|
 \ V / (_| | |  \__ \ | (_| | (__| | | (_) \__ \__ \ |  _| (_| | |_
  \_/ \__,_|_|  |___/  \__,_|\___|_|  \___/|___/___/ |_|  \__,_|\__|

;

proc transpose data=snf.&pgm.x000000xls030 out=snf.&pgm.x000000xlsrpt(drop=_name_);
by rpt_rec_num Provider;
var snfval;
id snfnam;
run;quit;


*     _
__  _| |___
\ \/ / / __|
 >  <| \__ \
/_/\_\_|___/

;
OPTION NOLABEL;

ods listing close;

%utlfkil(d:/snf/xls/&pgm.Sample.xlsx);

* need to add provider number;

ods excel file="d:/snf/xls/&pgm.Sample.xlsx";

%utlnopts;
proc report data=snf.&pgm.x000000xlsRpt (obs=10)  /*(
        rename=(rpt_rec_num=Submitted_Report))*/ missing nowd split="@";
cols
  rpt_rec_num
  %do_over(ss,phrase=?)
  %do_over(vs,phrase=?)
 ;
define rpt_rec_num   /  "Submitted@Report@primary@Key";
%do_over(ss,phrase=%nrstr( define ? /  "%qsysfunc(putc(?,$snffmt))" style={cellwidth=5in};));
%do_over(vs,phrase=%nrstr( define ? /  "%qsysfunc(putc(?,$snffmt))" style={cellwidth=5in};));
run;quit;

ods excel close;

ods listing;

%utlopts;


*
                 _
 _   _ _ __ ___ | |
| | | | '_ ` _ \| |
| |_| | | | | | | |
 \__,_|_| |_| |_|_|
          _
 ___  ___| |__   ___ _ __ ___   __ _
/ __|/ __| '_ \ / _ \ '_ ` _ \ / _` |
\__ \ (__| | | |  __/ | | | | | (_| |
|___/\___|_| |_|\___|_| |_| |_|\__,_|
          _             _ ___     __    _
  ___ ___| |    ___ ___| | \ \   / /_ _| |_   _  ___
 / __/ _ \ |   / __/ _ \ | |\ \ / / _` | | | | |/ _ \
| (_|  __/ |  | (_|  __/ | | \ V / (_| | | |_| |  __/
 \___\___|_|___\___\___|_|_|  \_/ \__,_|_|\__,_|\___|
          |_____|
;

options validvarname=v7;

%utl_optlen(inp=snf.&pgm.x000000xls030 ,out=snf.&pgm.x000000xls030);

* input should be sorted by cel_reportKey cel_name;
data snf.cel_cellvalue(index=(cel_reportNumName=(cel_reportKey cel_name)/unique cel_reportKey));

   set snf.&pgm.x000000xls030( rename=(
       rpt_rec_num = cel_reportKey
       snfnam      = cel_name
       snfVal      = cel_value
       ));

   keep cel_reportKey cel_name cel_value;

run;quit;


/*
data cells;
   set snf.cel_cellValue(obs=3);
   select (_n_);
      when (1) label="One";
      when (2) label="Two";
      when (3) label="Tre";
   end;
run;quit;

proc transpose data=cells out=celx;
var cel_value;
id cel_name;
idlabel label;
run;quit;

proc sql;
   select
      count(distinct substr(cel_name,1,7)) as wks
   from
      snf.cel_cellvalue
;quit;

   Variables in Creation Order

#    Variable         Type    Len

1    cel_reportKey    Num       5
2    cel_name         Char     21
3    cel_value        Char     33


              Alphabetic List of Indexes and Attributes

                                      # of
                          Unique    Unique
#    Index                Option    Values    Variables

1    cel_reportKey                      11
2    cel_reportNumName    YES        12182    cel_reportKey cel_name
*/

*          _                _     _
  __ _  __| |_ __  __ _  __| | __| |_ __ ___  ___ ___
 / _` |/ _` | '__|/ _` |/ _` |/ _` | '__/ _ \/ __/ __|
| (_| | (_| | |  | (_| | (_| | (_| | | |  __/\__ \__ \
 \__,_|\__,_|_|___\__,_|\__,_|\__,_|_|  \___||___/___/
             |_____|
;

data adr_address(rename=cel_reportkey=adr_cel_reportkey);
     set snf.cel_cellvalue( where=(
         cel_name in (
             'S200001_00100_00100_C'
            ,'S200001_00200_00100_C'
            ,'S200001_00200_00200_C'
            ,'S200001_00200_00300_C'
            ,'S200001_00300_00100_C'
            ,'S200001_00300_00200_C'
            ,'S200001_00300_00300_C'
            ,'S200001_00400_00100_C'
            ,'S200001_00400_00200_C'
            ,'S200001_00400_00300_C'
            ,'S200001_00400_00400_C'
            ,'S200001_00400_00500_C'
            ,'S200001_00400_00600_C'
            ,'S200001_01400_00100_C'
            ,'S200001_01400_00200_C'
            ,'S200001_01500_00100_N'
            )));
        by
          cel_reportKey cel_name;
        if
          first.cel_name;
run;quit;

proc transpose data=adr_address out=adr_address1(drop=_name_ index=(adr_cel_reportKey/unique));
by adr_cel_reportkey;
var cel_value;
id cel_name;
run;quit;


data snf.adr_address(
       sortedby=adr_cel_reportKey
       index=(adr_cel_reportKey/unique)
       rename=(
             S200001_00400_00200_C =  adr_rpv_providerNum
             S200001_00100_00100_C =  Street_S200001_00100_00100_C
             S200001_00200_00100_C =  City_S200001_00200_00100_C
             S200001_00200_00200_C =  State_S200001_00200_00200_C
             S200001_00200_00300_C =  Zip_S200001_00200_00300_C
             S200001_00300_00100_C =  County_S200001_00300_00100_C
             S200001_00300_00200_C =  Cbsa_code_S200001_00300_00200_C
             S200001_00300_00300_C =  UrbanRural_S200001_00300_00300_C
             S200001_00400_00100_C =  Provider_S200001_00400_00100_C
             S200001_00400_00300_C =  Cert_date_S200001_00400_00300_C
             S200001_00400_00400_C =  Pay_V_S200001_00400_00400_C
             S200001_00400_00500_C =  Pay_XVIII_S200001_00400_00500_C
             S200001_00400_00600_C =  Pay_XIX_S200001_00400_00600_C
             S200001_01400_00100_C =  Fiscal_Bgn_S200001_01400_00100_C
             S200001_01400_00200_C =  Fiscal_End_S200001_01400_00200_C
             S200001_01500_00100_N =  TypControl_S200001_01500_00100_N
       ));
   retain adr_cel_reportKey S200001_00400_00200_C S200001_00400_00100_C
          S200001_00400_00200_C
          S200001_00100_00100_C
          S200001_00200_00100_C
          S200001_00200_00200_C
          S200001_00200_00300_C
          S200001_00300_00100_C
          S200001_00300_00200_C
          S200001_00300_00300_C
          S200001_00400_00400_C
          S200001_00400_00500_C
          S200001_00400_00600_C
          S200001_01500_00100_N
          S200001_00400_00300_C
          S200001_01400_00100_C
          S200001_01400_00200_C;

   label
       adr_cel_reportKey      = "Report Number a Facility can have mutiple reports in the same year"
       S200001_00100_00100_C  ="%qsysfunc(putc(S200001_00100_00100_C,$snffmt))"
       S200001_00200_00100_C  ="%qsysfunc(putc(S200001_00200_00100_C,$snffmt))"
       S200001_00200_00200_C  ="%qsysfunc(putc(S200001_00200_00200_C,$snffmt))"
       S200001_00200_00300_C  ="%qsysfunc(putc(S200001_00200_00300_C,$snffmt))"
       S200001_00300_00100_C  ="%qsysfunc(putc(S200001_00300_00100_C,$snffmt))"
       S200001_00300_00200_C  ="%qsysfunc(putc(S200001_00300_00200_C,$snffmt))"
       S200001_00300_00300_C  ="%qsysfunc(putc(S200001_00300_00300_C,$snffmt))"
       S200001_00400_00100_C  ="%qsysfunc(putc(S200001_00400_00100_C,$snffmt))"
       S200001_00400_00200_C  ="%qsysfunc(putc(S200001_00400_00200_C,$snffmt))"
       S200001_00400_00300_C  ="%qsysfunc(putc(S200001_00400_00300_C,$snffmt))"
       S200001_00400_00400_C  ="%qsysfunc(putc(S200001_00400_00400_C,$snffmt))"
       S200001_00400_00500_C  ="%qsysfunc(putc(S200001_00400_00500_C,$snffmt))"
       S200001_00400_00600_C  ="%qsysfunc(putc(S200001_00400_00600_C,$snffmt))"
       S200001_01400_00100_C  ="%qsysfunc(putc(S200001_01400_00100_C,$snffmt))"
       S200001_01400_00200_C  ="%qsysfunc(putc(S200001_01400_00200_C,$snffmt))"
       S200001_01500_00100_N  ="%qsysfunc(putc(S200001_01500_00100_N,$snffmt))"
   ;

   set adr_address1 ;



run;quit;


*          _              _     _                     _ _
  ___ ___ | |    ___ ___ | | __| | ___  ___  ___ _ __(_) |__   ___
 / __/ _ \| |   / __/ _ \| |/ _` |/ _ \/ __|/ __| '__| | '_ \ / _ \
| (_| (_) | |  | (_| (_) | | (_| |  __/\__ \ (__| |  | | |_) |  __/
 \___\___/|_|___\___\___/|_|\__,_|\___||___/\___|_|  |_|_.__/ \___|
           |_____|
;


data snf.col_colDescribe(index=(col_cel_name/unique) sortedby=col_cel_name);

      set snf.&pgm.x000000xlsRptFmt(
               drop=end fmtname
               rename=(start=col_cel_name label=col_description));
run;quit;

*                                      _   ____                _
 _ __ _ ____   __  _ __ ___  ___  _ __| |_|  _ \ _ ____   ____| |_ __
| '__| '_ \ \ / / | '__/ _ \/ _ \| '__| __| |_) | '__\ \ / / _` | '__|
| |  | |_) \ V /  | | |  __/ (_) | |  | |_|  __/| |   \ V / (_| | |
|_|  | .__/ \_/___|_|  \___|\___/|_|   \__|_|   |_|    \_/ \__,_|_|
     |_|     |_____|
;

data snf.rpv_reportPrvdr(index=(rpv_cel_reportKey/unique));

   set snf.&pgm.rpr2rec( rename=(
           start=rpv_cel_reportKey
           label=rpv_providerNum
           ));
    drop fmtname;
run;quit;

*                                _
 ___ _   _ ___     ___ _   _ ___| |_ ___ _ __ ___
/ __| | | / __|   / __| | | / __| __/ _ \ '_ ` _ \
\__ \ |_| \__ \   \__ \ |_| \__ \ ||  __/ | | | | |
|___/\__, |___/___|___/\__, |___/\__\___|_| |_| |_|
     |___/   |_____|   |___/
;

data snf.sys_system (index=(sys_cel_reportkey/unique sys_rpv_providernum)
                    sortedby=sys_cel_reportkey );

   length sys_year $4.;
  retain
     sys_cel_reportkey
     sys_rpv_providernum
     sys_initlRptsw
     sys_lastRptsw
     sys_trnsmtlNum
     sys_fiNum
     sys_utilCd
     sys_specInd
     sys_YEAR
     sys_prvdrCtrlTypeCd
     sys_RptStusCd
     sys_adrvndrCd
     sys_npi
     sys_procDt
     sys_fiCreatDt
     sys_nprdt
     sys_fiRcptDt
  ;

  set snf.snf_100_rpx15(obs=10 rename=(
     rpt_rec_num          =  sys_cel_reportkey
     prvdr_num            =  sys_rpv_providernum
     initl_rpt_sw         =  sys_initlRptsw
     last_rpt_sw          =  sys_lastRptsw
     trnsmtl_num          =  sys_trnsmtlNum
     fi_num               =  sys_fiNum
     util_cd              =  sys_utilCd
     spec_ind             =  sys_specInd
     yer                  =  sys_YEAR
     prvdr_ctrl_type_cd   =  sys_prvdrCtrlTypeCd
     rpt_stus_cd          =  sys_RptStusCd
     adr_vndr_cd          =  sys_adrvndrCd
     npi                  =  sys_npi
     proc_dt              =  sys_procDt
     fi_creat_dt          =  sys_fiCreatDt
     npr_dt               =  sys_nprdt
     fi_rcpt_dt           =  sys_fiRcptDt
   ));
   sys_YEAR = '2015';


   drop
      FY_BGN_DT
      FY_END_DT;
run;quit;

*    _             _                                            _     _
 ___(_)_ __     __| | ___ _ __ ___   ___   __ _ _ __ __ _ _ __ | |__ (_) ___
|_  / | '_ \   / _` |/ _ \ '_ ` _ \ / _ \ / _` | '__/ _` | '_ \| '_ \| |/ __|
 / /| | |_) | | (_| |  __/ | | | | | (_) | (_| | | | (_| | |_) | | | | | (__
/___|_| .__/___\__,_|\___|_| |_| |_|\___/ \__, |_|  \__,_| .__/|_| |_|_|\___|
      |_| |_____|                         |___/          |_|
;


%utlnopts;

%arraydelete(cls);

%array(cls,values= zcta5
         county state altzips esriid geoid naltzips intptlat intptlon
         landsqmi areasqmi totpopsf1 logrecno totpop age0_4 age5_9
         age10_14 age15_19 age20_24 age25_34 age35_44 age45_54 age55_59
         age60_64 age65_74 age75_84 over85 medianage over5 over15 under18
         over18 over21 over25 over62 over65 males over18males over65males
         females over18females over65females onerace white1 black1
         indian1 asian1 hawnpi1 other1 multirace tothhs hhinc0 hhinc10
         hhinc15 hhinc25 hhinc35 hhinc50 hhinc75 hhinc100 hhinc150
         hhinc200 numhhearnings numhhsocsec numhhretinc numhhsuppsecinc
         numhhpubassist numhhfoodstmp medianhhinc avghhinc avghhearnings
         avghhsocsec avghhretinc avghhsuppsecinc avghhpubassist famhhs
         famhhinc0 famhhinc10 famhhinc15 famhhinc25 famhhinc35 famhhinc50
         famhhinc75 famhhinc100 famhhinc150 famhhinc200 medianfaminc
         avgfaminc pci nonfamhhs mediannonfaminc avgnonfaminc poor
         povuniverseunder18 poorunder18 povuniverse18_64 poor18to64
         povuniverseover65 poorover65 povuniversefamilypop
         povuniverseunrelated poorinfamily poorfamilies poorunrelated
         povratiounderhalf povratiov5tov99 povratio1to2 povratioover2
         notinsuredunder65 publicinsuranceunder65
         privateinsuranceonlyunder65 noninstunder18 notinsuredunder18
         families famswithkids marriedcouples coupleswithkids
         singlemalefamilies singlefathers singlefemalefamilies
         singlemothers livingalone over65alone hhswithkids hhswithelders
         avghhsize avgfamsize hhpop famhhpop householder unmarriedpartner
         umpartnerhhsperk nevermarried married separated widowed divorced
         women15to50 unmarriedwomen15to50 birthrate15_19 birthrate20_34
         birthrate35_50 over3 enrolledover3 innursery inkindergarten
         inelementary inhighschool incollege lessthan9th somehighschool
         highschool somecollege associates bachelors gradprof
         highschoolormore bachelorsormore civilian veteran disabled
         usnative borninus bornincurrstate bornindiffstate bornabroad
         foreignborn naturalized noncitizen englishonly othlang
         othlangenglishltd spanish spanishenglishltd tothus occhus
         ownerocc renterocc personsinownerunits personsinrenterunits
         hvalunder50 hval50 hval100 hval150 hval200 hval300 hval500
         hvalovermillion hvalover2million medianhvalue avghvalue

         mediangrossrent avggrossrent );

%put &=clsn;

options compress=binary validvarname=v7;
data snf.zip_demographics(sortedby=zip_zip5 index=(zip_zip5/unique));
   length zip_zip5 $5;
   retain zip_zip5;
   set lup.mo_zcta2015cutzipfix(obs=1
   keep=%do_over(cls,phrase=?)
   rename=(%do_over(cls,phrase=? = zip_? )));
   length _numeric_ 8.;
   zip_zip5 = zip_zcta5;
   label zip_zip5 = 'If a miss average matching three digit zcta5. Hot rate on zipcode=zcta5 is over 80%';
run;quit;
%utlopts;

proc datasets lib = snf nolist;
  modify zip_demographics ;
    attrib _all_ label = "" ;
    informat _all_;
    format _all_;
  run ;
quit ;

*    _ _
  __| (_) __ _  __ _ _ __ __ _ _ __ ___
 / _` | |/ _` |/ _` | '__/ _` | '_ ` _ \
| (_| | | (_| | (_| | | | (_| | | | | | |
 \__,_|_|\__,_|\__, |_|  \__,_|_| |_| |_|
               |___/
;

* load tables into mysql;

libname mysqllib mysql user=root password="sas28rlx" database=world port=3306;

/*
proc sql;drop table dm  ;
proc sql;drop table lb ;
run;quit;
*/

proc sql;
  drop table mysqllib.sys_system;
  drop table mysqllib.rpv_reportPrvdr;
  drop table mysqllib.col_colDescribe;
  drop table mysqllib.adr_address;
  drop table mysqllib.cel_cellvalue;
  drop table mysqllib.zip_demographics;
quit;

proc contents data=mysqllib._all_;
run;quit;

proc copy in=snf out=mysqllib;
select
 /*  sys_system         */
 /*  rpv_reportPrvdr    */
 /*  col_colDescribe   */
  adr_address
 /*  cel_cellvalue     */
 /*  zip_demographics  */
;
run;quit;


proc sql;
  drop table mysqllib.city;
  drop table mysqllib.country;
  drop table mysqllib.countrylanguage;
quit;

data cells;
   set snf.cel_cellValue(obs=3);
   select (_n_);
      when (1) label="One";
      when (2) label="Two";
      when (3) label="Tre";
   end;
run;quit;

proc transpose data=cells out=celx;
var cel_value;
id cel_name;
idlabel label;
run;quit;


 data class;
   label
     name ="Student name"
     age ="Student age"
     sex ="Student sex"
   ;
   set sashelp.class(keep=name age sex);
run;quit;


*                      _       _          _
__   ____ _ _ __ ___  | | __ _| |__   ___| |
\ \ / / _` | '__/ __| | |/ _` | '_ \ / _ \ |
 \ V / (_| | |  \__ \ | | (_| | |_) |  __/ |
  \_/ \__,_|_|  |___/ |_|\__,_|_.__/ \___|_|

;

/*

S200001_00400_00200_C =  Provider CCN@S200001_00400_00200_C
S200001_01400_00100_C =  Fiscal_Bgn_S200001_01400_00100_C
S200001_01400_00200_C =  Fiscal_End_S200001_01400_00200_C

cel_reportKey            cel_name         cel_value          snf.cel_cellvalue      l
col_cel_name             col_description                     snf.col_coldescribe    r

*/

* get data;
proc sql;
  create
     table snf.&pgm.preRpt as
  select
      l.cel_reportKey
     ,input(put(l.cel_reportKey,7.),snfRecPrvdr.) as Provider
     ,r.col_description
     ,l.cel_name
     ,coalesce(cel_value,"  ") as cel_value
  from
     snf.cel_cellValue as l,
     snf.col_coldescribe as r
  where
     l.cel_name  = r.col_cel_name
  order
     by l.cel_reportKey, Provider, l.cel_name  descending ;
;quit;

proc transpose data=snf.&pgm.preRpt(
        where=(cel_name in: ("S2","G0")))
         out=snf.&pgm.preRptXpo (drop=_name_);
   by cel_reportKey Provider;
   var cel_value;
   id cel_name;
   idlabel col_description;
run;quit;


*     _
__  _| |___
\ \/ / / __|
 >  <| \__ \
/_/\_\_|___/

;
ods listing close;

%utlfkil(d:/snf/xls/&pgm.Sample.xlsx);

* need to add provider number;

ods excel file="d:/snf/xls/&pgm.pivot.xlsx";

%utlnopts;
options label;

proc report data=snf.&pgm.preRptXpo(obs=10)  missing nowd split="@"
  style(column)={cellwidth=5in};
run;quit;

ods excel close;
ods listing;
%utlopts;

*          _ _
  __ _  __| | |__   ___   ___
 / _` |/ _` | '_ \ / _ \ / __|
| (_| | (_| | | | | (_) | (__
 \__,_|\__,_|_| |_|\___/ \___|
                      _
__   _____   ___   __| | ___   ___
\ \ / / _ \ / _ \ / _` |/ _ \ / _ \
 \ V / (_) | (_) | (_| | (_) | (_) |
  \_/ \___/ \___/ \__,_|\___/ \___/

;

proc sql;
  create
     table snf.&pgm.adhoc2 as
  select
      l.rpt_rec_num as cel_reportKey
     ,l.prvdr_num as Provider_CCN
     ,r.col_description
     ,l.snfnam as cel_name
     ,coalesce(l.snfval,"  ") as cel_value length 255
  from
     snf.snf_100_numalp15yersrt l,
     snf.col_coldescribe as r
  where
     l.snfnam = r.col_cel_name
  order
     by cel_reportKey, Provider_CCN, cel_name  descending ;
;quit;

proc transpose data=snf.&pgm.adhoc2
         out=snf.&pgm.adhoc2Xpo (drop=_name_);
   by cel_reportKey Provider_CCN;
   var cel_value;
   id cel_name;
   idlabel col_description;
run;quit;

optios ls=255;
data _null_;
  set snf.&pgm.adhoc2Xpo(obs=1);
  array chr _character_;
  do over chr;
    lbl=vlabel(chr);
    put chr @20 lbl;
  end;
  stop;
run;quit;

%utl_optlen(inp=snf.&pgm.adhoc2Xpo,out=snf.&pgm.adhoc2Xpo);

%inc "c:/oto/oto_voodoo.sas";

%utlvdoc
    (
    libname        = snf          /* libname of input dataset */
    ,data          = &pgm.adhoc2Xpo     /* name of input dataset */
    ,key           = cel_reportKey   /* 0 or variable */
    ,ExtrmVal      = 10           /* display top and bottom 30 frequencies */
    ,UniPlot       = 0            /* 'true' enables ('false' disables) plot option on univariate output */
    ,UniVar        = 0            /* 'true' enables ('false' disables) plot option on univariate output */
    ,misspat       = 0            /* 0 or 1 missing patterns */
    ,chart         = 0            /* 0 or 1 line printer chart */
    ,taball        = 0
    ,tabone        = 0            /* 0 or  variable vs all other variables          */
    ,mispop        = 0            /* 0 or 1  missing vs populated*/
    ,mispoptbl     = 1            /* 0 or 1  missing vs populated*/
    ,dupcol        = 0            /* 0 or 1  columns duplicated  */
    ,unqtwo        = 0
    ,vdocor        = 0            /* 0 or 1  correlation of numeric variables */
    ,oneone        = 0            /* 0 or 1  one to one - one to many - many to many */
    ,cramer        = 0            /* 0 or 1  association of character variables    */
    ,optlength     = 0
    ,maxmin        = 0
    ,unichr        = 0
    ,outlier       = 0
    ,printto       = d:\snf\vdo\&data..txt        /* file or output if output window */
    ,Cleanup       = 0           /* 0 or 1 delete intermediate datasets */
    );



Hospice@LOSTitle XVIII@S300001_00700_01400_N

S300001_
00700_
01400_N     Frequency     Percent
---------------------------------
               15395       99.97
1                  1        0.01
15.5               1        0.01
25.54              1        0.01
69                 1        0.01


Home Health Agency@FTENonpaid Payroll@S300001_00400_02300_N

S300001_
00400_
02300_N     Frequency     Percent
---------------------------------
               15397       99.99
0.25               1        0.01
0.61               1        0.01


* __ _               _
 / _(_)___  ___ __ _| |  _   _  ___  __ _ _ __
| |_| / __|/ __/ _` | | | | | |/ _ \/ _` | '__|
|  _| \__ \ (_| (_| | | | |_| |  __/ (_| | |
|_| |_|___/\___\__,_|_|  \__, |\___|\__,_|_|
                         |___/
;

proc sql;
  create
     table snf.&pgm.preRpt as
  select
      l.rpt_rec_num as cel_reportKey
     ,l.prvdr_num as Provider_CCN
     ,r.col_description
     ,l.snfnam as cel_name
     ,coalesce(l.snfval,"  ") as cel_value length 255
  from
     snf.snf_100_numalp15yersrt l,
     snf.col_coldescribe as r
  where
     l.snfnam = r.col_cel_name AND
     l.snfnam in (
        'S200001_00400_00200_C'
       ,'S200001_01400_00100_C'
       ,'S200001_01400_00200_C'
       )
  order
     by cel_reportKey, Provider_CCN, cel_name  descending ;
;quit;

proc transpose data=snf.&pgm.preRpt
         out=snf.&pgm.preRptXpo(drop=_name_);
   by cel_reportKey Provider_CCN;
   var cel_value;
   id cel_name;
   idlabel col_description;
run;quit;




A000000_10000_00100_N
A000000_10000_00200_N
C000000_10000_00200_N
C000000_10000_00100_N





























/* query to find provider type

proc sql;
  create
      table adhoc1 as
  select
      *
  from
      snf.snf_100_numalp15yersrt
  where
      SNFNAM IN (
'S200001_00100_00100_C'
,'S200001_00200_00100_C'
,'S200001_00200_00200_C'
,'S200001_00200_00300_C'
,'S200001_00300_00100_C'
,'S200001_00300_00200_C'
,'S200001_00300_00300_C'
,'S200001_00300_00400_C'
,'S200001_01500_00100_C'
,'S200001_01400_00100_C'
,'S200001_01400_00200_C'
,'S200001_00300_00300_N'
,'S200001_00300_00400_N'
,'S200001_01500_00100_N'
,'S200001_01400_00100_N'
,'S200001_01400_00200_N'
);
;quit;


proc sql;
  select
      *
  from
      snf.COL_COLDESCRIBE
  where
      COL_CEL_nAME IN (
'S200001_00100_00100_C'
,'S200001_00200_00100_C'
,'S200001_00200_00200_C'
,'S200001_00200_00300_C'
,'S200001_00300_00100_C'
,'S200001_00300_00200_C'
,'S200001_00300_00300_C'
,'S200001_00300_00400_C'
,'S200001_01500_00100_C'
,'S200001_01400_00100_C'
,'S200001_01400_00200_C'
,'S200001_00300_00300_N'
,'S200001_00300_00400_N'
,'S200001_01500_00100_N'
,'S200001_01400_00100_N'
,'S200001_01400_00200_N'
);
;quit;


10 sys_prvdrCtrlTypeCd

proc freq data=snf.sys_system;
tables sys_prvdrCtrlTypeCd;
run;quit;    4,5,6
sys_prvdrCtrlTypeCd


proc freq data=SNF.SNF_060SNFADD(where=(snfnam='S200001_01500_00100_N'));
tables snfval ;
run;quit;


'S200001_00100_00100_C'
,'S200001_00200_00100_C'
,'S200001_00200_00200_C'
,'S200001_00200_00300_C'
,'S200001_00300_00100_C'
,'S200001_00300_00200_C'
,'S200001_00300_00300_C'
,'S200001_00300_00400_C'
,'S200001_01500_00100_C'
,'S200001_01400_00100_C'
,'S200001_01400_00200_C'
,'S200001_00300_00300_N'
,'S200001_00300_00400_N'
,'S200001_01500_00100_N'
,'S200001_01400_00100_N'
,'S200001_01400_00200_N'






S200001_00100_00100_C  Street@S200001_00100_00100_C
S200001_00200_00100_C  City@S200001_00200_00100_C
S200001_00200_00200_C  State@S200001_00200_00200_C
S200001_00200_00300_C  Zip@S200001_00200_00300_C
S200001_00300_00100_C  County@S200001_00300_00100_C
S200001_00300_00200_C  Cbsa code@S200001_00300_00200_C
S200001_00300_00300_C  Urban rural@S200001_00300_00300_C
S200001_01400_00100_C  Fiscal Begin Date@S200001_01400_00100_C
S200001_01400_00200_C  Fiscal End Date@S200001_01400_00200_C
S200001_01500_00100_N  Type of Control@S200001_01500_00100_N



Street Address          S2-Part1-Line-1-Column-1     S200001_00100_00100_C  Street            S200001_00100_00100_C
City                    S2-Part1-Line-2-Column-1     S200001_00200_00100_C  City              S200001_00200_00100_C
State Code              S2-Part1-Line-2-Column-2     S200001_00200_00200_C  State             S200001_00200_00200_C
Zip Code                S2-Part1-Line-2-Column-3     S200001_00200_00300_C  Zip               S200001_00200_00300_C
County                  S2-Part1-Line-3-Column-1     S200001_00300_00100_C  County            S200001_00300_00100_C
Medicare CBSA Number    S2-Part1-Line-3-Column-2     S200001_00300_00200_C  Cbsa code         S200001_00300_00200_C
Rural versus Urban      S2-Part1-Line-3-Column-3     S200001_00300_00300_C  Urban rural       S200001_00300_00300_C
Fiscal Year Begin Date  S2-Part1-Line-14-Column-1    S200001_01400_00100_C  Fiscal Begin Date S200001_01400_00100_C
Fiscal Year End Date    S2-Part1-Line-14-Column-2    S200001_01400_00200_C  Fiscal End Date   S200001_01400_00200_C
Type of Control         S2-Part1-Line 15-Column-1    S200001_01500_00100_N  Type of Control   S200001_01500_00100_N


*/




%inc "c:/oto/oto_voodoo.sas";


%*utlvdoc
    (
    libname        = work         /* libname of input dataset */
    ,data          = zipcode      /* name of input dataset */
    ,key           = zip          /* 0 or variable */
    ,ExtrmVal      = 10           /* display top and bottom 30 frequencies */
    ,UniPlot       = 1            /* 'true' enables ('false' disables) plot option on univariate output */
    ,UniVar        = 1            /* 'true' enables ('false' disables) plot option on univariate output */
    ,misspat       = 1            /* 0 or 1 missing patterns */
    ,chart         = 1            /* 0 or 1 line printer chart */
    ,taball        = AREACODES DST STATECODE STATENAME ZIP_CLASS STATE Y COUNTY /* variable 0 */
    ,tabone        = STATECODE    /* 0 or  variable vs all other variables          */
    ,mispop        = 1            /* 0 or 1  missing vs populated*/
    ,mispoptbl     = 1            /* 0 or 1  missing vs populated*/
    ,dupcol        = 1            /* 0 or 1  columns duplicated  */
    ,unqtwo        = AREACODES DST STATECODE STATENAME ZIP_CLASS STATE Y COUNTY COUNTYNM            /* 0 */
    ,vdocor        = 1            /* 0 or 1  correlation of numeric variables */
    ,oneone        = 1            /* 0 or 1  one to one - one to many - many to many */
    ,cramer        = 1            /* 0 or 1  association of character variables    */
    ,optlength     = 1
    ,maxmin        = 1
    ,unichr        = 1
    ,outlier       = 1
    ,printto       = d:\txt\vdo\&data..txt        /* file or output if output window */
    ,Cleanup       = 0           /* 0 or 1 delete intermediate datasets */
    );



































*               _                __
  ___ _ __   __| |  _ __  _   _ / _|
 / _ \ '_ \ / _` | | '_ \| | | | |_
|  __/ | | | (_| | | |_) | |_| |  _|
 \___|_| |_|\__,_| | .__/ \__,_|_|
                   |_|
 _         _           _
| |_ _   _| |_     ___| |_   _
| __| | | | __|   / __| | | | |
| |_| |_| | |_    \__ \ | |_| |
 \__|\__,_|\__|___|___/_|\__, |
             |_____|     |___/
;


*
 _ __ ___   __ _  ___ _ __ ___  ___
| '_ ` _ \ / _` |/ __| '__/ _ \/ __|
| | | | | | (_| | (__| | | (_) \__ \
|_| |_| |_|\__,_|\___|_|  \___/|___/

;
proc datasets library=work kill;
run;quit;;

%Macro utl_ymrlan100
    (
      style=utl_ymrlan100
      ,frame=void
      ,TitleFont=13pt
      ,docfont=13pt
      ,fixedfont=12pt
      ,rules=none
      ,bottommargin=.25in
      ,topmargin=.25in
      ,rightmargin=.25in
      ,leftmargin=.25in
      ,cellheight=13pt
      ,cellpadding = .2pt
      ,cellspacing = .2pt
      ,borderwidth = .2pt
    ) /  Des="SAS PDF Template for PDF";

ods path work.templat(update) sasuser.templat(update) sashelp.tmplmst(read);

proc template ;
source styles.printer;
run;quit;

Proc Template;

   define style &Style;
   parent=styles.rtf;

        class body from Document /

               protectspecialchars=off
               asis=on
               bottommargin=&bottommargin
               topmargin   =&topmargin
               rightmargin =&rightmargin
               leftmargin  =&leftmargin
               ;

        class color_list /
              'link' = blue
               'bgH'  = _undef_
               'fg'  = black
               'bg'   = _undef_;

        class fonts /
               'TitleFont2'           = ("Arial, Helvetica, Helv",&titlefont,Bold)
               'TitleFont'            = ("Arial, Helvetica, Helv",&titlefont,Bold)

               'HeadingFont'          = ("Arial, Helvetica, Helv",&titlefont)
               'HeadingEmphasisFont'  = ("Arial, Helvetica, Helv",&titlefont,Italic)

               'StrongFont'           = ("Arial, Helvetica, Helv",&titlefont,Bold)
               'EmphasisFont'         = ("Arial, Helvetica, Helv",&titlefont,Italic)

               'FixedFont'            = ("Courier New, Courier",&fixedfont)
               'FixedEmphasisFont'    = ("Courier New, Courier",&fixedfont,Italic)
               'FixedStrongFont'      = ("Courier New, Courier",&fixedfont,Bold)
               'FixedHeadingFont'     = ("Courier New, Courier",&fixedfont,Bold)
               'BatchFixedFont'       = ("Courier New, Courier",&fixedfont)

               'docFont'              = ("Arial, Helvetica, Helv",&docfont)

               'FootFont'             = ("Arial, Helvetica, Helv", 9pt)
               'StrongFootFont'       = ("Arial, Helvetica, Helv",8pt,Bold)
               'EmphasisFootFont'     = ("Arial, Helvetica, Helv",8pt,Italic)
               'FixedFootFont'        = ("Courier New, Courier",8pt)
               'FixedEmphasisFootFont'= ("Courier New, Courier",8pt,Italic)
               'FixedStrongFootFont'  = ("Courier New, Courier",7pt,Bold);

        class GraphFonts /
               'GraphDataFont'        = ("Arial, Helvetica, Helv",&fixedfont)
               'GraphValueFont'       = ("Arial, Helvetica, Helv",&fixedfont)
               'GraphLabelFont'       = ("Arial, Helvetica, Helv",&fixedfont,Bold)
               'GraphFootnoteFont'    = ("Arial, Helvetica, Helv",8pt)
               'GraphTitleFont'       = ("Arial, Helvetica, Helv",&titlefont,Bold)
               'GraphAnnoFont'        = ("Arial, Helvetica, Helv",&fixedfont)
               'GraphUnicodeFont'     = ("Arial, Helvetica, Helv",&fixedfont)
               'GraphLabel2Font'      = ("Arial, Helvetica, Helv",&fixedfont)
               'GraphTitle1Font'      = ("Arial, Helvetica, Helv",&fixedfont)
               'NodeDetailFont'       = ("Arial, Helvetica, Helv",&fixedfont)
               'NodeInputLabelFont'   = ("Arial, Helvetica, Helv",&fixedfont)
               'NodeLabelFont'        = ("Arial, Helvetica, Helv",&fixedfont)
               'NodeTitleFont'        = ("Arial, Helvetica, Helv",&fixedfont);


        style Graph from Output/
                outputwidth = 100% ;

        style table from table /
                outputwidth=100%
                protectspecialchars=off
                asis=on
                background = colors('tablebg')
                frame=&frame
                rules=&rules
                cellheight  = &cellheight
                cellpadding = &cellpadding
                cellspacing = &cellspacing
                bordercolor = colors('tableborder')
                borderwidth = &borderwidth;

         class Footer from HeadersAndFooters

                / font = fonts('FootFont')  just=left asis=on protectspecialchars=off ;

                class FooterFixed from Footer
                / font = fonts('FixedFootFont')  just=left asis=on protectspecialchars=off;

                class FooterEmpty from Footer
                / font = fonts('FootFont')  just=left asis=on protectspecialchars=off;

                class FooterEmphasis from Footer
                / font = fonts('EmphasisFootFont')  just=left asis=on protectspecialchars=off;

                class FooterEmphasisFixed from FooterEmphasis
                / font = fonts('FixedEmphasisFootFont')  just=left asis=on protectspecialchars=off;

                class FooterStrong from Footer
                / font = fonts('StrongFootFont')  just=left asis=on protectspecialchars=off;

                class FooterStrongFixed from FooterStrong
                / font = fonts('FixedStrongFootFont')  just=left asis=on protectspecialchars=off;

                class RowFooter from Footer
                / font = fonts('FootFont')  asis=on protectspecialchars=off just=left;

                class RowFooterFixed from RowFooter
                / font = fonts('FixedFootFont')  just=left asis=on protectspecialchars=off;

                class RowFooterEmpty from RowFooter
                / font = fonts('FootFont')  just=left asis=on protectspecialchars=off;

                class RowFooterEmphasis from RowFooter
                / font = fonts('EmphasisFootFont')  just=left asis=on protectspecialchars=off;

                class RowFooterEmphasisFixed from RowFooterEmphasis
                / font = fonts('FixedEmphasisFootFont')  just=left asis=on protectspecialchars=off;

                class RowFooterStrong from RowFooter
                / font = fonts('StrongFootFont')  just=left asis=on protectspecialchars=off;

                class RowFooterStrongFixed from RowFooterStrong
                / font = fonts('FixedStrongFootFont')  just=left asis=on protectspecialchars=off;

                class SystemFooter from TitlesAndFooters / asis=on
                        protectspecialchars=off just=left;
    end;
run;
quit;

%Mend utl_ymrlan100;
%utl_ymrlan100;




%Macro Tut_Sly
(
 stop=43,
 L1=' ',  L43=' ',  L2=' ', L3=' ', L4=' ', L5=' ', L6=' ', L7=' ', L8=' ', L9=' ',
 L10=' ', L11=' ',
 L12=' ', L13=' ', L14=' ', L15=' ', L16=' ', L17=' ', L18=' ', L19=' ',
 L20=' ', L21=' ',
 L22=' ', L23=' ', L24=' ', L25=' ', L26=' ', L27=' ', L28=' ', L29=' ', L30=' ', L31=' ', L32=' ',
 L33=' ', L34=' ', L35=' ', L36=' ', L37=' ', L38=' ', L39=' ', L40=' ', L41=' ', L42=' ',
 L44=' ', L45=' ', L46=' ', L47=' ', L48=' ', L49=' ', L50=' ', L51=' ', L52=' '
 )/ des="SAS Slides all argument values need to be single quoted";

/* creating slides for a presentation */
/* up to 32 lines */
/* backtic ` is converted to a single quote  */
/* | is converted to a , */

Data _OneLyn1st(rename=t=title);

Length t $255;
 t=resolve(translate(&L1,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
 t=resolve(translate(&L2,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
 t=resolve(translate(&L3,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
 t=resolve(translate(&L4,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
 t=resolve(translate(&L5,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
 t=resolve(translate(&L6,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
 t=resolve(translate(&L7,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
 t=resolve(translate(&L8,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
 t=resolve(translate(&L9,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L10,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L11,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L12,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L13,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L14,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L15,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L16,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L17,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L18,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L19,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L20,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L21,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L22,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L23,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L24,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L25,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L26,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L27,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L28,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L29,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L30,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L31,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L32,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L33,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L34,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L35,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L36,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L37,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L38,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L39,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L41,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L42,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L43,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L44,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L45,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L46,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L47,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L48,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L50,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L51,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;
t=resolve(translate(&L52,"'","`"));t=translate(t,",","|");t=translate(t,";","~");t=translate(t,'%',"#");t=translate(t,'&',"@");Output;

run;quit;

/*  %let l7='^S={font_size=25pt just=c cellwidth=100pct}Premium Dollars';  */

options label;
%if &stop=7 %then %do;
   data _null_;
      tyt=scan(&l7,2,'}');
      call symputx("tyt",tyt);
   run;
   ods pdf bookmarkgen=on bookmarklist=show;
   ods proclabel="&tyt";run;quit;
%end;
%else %do;
   ods proclabel="Title";run;quit;
%end;


data _onelyn;
  set _onelyn1st(obs=%eval(&stop + 1));
  if not (left(title) =:  '^') then do;
     pre=upcase(scan(left(title),1,' '));
     idx=index(left(title),' ');
     title=substr(title,idx+1);
  end;
  put title;
run;

* display the slide ;
title;
footnote;

proc report data=_OneLyn nowd  style=utl_pdflan100;
col title;
define title / display ' ';
run;
quit;

%Mend Tut_Sly;

%macro utl_boxpdf2ppt(inp=&outpdf001,out=&outppt001)/des="www.boxoft.con pdf to ppt";
  data _null_;
    cmd=catt("&pdf2ppt",' "',"&inp", '"',' "',"&out",'"');
    put cmd;
    call system(cmd);
  run;
%mend utl_boxpdf2ppt;

%MACRO greenbar ;
   DEFINE _row / order COMPUTED NOPRINT ;
   COMPUTE _row;
      nobs+1;
      _row = nobs;
      IF (MOD( _row,2 )=0) THEN
         CALL DEFINE( _ROW_,'STYLE',"STYLE={BACKGROUND=graydd}" );
   ENDCOMP;
%MEND greenbar;


%macro pdfbeg(rules=all,frame=box,file=d:/snf/pdf/&pgm.slides.pdf);
    %utlnopts;
    options orientation=landscape validvarname=v7;
    ods listing close;
    ods pdf close;
    ods path work.templat(update) sasuser.templat(update) sashelp.tmplmst(read);
    %utlfkil(&file);
    ods noptitle;
    ods escapechar='^';
    ods listing close;
    ods graphics on / width=10in  height=7in ;
    ods pdf file="&file"
    style=utl_ymrlan100 notoc /* bookmarkgen=on bookmarklist=show */;
%mend pdfbeg;

%macro codebegin;
  options orientation=landscape lrecl=384;
  data _null_;
  length lyn $384;
   input;
   lyn=strip(_infile_);
   file print;
   put lyn "^{newline}" @;
   call execute(_infile_);
%mend codebegin;


%macro pdfend;
   ods graphics off;
   ods pdf close;
   ods listing;
   options ls=171 ps=66;
   %utlopts;
%mend pdfend;

%MACRO UTLOPTS
         / des = "Turn all debugging options off forgiving options";

OPTIONS

   OBS=MAX
   FIRSTOBS=1
   lrecl=384
   NOFMTERR      /* DO NOT FAIL ON MISSING FORMATS                              */
   SOURCE      /* turn sas source statements on                               */
   SOURCe2     /* turn sas source statements on                               */
   MACROGEN    /* turn  MACROGENERATON ON                                     */
   SYMBOLGEN   /* turn  SYMBOLGENERATION ON                                   */
   NOTES       /* turn  NOTES ON                                              */
   NOOVP       /* never overstike                                             */
   CMDMAC      /* turn  CMDMAC command macros on                              */
   /* ERRORS=2    turn  ERRORS=2  max of two errors                           */
   MLOGIC      /* turn  MLOGIC    macro logic                                 */
   MPRINT      /* turn  MPRINT    macro statements                            */
   MRECALL     /* turn  MRECALL   always recall                               */
   MERROR      /* turn  MERROR    show macro errors                           */
   NOCENTER    /* turn  NOCENTER  I do not like centering                     */
   DETAILS     /* turn  DETAILS   show details in dir window                  */
   SERROR      /* turn  SERROR    show unresolved macro refs                  */
   NONUMBER    /* turn  NONUMBER  do not number pages                         */
   FULLSTIMER  /*   turn  FULLSTIMER  give me all space/time stats            */
   NODATE      /* turn  NODATE      suppress date                             */
   /*DSOPTIONS=NOTE2ERR                                                                              */
   /*ERRORCHECK=STRICT /*  syntax-check mode when an error occurs in a LIBNAME or FILENAME statement */
   DKRICOND=WARN      /*  variable is missing from input data during a DROP=, KEEP=, or RENAME=     */
   DKROCOND=WARN      /*  variable is missing from output data during a DROP=, KEEP=, or RENAME=     */
   /* NO$SYNTAXCHECK  be careful with this one */
 ;

run;quit;

%MEND UTLOPTS;
%macro utlnopts(note2err=nonote2err,nonotes=nonotes)
    / des = "Turn  debugging options off";

OPTIONS
     FIRSTOBS=1
     NONUMBER
     MLOGICNEST
   /*  MCOMPILENOTE */
     MPRINTNEST
     lrecl=384
     MAUTOLOCDISPLAY
     NOFMTERR     /* turn  Format Error off                           */
     NOMACROGEN   /* turn  MACROGENERATON off                         */
     NOSYMBOLGEN  /* turn  SYMBOLGENERATION off                       */
     &NONOTES     /* turn  NOTES off                                  */
     NOOVP        /* never overstike                                  */
     NOCMDMAC     /* turn  CMDMAC command macros on                   */
     NOSOURCE    /* turn  source off * are you sure?                 */
     NOSOURCE2    /* turn  SOURCE2   show gererated source off        */
     NOMLOGIC     /* turn  MLOGIC    macro logic off                  */
     NOMPRINT     /* turn  MPRINT    macro statements off             */
     NOCENTER     /* turn  NOCENTER  I do not like centering          */
     NOMTRACE     /* turn  MTRACE    macro tracing                    */
     NOSERROR     /* turn  SERROR    show unresolved macro refs       */
     NOMERROR     /* turn  MERROR    show macro errors                */
     OBS=MAX      /* turn  max obs on                                 */
     NOFULLSTIMER /* turn  FULLSTIMER  give me all space/time stats   */
     NODATE       /* turn  NODATE      suppress date                  */
     DSOPTIONS=&NOTE2ERR
     ERRORCHECK=STRICT /*  syntax-check mode when an error occurs in a LIBNAME or FILENAME statement */
     DKRICOND=ERROR    /*  variable is missing from input data during a DROP=, KEEP=, or RENAME=     */

     /* NO$SYNTAXCHECK  be careful with this one */
;

RUN;quit;

%MEND UTLNOPTS;


*    _ _     _
 ___| (_) __| | ___  ___
/ __| | |/ _` |/ _ \/ __|
\__ \ | | (_| |  __/\__ \
|___/_|_|\__,_|\___||___/

;

/*
%inc "c:/oto/utl_rtflan100.sas";

%utl_rtflan100;
*/

%utl_ymrlan100;

* common slide properties;
%let z=%str(                  );
%let b=%str(font_weight=bold);
%let c=%str(font_face="Courier New");
%let f=%str(font_face="Arial");
%let w=%str(cellwidth=100pct);
%let t=^S={font_size=18pt just=l cellwidth=100pct};

/*
* because I allow macro triggers
use these when you do not want a trigger.
Use double quotes when possible
| to ,

` to single quote
~ to semi colon
# to percent sign
@ to ambersand
*/
                                                                |
title;
footnote;

/* https://communities.sas.com/t5/SAS-GRAPH-and-ODS-Graphics/O-DS-Christmas-Tree/m-p/240189 */

* first slide;  ;;;;/*'*/ *);*};*];*/;/*"*/;%mend;run;quit;%end;end;run;endcomp;%utlfix;




%pdfbeg(file=d:/snf/pdf/&pgm.part1.pdf);

%Tut_Sly
   (
    stop=23
    ,L6  ='^S={font_size=25pt just=c &w}Creating a Cost Report Relational Schema for'
    ,L8  ='^S={font_size=25pt just=c &w}Skilled Nursing Facilities| Home Health Agencies|'
    ,L9  ='^S={font_size=25pt just=c &w}Renal Facilities| Hospice| Health Clinics|'
    ,L10 ='^S={font_size=25pt just=c &w}Federal Qualified Health Centers| Community Health Centers|'
    ,L11 ='^S={font_size=25pt just=c &w}and Rural Health Centers.'
    ,L16 ='^S={font_size=18pt just=c &w}Jeff Chambers and Roger DeAngelis'
   );

%Tut_Sly
   (
    stop=19
    ,L13 ='^S={font_size=25pt just=c &w}Schema contains primarily financial data from worksheets~'
    ,L16 ='^S={font_size=25pt just=c &w}S200001| G000000| G200001| G200002'
    ,L17 ='^S={font_size=25pt just=c &w}S300001| S300002| S300003| S300004'
    ,L18 ='^S={font_size=25pt just=c &w}S300005| S400000| S700001| A700000'
    ,L19 ='^S={font_size=25pt just=c &w}A000000| C000000| E00A181 and O010000.'
   );

%Tut_Sly
   (
    stop=22
    ,L13 ='^S={font_size=25pt just=c &w}Agenda'
    ,L15 ='^S={font_size=25pt just=l &w}1. Example of key data in current CSV cost report Puf'
    ,L16 ='^S={font_size=25pt just=l &w}2. Example Cost Report Form for Cash on Hand'
    ,L17 ='^S={font_size=25pt just=l &w}3. Example excel mini puf with cash on hand'
    ,L18 ='^S={font_size=25pt just=l &w}4. Entity diagrams of full model and excel sub-model'
    ,L19 ='^S={font_size=25pt just=l &w}5. Normalized central fact table'
    ,L20 ='^S={font_size=25pt just=l &w}6. Simple flexible SAS code to produce any excel PUF'
    ,L21 ='^S={font_size=25pt just=l &w}7. Example excel PUF revisited'
    ,L22 ='^S={font_size=25pt just=l &w}8. QC using Optimizer output'
   );


%Tut_Sly
   (
    stop=15
    ,L15='^S={font_size=25pt just=c &w}Key Fields in Current CSV PUF'
   );

%Tut_Sly
   (
    stop=34
    ,L3 ='^S={font_size=17pt just=l &w   }Key Fields in Current CSV PUF'
    ,L5 ='^S={font_size=15pt just=l &b &c}rpt_rec_num   wksht_cd  line_num clmn_num  itm_txt'

   ,L7  ='^S={font_size=15pt just=l &b &c}1000236       A000000    00700    00100    51333  '
   ,L8  ='^S={font_size=15pt just=l &b &c}1000236       A000000    00700    00200    912648 '
   ,L9  ='^S={font_size=15pt just=l &b &c}1000236       A000000    00700    00300    963981 '
   ,L10 ='^S={font_size=15pt just=l &b &c}1000236       A000000    00700    00500    963981 '
   ,L11 ='^S={font_size=15pt just=l &b &c}1000236       A000000    00700    00700    963981 '
   ,L12 ='^S={font_size=15pt just=l &b &c}1000236       A000000    00800    00100    297027 '
   ,L13 ='^S={font_size=15pt just=l &b &c}1000236       A000000    00800    00200    2043281'
   ,L14 ='^S={font_size=15pt just=l &b &c}1000236       A000000    00800    00300    2340308'
   ,L15 ='^S={font_size=15pt just=l &b &c}1000236       A000000    00800    00500    2340308'
   ,L16 ='^S={font_size=15pt just=l &b &c}1000236       A000000    00800    00600    -1956  '
   ,L17 ='^S={font_size=15pt just=l &b &c}1000236       A000000    00800    00700    2338352'
   ,L18 ='^S={font_size=15pt just=l &b &c}1000236       A000000    00900    00100    229048 '
   );

%Tut_Sly
   (
    stop=15
    ,L15='^S={font_size=25pt just=c &w}Example Cost Report Form'
   );

%pdfend;

* example form;


%pdfbeg(file=d:/snf/pdf/&pgm.part2.pdf);

%Tut_Sly
   (
    stop=15
    ,L15='^S={font_size=25pt just=c &w}Example Excel PUF'
   );

%pdfend;

* example mini excel puf;


%pdfbeg(file=d:/snf/pdf/&pgm.part3.pdf);

%Tut_Sly
   (
    stop=16
    ,L15='^S={font_size=25pt just=c &w}Entity Diagrams for full Model'
    ,L16 ='^S={font_size=25pt just=c &w}and Excel PUF Sub-Model'
   );

%pdfend;

* full mode;
* submodel;




%pdfbeg(file=d:/snf/pdf/&pgm.part4.pdf);

%Tut_Sly
   (
    stop=16
    ,L15='^S={font_size=25pt just=c &w}For Expediency we will Examine the Fact Table'
    ,L16 ='^S={font_size=25pt just=c &w}and the Excel PUF Sub-Model'
   );


%Tut_Sly
   (
    stop=24
    ,L3 ='^S={font_size=17pt just=l &w   }SNF 2015 Table cel_cellvalue  Observations  1|0571|964'
    ,L6 ='^S={font_size=15pt just=l &b &c}         cel_ '
    ,L7 ='^S={font_size=15pt just=l &b &c}        report                                   cel_'
   ,L8  ='^S={font_size=15pt just=l &b &c}Obs      Key               cel_name             value'
   ,L10 ='^S={font_size=15pt just=l &b &c}---    -------------    ---------------------   ------'
   ,L11 ='^S={font_size=15pt just=l &b &c}  1    SNF15_1123184    A000000_00100_00300_N    662493'
   ,L12 ='^S={font_size=15pt just=l &b &c}  2    SNF15_1123184    A000000_00100_00400_N'
   ,L13 ='^S={font_size=15pt just=l &b &c}  3    SNF15_1123184    A000000_00100_00500_N    662493'
   ,L14 ='^S={font_size=15pt just=l &b &c}  4    SNF15_1123184    A000000_00100_00600_N    -1346'
   ,L15 ='^S={font_size=15pt just=l &b &c}  5    SNF15_1123184    A000000_00100_00700_N    661147'

   ,L17 ='^S={font_size=15pt just=l &w}To get Provider Number'
   ,L18 ='^S={font_size=15pt just=l &w}put(cel_reportKey|cel_reportKey2Ptvdr.)'
   ,L20 ='^S={font_size=15pt just=l &w}To get cell description for excel column header(max 255 chars)'
   ,L21 ='^S={font_size=15pt just=l &w}put(cell_name|$cel_name2des.)'
   ,L23 ='^S={font_size=15pt just=l &w}Pivot and send to excel'
   ,L24 ='^S={font_size=15pt just=l &w}ods excel uses the label for column names'
   );

%Tut_Sly
   (
    stop=16
    ,L15='^S={font_size=25pt just=c &w}Create a Example Excel PUF'
    ,L16 ='^S={font_size=25pt just=c &w}of Cash on Hand'
   );


%Tut_Sly
   (
    stop=34
    ,L3 ='^S={font_size=17pt just=l &w   }Code to Create Mini PUF'
    ,L5 ='^S={font_size=15pt just=l &b &c}proc sql'
    ,L6 ='^S={font_size=15pt just=l &b &c}  create'
   ,L7  ='^S={font_size=15pt just=l &b &c}     table mini as'
   ,L8  ='^S={font_size=15pt just=l &b &c}  select'
   ,L9  ='^S={font_size=15pt just=l &b &c}     cel_reportKey'
   ,L10 ='^S={font_size=15pt just=l &b &c}    |put(cel_reportKey|cel_reporKey2prvdr.) as Provider'
   ,L11 ='^S={font_size=15pt just=l &b &c}    |cel_name'
   ,L12 ='^S={font_size=15pt just=l &b &c}    |cel_value'
   ,L13 ='^S={font_size=15pt just=l &b &c}    |put(cel_name|$cel_name2des.) as excel_column_header'
   ,L14 ='^S={font_size=15pt just=l &b &c}  from'
   ,L15 ='^S={font_size=15pt just=l &b &c}     snf.cel_cellvalue'
   ,L16 ='^S={font_size=15pt just=l &b &c}  where'
   ,L17 ='^S={font_size=15pt just=l &b &c}     cel_namein(`G000000_00100_00100_N`|`G000000_00100_00200_N`|'
   ,L18 ='^S={font_size=15pt just=l &b &c}     `G000000_00100_00300_N`|`G000000_00100_00400_N`|`G000000_00100_00500_N`)'
   ,L19 ='^S={font_size=15pt just=l &b &c}  order'
   ,L20 ='^S={font_size=15pt just=l &b &c}     by cel_reportKey| provider| cel_name'
   ,L21 ='^S={font_size=15pt just=l &b &c}quit'
   ,L23 ='^S={font_size=15pt just=l &b &c}proc transpose data=mini out=miniXpo(drop=_name_)'
   ,L24 ='^S={font_size=15pt just=l &b &c} by cel_reportKey provider'
   ,L25 ='^S={font_size=15pt just=l &b &c} var cel_value'
   ,L26 ='^S={font_size=15pt just=l &b &c} id cel_name'
   ,L27 ='^S={font_size=15pt just=l &b &c} idlabel excel_column_header'
   ,L28 ='^S={font_size=15pt just=l &b &c}run'
   ,L39 ='^S={font_size=15pt just=l &b &c}ods excel file=`d:/snf/xls/&pgm.mini.xlsx` style=pearl'
   ,L31 ='^S={font_size=15pt just=l &b &c}proc report data=miniXpo nowd missing style(column)={just=right cellwidth=5in}  split=`@`'
   ,L32 ='^S={font_size=15pt just=l &b &c}run'
   ,L33 ='^S={font_size=15pt just=l &b &c}ods excel close'
   );

%pdfend;

* min puf;

%pdfbeg(file=d:/snf/pdf/&pgm.part5.pdf);
%Tut_Sly
   (
    stop=16
    ,L15='^S={font_size=25pt just=c &w}QC using Optimizer output'
    ,L16 ='^S={font_size=25pt just=c &w}of Cash on Hand'
   );

%pdfend;


* optimizer qc;

















proc sql;
  create
     table mini as
  select
     cel_reportKey
    ,input(put(cel_reportKey,7.),cel_reportKey2prvdr.) as Provider
    ,cel_name
    ,cel_value
    ,put(cel_name,$cel_name2des.) as excel_column_header
  from
     snf.cel_cellvalue
  where
     cel_name in ('G000000_00100_00100_N','G000000_00100_00200_N',
     'G000000_00100_00300_N','G000000_00100_00400_N','G000000_00100_00500_N')
  order
     by cel_reportKey, provider, cel_name;
;quit;

proc transpose data=mini out=miniXpo(drop=_name_);
 by cel_reportKey provider;
 var cel_value;
 id cel_name;
 idlabel excel_column_header;
run;quit;

ods excel file="d:/snf/xls/&pgm.mini.xlsx" style=pearl;
proc report data=miniXpo nowd missing style(column)={just=right cellwidth=5in}  split='@';
run;quit;
ods excel close;
















%utlfkil(d:/snf/xls/&pgm.mini.xlsx);
























  order                      ;;;;/*'*/ *);*};*];*/;/*"*/;%mend;run;quit;%end;end;run;endcomp;%utlfix;
     by cel_reportKey,







G000000_00100_00100_N   Assets Current_Assets Cash On Hand And In Banks General Fund          G000000_00100_00100_N
G000000_00100_00200_N   Assets Current_Assets Cash On Hand And In Banks Specific Purpose_Fund G000000_00100_00200_N
G000000_00100_00300_N   Assets Current_Assets Cash On Hand And In Banks Endowment Fund        G000000_00100_00300_N
G000000_00100_00400_N   Assets Current_Assets Cash On Hand And In Banks Plant Fund            G000000_00100_00400_N
G000000_00100_00500_N   Total Funds Current_Assets Cash On Hand And In Banks                  G000000_00100_00500_N




'G000000_00100_00100_N' ,'G000000_00100_00200_N' ,'G000000_00100_00300_N' ,
'G000000_00100_00400_N' ,'G000000_00100_00500_N'








































































proc format lib=snf.snffmt_a cntlout=out(keep=start label);
select $snffmt;
run;quit;



----------------------------------------------------------------------------
|                  INFORMAT NAME: @SNFRECPRVDR LENGTH: 12                  |
|   MIN LENGTH:   1  MAX LENGTH:  40  DEFAULT LENGTH:  12  FUZZ:        0  |
|--------------------------------------------------------------------------|
|START           |END             |INVALUE(VER. 9.4     23FEB2020:16:57:31)|
|----------------+----------------+----------------------------------------|
|         1089712|         1089712|                                  495134|
|         1091410|         1091410|                                   75417|
|         1093283|         1093283|                                  165252|
|         1095547|         1095547|                                  225497|
|         1095966|         1095966|                                  265161|
|         1095967|         1095967|                                  265239|
|         1098814|         1098814|                                  265322|
|         1099059|         1099059|                                  455936|
|         1100296|         1100296|                                  265428|
|         1100668|         1100668|                                  265538|
|         1101648|         1101648|                                  315517|
|         1101693|         1101693|                                  155734|
|         1102798|         1102798|                                  165257|
----------------------------------------------------------------------------





G000000_00100_00100_N   Assets Current_Assets Cash On Hand And In Banks General Fund          G000000_00100_00100_N
G000000_00100_00200_N   Assets Current_Assets Cash On Hand And In Banks Specific Purpose_Fund G000000_00100_00200_N
G000000_00100_00300_N   Assets Current_Assets Cash On Hand And In Banks Endowment Fund        G000000_00100_00300_N
G000000_00100_00400_N   Assets Current_Assets Cash On Hand And In Banks Plant Fund            G000000_00100_00400_N
G000000_00100_00500_N   Total Funds Current_Assets Cash On Hand And In Banks                  G000000_00100_00500_N














To get Prvider Number
put(cel_reportKey,cel_reportKey2Ptvdr.)
To get cell description for excel column header(max 255 chars)
put(cell_name,$cel_name2des.)
Pivot and send to excel






                                                                                                           To get Prvider Number

                                                                                                           put(cel_reportKey,cel_reportKey2Ptvdr.)

                                                                                                           To get cell description for excel column header(max 255 chars)

                                                                                                           put(cell_name,$cel_name2des.)

                                                                                                           Pivot and send to excel





































Just 2015 Skilled Nursing Facilities cetral fact table

Table cel_cellvalue  Observations  1,0571,964

Variables in Creation Order

#    Variable         Type    Len

1    cel_reportKey    Num      11
2    cel_name         Char     21
3    cel_value        Char     33


Alphabetic List of Indexes and Attributes

                                      # of
                          Unique    Unique
#    Index                Option    Values    Variables

1    cel_reportKey                  15,639
2    cel_reportNumName    YES   1,0571,964    cel_reportKey cel_name


Sorted by  cel_reportKey cel_name


Table cel_cellvalue  Observations  1,0571,964

          cel_
         report                                   cel_
 Obs      Key               cel_name             value

   1    SNF15_1123184    A000000_00100_00300_N    662493
   2    SNF15_1123184    A000000_00100_00400_N      
   3    SNF15_1123184    A000000_00100_00500_N    662493
   4    SNF15_1123184    A000000_00100_00600_N    -1346
   5    SNF15_1123184    A000000_00100_00700_N    661147


Lookups

    To get Prvider Number

    put(cel_reportKey,cel_reportKey2Ptvdr.)

    To get cell description for excel column header(max 255 chars)

    put(cell_name,$cel_name2des.)

    Pivot and send to excel




















%pdfend;

title "General Practice Beneficiaries by Year";
proc sgpanel data=phy.&pgm._facAll(where=(TOTAL_UNIQUE_BENES < 700));
label  TOTAL_DRUG_UNIQUE_BENES="Drug Beneficiaries";
label  TOTAL_UNIQUE_BENES     ="Total Beneficiaries";
panelby years / novarname sparse;
histogram TOTAL_DRUG_UNIQUE_BENES / fillattrs=graphdata1 transparency=0.5 ;
histogram TOTAL_UNIQUE_BENES /fillattrs=graphdata2 transparency=0.7;
run;quit;

%Tut_Sly
   (
    stop=16
    ,L13 ='^S={font_size=25pt just=c &w}Histograms of Transformed Drug and Total Beneficiaries'
    ,L16 ='^S={font_size=25pt just=c &w}ArcSine Transformation of Percentages'
   );

title1 "Percent of Drug Beneficiaries by Year";
title2 "ArcSine Sqare Root Transform of Percentage";
proc sgpanel data=phy.&pgm._tajInp;
label  drug_pct_of_total="Percent Drug Beneficiaries";
label  xpo_drug_pct_of_total="ArcSineSqrt Percent Drug Beneficiaries";
panelby year / novarname sparse;
histogram drug_pct_of_total      / fillattrs=graphdata1 transparency=0.5 ;
histogram xpo_drug_pct_of_total /fillattrs=graphdata2 transparency=0.7;
run;quit;

%Tut_Sly
   (
    stop=16
    ,L13 ='^S={font_size=25pt just=c &w}Mean Drug Beneficiary Percentage by Trajectory'
    ,L16 ='^S={font_size=25pt just=c &w}In originaly Percentage Units'
   );

title1 "Meand of Trajectories of Percent Drug Beneficiaries";
title2 "Low and High Trajectories";
title3 "Raw un-transformed Percentages";
proc sgplot data=phy.&pgm._facRen noautolegend /* tmplout='d:/phy/txt/&pgm._sghst.txt' */;
histogram avg_pct / fillattrs=graphdata1 transparency=0.7  binwidth=3 ;
density avg_pct / lineattrs=graphdata1;
histogram _avg_pct / fillattrs=graphdata2 transparency=0.5  binwidth=3 ;
density _avg_pct / lineattrs=graphdata2;
keylegend " " " " / title=" " noborder;
xaxis grid label="Percent Drug Beneficiaries";
run;quit;

%Tut_Sly
   (
    stop=16
    ,L13 ='^S={font_size=25pt just=c &w}Mean Drug Beneficiary Percentage by Trajectory'
    ,L16 ='^S={font_size=25pt just=c &w}ArcSine Transformation of Units'
   );

title1 "Mean of Trajectories of Percent Drug Beneficiaries";
title2 "Low and High Trajectories";
title3 "ArcSin Transformed Percentages";
proc sgplot data=phy.&pgm._facRen noautolegend /* tmplout='d:/phy/txt/&pgm._sghst.txt' */;
histogram xpo_avg_pct / fillattrs=graphdata1 transparency=0.7  binwidth=.05;
density xpo_avg_pct / lineattrs=graphdata1;
histogram _xpo_avg_pct / fillattrs=graphdata2 transparency=0.5 binwidth=.05;
density _xpo_avg_pct / lineattrs=graphdata2;
keylegend " " " " / title=" " noborder;
xaxis grid label="Percent Drug Beneficiaries";
run;quit;


proc sgplot data=phy.&pgm._nrmgFix(where=(_name_=:'PRED'));
format col1 percent5.2;
title1 "Drug Payments as a Percentage of Allowed Amounts";
label year="Year";
label col1="Percent of Drug Beneficiaries";
series x=year y=col1 / group=des lineattrs=(pattern=solid thickness=1pt color=black)  smoothconnect
datalabel=col1 datalabelattrs=(size=12);
xaxis values=(2012 to 2015 by 1) grid;
yaxis values=(.10 to .60 by .10) grid;
inset "High Percentage of Drug Beneficiaries" / position=BottomLeft;
inset "Low Percentage of Drug Beneficiaries" / position=TopLeft;
keylegend "Close to Allowed Amount" "Close to Allowed Amount" / title="" noborder across=2;
run;quit;

title;
footnote;
proc report data=prerpt(where=(odr ne '060')) nowd split='#' missing style(header)={font_weight=bold};
   cols (
   "^S={outputwidth=100% just=c font_size=15pt font_face=arial}
    Trajectories of Percent Drug Beneficiaries  ^{newline}
    High and Low Percentages  ^{newline}^{newline}
    The High Trajectory Claims were 53.9% of Alowed Amount ^{newline}
    The Low Trajectory Claims were 21.6% of Alowed Amount ^{newline} ^{newline}"
     mjr mnr _1 _2 _3);
    define mjr   / order    noprint order=data;
    define mnr   / display  ""                                         style={cellwidth=20%  just=l } order=data;
    define _1    / display  "Low Percentages#Trajectory#N(%)#&_1.##"   style={cellwidth=26%  just=r } order=data;
    define _2    / display  "High Percentages#N(%)#&_2.##"             style={cellwidth=26%  just=r } order=data;
    define _3    / display  "Total#N(%)#&_3.##"                        style={cellwidth=26%  just=r } order=data;
    compute before mjr / style=[just=l];
      line mjr $96.;
    endcomp;
run;quit;
ods pdf text="^S={font_size=10pt} ^{newline}    ";
ods pdf text="^S={outputwidth=100% just=l font_size=10pt font_style=italic}  Program: c:/utl/&pgm..sas";
ods pdf text="^S={outputwidth=100% just=l font_size=10pt font_style=italic}  Log: d:/phy/log/&pgm..log";
ods pdf text="^S={outputwidth=100% just=l font_size=10pt font_style=italic}  &sysdata &systime";
run;quit;
%pdfend;

*               _
  ___ _ __   __| |
 / _ \ '_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

;

*    _      _        _ _
  __| | ___| |_ __ _(_) |
 / _` |/ _ \ __/ _` | | |
| (_| |  __/ || (_| | | |
 \__,_|\___|\__\__,_|_|_|

;
%macro phy_years(yr);

libname phy "d:/phy";

data phy.phy_100&yr.(compress=yes);
      LENGTH
            npi                                  $10
            nppes_provider_last_org_name         $70
            nppes_provider_first_name            $20
            nppes_provider_mi                    $1
            nppes_credentials                    $20
            nppes_provider_gender                $1
            nppes_entity_code                    $1
            nppes_provider_street1               $55
            nppes_provider_street2               $55
            nppes_provider_city                  $40
            nppes_provider_zip                   $20
            nppes_provider_state                 $2
            nppes_provider_country               $2
            provider_type                        $43
            medicare_participation_indicator     $1
            place_of_service                     $1
            hcpcs_code                           $5
            hcpcs_description                    $256
            hcpcs_drug_indicator                 $1
            line_srvc_cnt                        8
            bene_unique_cnt                      8
            bene_day_srvc_cnt                    8
            average_Medicare_allowed_amt         8
            average_submitted_chrg_amt           8
            average_Medicare_payment_amt         8
            average_Medicare_standard_amt        8;
      INFILE "d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY201&yr..TXT"

            lrecl=32767
            dlm='09'x
            pad missover
            firstobs = 3
            dsd;

      INPUT
            npi
            nppes_provider_last_org_name
            nppes_provider_first_name
            nppes_provider_mi
            nppes_credentials
            nppes_provider_gender
            nppes_entity_code
            nppes_provider_street1
            nppes_provider_street2
            nppes_provider_city
            nppes_provider_zip
            nppes_provider_state
            nppes_provider_country
            provider_type
            medicare_participation_indicator
            place_of_service
            hcpcs_code
            hcpcs_description
            hcpcs_drug_indicator
            line_srvc_cnt
            bene_unique_cnt
            bene_day_srvc_cnt
            average_Medicare_allowed_amt
            average_submitted_chrg_amt
            average_Medicare_payment_amt
            average_Medicare_standard_amt;

      LABEL
            npi                                 = "National Provider Identifier"
            nppes_provider_last_org_name        = "Last Name/Organization Name of the Provider"
            nppes_provider_first_name           = "First Name of the Provider"
            nppes_provider_mi                   = "Middle Initial of the Provider"
            nppes_credentials                   = "Credentials of the Provider"
            nppes_provider_gender               = "Gender of the Provider"
            nppes_entity_code                   = "Entity Type of the Provider"
            nppes_provider_street1              = "Street Address 1 of the Provider"
            nppes_provider_street2              = "Street Address 2 of the Provider"
            nppes_provider_city                 = "City of the Provider"
            nppes_provider_zip                  = "Zip Code of the Provider"
            nppes_provider_state                = "State Code of the Provider"
            nppes_provider_country              = "Country Code of the Provider"
            provider_type                       = "Provider Type of the Provider"
            medicare_participation_indicator    = "Medicare Participation Indicator"
            place_of_service                    = "Place of Service"
            hcpcs_code                          = "HCPCS Code"
            hcpcs_description                   = "HCPCS Description"
            hcpcs_drug_indicator                = "Identifies HCPCS As Drug Included in the ASP Drug List"
            line_srvc_cnt                       = "Number of Services"
            bene_unique_cnt                     = "Number of Medicare Beneficiaries"
            bene_day_srvc_cnt                   = "Number of Distinct Medicare Beneficiary/Per Day Services"
            average_Medicare_allowed_amt        = "Average Medicare Allowed Amount"
            average_submitted_chrg_amt          = "Average Submitted Charge Amount"
            average_Medicare_payment_amt        = "Average Medicare Payment Amount"
            average_Medicare_standard_amt       = "Average Medicare Standardized Payment Amount";
RUN;

%mend phy_years;

%phy_years(2);
%phy_years(3);
%phy_years(4);
%phy_years(5);

data &pgm._allfor/view=&pgm._allfor;
  retain yr " ";
  set
    phy.phy_1002(in=a)
    phy.phy_1003(in=b)
    phy.phy_1004(in=c)
    phy.phy_1005(in=d)
;
  select;
    when (a)  yr='2';
    when (b)  yr='3';
    when (c)  yr='4';
    when (d)  yr='5';
    otherwise;
 end;

run;quit;

* code decode for lookup;
proc sql;
  create
     table phy.&pgm._cdeDec as
  select
     max(hcpcs_code) as hcpcs_code
    ,max(hcpcs_description) as hcpcs_description
 from
     &pgm._allfor
 group
     by hcpcs_code;
;quit;

/*
Up to 40 obs PHY.PHY_110HPCS_CDEDEC total obs=7,028

  HCPCS_
   CODE     HCPCS_DESCRIPTION

  00100     Anesthesia for procedure on salivary gland with biopsy
  00102     Anesthesia for procedure to repair lip defect present at birth
  00103     Anesthesia for procedure on eyelid
  00104     Anesthesia for electric shock treatment
  00120     Anesthesia for biopsy of external middle and inner ear
  00126     Anesthesia for incision of ear drum
*/


* code decode for lookup provider type;
proc sql;
  *reset inobs=10000;
  create
    table phy.&pgm._typ as
  select
    put(monotonic(),z2.) as type_code
   ,provider_type
  from
   (
    select
       max(provider_type) as provider_type
    from
       &pgm._allfor
    group
      by provider_type
   );
;quit;

proc freq data=phy.&pgm._typ noprint;
tables type_code*provider_type / out=&pgm._typfrq;
run;quit;

/*
TYPE_
CODE     PROVIDER_TYPE

 01      Addiction Medicine
 02      All Other Suppliers
 03      Allergy/Immunology
 04      Ambulance Service Supplier
 05      Ambulatory Surgical Center
 06      Anesthesiologist Assistants
 07      Anesthesiology
 08      Audiologist (billing independently)
 09      CRNA
 10      Cardiac Electrophysiology
 11      Cardiac Surgery
 12      Cardiology
 13      Centralized Flu
 14      Certified Clinical Nurse Specialist
 15      Certified Nurse Midwife
 16      Chiropractic
 17      Clinical Laboratory
 18      Clinical Psychologist
 19      Colorectal Surgery (formerly proctology)
 20      Critical Care (Intensivists)
 21      Dermatology
 22      Diagnostic Radiology
 23      Emergency Medicine
 24      Endocrinology
 25      Family Practice
 26      Gastroenterology
 27      General Practice
 28      General Surgery
 29      Geriatric Medicine
 30      Geriatric Psychiatry
 31      Gynecological/Oncology
 32      Hand Surgery
 33      Hematology
 34      Hematology/Oncology
 35      Hospice and Palliative Care
 36      Independent Diagnostic Testing Facility
 37      Infectious Disease
 38      Internal Medicine
 39      Interventional Cardiology
 40      Interventional Pain Management
 41      Interventional Radiology
 42      Licensed Clinical Social Worker
 43      Mammographic Screening Center
 44      Mass Immunization Roster Biller
 45      Maxillofacial Surgery
 46      Medical Oncology
 47      Multispecialty Clinic/Group Practice
 48      Nephrology
 49      Neurology
 50      Neuropsychiatry
 51      Neurosurgery
 52      Nuclear Medicine
 53      Nurse Practitioner
 54      Obstetrics/Gynecology
 55      Occupational therapist
 56      Ophthalmology
 57      Optometry
 58      Oral Surgery (dentists only)
 59      Orthopedic Surgery
 60      Osteopathic Manipulative Medicine
 61      Otolaryngology
 62      Pain Management
 63      Pathology
 64      Pediatric Medicine
 65      Peripheral Vascular Disease
 66      Pharmacy
 67      Physical Medicine and Rehabilitation
 68      Physical Therapist
 69      Physician Assistant
 70      Plastic and Reconstructive Surgery
 71      Podiatry
 72      Portable X-ray
 73      Preventive Medicine
 74      Psychiatry
 75      Psychologist (billing independently)
 76      Public Health Welfare Agency
 77      Pulmonary Disease
 78      Radiation Oncology
 79      Radiation Therapy
 80      Registered Dietician/Nutrition Professional
 81      Rheumatology
 82      Sleep Medicine
 83      Slide Preparation Facility
 84      Speech Language Pathologist
 85      Sports Medicine
 86      Surgical Oncology
 87      Thoracic Surgery
 88      Unknown Physician Specialty Code
 89      Unknown Supplier/Provider
 90      Urology
 91      Vascular Surgery


Addiction Medicine
Pain Management
Interventional Pain Management

Orthopedic Surgery
Osteopathic Manipulative Medicine
Public Health Welfare Agency
Licensed Clinical Social Worker
Ambulatory Surgical Center
Maxillofacial Surgery
Hand Surgery
Neurosurgery
Plastic and Reconstructive Surgery
Sports Medicine
Thoracic Surgery
General Surgery
Colorectal Surgery (formerly proctology)
*/

* reduce types;
data &pgm._typten surg;
 set &pgm._typfrq;

if index(upcase(provider_type),'SURG') then output surg;
run;quit;

data &pgm._fmt;
  retain fmtname "$&pgm._ptype2code" ;
  set phy.&pgm._typ;
  start=provider_type;
  end=start;
  label=type_code;
run;quit;

options fmtsearch=(phy.formats work.formats);
proc format cntlin=&pgm._fmt lib=phy.phy_formats;
run;quit;

data phy.&pgm._cut;
    length zip $5.;
    set
      &pgm._allfor;
    array avgs[*] average_:;
    zip=substr(nppes_provider_zip,1,5);
    do i=1 to dim(avgs);
       avgs[i]=round(100*avgs[i],1);
    end;
    provider_type_code=put(provider_type,$ptype.);

    nppes_credentials = compbl(upcase(compress(nppes_credentials,',.)(&/')));

    keep
      yr
      average_medicare_payment_amt
      bene_day_srvc_cnt
      bene_unique_cnt
      hcpcs_code
      hcpcs_drug_indicator
      line_srvc_cnt
      medicare_participation_indicator
      npi
      nppes_entity_code
      nppes_provider_country
      nppes_provider_gender
      nppes_provider_state
      place_of_service
      provider_type_code
      nppes_credentials
      zip
    ;
run;quit;

*                    _                  _       _
 _ __ ___   __ _ ___| |_ ___ _ __    __| | __ _| |_ __ _
| '_ ` _ \ / _` / __| __/ _ \ '__|  / _` |/ _` | __/ _` |
| | | | | | (_| \__ \ ||  __/ |    | (_| | (_| | || (_| |
|_| |_| |_|\__,_|___/\__\___|_|     \__,_|\__,_|\__\__,_|

;

*** need to fix **;
proc sql;
  create
    table phy.&pgm._manual as
  select
    l.*
   ,average_medicare_payment_amt ***bene_unique_cnt change to line_srvc_cnt*** as payment
   ,case (r.edd_professions)
      when ('NO')  then 'UNK'
      else edd_professions
   end as edd_professions
  from
    phy.&pgm._cut as l left join phy.&pgm._edddoc as r   /* eddDoc on end */
  on
   l.nppes_credentials eq r.edd_sufix
;quit;



proc sql;
  create
    table phy.&pgm._taj010 as
  select
     npi
    ,yr
    ,average_medicare_payment_amt * line_srvc_cnt as payment
    ,case
       when ( edd_professions in ('MD','DO')) then 1
       else 0
     end as md_pa
    ,case (nppes_provider_gender)
       when ('M') then 0
       else 1
     end as gender
  from
     phy.&pgm._manual
  where
     provider_type_code='27' and edd_professions in ('MD','DO','NP','PA')
  order
     by npi, md_pa, gender, yr;
;quit;

proc summary data=phy.&pgm._taj010 nway;
class npi gender md_pa yr;
var payment;
output out=phy.&pgm._tajsum sum=;
run;quit;

proc transpose data=phy.&pgm._tajsum out=&pgm._tajSumXpo(drop=_name_);
by npi gender md_pa;
id yr;
var payment;
run;quit;

data &pgm._tajAddTym;
 retain t1-t4 .;
 set &pgm._tajSumXpo;
 array tym[4] t1 t2 t3 t4 (1,2,3,4);
 array pays[4] _1 _2 _3 _4;
   do idx=1 to dim(pays);
     if pays[idx] le 1 then pays[idx]=1;
     pays[idx]=log(pays[idx]);
  end;
run;quit;

proc traj data=&pgm._tajAddTym
       out = want_of
   outplot = want_op
   outstat = want_os ci95M;
  id npi;
  var _2-_5 ;
  indep t1-t4;
  risk md_pa gender;
  order 1 1;
  model zip;
run;quit;


options ls=64 ps=44;
proc plot data=WANT_OP;
format t 2.;
plot  (pred1-pred2)*t='*' / overlay haxis=24 to 1 by -1 ;
run;quit;




SAS Forum: Sort columns independently



/* T1003070

%let pgm=utl_sorting_columns_of_a_table_in_place;

SAS Forum Sorting columns of a table in place

WPS/R or IML/R ( a one liner - slot machine example)

winner<-apply(slots,2,sort);

github
https://tinyurl.com/y8f32me3
https://github.com/rogerjdeangelis/Sorting-columns-of-a-table-in-place-in-a-SAS-dataset

inspired by

https://tinyurl.com/ybqzyvok
https://communities.sas.com/t5/SAS-Enterprise-Guide/Sort-columns-independently/m-p/451265

and
https://goo.gl/UTP3LD
http://stackoverflow.com/questions/42834439/r-sort-one-column-ascending-all-others-descending-based-on-column-order

slot machine probability? (1/n*1/n*1/n)

Not so easy in SQL or datastep(hash - I don't see it?)

IML and especially R often force programmers to think
non sequentially.

HAVE ( Casino Slot machine )
============================

Up to 40 obs WORK.TRECOL total obs=10

No slot machine winners

Obs   SPIN    COL1    COL2    COL3

  1      1      5       3       0
  2      2      3       3       1
  3      3      0       3       5
  4      4      3       4       0
  5      5      3       0       5
  6      6      1       1       2
  7      7      5       3       2
  8      8      5       0       3
  9      9      4       2       2
 10     10      0       4       1

WANT Lets sort each column in place)
====================================

     SPIN COL1 COL2 COL3
 [1,]   1    0    0    1
 [2,]   2    0    0    1
 [3,]   3    1    1    1
 [4,]   4    2    1    2
 [5,]   5    3    2    3
 [6,]   6    3    2    3
 [7,]   7    3    3    3  WINNER
 [8,]   8    5    4    4
 [9,]   9    5    5    4
[10,]  10    5    5    5  WINNER


WORKING CODE  (a one liner)
===========================

      winner<-apply(slots,2,sort);

FULL SOLUTION
=============

ods listing;
data "d:/sd1/slots.sas7bdat";
 do spin=1 to 10;
   col1=int(6*uniform(-1));
   col2=int(6*uniform(-1));
   col3=int(6*uniform(-1));
   output;
 end;
run;

* Roll those slots;
%utl_submit_wps64('
  source("c:/Program Files/R/R-3.3.2/etc/Rprofile.site",echo=T);
  library(haven);
  slots=as.matrix(read_sas("d:/sd1/slots.sas7bdat"));
  winner<-apply(slots,2,sort);
  winner;
');

> library(haven); slots=as.matrix(read_sas('d:/sd1/slots.sas7bdat'));
  winner<-apply(slots,2,sort); winner;

      CID COL1 COL2 COL3
 [1,]   1    1    0    0
 [2,]   2    1    0    0
 [3,]   3    1    1    1
 [4,]   4    2    2    1
 [5,]   5    2    3    1
 [6,]   6    2    3    3
 [7,]   7    3    3    4

 [8,]   8    4    4    4  Winner

 [9,]   9    4    5    4


[10,]  10    5    5    5 Winner
>

%utl_submit_wps64('
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk sas7bdat "%sysfunc(pathname(work))";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(haven);
slots=as.matrix(read_sas("d:/sd1/slots.sas7bdat"));
winner<-apply(slots,2,sort);
winner;
endsubmit;
import r=winner data=wrk.winner;
run;quit;
');


wor.winner total obs=10

Obs    V1    V2    V3    V4

  1     1     0     0     0
  2     2     0     0     0
  3     3     0     0     0
  4     4     0     0     0
  5     5     1     0     1
  6     6     1     1     1
  7     7     1     1     1
  8     8     3     1     2
  9     9     4     2     3
 10    10     4     4     5














proc freq data=phy.&pgm._manual order=freq;
tables edd_professions/missing out=&pgm._cuttyp;
run;quit;

%utl_optlen(inp=phy.&pgm._manual,out=phy.&pgm._manual);

/*
                                            Cumulative    Cumulative
EDD_PROFESSIONS    Frequency     Percent     Frequency      Percent
--------------------------------------------------------------------
MD                 26906396       81.50      26906396        81.50
DO                  2198358        6.66      29104754        88.15
NP                  1046036        3.17      30150790        91.32
PA                   966887        2.93      31117677        94.25
DPM                  736669        2.23      31854346        96.48
OD                   562918        1.70      32417264        98.19
NURSE                545288        1.65      32962552        99.84
MBBS                  23694        0.07      32986246        99.91
UNK                   14484        0.04      33000730        99.95
DENTIST               14001        0.04      33014731       100.00
PHARMACIST             1016        0.00      33015747       100.00
*/

/*
01  Addiction Medicine
62  Pain Management
40  Interventional Pain Management
*/

* all providers;
proc sql;
  create
    table &pgm._npisql as
  select
     yr
    ,count(cntnpi) as providers
  from
    (
     select
        yr
       ,max(npi) as cntnpi
     from
       phy.&pgm._manual
     where
       edd_professions in ('MD','DO')
     group
       by yr, npi
    )
  group
    by yr
;quit;


/* all providers

37 255 346

MD and Do

Obs    YR    PROVIDERS

 1     2       529590
 2     3       537825
 3     4       544272
 4     5       550273



YR    PROVIDERS

2       880644
3       909605
4       938146
5       968417
*/

*            _
 _ __   __ _(_)_ __
| '_ \ / _` | | '_ \
| |_) | (_| | | | | |
| .__/ \__,_|_|_| |_|
|_|
;


* pain providers;
proc sql;
  create
    table &pgm._npipyn as
  select
     yr
    ,count(cntnpi) as providers
  from
    (
     select
        yr
       ,max(npi) as cntnpi
     from
       phy.&pgm._manual
     where
       provider_type_code in ('01','40','62')
     group
       by yr, npi
    )
  group
    by yr
;quit;


/* pain PROVIDERS
Obs    YR    PROVIDERS

 1     2        3101
 2     3        3318
 3     4        3515
 4     5        3678
*/

/*
Trend in providers of 'Addiction Medicine' 2012-2015

I downloaded the provider pufs and took a look at

d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY2012.TXT
d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY2013.TXT
d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY2014.TXT
d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY2015.TXT


Have to have credentials

data phy._difpyn;
 input year pain_npi benes all_nps;
  dif_pain_npi=dif(pain_npi)/pain_npi;
  dif_benes=dif(benes)/benes;
  dif_all_nps=dif(all_nps)/all_nps;
cards4;
2012  57464     3962741    683814
2013  63322     4576238    705154
2014  67717     5263482    723522
2015  69218     5374294    742851
;;;;
run;quit;

proc summary data=phy.&pgm._manual(where=(provider_type_code in ('01','40','62'))) n;
class yr;
var bene_unique_cnt;
output out=&pgm._pynbne sum=;
run;quit;

/*

    PAIN
    BENE_
   UNIQUE_
     CNT

   4041475
   4672408
   5382180
   5508845
*/

proc summary data=phy.&pgm._manual;
class yr;
var bene_unique_cnt;
output out=&pgm._allbne sum=;
run;quit;

/*
    BENE_
 UNIQUE_CNT

  834770973
  842761312
  848335652
  862558384
*/

data phy._difpyn;
 retain spc1 spc2 spc3  " ";
 input year npiPyn npiAll srvPyn srvAll;
  difnpiPyn = 100*dif(npiPyn)/npiPyn;
  difnpiAll = 100*dif(npiAll)/npiAll;
  difsrvPyn = 100*dif(srvPyn)/srvPyn;
  difsrvAll = 100*dif(srvAll)/srvAll;
cards4;
2012 3101 880644  4041475  834770973
2013 3318 909605  4672408  842761312
2014 3515 938146  5382180  848335652
2015 3678 968417  5508845  862558384
;;;;
run;quit;

%include "c:/oto/utl_rtflan100.sas";
%utl_rtflan100;

title;
footnote;

options orientation=landscape;
ods rtf file="d:/phy/rtf/&pgm._pynDif.rtf" style=utl_rtflan100;
ods escapechar='^';
ods rtf prepage="^S={outputwidth=100% just=l font_size=11pt font_face=arial}
  {Pain Management Providers} ^R/RTF'\line' ^R/RTF'\line'      1. Addiction Medicine ^R/RTF'\line'      2. Pain Management
  ^R/RTF'\line'      3. Interventional Pain Management ";
proc report data=phy._difpyn nowd missing split='#';
cols year
   ( "Counts"
    ("Providers(NPI)" npipyn npiall )
    ("Services"       srvpyn srvall )
   ) spc1
   ("Percent Change"
    ("NPI"      difnpipyn difnpiall )
    ("Services" difsrvpyn difsrvall )
   );
define YEAR     / display          style(column)={just=c cellwidth=7%};
define NPIPYN   / display "Pain" format=comma15.  style(column)={just=c cellwidth=10%};
define NPIALL   / display "All"  format=comma15.  style(column)={just=c cellwidth=10%};
define SRVPYN   / display "Pain" format=comma15.  style(column)={just=c cellwidth=12%};
define SRVALL   / display "All"  format=comma15.  style(column)={just=c cellwidth=12%};
define spc1     / display ""  style(column)={just=c cellwidth=3%};
define DIFNPIPYN/ display "Pain" format=comma5.1  style(column)={just=c cellwidth= 9%};
define DIFNPIALL/ display "All"  format=comma5.1  style(column)={just=c cellwidth= 9%};
define DIFSRVPYN/ display "Pain" format=comma5.1  style(column)={just=c cellwidth= 9%};
define DIFSRVALL/ display "All"  format=comma5.1  style(column)={just=c cellwidth= 9%};
run;quit;
ods rtf text="^S={outputwidth=100% just=r font_size=9pt} Page 1 of 1";
ods rtf text="^S={outputwidth=100% just=l font_size=8pt font_style=italic}  {SOURCES:^R/RTF'\line'  }";
ods rtf text="^S={outputwidth=100% just=l font_size=8pt font_style=italic}  {    d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY2012.TXT}";
ods rtf text="^S={outputwidth=100% just=l font_size=8pt font_style=italic}  {    d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY2013.TXT}";
ods rtf text="^S={outputwidth=100% just=l font_size=8pt font_style=italic}  {    d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY2014.TXT}";
ods rtf text="^S={outputwidth=100% just=l font_size=8pt font_style=italic}  {    d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY2015.TXT}";
ods rtf close;

*                 __               _
 _ __  _ __ ___  / _| ___  ___ ___(_) ___  _ __
| '_ \| '__/ _ \| |_ / _ \/ __/ __| |/ _ \| '_ \
| |_) | | | (_) |  _|  __/\__ \__ \ | (_) | | | |
| .__/|_|  \___/|_|  \___||___/___/_|\___/|_| |_|
|_|
;

Data phy.&pgm._edddoc(
     /*index=(edd_sufix/unique*/
     label="Sudeshna editited professions");
retain key;
length
  edd_hier
  edd_professions
  edd_flg
  edd_sufix
          $64;
input;
key=put(200000+_n_+3,z6.);
edd_hier        =upcase(scan(_infile_,1,' '));
edd_professions= upcase(scan(_infile_,2,' '));
edd_flg        = upcase(scan(_infile_,3,' '));
edd_sufix      = catx(' ',scan(_infile_,4,' '),scan(_infile_,5,' '));
if edd_sufix='' then put (_all_) (= $ /) //;

/*
edd_professions=tranwrd(edd_professions,'???','?');
edd_professions=tranwrd(edd_professions,'??' ,'?');
*/
cards4;
1      MD      yes      MD SR
1      MD      yes      MD
1      MD      yes      MDCM
1      MD      yes      FHM MPH
1      MD      yes      FACS
1      MD      yes      PC FACP
1      MD      yes      PC FACS
1      MD      yes      FAAFP
1      MD      yes      FAAP FACS
1      MD      yes      FAAP MS
1      MD      yes      FACP MS
1      MD      yes      FACP PHD
1      MD      yes      PC FAAP
1      MD      yes      FAAFP MPH
1      MD      yes      FAAFP MSPH
1      MD      yes      FAAFP PHD
1      MD      yes      FAAP MPH
1      MD      yes      FACC
1      MD      yes      FACC FACP
1      MD      yes      FACC MA
1      MD      yes      FACC MBA
1      MD      yes      FACC MSC
1      MD      yes      FACP
1      MD      yes      FACP DDS
1      MD      yes      FACP DMD
1      MD      yes      FACP JD
1      MD      yes      FACP MA
1      MD      yes      FACP MSD
1      MD      yes      FACS MBA
1      MD      yes      FACS MPH
1      MD      yes      FACS MS
1      MD      yes      FACS PA
1      MD      yes      FACS PC
1      MD      yes      MPH FAAP
1      MD      yes      FHM FAAP
1      MD      yes      FHM FACP
1      MD      yes      PHD MD
1      MD      yes      MPH MD
1      MD      yes      PC MD
1      MD      yes      PA MD
1      MD      yes      MD DDS
1      MD      yes      MDPHD
1      MBBS      yes      MBBS
1      MD      yes      MD DMD
1      MD      yes      DR
1      MD      yes      MS MD
1      MD      yes      FACS MD
1      MD      yes      DDS MD
1      MD      yes      MBA MD
1      MD      yes      MDMPH
1      MD      yes      FACP MD
1      MD      yes      MBBS MD
1      MD      yes      LTD MD
1      MD      yes      DDSMD
1      MD      yes      FACC MD
1      MD      yes      MD MBBS
1      MD      yes      MSC MD
1      MD      yes      LLC MD
1      MD      yes      MD-PHD
1      MD      yes      DMDMD
1      MD      yes      DOCTOR
1      MD      yes      PLLC MD
1      MD      yes      FAAP MD
1      MD      yes      MD MD
1      MD      yes      CM MD
1      MD      yes      MSPH MD
1      MD      yes      MD DO
1      MD      yes      JD MD
1      MD      yes      MDPC
1      MD      yes      MD MA
1      MD      yes      MDMBA
1      MD      yes      MHS MD
1      MD      yes      PS MD
1      MD      yes      DO MD
1      MD      yes      MA MD
1      MD      yes      MD MS
1      MD      yes      PSC MD
1      MD      yes      MD BA
1      MD      yes      MD MI
1      MD      yes      MED MD
1      MD      yes      MD DR
1      MD      yes      MD DVM
1      MD      yes      MD KY
1      MD      yes      FAAFP MD
1      MD      yes      MDFACS
1      MD      yes      MD BS
1      MD      yes      APC MD
1      MD      yes      PHARMD MD
1      MD      yes      MBBSMD
1      MD      yes      MD MPH
1      MD      yes      MDFACP
1      MD      yes      MDMBBS
1      MD      yes      MHA MD
1      MD      yes      MPP MD
1      MD      yes      APMC MD
1      MBBS      yes      MPH MBBS
1      MD      yes      FACS PHD
1      MD      yes      DVM MD
1      MD      yes      MD DS
1      MD      yes      MD FORBES
1      MD      yes      MD PA
1      MD      yes      MDDMD
1      MD      yes      MDJD
1      MD      yes      MDMD
1      MBBS      yes      PHD MBBS
1      MD      yes      FACP MPH
1      MD      yes      JDMD
1      MD      yes      MBCHB MD
1      MD      yes      MD CS
1      MD      yes      MD DPM
1      MD      yes      MD MP
1      MD      yes      MD PECK
1      MD      yes      MD PS
1      MD      yes      MDFCCP
1      MD      yes      MDINC
1      MD      yes      RPH MD
1      MD      yes      DR MD
1      MD      yes      ND MD
1      MD      yes      DPM MD
1      MD      yes      MBBCH MD
1      MD      yes      MD JD
1      MD      yes      MD LR
1      MD      yes      MD MF
1      MD      yes      MD PHUOC
1      MD      yes      MICHAELMD
1      MD      yes      MMSC MD
1      MD      yes      MPA MD
1      MD      yes      BS MD
1      MD      yes      MD CM
1      MD      yes      MD FM
1      MD      yes      MD LD
1      MD      yes      MD MBBCH
1      MD      yes      MD MBCHB
1      MD      yes      MD PC
1      MD      yes      MDDO
1      MD      yes      MDFAAFP
1      MD      yes      MDFACC
1      MD      yes      MDFACEP
1      MD      yes      MDLLC
1      MD      yes      MDMHS
1      MD      yes      MDPM
1      MD      yes      MFA MD
1      MD      yes      MHSA MD
1      MD      yes      MSCI MD
1      MD      yes      MSHP MD
1      MD      yes      SR MD
1      MD      yes      PROF MD
1      MD      yes      RDMS MD
1      NP      yes      MSN PMHNP-BC
1      MD      yes      PHDMD
1      MD      yes      PHYSICIAN
1      MD      yes      CMD MD
1      MD      yes      DVMMD
1      MD      yes      MBE MD
1      MD      yes      MDPHDMBA
1      MD      yes      MHSC MD
1      MD      yes      MSCR MD
1      MD      yes      MSCS MD
1      MD      yes      -MD
1      MD      yes      11MD
1      MD      yes      MD LK
1      MD      yes      MD ND
1      MD      yes      MD RN
1      MD      yes      MD RPH
1      MD      yes      MD111
1      MD      yes      MDFRCA
1      MD      yes      MDFRCS
1      MD      yes      MDIV MD
1      MD      yes      PLC MD
1      MBBS      yes      MHA MBBS
1      UNK      yes      LLC FACP
1*      MD      yes      MSHS MD
1      MD      yes      JOYCEMD
1      MD      yes      JRDMD
1      MD      yes      OD MD
1      MD      yes      PA-C MD
1      MD      yes      RNC MD
1      MD      yes      HMD MD
1      MD      yes      MBA MBBSMD
1      MD      yes      MD DM
1      MD      yes      MD DOCTOR
1      MD      yes      MD JDMD
1      MD      yes      MD MASTERS
1      MD      yes      MD MDH
1      MD      yes      MD MN
1      MD      yes      MD MSD
1      MD      yes      MD MSN
1      MD      yes      MD NP
1      MD      yes      MD PHARMD
1      MD      yes      MD VMD
1      MD      yes      MDCM MS
1      MD      yes      MDH MD
1      MD      yes      MDPHD LR
1      MD      yes      MED DR
1      MD      yes      MMS MD
1      MBBS      yes      MA MBBS
1      MBBS      yes      MBBS BS
1      MBBS      yes      MBBS MA
1      MBBS      yes      MHS MBBS
1      MBBS      yes      MSC MBBS
1      UNK      yes      CMD FACP
1      MD      yes      CPE MD
1      MD      yes      MPAS MD
1      MD      yes      MS MDMPH
1      MD      yes      MSA MD
1      MD      yes      PLLC DR
1      MD      yes      DM MD
1      MD      yes      FHM MD
1      MD      yes      LTD DR
1      MD      yes      MED MBCHB
1      MD      yes      MPH MBCHB
1            MD  UNK     MDPA
1      MD      UNK      MD PHD
1      MD      UNK      DMD MD
2      DO      yes      RDMS DO
2      DO      yes      DO
2      DO      yes      FACS DO
2      DO      yes      FAAFP DO
2      DO      yes      FAAP DO
2      DO      yes      FACP DO
2      DO      yes      MPH DO
2      DO      yes      PHD DO
2      DO      yes      PC DO
2      DO      yes      PA DO
2      DO      yes      MS DO
2      DO      yes      MBA DO
2      DO      yes      DO SR
2      DO      yes      LLC DO
2      DO      yes      CMD DO
2      DO      yes      DOMPH
2      DO      yes      PHARMD DO
2      DO      yes      DO PHD
2      DO      yes      LTD DO
2      DO      yes      PS DO
2      DO      yes      DO DVM
2      DO      yes      DO MS
2      DO      yes      DPM DO
2      DO      yes      PLLC DO
2      DO      yes      DDS DO
2      DO      yes      DO DPM
2      DO      yes      DO MPH
2      DO      yes      FACC DO
2      DO      yes      JD DO
2      DO      yes      MA DO
2      DO      yes      MDH DO
2      DO      yes      MED DO
2      DO      yes      MHA DO
2      DO      yes      MPS DO
2      DO      yes      PLC DO
2      DO      yes      MSC DO
3      dentist      yes      DMSC MS
3      Dentist      yes      DDS
3      Dentist      yes      DMD
3      Dentist      yes      MS DDS
3      Dentist      yes      PC DDS
3      Dentist      yes      PA DDS
3      Dentist      yes      MSD DDS
3      Dentist      yes      PC DMD
3      Dentist      yes      MS DMD
3      Dentist       yes      PA DMD
3      Dentist      yes      DDSMS
3      Dentist      yes      PHD DDS
3      Dentist      yes      LTD DDS
3      Dentist      yes      MSD DMD
3      Dentist      yes      PS DDS
3      Dentist      yes      MPH DDS
3      Dentist      yes      LLC DDS
3      Dentist      yes      PLLC DDS
3      Dentist      yes      DDS SR
3      dentist      yes      LLC DMD
3      Dentist      yes      MDS DDS
3      dentist      yes      DDM
3      Dentist      yes      DDSMSD
3      Dentist      yes      DDSPC
3      Dentist      yes      MPH DMD
3      Dentist      yes      PHD DMD
3      Dentist      yes      MDDDS
3      dentist      yes      PSC DMD
3      Dentist      yes      DMDMS
3      Dentist      yes      MMSC DMD
3      Dentist      yes      APC DDS
3      Dentist      yes      DDS DR
3      Dentist      yes      DDSINC
3      dentist      yes      DDS MS
3      dentist      yes      DMD DDS
3      dentist      yes      DDS DMD
3      dentist      yes      DMD SR
3      Dentist      yes      MDS DMD
3      dentist      yes      PLLC DMD
3      dentist      yes      DDS MI
3      Dentist      yes      DMDPC
3      Dentist      yes      LTD DMD
3      dentist      yes      PLC DDS
3      dentist      yes      DDS MA
3      dentist      yes      DMSC DDS
3      Dentist      yes      MA DDS
3      Dentist      yes      MMSC DDS
3      Dentist      yes      PS DMD
3      Dentist      yes      DDS KY
3      Dentist      yes      DMD DR
3      dentist       yes      DDDS
3      dentist       yes      DDMD
3      dentist       yes      DMD MS
3      dentist       yes      DMDPA
3      dentist      yes      MSC DMD
3      dentist      yes      DDSPHD
3      dentist      yes      DDS BA
3      dentist      yes      DDS PHD
3      dentist      yes      DENTIST
3      dentist      yes      MSCD DMD
3      Dentist      yes      DMD DMD
3      Dentist      yes      DMDLLC
3      dentist      yes      MHS DMD
3      dentist      yes      MSC DDS
3      dentist      yes      MSCD DDS
3      dentist      yes      MSED DMD
3      dentist      yes      DDS BDS
3      dentist      yes      DDSDMDMS
3      dentist      yes      DDSLTD
3      dentist      yes      DDSPS
3      Dentist      yes      BDS DDS
3      dentist      yes      DDS LK
3      dentist      yes      DDS PA
3      dentist      yes      DDS PHUOC
3      dentist      yes      DMD BA
3      dentist      yes      DMDINC
3      dentist      yes      DMDMPH
3      dentist      yes      DMDMSD
3      dentist      yes      DMDPHD
3      dentist      yes      DMDPSC
3      dentist      yes      DMSC DMD
3      dentist      yes      FACS DDS
3      dentist      yes      MBA DDS
3      dentist      yes      MBE DMD
3      dentist      yes      MDSC DMD
3      dentist      yes      -DDS
3      dentist      yes      ANNDDS
3      dentist      yes      RPH DDS
3      dentist      yes      MPA DDS
3      Dentist      yes      PDC DDS
3      Dentist      yes      PHARMD DDS
3      Dentist      yes      RPH DMD
3      Dentist      yes      SR DDS
3      Dentist      yes      SR DMD
3      dentist      yes      DDM DENTIST
3      dentist      yes      DDS BS
3      dentist      yes      DDS DDS
3      dentist      yes      DDS DENTIST
3      dentist      yes      DDS DVM
3      dentist      yes      DDS LD
3      dentist      yes      DDS MPH
3      dentist      yes      DDS MSD
3      dentist      yes      DDS MSN
3      dentist      yes      DDS ND
3      dentist      yes      DDS PC
3      dentist      yes      DDS RN
3      dentist      yes      DDS RPH
3      dentist      yes      DDSMD DDS
3      dentist      yes      DMD BDS
3      dentist      yes      DMD BS
3      dentist      yes      DMD CM
3      dentist      yes      DMD DM
3      dentist      yes      DMD DO
3      dentist      yes      DMD FORBES
3      dentist      yes      DMD MF
3      dentist      yes      DMD MI
3      dentist      yes      DMD PA
3      dentist      yes      DR DDS
3      dentist      yes      MDSC DDS
3      dentist      yes      MHA DDS
3      dentist      yes      MMS DDS
3      dentist      yes      APC DMD
3      dentist      yes      PLC DMD
3      dentist      yes      MSPA DDS
3      dentist      yes      ND DMD
3      Dentist      yes      PROF DDS
3      dentist      yes      MSHS DDS
3      dentist      yes      DO DMD
3      dentist      yes      LTD DDSMS
3      dentist      maybe      MSC BDS
4      NP      yes      PNP
4      NP      yes      NP
4      NP      yes      MNNP
4      NP      yes      FNP-BC
4      NP      yes      FNP
4      NP      yes      FNP APRN
4      NP      yes      FNP MSN
4      NP      yes      MSN-FNP
4      NP      yes      DNP
4      NP      yes      CNP
4      NP      yes      NP-C
4      NP      yes      NPC
4      NP      yes      CNNP
4      NP      yes      FNP-C
4      NP      yes      FNP-C MSN
4      NP      yes      CRNP
4      NP      yes      CPNP
4      NP      yes      ARNP
4      NP      yes      ANP
4      NP      yes      ACNP
4      NP      yes      FNP-BC MSN
4      NP      yes      NP MSN
4      NP      yes      APNP
4      NP      yes      PMHNP
4      NP      yes      NP-C MSN
4      NP      yes      CRNP MSN
4      NP      yes      ANP-BC
4      NP      yes      MSN NP
4      NP      yes      CFNP
4      NP      yes      ACNP-BC
4      NP      yes      NNP
4      NP      yes      WHNP
4      NP      yes      CPNP MSN
4      NP      yes      CNP MSN
4      NP      yes      MSNFNP
4      NP      yes      PMHNP-BC
4      NP      yes      APN NP
4      NP      yes      FNP RN
4      NP      yes      CNP RN
4      NP      yes      RNP
4      NP      yes      FNP MS
4      NP      yes      FNP-BC APRN
4      NP      yes      FNP-C APRN
4      NP      yes      ANP-C
4      NP      yes      GNP
4      NP      yes      ARNP MSN
4      NP      yes      NP MS
4      NP      yes      NPP
4      NP      yes      ANP-BC MSN
4      NP      yes      ANP MSN
4      NP      yes      APN MSN
4      NP      yes      NP APRN
4      NP      yes      CNM NP
4      NP      yes      FNP-C RN
4      NP      yes      NNP-BC
4      NP      yes      NP CNM
4      NP      yes      NP RN
4      NP      yes      ACNP MSN
4      NP      yes      WHNP-BC
4      NP      yes      ACNP-BC MSN
4      NP      yes      CPNP RN
4      NP      yes      FNP-BC RN
4      NP      yes      APRN NP
4      NP      yes      FNP-BC DNP
4      NP      yes      NNP-BC MSN
4      NP      yes      FNP-BC MS
4      NP      yes      PMHNP APRN
4      NP      yes      NP-C APRN
4      NP      yes      CRNA NP
4      NP      yes      FNP DNP
4      NP      yes      MSN FNP
4      NP      yes      CNP APRN
4      NP      yes      CPNP MS
4      NP      yes      CRNP MS
4      NP      yes      AGACNP
4      NP      yes      AGNP
4      NP      yes      ANP MS
4      NP      yes      ARNP MN
4      NP      yes      AGPCNP-BC
4      NP      yes      MSN-NP
4      NP      yes      NP PHD
4      NP      yes      PMHNP MSN
4      NP      yes      AG-ACNP
4      NP      yes      AGACNP-BC
4      NP      yes      APRN-NP
4      NP      yes      MSNNP
4      NP      yes      FNP CNM
4      NP      yes      NP-C RN
4      NP      yes      CPNP APRN
4      NP      yes      ANP RN
4      NP      yes      WHNP CNM
4      NP      yes      APRN-CNP
4      NP      yes      FNP-BC APN
4      NP      yes      MHNP APRN
4      NP      yes      CRNP DNP
4      NP      yes      FNP-C MS
4      NP      yes      FNPC
4      NP      yes      CPNP-PC
4      NP      yes      MSNFNP-BC
4      NP      yes      CPNP-AC
4      NP      yes      APRN DNP
4      NP      yes      FNP-C DNP
4      NP      yes      NP-BC
4      NP      yes      ACNP APRN
4      NP      yes      WHNP-BC MSN
4      NP      yes      RNNP
4      NP      yes      MSNCRNP
4      NP      yes      CFNP MSN
4      NP      yes      FPMHNP
4      NP      yes      MSN FNP-BC
4      NP      yes      MSNFNP-C
4      NP      yes      PMH-NP
4      NP      yes      PMHNP-BC MSN
4      NP      yes      WHNP MSN
4      NP      yes      ANP-C MSN
4      NP      yes      ARNP-C
4      NP      yes      FNP PHD
4      NP      yes      NP-CNM
4      NP      yes      AGPCNP
4      NP      yes      FNP NP
4      NP      yes      CNP APN
4      NP      yes      CNP MS
4      NP      yes      MSN-FNP-C
4      NP      yes      PNP MSN
4      NP      yes      CNM FNP
4      NP      yes      APNP MSN
4      NP      yes      GNP-BC
4      NP      yes      APRN FNP
4      NP      yes      MSN ARNP
4      NP      yes      NNP MSN
4      NP      yes      NP RNC
4      NP      yes      NP-C MS
4      NP      yes      PMHNP FNP
4      NP      yes      WHNP APRN
4      NP      yes      APRNFNP
4      NP      yes      ARNP DNP
4      NP      yes      CNM ARNP
4      NP      yes      CNS NP
4      NP      yes      MS NP
4      NP      yes      MSNP
4      NP      yes      WHCNP
4      NP      yes      AGNP-C
4      NP      yes      FNP APN
4      NP      yes      FNP ARNP
4      NP      yes      FNP-BC PHD
4      NP      yes      FNP MN
4      NP      yes      ARNP-BC
4      NP      yes      DNP NP
4      NP      yes      APNP FNP-BC
4      NP      yes      PMHNP-BC APRN
4      NP      yes      ENP
4      NP      yes      ANP-BC MS
4      NP      yes      ANP-BC RN
4      NP      yes      ARNP CNM
4      NP      yes      PHD NP
4      NP      yes      APN-C NP
4      NP      yes      CNMNP
4      NP      yes      DNP FNP
4      NP      yes      FNP-BC ARNP
4      NP      yes      FNP-C ARNP
4      NP      yes      MSFNP
4      NP      yes      NP DNP
4      NP      yes      ACNP MS
4      NP      yes      FNPBC
4      NP      yes      PMHNP-BC RN
4      NP      yes      PNP APRN
4      NP      yes      MS-FNP
4      NP      yes      MSNCNP
4      NP      yes      APN DNP
4      NP      yes      CPNP-AC MSN
4      NP      yes      CRNP NP
4      NP      yes      FNP RNC
4      NP      yes      PNP MS
4      NP      yes      PNP-BC
4      NP      yes      ARNP PHD
4      NP      yes      CNM DNP
4      NP      yes      MSN CRNP
4      NP      yes      MSN-ACNP
4      NP      yes      MSNARNP
4      NP      yes      NP-C DNP
4      NP      yes      ACNP-BC MS
4      NP      yes      NPMSN
4      NP      yes      ACNP-C
4      NP      yes      ANP-BC DNP
4      NP      yes      APNCNP
4      NP      yes      C-FNP
4      NP      yes      CFNP RN
4      NP      yes      CRNP PHD
4      NP      yes      FNP-BC APNP
4      NP      yes      FNPC MSN
4      NP      yes      MSN DNP
4      NP      yes      MSN NP-C
4      NP      yes      MSN-FNP-BC
4      NP      yes      MSNNP-C
4      NP      yes      NP CNS
4      NP      yes      NP-C APN
4      NP      yes      NP-C FNP
4      NP      yes      PMHNP RN
4      NP      yes      DNP MSN
4      NP      yes      ACNP-BC RN
4      NP      yes      AGACNP APRN
4      NP      yes      AGACNP-BC MSN
4      NP      yes      ARNP CRNA
4      NP      yes      C-NP
4      NP      yes      DNPFNP
4      NP      yes      FNPMSN
4      NP      yes      FPMHNP-BC
4      NP      yes      MN ARNP
4      NP      yes      MSN FNP-C
4      NP      yes      MSN-CRNP
4      NP      yes      RN-CNP
4      NP      yes      RNCPNP
4      NP      yes      NP APN
4      NP      yes      NP-CNS
4      NP      yes      PNP-AC
4      NP      yes      APRN-FNP
4      NP      yes      APRNNP
4      NP      yes      BC-FNP
4      NP      yes      CNP DNP
4      NP      yes      CRNP-F
4      NP      yes      FNP-C APN
4      NP      yes      ANP RNC
4      NP      yes      ARNP MS
4      NP      yes      NNP-BC RN
4      NP      yes      NP PMH
4      NP      yes      NP-C FNP-BC
4      NP      yes      PNP-BC MSN
4      NP      yes      RNCNP
4      NP      yes      MSNANP
4      NP      yes      DNP CRNP
4      NP      yes      DNPFNP-BC
4      NP      yes      DRNP
4      NP      yes      FNP APRN-BC
4      NP      yes      FNP-APRN
4      NP      yes      FNP-BC CRNP
4      NP      yes      MSN CNP
4      NP      yes      MSN-ANP
4      NP      yes      MSN-NNP
4      NP      yes      MSN-PMHNP
4      NP      yes      MSNCPNP
4      NP      yes      NP CS
4      NP      yes      NP MN
4      NP      yes      NP-BC MSN
4      NP      yes      ANP APRN
4      NP      yes      ANP PHD
4      NP      yes      ANP-BC APRN
4      NP      yes      ANP-C MS
4      NP      yes      ANP-C RN
4      NP      yes      APNP CRNA
4      NP      yes      APNP FNP
4      NP      yes      APNP MS
4      NP      yes      APRN-FNP-BC
4      NP      yes      APRNFNP-C
4      NP      yes      CRNA ARNP
4      NP      yes      PNP RN
4      NP      yes      RNFNP
4      NP      yes      WHNP RNC
4      NP      yes      ARNP RN
4      NP      yes      CPNP APN
4      NP      yes      NNP-BC APRN
4      NP      yes      NNP-BC MS
4      NP      yes      FNP-BC NP
4      NP      yes      FNP-C CRNP
4      NP      yes      GNP ANP
4      NP      yes      GNP MSN
4      NP      yes      GNP RN
4      NP      yes      GNP-BC MSN
4      NP      yes      NNP APRN
4      NP      yes      NP CRNA
4      NP      yes      NP FNP-BC
4      NP      yes      NP NP
4      NP      yes      ACNP-BC APRN
4      NP      yes      ACNP-BC DNP
4      NP      yes      AGPCNP-BC MSN
4      NP      yes      APNC NP
4      NP      yes      CNM WHNP
4      NP      yes      CRNP RN
4      NP      yes      DNP APRN
4      NP      yes      MSN WHNP
4      NP      yes      MSN WHNP-BC
4      NP      yes      PC NP
4      NP      yes      APRNFNP-BC
4      NP      yes      PMHNP-BC PHD
4      NP      yes      ACNP DNP
4      NP      yes      ACNP FNP
4      NP      yes      ACNP RN
4      NP      yes      ACNP-BC APN
4      NP      yes      AFNP
4      NP      yes      AG-ACNP MS
4      NP      yes      AGNP MSN
4      NP      yes      AGNP-BC MSN
4      NP      yes      AGNP-C MSN
4      NP      yes      AGPCNP MSN
4      NP      yes      AHNP APRN
4      NP      yes      APN-A NP
4      NP      yes      APN-BC NP
4      NP      yes      APNNP
4      NP      yes      APNP-BC
4      NP      yes      APRN CPNP
4      NP      yes      APRNCPNP
4      NP      yes      CNP CNM
4      NP      yes      CNSNP
4      NP      yes      CPNP-AC APRN
4      NP      yes      DNP-FNP
4      NP      yes      DNPFNP-C
4      NP      yes      FNP-C APNP
4      NP      yes      FNP-MSN
4      NP      yes      GNP APRN
4      NP      yes      GNP-BC ANP-BC
4      NP      yes      GNP-BC APRN
4      NP      yes      GNP-BC RN
4      NP      yes      MS FNP
4      NP      yes      MSN CPNP
4      NP      yes      MSNACNP
4      NP      yes      MSNPNP
4      NP      yes      NP CRNP
4      NP      yes      NP-C CRNP
4      NP      yes      NP-P
4      NP      yes      NPA
4      NP      yes      OGNP
4      NP      yes      RN NP
4      NP      yes      WHNP RN
4      NP      yes      WHNP-BC APRN
4      NP      yes      WHNP-BC CNM
4      NP      yes      MSN MPH
4      NP      yes      PA NP
4      NP      yes      PMHNP-BC DNP
4      NP      yes      PPCNP-BC
4      NP      yes      MSN-AGACNP
4      NP      yes      ANP DNP
4      NP      yes      ANPGNP
4      NP      yes      APN-CNP
4      NP      yes      APN-FNP
4      NP      yes      APNCRNA
4      NP      yes      APNP ANP-BC
4      NP      yes      APNP CNM
4      NP      yes      APNP CPNP
4      NP      yes      CPNP DNP
4      NP      yes      CPNP-ACPC
4      NP      yes      CPNP-PC MSN
4      NP      yes      CPNP-PC RN
4      NP      yes      CRNAARNP
4      NP      yes      CRNP-A
4      NP      yes      DNPAPRN
4      NP      yes      FNP CNS
4      NP      yes      FNP-BC MN
4      NP      yes      FNP-BC RNMSN
4      NP      yes      FNP-PP
4      NP      yes      FNPAPRN
4      NP      yes      FNPC RN
4      NP      yes      FNPPMHNP
4      NP      yes      GNP FNP
4      NP      yes      MHNP FNP
4      NP      yes      MN-FNP
4      NP      yes      MS ANP
4      NP       yes      PMHNP DNP
4      NP       yes      PMHNP MS
4      NP       yes      PMHNP-BC MS
4      NP       yes      PNP-AC MSN
4      NP       yes      RN FNP
4      NP       yes      RN FNP-BC
4      NP       yes      RN NP-C
4      NP       yes      RN-FNP
4      NP       yes      WHCNP CNM
4      NP       yes      WHNP-BC ANP-BC
4      NP       yes      WHNP-BC RN
4      NP      yes      GNP MS
4      NP      yes      MSN-ARNP
4      NP      yes      MSN-CNP
4      NP      yes      MSN-PNP
4      NP      yes      MSNANP-BC
4      NP      yes      NP BSN
4      NP      yes      NP MI
4      NP      yes      NP-C APNP
4      NP      yes      NP-C ARNP
4      NP      yes      NP-C MN
4      NP      yes      NP-CRNA
4      NP      yes      MSNCFNP
4      NP      yes      MSNNNP-BC
4      NP      yes      MSNPMHNP
4      NP      yes      NNP RNC
4      NP      yes      PHD ARNP
4      NP      yes      PHD FNP
4      NP      yes      PHD FNP-BC
4      NP      yes      RNMSNFNP-BC
4      NP      yes      AG-ACNP-BC
4      NP      yes      AGACNP-BC DNP
4      NP      yes      AGNP-BC
4      NP      yes      APRN NP-C
4      NP      yes      ARNPCNM
4      NP      yes      C-FNP MSN
4      NP      yes      CFNP MS
4      NP      yes      CNP RNC
4      NP      yes      MSFNP-BC
4      NP      yes      DSS
4      NP      yes      ACNPC-AG
4      NP      yes      ECRNP
4      NP       yes      ACNP-BC CRNP
4      NP       yes      ACNP-BC NP
4      NP       yes      ACNP-C RN
4      NP       yes      AGACNP RN
4      NP       yes      AGNP-C APRN
4      NP       yes      AGPCNP-BC RN
4      NP       yes      ANP CNS
4      NP       yes      ANP CS
4      NP       yes      ANP NP
4      NP       yes      ANP-BC APN
4      NP       yes      ANP-BC NP
4      NP       yes      AOCNP
4      NP       yes      APMHNP
4      NP       yes      APNFNP-BC
4      NP       yes      APNP FNP-C
4      NP       yes      APNP NP-C
4      NP       yes      APNP RN
4      NP       yes      APRN FNP-BC
4      NP       yes      APRN-BC FNP
4      NP       yes      APRN-NP MSN
4      NP       yes      ARNP NP
4      NP       yes      ARNP-C MSN
4      NP       yes      CNM ANP
4      NP       yes      CNMFNP
4      NP       yes      CNP FNP
4      NP       yes      CPNP NP
4      NP       yes      CPNP-AC RN
4      NP       yes      CPNP-PC APRN
4      NP       yes      DNP ARNP
4      NP       yes      DNP CNM
4      NP       yes      DNP FNP-BC
4      NP       yes      DNP FNP-C
4      NP       yes      DNP PNP
4      NP       yes      DNPCRNP
4      NP       yes      FNP PA
4      NP       yes      FNP PNP
4      NP       yes      FNP-BC ANP-BC
4      NP       yes      FNP-BC CNM
4      NP       yes      FNPBC MSN
4      NP       yes      GNP RNC
4      NP       yes      GNP-BC ANP-C
4      NP       yes      GNP-BC MS
4      NP       yes      MPH FNP-BC
4      NP       yes      MS ARNP
4      NP       yes      MS-NP
4      NP       yes      MSN ACNP
4      NP       yes      MSN APNP
4      NP       yes      MSN RNP
4      NP       yes      MSN-ACNP-BC
4      NP       yes      MSN-AGNP
4      NP       yes      MSN-APNP
4      NP       yes      MSN-FNP NP
4      NP       yes      MSN-WHNP
4      NP       yes      MSNAPRNFNP
4      NP       yes      MSNNNP
4      NP       yes      MSNRNFNP-BC
4      NP       yes      NNP MS
4      NP       yes      NNP-BC CRNP
4      NP       yes      NNP-BC PHD
4      NP       yes      NP MA
4      NP       yes      NPCNS
4      NP       yes      RN ANP
4      NP       yes      RN PMHNP-BC
4      NP       yes      RNC NP
4      NP       yes      RNC-FNP
4      NP       yes      RNCNNP
4      NP       yes      RNMSNCPNP
4      NP       yes      RNMSNFNP
4      NP       yes      RNMSNFNP-C
4      NP       yes      RNMSNNP
4      NP       yes      RNMSNP
4      NP       yes      WHNP-BC NP
4      NP      yes      FNP MASTERS
4      NP      yes      CRNP-F MSN
4      NP      yes      CRNPMSN
4      NP      yes      CNNP RNC
4      NP      yes      CNP-BC
4      NP      yes      CNPMSN
4      NP      yes      MFNP
4      NP      yes      PMHNP-BC APN
4      NP      yes      PMHS CPNP
4      NP      yes      PNP FNP
4      NP      yes      PNP-C
4      NP      yes      RNP MS
4      NP      yes      RNP MSN
4      NP      yes      PHMNP-BC
4      NP      yes      ACHPN FNP-BC
4      NP      yes      ACHPN GNP-BC
4      NP      yes      ACNP ANP
4      NP      yes      ACNP-BC FNP-BC
4      NP      yes      ACNP-BC FNP-C
4      NP      yes      ACNP-BC PHD
4      NP      yes      ACNP-BC RNMSN
4      NP      yes      ACPNP
4      NP      yes      ACRNP
4      NP      yes      AG-ACNP MSN
4      NP      yes      AGACNP DNP
4      NP      yes      AGNP-BC RN
4      NP      yes      AGPCNP APRN
4      NP      yes      AGPCNP-BC MS
4      NP      yes      AGPCNP-C
4      NP      yes      ANP APN
4      NP      yes      ANP BSN
4      NP      yes      ANP CNM
4      NP      yes      ANP MN
4      NP      yes      ANP-BC CRNP
4      NP      yes      ANP-BC PHD
4      NP      yes      ANP-C PHD
4      NP      yes      ANPBC
4      NP      yes      ANPC MSN
4      NP      yes      ANPMS
4      NP      yes      APN FNP
4      NP      yes      APN NP-C
4      NP      yes      APN-NP
4      NP      yes      APNP CNS
4      NP      yes      APNP DNP
4      NP      yes      APNP-C
4      NP      yes      APRN PMHNP
4      NP      yes      APRN-BC NP
4      NP      yes      APRN-FNP-C
4      NP      yes      APRN-NNP
4      NP      yes      APRN-NNP-BC
4      NP      yes      APRNCNP
4      NP      yes      APRNCRNP
4      NP      yes      ARNP FNP
4      NP      yes      ARNP MSN-FNP
4      NP      yes      ARNP-BC MS
4      NP      yes      ARNP-BC MSN
4      NP      yes      ARNP-FNP
4      NP      yes      ARNP-FNP-BC
4      NP      yes      ARNP-FNP-C
4      NP      yes      BC-ANP
4      NP      yes      BC-FNP APRN
4      NP      yes      BC-FNP MSN
4      NP      yes      C-ANP
4      NP      yes      C-PNP
4      NP      yes      C-PNP MSN
4      NP      yes      C-RNP
4      NP      yes      CFNP APRN
4      NP      yes      CFNP-BC
4      NP      yes      CGNP
4      NP      yes      CNM CNP
4      NP      yes      CNP ARNP
4      NP      yes      CNP BSN
4      NP      yes      CNP CNS
4      NP      yes      CNP MPH
4      NP      yes      CNP PHD
4      NP      yes      CNP-FNP
4      NP      yes      CPNP ARNP
4      NP      yes      CPNP BSN
4      NP      yes      CPNP FNP
4      NP      yes      CPNP PHD
4      NP      yes      CPNP-AC MS
4      NP      yes      CPNP-BC
4      NP      yes      CPNP-PCAC
4      NP      yes      CRNA DNP
4      NP      yes      CRNP APRN
4      NP      yes      CRNP CNM
4      NP      yes      CRNP FNP-BC
4      NP      yes      CRNP-AC
4      NP      yes      CRNP-F MS
4      NP      yes      CRNP-FAMILY
4      NP      yes      CS NP
4      NP      yes      DNPCNP
4      NP      yes      DNPNP
4      NP      yes      FNP ACNP
4      NP      yes      FNP ANP
4      NP      yes      FNP BSN
4      NP      yes      FNP DNSC
4      NP      yes      FNP GNP
4      NP      yes      FNP MNSC
4      NP      yes      FNP MPH
4      NP      yes      FNP PMHNP
4      NP      yes      FNP RNMSN
4      NP      yes      FNP SR
4      NP      yes      FNP WHNP
4      NP      yes      FNP-BC ACNP-BC
4      NP      yes      FNP-BC ANP
4      NP      yes      FNP-BC BSN
4      NP      yes      FNP-BC CNP
4      NP      yes      FNP-BC DRNP
4      NP      yes      FNP-C CNM
4      NP      yes      FNP-C CNS
4      NP      yes      FNP-C MN
4      NP      yes      FNP-C RNMSN
4      NP      yes      FNP-DNP
4      NP      yes      FNPC APRN
4      NP      yes      FNPC MN
4      NP      yes      FNPPMHNP-BC
4      NP      yes      FPMHNP APRN
4      NP      yes      FPMHNP-BC ARNP
4      NP      yes      FPMHNP-BC MSN
4      NP      yes      GNP-C
4      NP      yes      GNP-C ANP-C
4      NP      yes      MASTERS NP
4      NP      yes      MCRNP
4      NP      yes      MPH DNP
4      NP      yes      MPH FNP
4      NP      yes      MPH NP
4      NP      yes      MS RNP
4      NP      yes      MS-ACNP
4      NP      yes      MS-ARNP
4      NP      yes      MSCNP
4      NP      yes      MSCRNP
4      NP       yes      A-GNP
4      NP       yes      AGACNP MSN
4      NP       yes      AGACNP-BC APRN
4      NP       yes      APMHNP-BC
4      NP       yes      APNCRNA NP
4      NP       yes      CNM WHNP-BC
4      NP       yes      CNMCNP
4      NP       yes      DNP APN
4      NP       yes      DNP CRNA
4      NP       yes      DNP-CRNP
4      NP       yes      MSN-NP-C
4      NP       yes      MSNANP-C
4      NP       yes      MSNAPNFNP-BC
4      NP       yes      MSNAPNP
4      NP       yes      MSNCRNA NP
4      NP       yes      MSNRNCPNP
4      NP       yes      MSNRNNNP-BC
4      NP       yes      NNP BSN
4      NP       yes      NNP RN
4      NP       yes      NNP-BC APN
4      NP       yes      NNP-BC ARNP
4      NP       yes      NP APN-BC
4      NP       yes      NP CM
4      NP       yes      NP MD
4      NP       yes      NP MLP
4      NP       yes      NP-C ANP-BC
4      NP       yes      NP-C APRN-BC
4      NP       yes      NP-C CNM
4      NP       yes      NP-C NP
4      NP       yes      NP-C PHD
4      NP       yes      NP-F
4      NP       yes      NP-PP
4      NP       yes      NPC MSN
4      NP       yes      NPP ANP
4      NP       yes      NPP CPNP
4      NP       yes      NPP PHD
4      NP       yes      OGNP RN
4      NP      yes      PMHNP ANP
4      NP      yes      PMHNP APN
4      NP      yes      PMHNP CNM
4      NP      yes      PMHNP MN
4      NP      yes      PMHNP-BC MN
4      NP      yes      PMHNP-BC NP
4      NP      yes      PMHNP-BC RNNP
4      NP      yes      PMHNP-C
4      NP      yes      PMNHP
4      NP      yes      PNP MN
4      NP      yes      PNP RNC
4      NP      yes      PNP-BC MS
4      NP      yes      RN ACNP-BC
4      NP      yes      RN CPNP
4      NP      yes      RN FNP-C
4      NP      yes      RNCCNNP
4      NP      yes      RNCSNP
4      NP      yes      WHCNP APRN
4      NP      yes      WHCNP MSN
4      NP      yes      WHNP ANP
4      NP      yes      WHNP MS
4      NP      yes      WHNP-BC APN
4      NP      yes      WHNP-BC CRNP
4      NP      yes      WHNP-BC DNP
4      NP      yes      WHNP-BC FNP-BC
4      NP      yes      WHNP-BC FNP-C
4      NP      yes      WHNP-BC MS
4      NP      yes      MSN ANP-BC
4      NP      yes      MSN C-NP
4      NP      yes      MSNGNP
4      NP      yes      MSNPMHNP-BC
4      NP      yes      PC FNP-C
4      NP      yes      PHD ANP
4      NP      yes      PHD PMHNP
4      NP      yes      PHMNP-BC MSN
4      NP      yes      RNCPNPMSN
4      NP      yes      MS APNP
4      NP      yes      MSNACNP-BC
4      NP      yes      MSNCPNP RN
4      NP      yes      MSNFNPC
4      NP      yes      MN NP
4      NP      yes      PMHNP ARNP
4      NP      yes      PMHNP FNP-BC
4      NP      yes      PMHNP GNP
4      NP      yes      PMHNP NP
4      NP      yes      PMHNP-BC ANP-BC
4      NP      yes      PMHNP-BC ARNP
4      NP      yes      PMHNP-BC CRNP
4      NP      yes      PMHNP-BC CRNP-BC
4      NP      yes      PMHNP-BC CS
4      NP      yes      PMHNP-BC FNP
4      NP      yes      PMHNP-BC FNP-BC
4      NP      yes      PMHNP-BC FNP-C
4      NP      yes      PMHNP-BC GNP-BC
4      NP      yes      PMHNP-BC MA
4      NP      yes      PMHNP-BC PNP
4      NP      yes      PMHNP-BC RNMSN
4      NP      yes      PMHNP-C FNP-C
4      NP      yes      PMNHP APRN
4      NP      yes      PNP ANP
4      NP      yes      PNP APN
4      NP      yes      PNP DNP
4      NP      yes      PNP NNP
4      NP      yes      PNP PHD
4      NP      yes      PNP PMHNP
4      NP      yes      PNP RNCS
4      NP      yes      PNP-AC BSNMSN
4      NP      yes      PNP-AC MS
4      NP      yes      PNP-BC APN
4      NP      yes      PNP-BC APRN
4      NP      yes      PNP-BC DNP
4      NP      yes      PNP-BC MNSC
4      NP      yes      PNP-BC NP
4      NP      yes      PNP-BC PHD
4      NP      yes      PNP-BC RN
4      NP      yes      PNP-C APRN
4      NP      yes      PPCNP-BC APRN
4      NP      yes      PPCNP-BC MS
4      NP      yes      PPCNP-BC MSN
4      NP      yes      PPCNP-BC NP
4      NP      yes      RN CNP
4      NP      yes      RN DNP
4      NP      yes      RN GNP
4      NP      yes      RN MSNFNP-BC
4      NP      yes      RN PMHNP
4      NP      yes      RN-CNP MS
4      NP      yes      RNC ARNP
4      NP      yes      RNC-ANP
4      NP      yes      RNC-ANP MSN
4      NP      yes      RNCNP MN
4      NP      yes      RNFA ANP
4      NP      yes      RNFA CRNP
4      NP      yes      RNFA FNP-C
4      NP      yes      RNMSNCPNP NP
4      NP      yes      RNNP MSN
4      NP      yes      RNP CNM
4      NP      yes      RNP RN
4      NP      yes      RNPC MS
4      NP      yes      WHCNP MN
4      NP      yes      WHCNP RN
4      NP      yes      WHNP APN
4      NP      yes      WHNP BSN
4      NP      yes      WHNP FNP
4      NP      yes      WHNP FNP-C
4      NP      yes      WHNP NP
4      NP      yes      WHNP PHD
4      NP      yes      WHNP-BC BSN
4      NP      yes      WHNP-BC MN
4      NP      yes      WHNP-BC NP-C
4      NP      yes      DNAP
4      NP      yes      DNP ANP-BC
4      NP      yes      DNP ARNP-BC
4      NP      yes      DNP CNP
4      NP      yes      DNP CNS
4      NP      yes      DNP MP
4      NP      yes      DNP MS
4      NP      yes      DNP NNP
4      NP      yes      DNP PHD
4      NP      yes      DNP PMHNP-BC
4      NP      yes      DNP RN
4      NP      yes      DNP-FNP MS
4      NP      yes      DNP-FNP-C
4      NP      yes      DNP-FNP-C ARNP
4      NP      yes      DNPARNPFNP-C
4      NP      yes      FNP ACNP-BC
4      NP      yes      FNP ANP-BC
4      NP      yes      FNP APN-C
4      NP      yes      FNP APRN-CRNA
4      NP      yes      FNP APRNBC
4      NP      yes      FNP APRNMSN
4      NP      yes      FNP BSMS
4      NP      yes      FNP CRN
4      NP      yes      FNP CRNA
4      NP      yes      FNP CRNP
4      NP      yes      FNP CS
4      NP      yes      FNP ENP
4      NP      yes      FNP LR
4      NP      yes      FNP MSN-APRN
4      NP      yes      FNP MSN-RN
4      NP      yes      FNP NNP
4      NP      yes      FNP NP-C
4      NP      yes      FNP NPP
4      NP      yes      FNP RNCS
4      NP      yes      FNP-BC AGACNP-BC
4      NP      yes      FNP-BC APRN-C
4      NP      yes      FNP-BC APRN-NP
4      NP      yes      FNP-BC CNS-BC
4      NP      yes      FNP-BC CPN
4      NP      yes      FNP-BC CPNP
4      NP      yes      FNP-BC DNPAPRN
4      NP      yes      FNP-BC FORBES
4      NP      yes      FNP-BC MPH
4      NP      yes      FNP-BC MSC
4      NP      yes      FNP-BC MSNCRNP
4      NP      yes      FNP-BC NP-C
4      NP      yes      FNP-BC NPP
4      NP      yes      FNP-BC PCNS-BC
4      NP      yes      FNP-BC RNC
4      NP      yes      FNP-C AGNP-C
4      NP      yes      FNP-C ANP-BC
4      NP      yes      FNP-C ANP-C
4      NP      yes      FNP-C APRN-NP
4      NP      yes      FNP-C BSN
4      NP      yes      FNP-C CPNP
4      NP      yes      FNP-C MA
4      NP      yes      FNP-C MSN-APRN
4      NP      yes      FNP-C ND
4      NP      yes      FNP-C NP
4      NP      yes      FNP-C PA-C
4      NP      yes      FNPACNP
4      NP      yes      FNPACNP MSN
4      NP      yes      FNPBC APN
4      NP      yes      FNPBC APRN
4      NP      yes      FNPBC DNP
4      NP      yes      FNPBC RN
4      NP      yes      FNPC MS
4      NP      yes      FPMHNP FNP
4      NP      yes      FPMHNP MSN
4      NP      yes      FPMHNP-BC DNP
4      NP      yes      FPMHNP-BC FNP
4      NP      yes      FPMHNP-BC RN
4      NP      yes      GNP ACNP
4      NP      yes      GNP ANP-BC
4      NP      yes      GNP APRN-BC
4      NP      yes      GNP ARNP
4      NP      yes      GNP DNP
4      NP      yes      GNP MSNAPRN-BC
4      NP      yes      GNP-BC DNPCRNP
4      NP      yes      GNP-BC NP
4      NP      yes      GNP-BC PHD
4      NP      yes      GNP-C APN-C
4      NP      yes      GNP-C RN
4      NP      yes      LLC APNP
4      NP      yes      MBA FNP
4      NP      yes      MHNP APNP
4      NP      yes      MHNP CNS
4      NP      yes      MLP ARNP
4      NP      yes      MN FNP
4      NP      yes      MPH ANP
4      NP      yes      MPH CNP
4      NP      yes      MPH CRNP
4      NP      yes      MPH RNP
4      NP      yes      -FNP
4      NP      yes      ACNP APRN-BC
4      NP      yes      ACNP MI
4      NP      yes      ACNP NP
4      NP      yes      ACNP PHD
4      NP      yes      ACNP-BC ANP
4      NP      yes      ACNP-BC ARNP
4      NP      yes      ACNP-BC CNP
4      NP      yes      ACNP-BC FNP
4      NP      yes      ACNP-BC MBE
4      NP      yes      ACNP-BC MNSC
4      NP      yes      ACNP-BC NP-C
4      NP      yes      ACNP-C MSN
4      NP      yes      ACNPBC
4      NP      yes      ACNPBC MSN
4      NP      yes      AG-ACNP RN
4      NP      yes      AG-ACNP-BC MS
4      NP      yes      AG-ACNP-BC MSN
4      NP      yes      AG-ACNP-BC RN
4      NP      yes      AGACNP CFNP
4      NP      yes      AGACNP-BC RN
4      NP      yes      AGNP APN
4      NP      yes      AGNP APRN
4      NP      yes      AGNP MA
4      NP      yes      AGNP MN
4      NP      yes      AGNP MS
4      NP      yes      AGNP NP
4      NP      yes      AGNP-BC DNP
4      NP      yes      AGNP-C BSN
4      NP      yes      AGNP-C FNP-BC
4      NP      yes      AGNP-C MS
4      NP      yes      AGPCNP-BC APN
4      NP      yes      AGPCNP-BC APNP
4      NP      yes      AGPCNP-BC GNP-BC
4      NP      yes      AGPCNP-C MSN
4      NP      yes      AHNP
4      NP      yes      AHNP GNP
4      NP      yes      ANP ACNP
4      NP      yes      ANP ACNS
4      NP      yes      ANP APRN-BC
4      NP      yes      ANP CRN
4      NP      yes      ANP FNP
4      NP      yes      ANP GNP
4      NP      yes      ANP MA
4      NP      yes      ANP NP-C
4      NP      yes      ANP RNCS
4      NP      yes      ANP-BC ARNP
4      NP      yes      ANP-BC BSN
4      NP      yes      ANP-BC GNP-BC
4      NP      yes      ANP-C APN
4      NP      yes      ANP-C APRN
4      NP      yes      ANP-C CNS
4      NP      yes      ANP-C DNP
4      NP      yes      ANP-C FNP
4      NP      yes      ANP-C FNP-C
4      NP      yes      ANP-C GNP
4      NP      yes      ANP-C MN
4      NP      yes      ANP-C NP
4      NP      yes      ANPC FNP
4      NP      yes      ANPC MS
4      NP      yes      ANPGNP-BC
4      NP      yes      ANPGNP-BC APN
4      NP      yes      AOCNP APN-C
4      NP      yes      AOCNP CRNP
4      NP      yes      AOCNP DNP
4      NP      yes      AOCNP MSNFNP-BC
4      NP      yes      AOCNP PHD
4      NP      yes      AOCNP WHNP-BC
4      NP      yes      APMHNP APRN
4      NP      yes      APN CNP
4      NP      yes      APN CPNP
4      NP      yes      APN FNP-BC
4      NP      yes      APN GNP
4      NP      yes      APN MSN-FNP
4      NP      yes      APN PMHNP
4      NP      yes      APN-BC ACNP
4      NP      yes      APN-BC APNP
4      NP      yes      APN-BC DNP
4      NP      yes      APN-BC FNP
4      NP      yes      APN-C DNP
4      NP      yes      APN-C DRNP
4      NP      yes      APN-C FNP
4      NP      yes      APN-CNP MSN
4      NP      yes      APN-CNP PHD
4      NP      yes      APNCNP AGACNP-BC
4      NP      yes      APNCNP MS
4      NP      yes      APNP ACNPC-AG
4      NP      yes      APNP ACNS-BC
4      NP      yes      APNP APN-BC
4      NP      yes      APNP APRN-BC
4      NP      yes      APNP NNP
4      NP      yes      APNP PHD
4      NP      yes      APNP RNC
4      NP      yes      APNP RNMSN
4      NP      yes      APNP WHNP
4      NP      yes      APNP WHNP-BC
4      NP      yes      APNP-BC DNP
4      NP      yes      APNP-BC MS
4      NP      yes      APNP-BC MSN
4      NP      yes      APRN FNP-C
4      NP      yes      APRN MSNFNP-BC
4      NP      yes      APRN PNP
4      NP      yes      APRN WHNP-BC
4      NP      yes      APRN-C DNP
4      NP      yes      APRN-C FNP-BC
4      NP      yes      APRN-FNP MSN
4      NP      yes      APRN-FNP-C MSN
4      NP      yes      APRN-NP PHD
4      NP      yes      APRN-NP PHDC
4      NP      yes      APRNBC DNP
4      NP      yes      APRNFNP-BC DNP
4      NP      yes      APRNFNP-BC NP
4      NP      yes      APRNNP-C MSN
4      NP      yes      ARNP ACNP-BC
4      NP      yes      ARNP ANP-BC
4      NP      yes      ARNP CNP
4      NP      yes      ARNP DRNP
4      NP      yes      ARNP FNP-BC
4      NP      yes      ARNP FNP-C
4      NP      yes      ARNP MASTERS
4      NP      yes      ARNP MPH
4      NP      yes      ARNP-BC RN
4      NP      yes      ARNP-C PHD
4      NP      yes      ARNP-C RN
4      NP      yes      BC-ANP APRN
4      NP      yes      BC-ANP BC-FNP
4      NP      yes      BC-FNP ARNP
4      NP      yes      BC-FNP RNMSN
4      NP      yes      BS PMHNP
4      NP      yes      BS RNP
4      NP      yes      BSN DNP
4      NP      yes      C-GNP APNP
4      NP      yes      C-GNP APRN
4      NP      yes      C-NP APRN
4      NP      yes      C-NP RN
4      NP      yes      C-PNP NP
4      NP      yes      C-PNP RN
4      NP      yes      CCNS ACNP-BC
4      NP      yes      CCNS APNP
4      NP      yes      CCNS CPNP
4      NP      yes      CCNS CRNP
4      NP      yes      CFNP CPNP
4      NP      yes      CNM CRNP
4      NP      yes      CNM FNP-C
4      NP      yes      CNM FNPC
4      NP      yes      CNM RNP
4      NP      yes      CNP MA
4      NP      yes      CNP MHA
4      NP      yes      CNP NP
4      NP      yes      CNP-BC APRN
4      NP      yes      CNP-BC MSRN
4      NP      yes      CPNP AGPCNP-BC
4      NP      yes      CPNP APRNMSN
4      NP      yes      CPNP CRNP
4      NP      yes      CPNP CS
4      NP      yes      CPNP MN
4      NP      yes      CPNP MPH
4      NP      yes      CPNP NNP-BC
4      NP      yes      CPNP-AC APN
4      NP      yes      CPNP-AC CRNP
4      NP      yes      CPNP-AC NP
4      NP      yes      CPNP-ACPC DNP
4      NP      yes      CPNP-PC BSN
4      NP      yes      CPNP-PCAC RN
4      NP      yes      CRNA APNP
4      NP      yes      CRNP ANP-BC
4      NP      yes      CRNP BSN
4      NP      yes      CRNP FNP
4      NP      yes      CRNP MPH
4      NP      yes      CRNP MSNMPH
4      NP      yes      CRNP PS
4      NP      yes      CRNP-AC MS
4      NP      yes      CRNP-BC
4      NP      yes      CRNP-BC FNP
4      NP      yes      CRNP-BC MSN
4      NP      yes      CRNP-F PHD
4      NP      yes      CS ARNP
4      NP      yes      CS FNP
4      NP      yes      CS NP-C
4      NP      yes      CS PMH-NP
4      NP      yes      CWCN FNP
4      NP      yes      CWON FNP-BC
4      NP      yes      CWON GNP-BC
4      NP      yes      CWS ANP-C
4      NP      yes      NNP ARNP
4      NP      yes      NNP CRN
4      NP      yes      NNP DNP
4      NP      yes      NNP FNP-BC
4      NP      yes      NNP PNP
4      NP      yes      NNP-BC BSN
4      NP      yes      NNP-BC DNP
4      NP      yes      NNP-BC MN
4      NP      yes      NNP-BC RNC
4      NP      yes      NP ACNP
4      NP      yes      NP ACNP-BC
4      NP      yes      NP AGPCNP-BC
4      NP      yes      NP APRN-BC
4      NP      yes      NP APRNBC
4      NP      yes      NP APRNMSN
4      NP      yes      NP ARNP
4      NP      yes      NP CRN
4      NP      yes      NP KY
4      NP      yes      NP LD
4      NP      yes      NP MASTERS
4      NP      yes      NP NNP-BC
4      NP      yes      NP PAC
4      NP      yes      NP PC
4      NP      yes      NP PMHNP
4      NP      yes      NP PMHNP-BC
4      NP      yes      NP RNCS
4      NP      yes      NP-BC APN
4      NP      yes      NP-BC APRN
4      NP      yes      NP-BC DNSC
4      NP      yes      NP-BC PC
4      NP      yes      NP-BC PMH
4      NP      yes      NP-C CNS
4      NP      yes      NP-C MBA
4      NP      yes      NP-C PMHNP-BC
4      NP      yes      NP-PP FNP
4      NP      yes      NPC MS
4      NP      yes      NPC NP
4      NP      yes      NPP DNP
4      NP      yes      NPP RN
4      NP      yes      OGNP RNC
4      NP      yes      PAC FNP
4      NP      yes      PC CRNP
4      NP      yes      PC PMHNP
4      NP      yes      PC PNP-AC
4      NP      yes      PCNS-BC DNP
4      NP      yes      PHD AGPCNP-BC
4      NP      yes      PHD CNP
4      NP      yes      PHD FNP-C
4      NP      yes      PHD NP-C
4      NP      yes      PHD PNP-BC
4      NP      yes      PHD RNP
4      NP      yes      PHD WHNP-BC
4      NP      yes      PHMNP-BC APRN
4      NP      yes      PLLC ARNP
4      NP      yes      PMH APRN-NP
4      NP      yes      PMH FNP
4      NP      yes      PMH NP
4      NP      yes      PMH-NP APRN
4      NP      yes      PMH-NP APRN-BC
4      NP      yes      PMH-NP MSN
4      NP      yes      PMHCNS-BC ANP
4      NP      yes      PMHCNS-BC APN
4      NP      yes      PMHCNS-BC ARNP
4      NP      yes      PMHCNS-BC NP
4      NP      yes      PMHCNS-BC PMHNP-BC
4      NP      yes      PMHNP APRN-BC
4      NP      yes      PMHNP PHD
4      NP      yes      PS ARNP
4      NP      yes      RN ACNP
4      NP      yes      RN ARNP
4      NP      yes      RNAPNC NP
4      NP      yes      MSNCNP RN
4      NP      yes      MSNFNP RN
4      NP      yes      MSNFNP-BC APRN
4      NP      yes      MSNFNP-BC NP
4      NP      yes      MSNFNP-BC RN
4      NP      yes      MSNNP-C NP
4      NP      yes      MSNNP-C RN
4      NP      yes      ND APN-FNP
4      NP      yes      ND ARNP
4      NP      yes      ND FNP-BC
4      NP      yes      NP ANP-BC
4      NP      yes      PHD GNP-BC
4      NP      yes      PHD PMHNP-BC
4      NP      yes      RN PNP-BC
4      NP      yes      MSN ACNP-BC
4      NP      yes      MSN ACNP-C
4      NP      yes      MSN AGNP
4      NP      yes      MSN AGNP-C
4      NP      yes      MSN ANP
4      NP      yes      MSN CFNP
4      NP      yes      MSN CNNP
4      NP      yes      MSN CPNP-AC
4      NP      yes      MSN FPMHNP
4      NP      yes      MSN NP-BC
4      NP      yes      MSN PMHNP
4      NP      yes      MSN PNP
4      NP      yes      MSN PNP-AC
4      NP      yes      MSN RNCNP
4      NP      yes      MSN-AGNP MSN-FNP
4      NP      yes      MSN-CRNA NP
4      NP      yes      MSN-FNP MS
4      NP      yes      MSN-FNP RN
4      NP      yes      MSN-FNP-C RN
4      NP      yes      MSN-NNP APRN
4      NP      yes      MSNA ARNP
4      NP      yes      MSNA NP
4      NP      yes      MSNAPN-C NP
4      NP      yes      MSNAPRN NP
4      NP      yes      MSNAPRNFNP-C
4      NP      yes      -FNP APRN
4      NP      yes      A-GNP-C
4      NP      yes      A-GNP-C ACNS-BC
4      NP      yes      A-GNP-C APNP
4      NP      yes      ACHPN ANP-BC
4      NP      yes      ACNS-BC DNP
4      NP      yes      ACNS-BC NP-C
4      NP      yes      APNFNP-BC MSN
4      NP      yes      APRN CFNP
4      NP      yes      APRN CNP
4      NP      yes      APRN-BC DNP
4      NP      yes      APRN-CNP MSN
4      NP      yes      APRN-PMH CRNP
4      NP      yes      APRNFNP MSN
4      NP      yes      C-FNP APRN
4      NP      yes      C-FNP MS
4      NP      yes      CFNP APN
4      NP      yes      CFNP BSN
4      NP      yes      CFNP CNM
4      NP      yes      CFNP NP
4      NP      yes      CNM CFNP
4      NP      yes      CNS-BC PMHNP
4      NP      yes      CNS-BC PMHNP-BC
4      NP      yes      CNS-MS FNP-BC
4      NP      yes      LLC PMHNP
4      NP      yes      BS FNP-C
4      NP      yes      CNMNP MS
4      NP      yes      CNNP MSRN
4      NP      yes      CNS ACNP
4      NP      yes      CNS ACNP-BC
4      NP      yes      CNS ANP
4      NP      yes      CNS ARNP
4      NP      yes      CNS CNP
4      NP      yes      CNS-BC FPMHNP-BC
4      NP      yes      MHS FNP
4      NP      yes      MSCPNP
4      NP      yes      MSCPNP RN
4      NP      yes      MSCS RN
4      NP      yes      MS ACNP
4      NP      yes      MS AGACNP-BC
4      NP      yes      MS CPNP
4      NP      yes      MS CRNP
4      NP      yes      MS GNP
4      NP      yes      MS WHNP-BC
4      NP      yes      MSC NP
4      NP      yes      MSFNP PHD
4      NP      yes      MASTERS PMHNP
4      NP      yes      MS CFNP
4      NP      yes      ENP FNP
4      NP      yes      ENP MSN
4      NP      yes      MN ANP
4      NP      yes      MN ANPC
5      PA      yes      RPA-C
5      PA      yes      RPA
5      PA      yes      PA
5      PA      yes      NCCPA
5      PA      yes      MPAS
5      PA      yes      MPAP
5      PA      yes      PA-C
5      PA      yes      PAC
5      PA      yes      PA-C MS
5      PA      yes      PA-C MPAS
5      PA      yes      PA-C MMS
5      PA      yes      MSPAS
5      PA      yes      MPA
5      PA      yes      MSPA
5      PA      yes      MPAS PA-C
5      PA      yes      PA-C PA
5      PA      yes      PA MS
5      PA      yes      RPAC
5      PA      yes      PA-C MSPAS
5      PA      yes      PA-C MPA
5      PA      yes      PA MPAS
5      PA      yes      MSPA-C
5      PA      yes      MMS PA-C
5      PA      yes      PA-C MMSC
5      PA      yes      MS PA-C
5      PA      yes      MPH PA-C
5      PA      yes      PA-C MPH
5      PA      yes      MPAS PA
5      PA      yes      PA MMS
5      PA      yes      PA-C MPAP
5      PA      yes      PA-C MSPA
5      PA      yes      MPA-C
5      PA      yes      PA DPM
5      PA      yes      PA PA
5      PA      yes      MS PA
5      PA      yes      PAC MS
5      PA      yes      MHS PA-C
5      PA      yes      PA-C BS
5      PA      yes      PA-C MSBS
5      PA      yes      MPASPA-C
5      PA      yes      PA DVM
5      PA      yes      PA OD
5      PA      yes      MMSC PA
5      PA      yes      MSPAS PA-C
5      PA      yes      PA-C MSM
5      PA      yes      MPH MSPAS
5      PA      yes      PA MMSC
5      PA      yes      PA PHD
5      PA      yes      PA-CMPAS
5      PA      yes      RPA-C MS
5      PA      yes      MMSC PA-C
5      PA      yes      MS-PAS
5      PA      yes      PA-C MSHS
5      PA      yes      PA SR
5      PA      yes      PA BS
5      PA      yes      PA-C PHD
5      PA      yes      MPAS PAC
5      PA      yes      MS-PA-C
5      PA      yes      PA MPH
5      PA      yes      R-PAC
5      PA      yes      MPASPA
5      PA      yes      MHSPA-C
5      PA      yes      MPAP PA-C
5      PA      yes      MPH PA
5      PA      yes      MS-PA
5      PA      yes      MS-PAC
5      PA      yes      PA-C MASTERS
5      PA      yes      PHD PA
5      PA      yes      MSPASMPH
5      PA      yes      MSPAC
5      PA      yes      MMS PA
5      PA      yes      BS PA-C
5      PA      yes      MPAC
5      PA      yes      MPAS BS
5      PA      yes      MPAS-C
5      PA      yes      MPH MPAS
5      PA      yes      MSHS PA-C
5      PA      yes      PA MSPAS
5      PA      yes      RPA-C PA
5      PA      yes      MMSPA-C
5      PA      yes      MHS PA
5      PA      yes      MSPA PA-C
5      PA      yes      PA MSHS
5      PA      yes      PA-C MCMSC
5      PA      yes      PA-CMPH
5      PA      yes      MPA PA-C
5      PA      yes      MPA-S
5      PA      yes      MS PAC
5      PA      yes      NCCPA PA
5      PA      yes      NPPA
5      PA      yes      PA FACS
5      PA      yes      PA MASTERS
5      PA      yes      PA-
5      PA      yes      PA-C NP
5      PA      yes      PA-C SR
5      PA      yes      PAC MPAS
5      PA      yes      PAC PA
5      PA      yes      PAS
5      PA      yes      PAS MS
5      PA      yes      PHD PA-C
5      PA      yes      RPA PA
5      PA      yes      RPA-C MPAS
5      PA      yes      RPAC MS
5      PA      yes      R-PA
5      PA      yes      BS PA
5      PA      yes      BSPA-C
5      PA      yes      M-PAS
5      PA      yes      MASTERS PA-C
5      PA      yes      MBA PA-C
5      PA      yes      MHP PA-C
5      PA      yes      MPAS RPA
5      PA      yes      MPAS RPA-C
5      PA      yes      MPHPA-C
5      PA      yes      MS MPAS
5      PA      yes      MS RPA-C
5      PA      yes      MA PA
5      PA      yes      PA MBA
5      PA      yes      PA MCMSC
5      PA      yes      PA MPA
5      PA      yes      PA MSPA
5      PA      yes      PA--C
5      PA      yes      PA-C BA
5      PA      yes      PA-C MHP
5      PA      yes      PA-C MHSC
5      PA      yes      PA-C MS-PAS
5      PA      yes      PA-C PHARMD
5      PA      yes      PA-CMMS
5      PA      yes      PA-CMS
5      PA      yes      PAC MMS
5      PA      yes      PAC MPA
5      PA      yes      RPA MPAS
5      PA      yes      RPA MS
5      PA      yes      NP PA
5      PA      yes      NP PA-C
5      PA      yes      PHARMD PA-C
5      PA      yes      MPAS PHD
5      PA      yes      MPAS-PAC
5      PA      yes      MSPASPA
5      PA      yes      MSBSPA-C
5      PA      yes      MSRPA-C
5      PA      yes      PA BDS
5      PA      yes      PA BSC
5      PA      yes      PA BSMS
5      PA      yes      PA CM
5      PA      yes      PA CNP
5      PA      yes      PA DDSMD
5      PA      yes      PA FAAP
5      PA      yes      PA FACC
5      PA      yes      PA FACP
5      PA      yes      PA FNP
5      PA      yes      PA FNP-C
5      PA      yes      PA FORBES
5      PA      yes      PA KY
5      PA      yes      PA LD
5      PA      yes      PA LR
5      PA      yes      PA MF
5      PA      yes      PA MI
5      PA      yes      PA MP
5      PA      yes      PA MPAP
5      PA      yes      PA MSBS
5      PA      yes      PA MSM
5      PA      yes      PA PAS
5      PA      yes      PA PECK
5      PA      yes      PA PHUOC
5      PA      yes      PA RPAC
5      PA      yes      PA VMD
5      PA      yes      PA-C ARNP
5      PA      yes      PA-C BSHS
5      PA      yes      PA-C BSMS
5      PA      yes      PA-C BSN
5      PA      yes      PA-C JD
5      PA      yes      PA-C MA
5      PA      yes      PA-C MBA
5      PA      yes      PA-C MED
5      PA      yes      PA-C MLP
5      PA      yes      PA-C MMA
5      PA      yes      PA-C MPS
5      PA      yes      PA-C MSPH
5      PA      yes      PA-C NMD
5      PA      yes      RPA-C BS
5      PA      yes      RPA-C BSC
5      PA      yes      RPA-C MASTERS
5      PA      yes      RPA-C MPH
5      PA      yes      RPA-C MPS
5      PA      yes      RPA-C MSHS
5      PA      yes      MCMSC PA
5      PA      yes      MPH MSPA
5      PA      yes      APA-C
5      PA      yes      APA-C MPAS
5      PA      yes      BS-PA-C
5      PA      yes      BSBA PA-C
5      PA      yes      BSHS PA-C
5      PA      yes      CNM PA
5      PA      yes      CNM PA-C
5      PA      yes      PHD MPAS
5      PA      yes      PHD PAC
5      PA      yes      PLLC PA-C
5      PA      yes      R-PAC MS
5      PA      yes      RN-PA-C
5      PA      yes      MSPAS PAC
5      PA      yes      MSPAS PHD
5      PA      yes      MSPASMPH PA
5      PA      yes      PAC PHD
5      PA      yes      PAC RN
5      PA      yes      MSN PA
5      PA      yes      MSN PA-C
5      PA      yes      APRN PA
5      PA      yes      BS MPAS
5      PA      yes      BSPA MPAS
5      PA      yes      MCMSC PA-C
5      PA      yes      MSHS PA
5      PA      yes      MSHS RPA-C
5      PA      yes      MSM PA-C
5      PA      yes      MPA PA
5      PA      yes      MPA RPA-C
5      PA      yes      MPA-C PA
5      PA      yes      MPAS MS
5      PA      yes      MPH PAC
5      PA      yes      MS MPA
5      PA      yes      MS-PA-C PA
5      PA      yes      MSC PA
5      PA      yes      MED MPAS
5      PA      yes      MHS PAC
5      PA      yes      MS RPAC
5      PA      yes      MMS PAC
5      PA      yes      MPA MPH
5      PA      yes      MHP PA
5      PA      yes      MPH MPA
5      PA      yes      MPH MPAP
5      PA      yes      AAHIVS PA
6      DPM      yes       MPH DPM
6      DPM      yes      DPM
6      DPM      yes      PC DPM
6      DPM      yes      MS DPM
6      DPM      yes      DPM SR
6      DPM      yes      PHD DPM
6      DPM      yes      PLLC DPM
6      DPM      yes      PS DPM
6      DPM      yes      LTD DPM
6      DPM      yes      PROF DPM
6      DPM      yes      DPM DR
6      DPM      yes      DPM DS
6      DPM      yes      DPM KY
6      DPM      yes      DPM MS
6      DPM      yes      DPM PA
6      DPM      yes      DPM PHD
6      DPM      yes      DR DPM
6      DPM      yes      LLC DPM
6      DPM      yes      MA DPM
6      DPM      yes      MED DPM
6      DPM      yes      MHA DPM
6      DPM      yes      ND DPM
6      DPM      yes      PLC DPM
7      OD      yes       OPTOMETRIST
7      OD      yes      OD
7      OD      yes      PC OD
7      OD      yes      MS OD
7      OD      yes      PHD OD
7      OD      yes      OPTOMETRY
7      OD      yes      OD SR
7      OD      yes      OD MS
7      OD      yes      LLC OD
7      OD      yes      DOCTOR OPTOMETRY
7      OD      yes      OD DR
7      OD      yes      OD FORBES
7      OD      yes      OD DVM
7      OD      yes      OD JD
7      OD      yes      OD MP
7      OD      yes      OD PS
7      OD      yes      MED OD
7      OD      yes      MPH OD
8      DVM      yes       PC DVM
8      DVM      yes       MSPH DVM
8      DVM      yes      DVM
8      DVM      yes      VMD
8      DVM      yes      PHD VMD
8      DVM      yes      MS VMD
8      DVM      yes      VMD MS
8      DVM      yes      PC VMD
8      DVM      yes      LLC VMD
8      DVM      yes      MPH VMD
8      DVM      yes      CVMA VMD
8      DVM      yes      MSC VMD
8      DVM      yes      ACVS
8      DVM      yes      MS DVM
8      DVM      yes      PHD DVM
8      DVM      yes      MPH DVM
8      DVM      yes      DVM MS
8      DVM      yes      DVM PHD
8      DVM      yes      CVA DVM
8      DVM      yes      MPVM DVM
8      DVM      yes      DVM DR
8      DVM      yes      DVM SR
8      DVM      yes      DVMMS
8      DVM      yes      DVMPHD
8      DVM      yes      EDVM
8      DVM      yes      MBA DVM
8      DVM      yes      MRCVS DVM
8      DVM      yes      BVMS DVM
8      DVM      yes      DDVM
8      DVM      yes      BVSC DVM
8      DVM      yes      DVM ARN
8      DVM      yes      DVM BS
8      DVM      yes      DVM MRCVS
8      DVM      yes      DVMDACVIM
8      DVM      yes      DVMMPH
8      DVM      yes      ACVS DVM
8      DVM      yes      PSC DVM
8      DVM      yes      MSC DVM
8      DVM      yes      PS DVM
8      DVM      yes      RPH DVM
8      DVM      yes      DR DVM
8      DVM      yes      DVM BSC
8      DVM      yes      DVM BVSC
8      DVM      yes      DVM CM
8      DVM      yes      DVM DO
8      DVM      yes      DVM DPM
8      DVM      yes      DVM KY
8      DVM      yes      DVM LR
8      DVM      yes      DVM MED
8      DVM      yes      DVM MP
8      DVM      yes      DVM PA
8      DVM      yes      DVM RN
8      DVM      yes      DVM VMD
8      DVM      yes      LLC DVM
8      DVM      yes      MMS DVM
8      DVM      yes      MPA DVM
8      DVM      yes      JD DVM
8      DVM      yes      BS DVM
6      DPM      yes      MBA DPM
8      DVM      yes      MRCVS
1b      MD      maybe      MDMS
1b      MD      maybe      MED
1b      UNK      maybe      PC DR
1b      MD      maybe      MSM MED
2b      DO      maybe      DO BA
2b      DO      maybe      DO BS
2b      DO      maybe      DO CM
2b      DO      maybe      DO FM
2b      DO      maybe      DO JD
2b      DO      maybe      DO MA
2b      DO      maybe      DO PECK
2b      DO      maybe      DO PS
3b      dentist      maybe      MDS
3b      dentist      maybe      PC MSD
3b      dentist      maybe      MDSC
3b      dentist      maybe      PS MSD
3b      dentist      maybe      MPH MSD
3b      dentist      maybe      MSD
3b      dentist      maybe      MS MDS
3b      dentist      maybe      PHD MDS
3b      dentist      maybe      MDM
3b      dentist      maybe      MDMPM
3b      dentist      maybe      MDMSC
3b      Dentist       maybe      MSD BDS
3b      dentist      maybe      CDDS
4b      nurse      maybe      RN
4b      nurse      maybe      PCNS-BC
4b      nurse      maybe      NMW
4b      nurse      maybe      APRN MSN
4b      nurse      maybe      MNMPH
4b      nurse      maybe      MNSC APN
4b      nurse      maybe      MSN
4b      nurse      maybe      MNSC
4b      nurse      maybe      MPH MSN
4b      nurse      maybe      RNCS
4b      nurse      maybe      DNSC
4b      nurse      maybe      CNS
4b      nurse      maybe      CRNA
4b      nurse      maybe      CPN
4b      nurse      maybe      CNM
4b      nurse      maybe      CNM MS
4b      nurse      maybe      MS CNM
4b      nurse      maybe      CNM RN
4b      nurse      maybe      CNW
4b      nurse      maybe      BS CNM
4b      nurse      maybe      CM
4b      Nurse      maybe      NPCNM
4b      nurse      maybe      CMW
4b      nurse      maybe      MS CM
4b      nurse      maybe      CWCN
4b      nurse      maybe      MN CNM
4b      nurse      maybe      MPH CNM
4b      Nurse      maybe      MS-CNM
4b      nurse      maybe      PHD CNM
4b      nurse     maybe      APRN
4b      nurse      maybe      APN
4b      nurse      maybe      MSN
4b      Nurse      maybe      AGCNS-BC
4b      nurse      maybe      APRN-CRNA
4b      nurse      maybe      APRN-BC
4b      nurse       maybe      CNM MSN
4b      nurse      maybe      MSN CNM
4b      nurse      maybe      CRNA APRN
4b      nurse      maybe      APRNMSN
4b      nurse      maybe      CNM APRN
4b      nurse      maybe      MSN APRN
4b      nurse      maybe      APN-C
4b      nurse      maybe      MSN RN
4b      nurse      maybe      CRNA MSN
4b      nurse      maybe      APRN-BC MSN
4b      nurse      maybe      APN-BC
4b      nurse      maybe      CS RN
4b      nurse      maybe      MSN BSN
4b      nurse      maybe      CRNA APN
4b      nurse      maybe      APN-C MSN
4b      nurse      maybe      APRN MS
4b      nurse      maybe      PMHCNS-BC
4b      nurse      maybe      MSN CRNA
4b      nurse      maybe      APRNBC
4b      nurse      maybe      MSNA
4b      nurse      maybe      APRN CRNA
4b      nurse      maybe      RN MSN
4b      nurse      maybe      CNS MSN
4b      nurse      maybe      APRN-C
4b      nurse      maybe      MS CRNA
4b      nurse      maybe      APNC
4b      nurse      maybe      APRNCNSPMH
4b      nurse      maybe      MSNAPRN
4b      nurse      maybe      APRN CNM
4b      nurse      maybe      APN-BC MSN
4b      nurse      maybe      CNS APRN
4b      nurse      maybe      CNS RN
4b      nurse      maybe      MSN-APRN
4b      nurse      maybe      MSNAPN
4b      nurse      maybe      MSNCNM
4b      nurse      maybe      RNC
4b      nurse      maybe      APN CRNA
4b      nurse      maybe      CRNA MS
4b      nurse      maybe      MS RN
4b      nurse      maybe      MSN PHD
4b      nurse      maybe      APN MS
4b      nurse      maybe      PHD MSN
4b      nurse      maybe      PCNS
4b      nurse      maybe      RN MS
4b      nurse      maybe      NURSE
4b      nurse      maybe      ACNS-BC MSN
4b      nurse      maybe      APRN PHD
4b      nurse      maybe      BSN MSN
4b      nurse      maybe      CNM APN
4b      Nurse      maybe      RNPC
4b      nurse      maybe      MIDWIFE NURSE
4b      nurse      maybe      APN RN
4b      nurse      maybe      APRN-C MSN
4b      nurse      maybe      MSNMPH
4b      nurse      maybe      APRN RN
4b      nurse      maybe      CNS APN
4b      nurse      maybe      CRN
4b      nurse      maybe      MSNCRNA
4b      nurse      maybe      APRN-BC RN
4b      nurse      maybe      BSNMSN
4b      nurse      maybe      BSN MSN
4b      nurse      maybe      APN CNM
4b      nurse      maybe      APN MNSC
4b      nurse      maybe      APN PHD
4b      nurse      maybe      APRN-CNM
4b      nurse      maybe      ARPN
4b      nurse      maybe      MSAPRN
4b      nurse      maybe      PMHCNS-BC APRN
4b      nurse      maybe      RNC MSN
4b      nurse      maybe      CNS MS
4b      nurse      maybe      CNM PHD
4b      nurse      maybe      CRNA BSN
4b      nurse      maybe      CRNA DNAP
4b      nurse      maybe      MSN-CRNA
4b      nurse      maybe      MSNAPRN-BC
4b      nurse      maybe      APRN CNS
4b      nurse      maybe      APRN MN
4b      nurse      maybe      APRN-BC MS
4b      nurse      maybe      MS APRN
4b      nurse       maybe      MSN MS
4b      nurse       maybe      PMHCNS-BC MS
4b      nurse       maybe      PMHCNS-BC MSN
4b      nurse       maybe      RN PHD
4b      nurse      maybe      ACNS
4b      nurse      maybe      ACNS-BC RN
4b      nurse      maybe      APRN MNSC
4b      nurse      maybe      CCNS
4b      nurse      maybe      CNS-BC
4b      nurse      maybe      MSNC
4b      nurse      maybe      MIDWIFE
4b      nurse      maybe      MN BSN
4b      nurse      maybe      NURSE-MIDWIFE
4b      nurse      maybe      CRNA BS
4b      nurse      maybe      CRNA MSNA
4b      nurse      maybe      DNAP CRNA
4b      nurse      maybe      MSNA CRNA
4b      nurse      maybe      APN-A
4b      nurse      maybe      APN-C MS
4b      nurse      maybe      APNC MSN
4b      nurse      maybe      APNCNS
4b      nurse      maybe      APRN-CNS
4b      nurse      maybe      APRNBC MSN
4b      nurse      maybe      CNS MN
4b      nurse      maybe      CNS PMH
4b      nurse      maybe      CS MSN
4b      nurse       maybe      MS MSN
4b      nurse       maybe      MSN APN
4b      nurse       maybe      MSN APRN-BC
4b      nurse       maybe      ACNS-BC MS
4b      nurse       maybe      ENP RN
4b      nurse      maybe      RNCS MSN
4b      nurse      maybe      RNMSN
4b      nurse      maybe      DMSN
4b      nurse      maybe      MS RNC
4b      nurse      maybe      MSRN
4b      nurse      maybe      APRNCRNA
4b      nurse      maybe      CNSPMH APRN
4b      nurse      maybe      CS APRN
4b      nurse      maybe      MHS CRNA
4b      nurse      maybe      PHD CRNA
4b      nurse       maybe      MSN RNC
4b      nurse       maybe      MSN-ANESTHESIA
4b      nurse       maybe      MSN-APN
4b      nurse       maybe      MSN-RN
4b      nurse       maybe      MSNCNS
4b      nurse      maybe      ND MSN
4b      nurse      maybe      PHD APRN
4b      nurse      maybe      RN BSN
4b      nurse      maybe      APRN CS
4b      nurse      maybe      APRN-BC PHD
4b      nurse      maybe      APRNNM
4b      nurse      maybe      LLC APRN
4b      nurse      maybe      MSN NNP
4b      nurse      maybe      APN CNS
4b      nurse      maybe      APN-BC RN
4b      nurse      maybe      APNBC
4b      nurse      maybe      APNC RN
4b      nurse      maybe      APNMSN
4b      nurse      maybe      APPN MS
4b      nurse      maybe      APRNCNS
4b      nurse      maybe      ARN
4b      nurse      maybe      CNS PHD
4b      nurse      maybe      CNS-BC MSN
4b      nurse      maybe      CNS-MS
4b      nurse      maybe      CNS-PP
4b      nurse      maybe      CS ANP
4b      Nurse      maybe      MN RN
4b      Nurse      maybe      MS CNS
4b      nurse      maybe      CNMAPRN
4b      nurse      maybe      PC RN
4b      nurse      maybe      PMH CNS
4b      nurse      maybe      PMH-CNS
4b      nurse      maybe      PMHCNS-BC PHD
4b      nurse      maybe      RNAPN-C
4b      nurse      maybe      RNCMS
4b      nurse      maybe      RNCNM
4b      nurse      maybe      RNCNS
4b      nurse      maybe      CNM MN
4b      nurse      maybe      CNM MSM
4b      nurse      maybe      MMSN
4b      Nurse      maybe      MSNRNCS
4b      Nurse      maybe      MSRNCS
4b      nurse      maybe      CRNA MA
4b      nurse      maybe      CRNA MN
4b      nurse      maybe      CRNA PHD
4b      nurse      maybe      NURSE MS
4b      nurse      maybe      RNC APRN
4b      nurse      maybe      MSNMPH APRN
4b      nurse       maybe      ND APRN
4b      nurse       maybe      PC APRN
4b      nurse       maybe      PC MSN
4b      nurse       maybe      PCNS-BC APRN
4b      nurse       maybe      RN APN
4b      nurse       maybe      RN APRN-BC
4b      nurse       maybe      RN BS
4b      nurse       maybe      RN CNM
4b      nurse       maybe      RN CNS-BC
4b      nurse       maybe      RN CRNA
4b      nurse       maybe      RN MN
4b      nurse       maybe      RNAPNC
4b      nurse       maybe      RNC BSN
4b      nurse       maybe      RNC MS
4b      nurse       maybe      RNCS MS
4b      nurse      maybe      MSN JD
4b      nurse      maybe      MSN LR
4b      nurse      maybe      MSN MI
4b      nurse      maybe      MSN PC
4b      nurse       maybe      ACNS-BC APRN
4b      nurse       maybe      AGCNS-BC MSN
4b      nurse       maybe      APN RNC
4b      nurse       maybe      APN RNFA
4b      nurse       maybe      APN-A MSN
4b      nurse       maybe      APN-BC APRN
4b      nurse       maybe      APN-BC MS
4b      nurse       maybe      APN-BC RNC
4b      nurse       maybe      APN-C RN
4b      nurse       maybe      APNCNS MS
4b      nurse       maybe      APNCNS MSN
4b      nurse       maybe      APRN
4b      nurse       maybe      CRNA
4b      nurse       maybe      APN
4b      nurse       maybe      CNM
4b      nurse       maybe      APRN PC
4b      nurse       maybe      APRN-BC MBA
4b      nurse       maybe      APRN-BC PMH-CNS
4b      nurse       maybe      APRN-BC RNCS
4b      nurse       maybe      APRN-C PHD
4b      nurse       maybe      APRN-C RN
4b      nurse       maybe      APRN-CNM MSN
4b      nurse       maybe      APRN-CNS MSN
4b      nurse       maybe      APRN-PMH
4b      nurse       maybe      ARPN MSN
4b      nurse       maybe      BS CRNA
4b      Nurse      maybe      CNS APRN-BC
4b      Nurse      maybe      CNS APRNMSN
4b      Nurse      maybe      CNS-BC APN
4b      Nurse      maybe      CNS-BC APRN
4b      Nurse      maybe      CNS-PP RN
4b      Nurse      maybe      CRN MSN
4b      Nurse      maybe      CRNA RN
4b      Nurse      maybe      CS MSRN
4b      nurse       maybe      MSN BS
4b      nurse       maybe      MSN CM
4b      nurse       maybe      MSN CNS
4b      nurse       maybe      MSN RNCS
4b      nurse       maybe      MSN-APRN MA
4b      nurse       maybe      MSNA BSN
4b      nurse       maybe      MSNC RN
4b      nurse       maybe      MSPA BA
4b      nurse       maybe      MSPH MSN
4b      nurse       maybe      BSN RN
4b      nurse      maybe      PHD RN
4b      nurse      maybe      MMA APRN
4b      nurse      maybe      MN APRN
4b      nurse      maybe      MS APN
4b      nurse      maybe      MS APN-A
4b      nurse      maybe      MS APN-BC
4b      nurse      maybe      MSN ACNS-BC
4b      nurse      maybe      PCNS APN
4b      nurse      maybe      PCNS MS
4b      nurse      maybe      PHD ACNS
4b      nurse      maybe      PMH-CNS APRN
4b      nurse      maybe      PMHCNS-BC RN
4b      nurse      maybe      PMHCNS-BC RNPC
4b      nurse      maybe      RDMS CNM
4b      nurse      maybe      MA CRNA
4b      nurse      maybe      PHD APN
4b      nurse      maybe      MA MSN
4b      nurse      maybe      MSN BA
4b      nurse      maybe      APN ACNS-BC
4b      nurse      maybe      APRNCNSPMH MS
4b      nurse      maybe      CCNS MS
4b      nurse      maybe      CCNS MSN
4b      nurse      maybe      CNS-BC PMH
4b      nurse      maybe      CS RNC
4b      nurse       maybe       ACNS-BC
4b      nurse       maybe       APRN CNS-BC
4b      nurse       maybe       APRN CNSPMH
4b      nurse       maybe       APRN DM
4b      nurse       maybe       APRN DNAP
4b      nurse       maybe       APRN DNSC
4b      nurse       maybe       APRN RNC
4b      nurse       maybe       APRNBC MA
4b      nurse       maybe       CNM APRN-BC
4b      nurse       maybe       CNM APRNMSN
4b      nurse       maybe       CNM BSN
4b      nurse       maybe       CNM CNM
4b      nurse       maybe       CNM DR
4b      nurse       maybe       CNM FORBES
5b      PA      maybe      MHSPA
5b      PA      maybe      BSPA
6b      DPM      maybe      DPMPC
6b      DPM      maybe      PDPM
8b      DVM      maybe      MPVM MPH
8b      veterinarian      maybe      PHD MPVM
8b      DVM      maybe      ADVM
8b      DVM      maybe      LDVM
8b      DVM      maybe      MDVM
8b      UNK      maybe      CDVM
8b      DVM?      maybe      FDVM
8b      DVM?      maybe      HDVM
8b      DVM      maybe      PDVM
9b      Pharmacist      maybe      RPH
9b      Pharmacist      maybe      PHC RPH
9b      Pharmacist      maybe      PHARMD
9b      pharmacist      maybe      CPP PHARMD
9b      Pharmacist      maybe      CPP
9b      pharmacist      maybe      CPP RPH
9b      pharmacist      maybe      DO PHARMD
9b      pharmacist      maybe      PHARMD PHC
no  no          no?      CS MS
no  no          no?      PHD SMD
no  no          no?      PHD AMD
no  no          no       ND
no  no          no       MSC
no  no          no       BS
no  no          no       MSBS
no  no          no       MBA MS
no  no          no      BVMS BSC
no  no          no      MS BVMS
no  no          no      NPP MS
no  no          no      NMD
no  no    nurse       no      MN
no  no          no      MPHMMS
no  no          no      MSPH MMS
no  no          no      MMSCPA
no  no          no      MMS
no  no          no      MHS
no  no          no      MSCP
no  no          no      MSCP PHD
no  no          no      MSA
no  no          no      MSM
no  no          no      MPH MMSC
no  no          no      MMSC
no  no          no      PC MMSC
no  no          no      MLP
no  no          no      DC-APC
no  no          no      APC MS
no  no          no      AAHIVS MS
no  no          no      CPE MBA
no  no          no      CWS
no  no          no      BVMS
no  no          no      BDS
no  no          no      MS BDS
no  no          no      MDS BDS
no  no          no      PHD BDS
no  no          no      BDS MPH
no  no          no      BDS MS
no  no          no      BVSC
no  no          no      BSC
no  no          no      PHD BVSC
no  no          no      PCS
no  no          no      APC
no  no          no      PC CS
no  no          no      PHD CS
no  no          no      CVMA
no  no          no      BSHS
no  no          no      MS CS
no  no          no      MS
no  no          no      PHD_2
no  no          no      JMD
no  no          no      MASTERS
no  no          no      PC
no  no          no      MA
no  no          nurse      BSN
no  no          no      MP PHD
no  no          no      MPH PHD
no  no          no      PC MS
no  no          no      PHD MS
no  no          no      MRCVS BVMS
no  no          no      MPH
no  no          no      MPH MS
no  no          no      JDVM
no  no          no      LLC
no  no          nurse      BSN MS
no  no          no      MBA MPH
no  no          no      MPH MMS
no  no          no      PHD MPH
no  no          no      BSMS
no  no          no      MBA MSN
no  no          no      MPH MN
no  no          no      MRS
no  no          no      MS MPH
no  no          no      MS PHD
no  no          No      BA
no  no          no      MS BSN
no  no          no      PHD MSC
no  no          no      MBA PHD
no  no          no      LLC MS
no  no          no      MPH MSHS
no  no          no      MS BS
no  no          no      MA MPH
no  no          no      PLLC MS
no  no          no      ND PHD
no  no          no      MPH ND
no  no          no      PHD MSD
no  no          no      DOCTORATE
no  no          no      ND MS
no  no          no      MPH BS
no  no          no      MPH MBA
no  no          no      MS MA
no  no          no      MS MS
no  no          no      MSC PHD
no  no          no      JD
no  no          no      MBA
no  no          no      MHS MPH
no  no          no      PHD BS
no  no          no      LTD
no  no          no      JD MPH
no  no          no      JD PHD
no  no          no      LLC ND
no  no          no      LLC PROF
no  no          no      PROF
no  no          no      MPH JD
no  no          no      MS MBA
no  no          no      PS MPH
no  no          no      PS MS
no  no          no      PC MPH
no  no          no      PC ND
no  no          no      PC PHD
no  no          no      PDC MS
no  no          no      LTD MS
no  no          no      MA BSN
no  no          no      MA MA
no  no          no      MASTERS BSN
no  no          no      MN MPH
no  no          no      MN MSC
no  no          no      MN PHD
no  no          no      MPH MSC
no  no          no      MSC MPH
no  no          no      MSC MS
no  no          no      ND DOCTOR
no  no          no      ND MPH
no  no          no      NMD ND
no  no          nurse      BSN MA
no  no          nurse      BSN MHA
no  no          nurse      BSN MN
no  no          nurse      BSN PHD
no  no          no      BS JD
no  no          no      MS ND
no  no          no      MED PROF
no  no          no      MHA MS
no  no          no      MSPH PHD
no  no          no      APMC
no  no          no      BSBA
no  no          no      MBA MMD
no  no          no      MCMSC
no  no          no      MHP
no  no          no      MHS PHD
no  no          no      MHSC
no  no          no      MMA
no  no          no      MPH MHA
no   no  no               RAMON
no   no  no               ALEX
no   no  no               MOHAN
no   no  no               BOYD
no   no  no               MOORE
no   no  no               BLAINE
no   no  no               ROLAND
no   no  no               MONIQUE
no   no  no               OMAR
no   no  no               ANGELICA
no   no  no               FLORENCE
no   no  no               BECK
no   no  no               EDMUNDO
no   no  no               FLETCHER
no   no  no               KY
no   no  no               LD
no   no  no               LK
no   no  no               ABEL
no   no  no               MEHDI
no   no  no               PHUOC
no   no  no               ARTA-LUANA ARTA-LUANA
no   no  no               FORBES
no   no  no               PECK
no   no  no               ALEXDUP
no   no  no               FLORENCE MA
no   no  no               MI MI
no   no  no               SR
no   no  no             MP
no   no  no             APR
no   no   DMD            IIIDMD
no   no   no            MIA
no   no   no            MF
no   no   MD            AMD
no   no   MD            MMD
no   no   no            NPF
no   no   MD            RMD
no   no   MD            CMD
no   no   MD            SMD
no   no   DDS             MDDS
no   no   no            DMV
no   no   DDS             SDDS
no   no   no            RNA
no   no   DDS             RDDS
no   no   MD            SDMD
no  no  no                ADPM
no  no  no                DDO
no  no  no                DDSP
no  no  no                KPA
no  no  no                MDO
no  no  no                MDP
no  no  no                PHC
no  no    MD            ZMD
no  no    MD            FDMD
no  no    DO            D0
no  no  no                LN
no  no  no                LR
no  no  no                MDD
no  no    DO            SDO
no  no    no                PHDC
no  no    DDS             IDDS
no  no    DDS             IIDDS
no  no    DO            IIDO
no  no    MD            FMD
no  no    MD            PMD
no  no    MD            GMD
no  no    MD            HMD
no  no    MD            IMD
no  no    MD            BMD
no  no    MD            JRMD
no  no    MD            KMD
no  no    MD            TMD
no  no    MD            OMD
no  no    MD            ADMD
no  no    MD            IIIMD
no  no    MD            MDPH
no  no  no                PS
no  no  no                CS
no  no  no                DS
no  no  no                FM
no  no  no                FPA
no  no  no                MPH MMD
no  no  no                DVN
no  no  no                DVN DM
;;;;
;run;quit;

proc sort data=phy.&pgm._edddoc force
   out=PHY.&pgm._profPre(index=(edd_sufix/unique)) nodupkey;
by edd_sufix;
run;quit;

data &pgm._ctl;
  retain fmtname "$&pgm._cred2prof";
  set PHY.&pgm._profPre;
  start=edd_sufix;
  end=start;
  label=edd_professions;
  keep fmtname start end label;
run;quit;

proc format lib=phy.phy_formats cntlin=&pgm._ctl;
run;quit;
%let pgm=phy_100Cms;

*******************************************************************************************************************;
*                                                                                                                 *;
*  PROJECT TOKEN = phy                                                                                            *;
*                                                                                                                 *;
*; libname phy "d:/phy";                                                                                          *;
*                                                                                                                 *;
*; options  validvarname=upcase fmtsearch=(phy.phy_formats work.formats);                                       *;
*                                                                                                                 *;
*; %let _r = c:/;                                                                                                 *;
*                                                                                                                 *;
*; %let pgmloc = c:\utl; * I cut and paste into EG                                                                *;
*                                                                                                                 *;
*  Windows Local workstation SAS 9.3M1(64bit) Win 7(64bit) Dell T7400 64gb ram, dual SSD raid 0 arrays, 8 core    *;
*                                                                                                                 *;
*  PROGRAM VERSIONSING c:\ver                                                                                     *;
*                                                                                                                 *;
*; %let purpose=Create SAS datasets fro CMS and ACS data ;                                                        *;
*                                                                                                                 *;
*  OVERVIEW                                                                                                       *;
*  ========                                                                                                       *;
*                                                                                                                 *;
*  External calls (None)                                                                                          *;
*                                                                                                                 *;
*  Internal calls  (None)                                                                                         *;
*                                                                                                                 *;
*  DRIVER macros (sequenc for running jobs)                                                                       *;
*  ========================================                                                                       *;
*                                                                                                                 *;
*  These are located in autocall library &_r/oto                                                                  *;
*                                                                                                                 *;
*                                                                                                                 *;
*  DEPENDENCIES  (autocall library and autoexec with password)                                                    *;
*  =============                                                                                                  *;
*  autocall &_r/oto                                                                                               *;
*                                                                                                                 *;
* ================================================================================================================*;
*                                                                                                                 *;
*                                                                                                                 *;
*  INPUTS                                                                   *;
*  =======                                                                  *;
*                                                                                                                 *;
*   https://goo.gl/2Vpj86                                                                                         *;
*   https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports                        *;
*     /Medicare-Provider-Charge-Data/Physician-and-Other-Supplier.html                                            *;
*                                                                                                                 *;
*   http://2015.padjo.org/tutorials/sql-walks/exploring-wsj-medicare-investigation-with-sql/                      *;
*                                                                                                                 *;
*   How the NPI number is used to associate medical providers with services and reimbursements.                   *;
*   How to find the total number of Medicare patients a medical provider had in 2012.                             *;
*   How to find every procedure and treatment that any given doctor billed to Medicare.                           *;
*   How to calculate how much Medicare actually reimbursed a given doctor for their services.                     *;
*   How to calculate the average number of times a given procedure was administered in a day,                     *;
*   or per patient – is it notable when a doctor administers a procedure at a much higher rate                    *;
*   than his/her peers?                                                                                           *;
*   Many of the text fields are not very reliable.                                                                *;
*   The HCPCS description field can be quite vague.                                                               *;
*                                                                                                                 *;
*   https://goo.gl/2Vpj86                                                                                         *;
*   https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports                        *;
*     /Medicare-Provider-Charge-Data/Physician-and-Other-Supplier.html                                            *;
*                                                                                                                 *;
*    Download detail claims data link                                                                             *;
*                                                                                                                 *;
*      d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY2012.TXT                                                   *;
*      d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY2013.TXT                                                   *;
*      d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY2014.TXT                                                   *;
*      d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY2015.TXT                                                   *;
*                                                                                                                 *;
*    Summary data NPI level                                                                                       *;
*                                                                                                                 *;
*     Tab delimited                                                                                                            *;
*      d:\phy\txt\Medicare_Physician_and_Other_Supplier_NPI_Aggregate_CY2015..txt                                 *;
*      d:\phy\txt\Medicare_Physician_and_Other_Supplier_NPI_Aggregate_CY2014..txt                                 *;
*                                                                                                                 *;
*     XLSX                                                                                                        *;
*      d:/phy/xls/Medicare-Physician-and-Other-Supplier-NPI-Aggregate-CY2013.xlsx                                 *;
*      d:/phy/xls/Medicare-Physician-and-Other-Supplier-NPI-Aggregate-CY2012.xlsx                                 *;
*                                                                                                                 *;
*                                                                                                                 *;
*  Zu\ipcode databases                                                                                            *;
*                                                                                                                 *;
*  OUTPUT                                                                                                         *;
*  ===========================                                                                                    *;
*                                                                                                                 *;
*    2012-2015 Detail Claims                                                                                      *;
*                                                                                                                 *;
*        PHY.PHY_100CMS_TABNPISUM created, with 2006119 rows and 70 columns                                       *;
*                                                                                                                 *;
*                                                                                                                 *;
*                                                                                                                 *;
*                                                                                                                 *;
*                                                                                                                 *;
*                                                                                                                 *;
*                                                                                                                 *;
*                                                                                                                 *;
*                                                                                                                 *;
*                                                                                                                 *;
*******************************************************************************************************************;
*                                                                                                                 *;
*                                                                                                                 *;
*******************************************************************************************************************;
*                                     _       _
 ___ _   _ _ __ ___  _ __ _   _    __| | __ _| |_ __ _
/ __| | | | '_ ` _ \| '__| | | |  / _` |/ _` | __/ _` |
\__ \ |_| | | | | | | |  | |_| | | (_| | (_| | || (_| |
|___/\__,_|_| |_| |_|_|   \__, |  \__,_|\__,_|\__\__,_|
                          |___/
;

%macro phy_100Cms(yr);

  DATA &pgm._npiTab;
      LENGTH
            npi                                 $10
            nppes_provider_last_org_name        $70
            nppes_provider_first_name           $20
            nppes_provider_mi                   $1
            nppes_credentials                   $20
            nppes_provider_gender               $1
            nppes_entity_code                   $1
            nppes_provider_street1              $55
            nppes_provider_street2              $55
            nppes_provider_city                 $40
            nppes_provider_zip                  $20
            nppes_provider_state                $2
            nppes_provider_country              $2
            provider_type                       $43
            medicare_participation_indicator    $1
        number_of_hcpcs                         8
            total_services                      8
            total_unique_benes                  8
            total_submitted_chrg_amt            8
            total_medicare_allowed_amt          8
            total_medicare_payment_amt          8
            total_medicare_stnd_amt             8
        drug_suppress_indicator                 $1
            number_of_drug_hcpcs                8
            total_drug_services                 8
            total_drug_unique_benes             8
        total_drug_submitted_chrg_amt           8
            total_drug_medicare_allowed_amt     8
            total_drug_medicare_payment_amt     8
        total_drug_medicare_stnd_amt            8
            med_suppress_indicator              $1
            number_of_med_hcpcs                 8
            total_med_services                  8
            total_med_unique_benes              8
            total_med_submitted_chrg_amt        8
            total_med_medicare_allowed_amt      8
            total_med_medicare_payment_amt      8
            total_med_medicare_stnd_amt         8
            beneficiary_average_age             8
            beneficiary_age_less_65_count       8
            beneficiary_age_65_74_count         8
            beneficiary_age_75_84_count         8
            beneficiary_age_greater_84_count    8
            beneficiary_female_count            8
            beneficiary_male_count              8
            beneficiary_race_white_count        8
            beneficiary_race_black_count        8
            beneficiary_race_api_count          8
            beneficiary_race_hispanic_count     8
            beneficiary_race_natind_count       8
            beneficiary_race_other_count        8
            beneficiary_nondual_count           8
            beneficiary_dual_count              8
            beneficiary_cc_afib_percent         8
            beneficiary_cc_alzrdsd_percent      8
            beneficiary_cc_asthma_percent       8
            beneficiary_cc_cancer_percent       8
            beneficiary_cc_chf_percent          8
            beneficiary_cc_ckd_percent          8
            beneficiary_cc_copd_percent         8
            beneficiary_cc_depr_percent         8
            beneficiary_cc_diab_percent         8
            beneficiary_cc_hyperl_percent       8
            beneficiary_cc_hypert_percent       8
            beneficiary_cc_ihd_percent          8
            beneficiary_cc_ost_percent          8
            beneficiary_cc_raoa_percent         8
            beneficiary_cc_schiot_percent       8
            beneficiary_cc_strk_percent         8
            beneficiary_average_risk_score      8;

      INFILE "d:\phy\txt\Medicare_Physician_and_Other_Supplier_NPI_Aggregate_CY&YR..txt"

            lrecl=32767
            dlm='09'x
            pad missover
            firstobs = 2
            dsd;

      INPUT
            npi
            nppes_provider_last_org_name
            nppes_provider_first_name
            nppes_provider_mi
            nppes_credentials
            nppes_provider_gender
            nppes_entity_code
            nppes_provider_street1
            nppes_provider_street2
            nppes_provider_city
            nppes_provider_zip
            nppes_provider_state
            nppes_provider_country
            provider_type
            medicare_participation_indicator
            number_of_hcpcs
            total_services
            total_unique_benes
            total_submitted_chrg_amt
            total_medicare_allowed_amt
            total_medicare_payment_amt
            total_medicare_stnd_amt
            drug_suppress_indicator
            number_of_drug_hcpcs
            total_drug_services
            total_drug_unique_benes
            total_drug_submitted_chrg_amt
            total_drug_medicare_allowed_amt
            total_drug_medicare_payment_amt
            total_drug_medicare_stnd_amt
            med_suppress_indicator
            number_of_med_hcpcs
            total_med_services
            total_med_unique_benes
            total_med_submitted_chrg_amt
            total_med_medicare_allowed_amt
            total_med_medicare_payment_amt
            total_med_medicare_stnd_amt
            beneficiary_average_age
            beneficiary_age_less_65_count
            beneficiary_age_65_74_count
            beneficiary_age_75_84_count
            beneficiary_age_greater_84_count
            beneficiary_female_count
            beneficiary_male_count
            beneficiary_race_white_count
            beneficiary_race_black_count
            beneficiary_race_api_count
            beneficiary_race_hispanic_count
            beneficiary_race_natind_count
            beneficiary_race_other_count
            beneficiary_nondual_count
            beneficiary_dual_count
            beneficiary_cc_afib_percent
            beneficiary_cc_alzrdsd_percent
            beneficiary_cc_asthma_percent
            beneficiary_cc_cancer_percent
            beneficiary_cc_chf_percent
            beneficiary_cc_ckd_percent
            beneficiary_cc_copd_percent
            beneficiary_cc_depr_percent
            beneficiary_cc_diab_percent
            beneficiary_cc_hyperl_percent
            beneficiary_cc_hypert_percent
            beneficiary_cc_ihd_percent
            beneficiary_cc_ost_percent
            beneficiary_cc_raoa_percent
            beneficiary_cc_schiot_percent
            beneficiary_cc_strk_percent
            beneficiary_average_risk_score
            ;

      LABEL
            npi                                  ="National Provider Identifier"
            nppes_provider_last_org_name         ="Last Name/Organization Name of the Provider"
            nppes_provider_first_name            ="First Name of the Provider"
            nppes_provider_mi                    ="Middle Initial of the Provider"
            nppes_credentials                    ="Credentials of the Provider"
            nppes_provider_gender                ="Gender of the Provider"
            nppes_entity_code                    ="Entity Type of the Provider"
            nppes_provider_street1               ="Street Address 1 of the Provider"
            nppes_provider_street2               ="Street Address 2 of the Provider"
            nppes_provider_city                  ="City of the Provider"
            nppes_provider_zip                   ="Zip Code of the Provider"
            nppes_provider_state                 ="State Code of the Provider"
            nppes_provider_country               ="Country Code of the Provider"
            provider_type                        ="Provider Type of the Provider"
            medicare_participation_indicator     ="Medicare Participation Indicator"
            number_of_hcpcs                      ="Number of HCPCS"
            total_services                       ="Number of Services"
            total_unique_benes                   ="Number of Medicare Beneficiaries"
            total_submitted_chrg_amt             ="Total Submitted Charge Amount"
            total_medicare_allowed_amt           ="Total Medicare Allowed Amount"
            total_medicare_payment_amt           ="Total Medicare Payment Amount"
            total_medicare_stnd_amt              ="Total Medicare Standardized Payment Amount"
            drug_suppress_indicator              ="Drug Suppress Indicator"
            number_of_drug_hcpcs                 ="Number of HCPCS Associated With Drug Services"
            total_drug_services                  ="Number of Drug Services"
            total_drug_unique_benes              ="Number of Medicare Beneficiaries With Drug Services"
            total_drug_submitted_chrg_amt        ="Total Drug Submitted Charge Amount"
            total_drug_medicare_allowed_amt      ="Total Drug Medicare Allowed Amount"
            total_drug_medicare_payment_amt      ="Total Drug Medicare Payment Amount"
            total_drug_medicare_stnd_amt         ="Total Drug Medicare Standardized Payment Amount"
            med_suppress_indicator               ="Medical Suppress Indicator"
            number_of_med_hcpcs                  ="Number of HCPCS Associated With Medical Services"
            total_med_services                   ="Number of Medical Services"
            total_med_unique_benes               ="Number of Medicare Beneficiaries With Medical Services"
            total_med_submitted_chrg_amt         ="Total Medical Submitted Charge Amount"
            total_med_medicare_allowed_amt       ="Total Medical Medicare Allowed Amount"
            total_med_medicare_payment_amt       ="Total Medical Medicare Payment Amount"
            total_med_medicare_stnd_amt          ="Total Medical Medicare Standardized Payment Amount"
            beneficiary_average_age              ="Average Age of Beneficiaries"
            beneficiary_age_less_65_count        ="Number of Beneficiaries Age Less 65"
            beneficiary_age_65_74_count          ="Number of Beneficiaries Age 65 to 74"
            beneficiary_age_75_84_count          ="Number of Beneficiaries Age 75 to 84"
            beneficiary_age_greater_84_count     ="Number of Beneficiaries Age Greater 84"
            beneficiary_female_count             ="Number of Female Beneficiaries"
            beneficiary_male_count               ="Number of Male Beneficiaries"
            beneficiary_race_white_count         ="Number of Non-Hispanic White Beneficiaries"
            beneficiary_race_black_count         ="Number of Black or African American Beneficiaries"
            beneficiary_race_api_count           ="Number of Asian Pacific Islander Beneficiaries"
            beneficiary_race_hispanic_count      ="Number of Hispanic Beneficiaries"
            beneficiary_race_natind_count        ="Number of American Indian/Alaska Native Beneficiaries"
            beneficiary_race_other_count         ="Number of Beneficiaries With Race Not Elsewhere Classified"
            beneficiary_nondual_count            ="Number of Beneficiaries With Medicare Only Entitlement"
            beneficiary_dual_count               ="Number of Beneficiaries With Medicare & Medicaid Entitlement"
            beneficiary_cc_afib_percent          ="Percent (%) of Beneficiaries Identified With Atrial Fibrillation"
            beneficiary_cc_alzrdsd_percent       ="Percent (%) of Beneficiaries Identified With Alzheimer’s Disease or Dementia"
            beneficiary_cc_asthma_percent        ="Percent (%) of Beneficiaries Identified With Asthma"
            beneficiary_cc_cancer_percent        ="Percent (%) of Beneficiaries Identified With Cancer"
            beneficiary_cc_chf_percent           ="Percent (%) of Beneficiaries Identified With Heart Failure"
            beneficiary_cc_ckd_percent           ="Percent (%) of Beneficiaries Identified With Chronic Kidney Disease"
            beneficiary_cc_copd_percent          ="Percent (%) of Beneficiaries Identified With Chronic Obstructive Pulmonary Disease"
            beneficiary_cc_depr_percent          ="Percent (%) of Beneficiaries Identified With Depression"
            beneficiary_cc_diab_percent          ="Percent (%) of Beneficiaries Identified With Diabetes"
            beneficiary_cc_hyperl_percent        ="Percent (%) of Beneficiaries Identified With Hyperlipidemia"
            beneficiary_cc_hypert_percent        ="Percent (%) of Beneficiaries Identified With Hypertension"
            beneficiary_cc_ihd_percent           ="Percent (%) of Beneficiaries Identified With Ischemic Heart Disease"
            beneficiary_cc_ost_percent           ="Percent (%) of Beneficiaries Identified With Osteoporosis"
            beneficiary_cc_raoa_percent          ="Percent (%) of Beneficiaries Identified With Rheumatoid Arthritis / Osteoarthritis"
            beneficiary_cc_schiot_percent        ="Percent (%) of Beneficiaries Identified With Schizophrenia / Other Psychotic Disorders"
            beneficiary_cc_strk_percent          ="Percent (%) of Beneficiaries Identified With Stroke"
            Beneficiary_Average_Risk_Score       ="Average HCC Risk Score of Beneficiaries"
;
run;quit;

%utl_optlen(inp=&pgm._npiTab,out=phy.&pgm._&yr.TabNpiSum);

%mend phy_100Cms;

%phy_100Cms(2015);
%phy_100Cms(2014);


* combine 2014 and 2015 tab datasets;
proc sql;
  create
     table phy.&pgm._TabNpiSum as
  select
     '14' as fro label="Summary data Year 2012-2015"
    ,*
  from
     phy.&pgm._2014TabNpiSum
  union
     corr
  select
     '15' as fro
     ,*
  from
     phy.&pgm._2015TabNpiSum
;quit;


* Table PHY.PHY_100CMS_TABNPISUM created, with 2006119 rows and 70 columns;

*     _
__  _| |___
\ \/ / / __|
 >  <| \__ \
/_/\_\_|___/

;

/* suggest you run these in separate SAS sessions simultaneosly
   These take a very long time
   I have guessing rows to maximum

* 1 hr to run;
libname xel "d:/phy/xls/Medicare-Physician-and-Other-Supplier-NPI-Aggregate-CY2013.xlsx";
data phy.&pgm._2013XlsNpiSum;
  set xel.'data$'n;;
run;quit;
libname xel clear;


* 1 hr to run;
libname xel "d:/phy/xls/Medicare-Physician-and-Other-Supplier-NPI-Aggregate-CY2012.xlsx";
data phy.&pgm._2012XlsNpiSum;
  set xel.'data$'n;;
run;quit;
libname xel clear;
*/

/* fix dif types problem by removing variable with conflicting types;
   I have guessing rows to maximum

  48    NUMBER_OF_BENEFICIARIES_WITH_RAC    Num       4
  ERROR: Column 48 from the first contributor of UNION is not the same type as its counterpart from the second.
  2012 has a comma in the number and 2013 does not;
*/

proc sql;
  create
    table phy.&pgm._XlsNpiSum as
  select
     '12' as fro label="Summary data Year 2012-2015"
    ,*
  from
    phy.&pgm._2012xlsNpiSum(drop=number_of_beneficiaries_with_rac) /* 69 variables */
  union
    corr
  select
    '13' as fro
   ,*
  from
    phy.&pgm._2013xlsNpiSum(drop=number_of_beneficiaries_with_rac) /* 69 variables */
;quit;

proc datasets lib=phy;
  modify &pgm._XlsNpiSum;
   label npi="National Provider Identifier";
run;quit;

/*
NOTE: PHY.PHY_100CMS_XLSNPISUM created, with 1881621 rows and 67 columns.
*/

* now we need to try to put the xls files with the tab files;

* output the tab file variable names and labels;
proc sql;
  create
    table &pgm._tabNamLbl as
  select
    monotonic() as tabKey
   ,name
   ,case
     when (index(label,'of the Provider'))>0 then substr(label,1,length(label)-16)
     else label
    end as label
  from
    sashelp.vcolumn
  where
    %upcase("&pgm._TabNpiSum") = memname and
    libname = "PHY"
;quit;

* output the xls file variable names and labels;
proc sql;
  create
    table &pgm._xlsNamLblPre as
  select
    monotonic() as xlsKey
   ,name
   ,case
     when (label eqt 'NPPES Provider') then substr(label,16)
     else label
    end as label
  from
    sashelp.vcolumn
  where
    %upcase("&pgm._XlsNpiSum") = memname and
    libname = "PHY" and
    label ne ""
;quit;

* match some of the missing matches;
data &pgm._xlsNamLbl;
  set &pgm._xlsNamLblPre;
  select (xlsKey);
    when ( 3) label='Last Name/Organization Name                           ';
    when ( 6) label='Credentials                                           ';
    when ( 8) label='Entity Type                                           ';
    when (13) label='State Code                                            ';
    when (14) label='Country Code                                          ';
    when (19) label='Number of Medicare Beneficiaries                      ';
    when (20) label='Total Submitted Charge Amount                         ';
    when (27) label='Total Drug Submitted Charge Amount                    ';
    when (34) label='Total Medical Submitted Charge Amount                 ';
    when (26) label='Number of Medicare Beneficiaries With Drug Services   ';
    when (33) label='Number of Medicare Beneficiaries With Medical Services';
    otherwise;
  end;
run;quit;

* build the rename statement for xls dataset;
proc sql;
  create
    table &pgm._xpoNam as
  select
    tab.tabKey
   ,xls.xlsKey
   ,xls.name as xlsNam
   ,tab.name as tabNam
   ,xls.label as xlsLabel
   ,tab.label as tabLabel
  from
    &pgm._xlsNamLbl as xls full outer join &pgm._tabNamLbl as tab
  on
    compged(substr(upcase(strip(xls.label)),1,64),substr(upcase(strip(tab.label)),1,64)) < 10
  where
    xls.name not in ('F68','F69')
;quit;

/*
options ls=255 ps=500;
proc print data=&pgm._xpoNam width=min;
var xlsKey tabKey xlsLabel tabLabel;
run;quit;

proc print data=&pgm._xpoNam width=min;
var xlsNam tabNam;
run;quit;
*/

data _null_;

  if _n_=0 then do;
    %let rc=%sysfunc(dosubl('
     proc sql;
       select
          cats(xlsNam,'=',tabNam)
       into
          :_ren separated by " "
       from
          &pgm._xpoNam
       where
          not ( xlsNam eq " " or xlsNam = tabNam)
     ;quit;
    '));
  end;

  rc=dosubl('
     proc datasets li=phy;
       modify &pgm._XlsNpiSum;
         rename
           &_ren
         ;
     run;quit;
  ');
run;quit;

* put tab and xls years together;

data phy.&pgm._NpiSum(rename=fro=year
  label="All summary data 2012-2013 xls files combined with 2014-2015 tab file");
  retain key . fro '  '  profession;
  set
    phy.&pgm._xlsNpiSum
    phy.&pgm._tabNpiSum
  ;
  key=_n_;

  profession= put(compress(NPPES_CREDENTIALS,'.,'),&pgm._cred2prof.);

  If strip(NPPES_CREDENTIALS) =: 'NURSE PRACTITIONER'   then profession='NP';
  If strip(NPPES_CREDENTIALS) =: 'PHYSICIAN ASSISTANT'  then profession='PA';
  If strip(NPPES_CREDENTIALS) =: 'PHYSICIANS ASSISTANT' then profession='PA';
  If strip(NPPES_CREDENTIALS) =: 'MEDICAL DOCTOR'       then profession='MD';
  If strip(NPPES_CREDENTIALS) =: 'PHYSICAL THERAPIST'   then profession='PT';

  if compress(NPPES_CREDENTIALS,'.,') =: 'DC '  then profession='DC';
  if compress(NPPES_CREDENTIALS,'.,') =: 'MD'  then profession='MD';
  if compress(NPPES_CREDENTIALS,'.,') =: 'M D'  then profession='MD';
  if compress(NPPES_CREDENTIALS,'.,') =: 'DO ' then profession='DO';
  if compress(NPPES_CREDENTIALS,'.,') =: 'OD ' then profession='OD';
  if compress(NPPES_CREDENTIALS,'.,') =: 'O D ' then profession='OD';
  if compress(NPPES_CREDENTIALS,'.,') =: 'D O ' then profession='DO';
  if compress(NPPES_CREDENTIALS,'.,') =: 'P A ' then profession='PA';
  if compress(NPPES_CREDENTIALS,'.,') =: 'PA ' then profession='PA';
  if compress(NPPES_CREDENTIALS,'.,') =: 'PA-' then profession='PA';
  if compress(NPPES_CREDENTIALS,'.,') =: 'RN ' then profession='NURSE';
  if compress(NPPES_CREDENTIALS,'.,') =: 'RN ' then profession='NURSE';
  if compress(NPPES_CREDENTIALS,'.,') =: 'RN/NP' then profession='NP';

run;quit;

%utl_optlen(inp=phy.&pgm._NpiSum,out=phy.&pgm._NpiSum);


/*
proc freq data=phy.&pgm._NpiSum order=freq;
tables NPPES_CREDENTIALS/out=long(where=(length(NPPES_CREDENTIALS)>12));
run;quit;

proc freq data=phy.&pgm._NpiSum order=freq;
tables profession;
run;quit;

 95% cleaned up fuzzy
PROFESSION     Frequency     Percent     Frequency      Percent
----------------------------------------------------------------
MD              2079266       58.77       2079266        58.77
NP               212314        6.00       2291580        64.78
PA               201474        5.70       2493054        70.47
DO               191217        5.41       2684271        75.88
NURSE            173766        4.91       2858037        80.79
DC               137221        3.88       2995258        84.67
OD               109576        3.10       3104834        87.76
PT                79474        2.25       3184308        90.01
DPM               56701        1.60       3241009        91.61
PHD               38454        1.09       3279463        92.70
DPT               31396        0.89       3310859        93.59
LCSW              28985        0.82       3339844        94.41
RN                13415        0.38       3353259        94.79
*/


* voodoo;
/*
data  sample;
  set phy.&pgm._NpiSum(where=(uniform(1234)<100000/3000000));
  if profession in (
    'MD'
    'NP'
    'PA'
    'DO'
    'NURSE'
    'DC'
    'OD' );
run;quit;











run;quit;

%inc "c:/oto/oto_voodoo.sas";


%utlvdoc
    (
    libname        = work         /* libname of input dataset */
    ,data          = sample       /* name of input dataset */
    ,key           = year npi          /* 0 or variable */
    ,ExtrmVal      = 20           /* display top and bottom 30 frequencies */
    ,UniPlot       = 1            /* 'true' enables ('false' disables) plot option on univariate output */
    ,UniVar        = 1            /* 'true' enables ('false' disables) plot option on univariate output */
    ,misspat       = 1            /* 0 or 1 missing patterns */
    ,chart         = 1            /* 0 or 1 line printer chart */
    ,taball        =  /* variable 0 */
    ,tabone        = YEAR PROFESSION   /* 0 or  variable vs all other variables          */
    ,mispop        = 1            /* 0 or 1  missing vs populated*/
    ,dupcol        = 1            /* 0 or 1  columns duplicated  */
    ,unqtwo        = YEAR PROVIDER_TYPE PROFESSION           /* 0 */
    ,vdocor        = 1            /* 0 or 1  correlation of numeric variables */
    ,oneone        = 1            /* 0 or 1  one to one - one to many - many to many */
    ,cramer        = 1            /* 0 or 1  association of character variables    */
    ,optlength     = 0
    ,maxmin        = 1
    ,unichr        = 1
    ,printto       = d:\txt\vdo\&data..txt        /* file or output if output window */
    ,Cleanup       = 0           /* 0 or 1 delete intermediate datasets */
    );

%*utlvdoc
    (
    libname        = work      /* libname of input dataset */
    ,data          = zipcode      /* name of input dataset */
    ,key           = zip          /* 0 or variable */
    ,ExtrmVal      = 10           /* display top and bottom 30 frequencies */
    ,UniPlot       = 0
    ,UniVar        = 0
    ,chart         = 0
    ,misspat       = 0
    ,taball        = 0
    ,tabone        = 0
    ,mispop        = 0
    ,dupcol        = 0
    ,unqtwo        = 0
    ,vdocor        = 0
    ,oneone        = 0
    ,cramer        = 0
    ,optlength     = 0
    ,maxmin        = 0
    ,unichr        = 0
    ,outlier       = 1
    ,printto       = d:\txt\vdo\&data..txt
    ,Cleanup       = 0
    );






https://www.sec.gov/Archives/edgar/data/318154/000119312508040431/dex109.htm


Variable Correlations (Spearman)

                                   Correlated                         Correlation    Number    Spearman
Variable                           With                                   Coef       of Obs       P

TOTAL_DRUG_MEDICARE_STND_AMT       TOTAL_DRUG_MEDICARE_PAYMENT_AMT      1.00000       46892     0.1720
TOTAL_MED_UNIQUE_BENES             TOTAL_UNIQUE_BENES                   0.99998       91167     0.0370
TOTAL_DRUG_MEDICARE_PAYMENT_AMT    TOTAL_DRUG_MEDICARE_ALLOWED_AMT      0.99992       91167     0.3585
TOTAL_DRUG_MEDICARE_STND_AMT       TOTAL_DRUG_MEDICARE_ALLOWED_AMT      0.99991       46892     0.1720
TOTAL_MEDICARE_PAYMENT_AMT         TOTAL_MEDICARE_ALLOWED_AMT           0.99899      103753     0.0002
TOTAL_MED_MEDICARE_PAYMENT_AMT     TOTAL_MED_MEDICARE_ALLOWED_AMT       0.99893       91167     0.0024
TOTAL_MEDICARE_STND_AMT            TOTAL_MEDICARE_PAYMENT_AMT           0.99780       53320     0.2837
TOTAL_MEDICARE_STND_AMT            TOTAL_MEDICARE_ALLOWED_AMT           0.99767       53320     0.2837
TOTAL_MED_MEDICARE_STND_AMT        TOTAL_MED_MEDICARE_PAYMENT_AMT       0.99754       46892     0.3859
TOTAL_MED_MEDICARE_STND_AMT        TOTAL_MED_MEDICARE_ALLOWED_AMT       0.99746       46892     0.3859
TOTAL_DRUG_MEDICARE_ALLOWED_AMT    TOTAL_DRUG_SUBMITTED_CHRG_AMT        0.99745       91167     0.3398
TOTAL_DRUG_MEDICARE_STND_AMT       TOTAL_DRUG_SUBMITTED_CHRG_AMT        0.99709       46892     0.1720
TOTAL_DRUG_MEDICARE_PAYMENT_AMT    TOTAL_DRUG_SUBMITTED_CHRG_AMT        0.99705       91167     0.3585
TOTAL_MED_SUBMITTED_CHRG_AMT       TOTAL_SUBMITTED_CHRG_AMT             0.99631       91167     0.0278
TOTAL_MED_MEDICARE_ALLOWED_AMT     TOTAL_MEDICARE_ALLOWED_AMT           0.99622       91167     0.0227
TOTAL_MED_MEDICARE_PAYMENT_AMT     TOTAL_MEDICARE_PAYMENT_AMT           0.99601       91167     0.0024
TOTAL_MED_MEDICARE_STND_AMT        TOTAL_MEDICARE_STND_AMT              0.99578       46892     0.3859
TOTAL_MED_MEDICARE_ALLOWED_AMT     TOTAL_MEDICARE_PAYMENT_AMT           0.99520       91167     0.0227
TOTAL_MED_MEDICARE_PAYMENT_AMT     TOTAL_MEDICARE_ALLOWED_AMT           0.99499       91167     0.0024
TOTAL_MED_MEDICARE_STND_AMT        TOTAL_MEDICARE_PAYMENT_AMT           0.99360       46892     0.3859
TOTAL_MED_MEDICARE_STND_AMT        TOTAL_MEDICARE_ALLOWED_AMT           0.99357       46892     0.3859
TOTAL_MEDICARE_STND_AMT            TOTAL_MED_MEDICARE_ALLOWED_AMT       0.99342       46892     0.2837
TOTAL_MEDICARE_STND_AMT            TOTAL_MED_MEDICARE_PAYMENT_AMT       0.99318       46892     0.2837
NUMBER_OF_MED_HCPCS                NUMBER_OF_HCPCS                      0.99313       91167     <.0001
TOTAL_DRUG_SUBMITTED_CHRG_AMT      TOTAL_DRUG_SERVICES                  0.99272       91167     0.4356


One to Many     PROFESSION to NPPES_CREDENTIALS


                     BENEFICIARY_
                       AGE_65_74_
 Obs    PROFESSION        COUNT       COUNT    PERCENT

   1      MD                .          6829    6.58198
   2      NP                .          1937    1.86693
   3      DC                .          1391    1.34068
   4      PA                .          1364    1.31466
   5      NURSE             .           832    0.80190
   6      DO                .           616    0.59372
   7      OD                .           468    0.45107
   8      MD               41           360    0.34698
   9      MD               30           355    0.34216
  10      MD               42           349    0.33638

























































Staff members can also take advantage of the Employee Stock Purchase Plan (ESPP) by contributing
up to 15 percent of their salary on an after-tax basis, subject to legal limits,
to purchase Amgen common stock at a discount. Additionally, eligible individuals
can participate in the Supplemental Retirement Plan (SRP) and Deferred Compensation Plan (DCP).


2004-2011
I think the discount was 5%?



































data



data &pgm._xlsNam2tabNam;
  retain fmtname '$xlsNam2tabNam';
  set &pgm._xpoNam(where=(xlsNam ne ''));
  start=xlsNam;
  end=start;
  label=tabNam;
  keep fmtname start end label;
run;quit;

/*
* we need to convert autogenerated xls names to names from tab txt files

WORK.PHY_100CMS_XLSNAM2TABNAM total obs=66

                    XLS COLUMN NAME
     FMTNAME        START                               END                                 SAS TAB Column

  $xlsNam2tabNam    NPI                                 NPI                                 NPI
  $xlsNam2tabNam    NPPES_PROVIDER_LAST_NAME___ORGAN    NPPES_PROVIDER_LAST_NAME___ORGAN    NPPES_PROVIDER_LAST_ORG_NAME
  $xlsNam2tabNam    NPPES_PROVIDER_FIRST_NAME           NPPES_PROVIDER_FIRST_NAME           NPPES_PROVIDER_FIRST_NAME
  $xlsNam2tabNam    NPPES_PROVIDER_MIDDLE_INITIAL       NPPES_PROVIDER_MIDDLE_INITIAL       NPPES_PROVIDER_MI
  $xlsNam2tabNam    NPPES_CREDENTIALS                   NPPES_CREDENTIALS                   NPPES_CREDENTIALS
  $xlsNam2tabNam    NPPES_PROVIDER_GENDER               NPPES_PROVIDER_GENDER               NPPES_PROVIDER_GENDER
  $xlsNam2tabNam    NPPES_ENTITY_CODE                   NPPES_ENTITY_CODE                   NPPES_ENTITY_CODE
...
*/

proc sql;
  select
     cats(
















proc format cntlin=&pgm._xlsNam2tabNam;
run;quit;



options ls=255;

%macro lsalh / cmd des="Type lsalh on command line. Lista ll obs highlighted dataset";
  store;note;notesubmit '%lsalha;';
%mend lsalh;

%macro lsalha;
FILENAME clp clipbrd ;
DATA _NULL_;
  INFILE clp;
  INPUT;
  put _infile_;
  call symputx('argx',_infile_);
RUN;
dm "out;clear;";
proc sql noprint;
  select put(count(*),comma18.) into :tob  separated by ' '
  from &argx
;quit;
title "All Obs(&tob) from dataset &argx.";
options nocenter;
proc print  data=&argx. width=min;
format _all_;
run;
title;
dm "out;top";
%mend lsalha;


*    _      _        _ _
  __| | ___| |_ __ _(_) |
 / _` |/ _ \ __/ _` | | |
| (_| |  __/ || (_| | | |
 \__,_|\___|\__\__,_|_|_|

;
%macro phy_years(yr);

libname phy "d:/phy";

data phy.phy_100&yr.(compress=yes);
      LENGTH
            npi                                  $10
            nppes_provider_last_org_name         $70
            nppes_provider_first_name            $20
            nppes_provider_mi                    $1
            nppes_credentials                    $20
            nppes_provider_gender                $1
            nppes_entity_code                    $1
            nppes_provider_street1               $55
            nppes_provider_street2               $55
            nppes_provider_city                  $40
            nppes_provider_zip                   $20
            nppes_provider_state                 $2
            nppes_provider_country               $2
            provider_type                        $43
            medicare_participation_indicator     $1
            place_of_service                     $1
            hcpcs_code                           $5
            hcpcs_description                    $256
            hcpcs_drug_indicator                 $1
            line_srvc_cnt                        8
            bene_unique_cnt                      8
            bene_day_srvc_cnt                    8
            average_Medicare_allowed_amt         8
            average_submitted_chrg_amt           8
            average_Medicare_payment_amt         8
            average_Medicare_standard_amt        8;
      INFILE "d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY201&yr..TXT"

            lrecl=32767
            dlm='09'x
            pad missover
            firstobs = 3
            dsd;

      INPUT
            npi
            nppes_provider_last_org_name
            nppes_provider_first_name
            nppes_provider_mi
            nppes_credentials
            nppes_provider_gender
            nppes_entity_code
            nppes_provider_street1
            nppes_provider_street2
            nppes_provider_city
            nppes_provider_zip
            nppes_provider_state
            nppes_provider_country
            provider_type
            medicare_participation_indicator
            place_of_service
            hcpcs_code
            hcpcs_description
            hcpcs_drug_indicator
            line_srvc_cnt
            bene_unique_cnt
            bene_day_srvc_cnt
            average_Medicare_allowed_amt
            average_submitted_chrg_amt
            average_Medicare_payment_amt
            average_Medicare_standard_amt;

      LABEL
            npi                                 = "National Provider Identifier"
            nppes_provider_last_org_name        = "Last Name/Organization Name of the Provider"
            nppes_provider_first_name           = "First Name of the Provider"
            nppes_provider_mi                   = "Middle Initial of the Provider"
            nppes_credentials                   = "Credentials of the Provider"
            nppes_provider_gender               = "Gender of the Provider"
            nppes_entity_code                   = "Entity Type of the Provider"
            nppes_provider_street1              = "Street Address 1 of the Provider"
            nppes_provider_street2              = "Street Address 2 of the Provider"
            nppes_provider_city                 = "City of the Provider"
            nppes_provider_zip                  = "Zip Code of the Provider"
            nppes_provider_state                = "State Code of the Provider"
            nppes_provider_country              = "Country Code of the Provider"
            provider_type                       = "Provider Type of the Provider"
            medicare_participation_indicator    = "Medicare Participation Indicator"
            place_of_service                    = "Place of Service"
            hcpcs_code                          = "HCPCS Code"
            hcpcs_description                   = "HCPCS Description"
            hcpcs_drug_indicator                = "Identifies HCPCS As Drug Included in the ASP Drug List"
            line_srvc_cnt                       = "Number of Services"
            bene_unique_cnt                     = "Number of Medicare Beneficiaries"
            bene_day_srvc_cnt                   = "Number of Distinct Medicare Beneficiary/Per Day Services"
            average_Medicare_allowed_amt        = "Average Medicare Allowed Amount"
            average_submitted_chrg_amt          = "Average Submitted Charge Amount"
            average_Medicare_payment_amt        = "Average Medicare Payment Amount"
            average_Medicare_standard_amt       = "Average Medicare Standardized Payment Amount";
RUN;

%mend phy_years;

%phy_years(2);
%phy_years(3);
%phy_years(4);
%phy_years(5);

data &pgm._allfor/view=&pgm._allfor;
  retain yr " ";
  set
    phy.phy_1002(in=a)
    phy.phy_1003(in=b)
    phy.phy_1004(in=c)
    phy.phy_1005(in=d)
;
  select;
    when (a)  yr='2';
    when (b)  yr='3';
    when (c)  yr='4';
    when (d)  yr='5';
    otherwise;
 end;

run;quit;

* code decode for lookup;
proc sql;
  create
     table phy.&pgm._cdeDec as
  select
     max(hcpcs_code) as hcpcs_code
    ,max(hcpcs_description) as hcpcs_description
 from
     &pgm._allfor
 group
     by hcpcs_code;
;quit;

/*
Up to 40 obs PHY.PHY_110HPCS_CDEDEC total obs=7,028

  HCPCS_
   CODE     HCPCS_DESCRIPTION

  00100     Anesthesia for procedure on salivary gland with biopsy
  00102     Anesthesia for procedure to repair lip defect present at birth
  00103     Anesthesia for procedure on eyelid
  00104     Anesthesia for electric shock treatment
  00120     Anesthesia for biopsy of external middle and inner ear
  00126     Anesthesia for incision of ear drum
*/


* code decode for lookup provider type;
proc sql;
  *reset inobs=10000;
  create
    table phy.&pgm._typ as
  select
    put(monotonic(),z2.) as type_code
   ,provider_type
  from
   (
    select
       max(provider_type) as provider_type
    from
       &pgm._allfor
    group
      by provider_type
   );
;quit;

proc freq data=phy.&pgm._typ noprint;
tables type_code*provider_type / out=&pgm._typfrq;
run;quit;

/*
TYPE_
CODE     PROVIDER_TYPE

 01      Addiction Medicine
 02      All Other Suppliers
 03      Allergy/Immunology
 04      Ambulance Service Supplier
 05      Ambulatory Surgical Center
 06      Anesthesiologist Assistants
 07      Anesthesiology
 08      Audiologist (billing independently)
 09      CRNA
 10      Cardiac Electrophysiology
 11      Cardiac Surgery
 12      Cardiology
 13      Centralized Flu
 14      Certified Clinical Nurse Specialist
 15      Certified Nurse Midwife
 16      Chiropractic
 17      Clinical Laboratory
 18      Clinical Psychologist
 19      Colorectal Surgery (formerly proctology)
 20      Critical Care (Intensivists)
 21      Dermatology
 22      Diagnostic Radiology
 23      Emergency Medicine
 24      Endocrinology
 25      Family Practice
 26      Gastroenterology
 27      General Practice
 28      General Surgery
 29      Geriatric Medicine
 30      Geriatric Psychiatry
 31      Gynecological/Oncology
 32      Hand Surgery
 33      Hematology
 34      Hematology/Oncology
 35      Hospice and Palliative Care
 36      Independent Diagnostic Testing Facility
 37      Infectious Disease
 38      Internal Medicine
 39      Interventional Cardiology
 40      Interventional Pain Management
 41      Interventional Radiology
 42      Licensed Clinical Social Worker
 43      Mammographic Screening Center
 44      Mass Immunization Roster Biller
 45      Maxillofacial Surgery
 46      Medical Oncology
 47      Multispecialty Clinic/Group Practice
 48      Nephrology
 49      Neurology
 50      Neuropsychiatry
 51      Neurosurgery
 52      Nuclear Medicine
 53      Nurse Practitioner
 54      Obstetrics/Gynecology
 55      Occupational therapist
 56      Ophthalmology
 57      Optometry
 58      Oral Surgery (dentists only)
 59      Orthopedic Surgery
 60      Osteopathic Manipulative Medicine
 61      Otolaryngology
 62      Pain Management
 63      Pathology
 64      Pediatric Medicine
 65      Peripheral Vascular Disease
 66      Pharmacy
 67      Physical Medicine and Rehabilitation
 68      Physical Therapist
 69      Physician Assistant
 70      Plastic and Reconstructive Surgery
 71      Podiatry
 72      Portable X-ray
 73      Preventive Medicine
 74      Psychiatry
 75      Psychologist (billing independently)
 76      Public Health Welfare Agency
 77      Pulmonary Disease
 78      Radiation Oncology
 79      Radiation Therapy
 80      Registered Dietician/Nutrition Professional
 81      Rheumatology
 82      Sleep Medicine
 83      Slide Preparation Facility
 84      Speech Language Pathologist
 85      Sports Medicine
 86      Surgical Oncology
 87      Thoracic Surgery
 88      Unknown Physician Specialty Code
 89      Unknown Supplier/Provider
 90      Urology
 91      Vascular Surgery


Addiction Medicine
Pain Management
Interventional Pain Management

Orthopedic Surgery
Osteopathic Manipulative Medicine
Public Health Welfare Agency
Licensed Clinical Social Worker
Ambulatory Surgical Center
Maxillofacial Surgery
Hand Surgery
Neurosurgery
Plastic and Reconstructive Surgery
Sports Medicine
Thoracic Surgery
General Surgery
Colorectal Surgery (formerly proctology)
*/

* reduce types;
data &pgm._typten surg;
 set &pgm._typfrq;

if index(upcase(provider_type),'SURG') then output surg;
run;quit;

data &pgm._fmt;
  retain fmtname "$ptype" ;
  set phy.&pgm._typ;
  start=provider_type;
  end=start;
  label=type_code;
run;quit;


proc format cntlin=&pgm._fmt lib=phy.formats;
run;quit;

options fmtsearch=(phy.formats work.formats);

data phy.&pgm._cut;
    length zip $5.;
    set
      &pgm._allfor;
    array avgs[*] average_:;
    zip=substr(nppes_provider_zip,1,5);
    do i=1 to dim(avgs);
       avgs[i]=round(100*avgs[i],1);
    end;
    provider_type_code=put(provider_type,$ptype.);

    nppes_credentials = compbl(upcase(compress(nppes_credentials,',.)(&/')));

    keep
      yr
      average_medicare_payment_amt
      bene_day_srvc_cnt
      bene_unique_cnt
      hcpcs_code
      hcpcs_drug_indicator
      line_srvc_cnt
      medicare_participation_indicator
      npi
      nppes_entity_code
      nppes_provider_country
      nppes_provider_gender
      nppes_provider_state
      place_of_service
      provider_type_code
      nppes_credentials
      zip
    ;
run;quit;

*                    _                  _       _
 _ __ ___   __ _ ___| |_ ___ _ __    __| | __ _| |_ __ _
| '_ ` _ \ / _` / __| __/ _ \ '__|  / _` |/ _` | __/ _` |
| | | | | | (_| \__ \ ||  __/ |    | (_| | (_| | || (_| |
|_| |_| |_|\__,_|___/\__\___|_|     \__,_|\__,_|\__\__,_|

;

*** need to fix **;
proc sql;
  create
    table phy.&pgm._manual as
  select
    l.*
   ,average_medicare_payment_amt ***bene_unique_cnt change to line_srvc_cnt*** as payment
   ,case (r.edd_professions)
      when ('NO')  then 'UNK'
      else edd_professions
   end as edd_professions
  from
    phy.&pgm._cut as l left join phy.&pgm._edddoc as r   /* eddDoc on end */
  on
   l.nppes_credentials eq r.edd_sufix
;quit;



proc sql;
  create
    table phy.&pgm._taj010 as
  select
     npi
    ,yr
    ,average_medicare_payment_amt * line_srvc_cnt as payment
    ,case
       when ( edd_professions in ('MD','DO')) then 1
       else 0
     end as md_pa
    ,case (nppes_provider_gender)
       when ('M') then 0
       else 1
     end as gender
  from
     phy.&pgm._manual
  where
     provider_type_code='27' and edd_professions in ('MD','DO','NP','PA')
  order
     by npi, md_pa, gender, yr;
;quit;

proc summary data=phy.&pgm._taj010 nway;
class npi gender md_pa yr;
var payment;
output out=phy.&pgm._tajsum sum=;
run;quit;

proc transpose data=phy.&pgm._tajsum out=&pgm._tajSumXpo(drop=_name_);
by npi gender md_pa;
id yr;
var payment;
run;quit;

data &pgm._tajAddTym;
 retain t1-t4 .;
 set &pgm._tajSumXpo;
 array tym[4] t1 t2 t3 t4 (1,2,3,4);
 array pays[4] _1 _2 _3 _4;
   do idx=1 to dim(pays);
     if pays[idx] le 1 then pays[idx]=1;
     pays[idx]=log(pays[idx]);
  end;
run;quit;

proc traj data=&pgm._tajAddTym
       out = want_of
   outplot = want_op
   outstat = want_os ci95M;
  id npi;
  var _2-_5 ;
  indep t1-t4;
  risk md_pa gender;
  order 1 1;
  model zip;
run;quit;


options ls=64 ps=44;
proc plot data=WANT_OP;
format t 2.;
plot  (pred1-pred2)*t='*' / overlay haxis=24 to 1 by -1 ;
run;quit;








































proc freq data=phy.&pgm._manual order=freq;
tables edd_professions/missing out=&pgm._cuttyp;
run;quit;

%utl_optlen(inp=phy.&pgm._manual,out=phy.&pgm._manual);

/*
                                            Cumulative    Cumulative
EDD_PROFESSIONS    Frequency     Percent     Frequency      Percent
--------------------------------------------------------------------
MD                 26906396       81.50      26906396        81.50
DO                  2198358        6.66      29104754        88.15
NP                  1046036        3.17      30150790        91.32
PA                   966887        2.93      31117677        94.25
DPM                  736669        2.23      31854346        96.48
OD                   562918        1.70      32417264        98.19
NURSE                545288        1.65      32962552        99.84
MBBS                  23694        0.07      32986246        99.91
UNK                   14484        0.04      33000730        99.95
DENTIST               14001        0.04      33014731       100.00
PHARMACIST             1016        0.00      33015747       100.00
*/

/*
01  Addiction Medicine
62  Pain Management
40  Interventional Pain Management
*/

* all providers;
proc sql;
  create
    table &pgm._npisql as
  select
     yr
    ,count(cntnpi) as providers
  from
    (
     select
        yr
       ,max(npi) as cntnpi
     from
       phy.&pgm._manual
     where
       edd_professions in ('MD','DO')
     group
       by yr, npi
    )
  group
    by yr
;quit;


/* all providers

37 255 346

MD and Do

Obs    YR    PROVIDERS

 1     2       529590
 2     3       537825
 3     4       544272
 4     5       550273



YR    PROVIDERS

2       880644
3       909605
4       938146
5       968417
*/

*            _
 _ __   __ _(_)_ __
| '_ \ / _` | | '_ \
| |_) | (_| | | | | |
| .__/ \__,_|_|_| |_|
|_|
;


* pain providers;
proc sql;
  create
    table &pgm._npipyn as
  select
     yr
    ,count(cntnpi) as providers
  from
    (
     select
        yr
       ,max(npi) as cntnpi
     from
       phy.&pgm._manual
     where
       provider_type_code in ('01','40','62')
     group
       by yr, npi
    )
  group
    by yr
;quit;


/* pain PROVIDERS
Obs    YR    PROVIDERS

 1     2        3101
 2     3        3318
 3     4        3515
 4     5        3678
*/

/*
Trend in providers of 'Addiction Medicine' 2012-2015

I downloaded the provider pufs and took a look at

d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY2012.TXT
d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY2013.TXT
d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY2014.TXT
d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY2015.TXT


Have to have credentials

data phy._difpyn;
 input year pain_npi benes all_nps;
  dif_pain_npi=dif(pain_npi)/pain_npi;
  dif_benes=dif(benes)/benes;
  dif_all_nps=dif(all_nps)/all_nps;
cards4;
2012  57464     3962741    683814
2013  63322     4576238    705154
2014  67717     5263482    723522
2015  69218     5374294    742851
;;;;
run;quit;

proc summary data=phy.&pgm._manual(where=(provider_type_code in ('01','40','62'))) n;
class yr;
var bene_unique_cnt;
output out=&pgm._pynbne sum=;
run;quit;

/*

    PAIN
    BENE_
   UNIQUE_
     CNT

   4041475
   4672408
   5382180
   5508845
*/

proc summary data=phy.&pgm._manual;
class yr;
var bene_unique_cnt;
output out=&pgm._allbne sum=;
run;quit;

/*
    BENE_
 UNIQUE_CNT

  834770973
  842761312
  848335652
  862558384
*/

data phy._difpyn;
 retain spc1 spc2 spc3  " ";
 input year npiPyn npiAll srvPyn srvAll;
  difnpiPyn = 100*dif(npiPyn)/npiPyn;
  difnpiAll = 100*dif(npiAll)/npiAll;
  difsrvPyn = 100*dif(srvPyn)/srvPyn;
  difsrvAll = 100*dif(srvAll)/srvAll;
cards4;
2012 3101 880644  4041475  834770973
2013 3318 909605  4672408  842761312
2014 3515 938146  5382180  848335652
2015 3678 968417  5508845  862558384
;;;;
run;quit;

%include "c:/oto/utl_rtflan100.sas";
%utl_rtflan100;

title;
footnote;

options orientation=landscape;
ods rtf file="d:/phy/rtf/&pgm._pynDif.rtf" style=utl_rtflan100;
ods escapechar='^';
ods rtf prepage="^S={outputwidth=100% just=l font_size=11pt font_face=arial}
  {Pain Management Providers} ^R/RTF'\line' ^R/RTF'\line'      1. Addiction Medicine ^R/RTF'\line'      2. Pain Management
  ^R/RTF'\line'      3. Interventional Pain Management ";
proc report data=phy._difpyn nowd missing split='#';
cols year
   ( "Counts"
    ("Providers(NPI)" npipyn npiall )
    ("Services"       srvpyn srvall )
   ) spc1
   ("Percent Change"
    ("NPI"      difnpipyn difnpiall )
    ("Services" difsrvpyn difsrvall )
   );
define YEAR     / display          style(column)={just=c cellwidth=7%};
define NPIPYN   / display "Pain" format=comma15.  style(column)={just=c cellwidth=10%};
define NPIALL   / display "All"  format=comma15.  style(column)={just=c cellwidth=10%};
define SRVPYN   / display "Pain" format=comma15.  style(column)={just=c cellwidth=12%};
define SRVALL   / display "All"  format=comma15.  style(column)={just=c cellwidth=12%};
define spc1     / display ""  style(column)={just=c cellwidth=3%};
define DIFNPIPYN/ display "Pain" format=comma5.1  style(column)={just=c cellwidth= 9%};
define DIFNPIALL/ display "All"  format=comma5.1  style(column)={just=c cellwidth= 9%};
define DIFSRVPYN/ display "Pain" format=comma5.1  style(column)={just=c cellwidth= 9%};
define DIFSRVALL/ display "All"  format=comma5.1  style(column)={just=c cellwidth= 9%};
run;quit;
ods rtf text="^S={outputwidth=100% just=r font_size=9pt} Page 1 of 1";
ods rtf text="^S={outputwidth=100% just=l font_size=8pt font_style=italic}  {SOURCES:^R/RTF'\line'  }";
ods rtf text="^S={outputwidth=100% just=l font_size=8pt font_style=italic}  {    d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY2012.TXT}";
ods rtf text="^S={outputwidth=100% just=l font_size=8pt font_style=italic}  {    d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY2013.TXT}";
ods rtf text="^S={outputwidth=100% just=l font_size=8pt font_style=italic}  {    d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY2014.TXT}";
ods rtf text="^S={outputwidth=100% just=l font_size=8pt font_style=italic}  {    d:\phy\txt\Medicare_Provider_Util_Payment_PUF_CY2015.TXT}";
ods rtf close;

*                 __               _
 _ __  _ __ ___  / _| ___  ___ ___(_) ___  _ __
| '_ \| '__/ _ \| |_ / _ \/ __/ __| |/ _ \| '_ \
| |_) | | | (_) |  _|  __/\__ \__ \ | (_) | | | |
| .__/|_|  \___/|_|  \___||___/___/_|\___/|_| |_|
|_|
;

Data phy.&pgm._edddoc(
     /*index=(edd_sufix/unique*/
     label="Sudeshna editited professions");
retain key;
length
  edd_hier
  edd_professions
  edd_flg
  edd_sufix
          $64;
input;
key=put(200000+_n_+3,z6.);
edd_hier        =upcase(scan(_infile_,1,' '));
edd_professions= upcase(scan(_infile_,2,' '));
edd_flg        = upcase(scan(_infile_,3,' '));
edd_sufix      = catx(' ',scan(_infile_,4,' '),scan(_infile_,5,' '));
if edd_sufix='' then put (_all_) (= $ /) //;

/*
edd_professions=tranwrd(edd_professions,'???','?');
edd_professions=tranwrd(edd_professions,'??' ,'?');
*/
cards4;
1      MD      yes      MD SR
1      MD      yes      MD
1      MD      yes      MDCM
1      MD      yes      FHM MPH
1      MD      yes      FACS
1      MD      yes      PC FACP
1      MD      yes      PC FACS
1      MD      yes      FAAFP
1      MD      yes      FAAP FACS
1      MD      yes      FAAP MS
1      MD      yes      FACP MS
1      MD      yes      FACP PHD
1      MD      yes      PC FAAP
1      MD      yes      FAAFP MPH
1      MD      yes      FAAFP MSPH
1      MD      yes      FAAFP PHD
1      MD      yes      FAAP MPH
1      MD      yes      FACC
1      MD      yes      FACC FACP
1      MD      yes      FACC MA
1      MD      yes      FACC MBA
1      MD      yes      FACC MSC
1      MD      yes      FACP
1      MD      yes      FACP DDS
1      MD      yes      FACP DMD
1      MD      yes      FACP JD
1      MD      yes      FACP MA
1      MD      yes      FACP MSD
1      MD      yes      FACS MBA
1      MD      yes      FACS MPH
1      MD      yes      FACS MS
1      MD      yes      FACS PA
1      MD      yes      FACS PC
1      MD      yes      MPH FAAP
1      MD      yes      FHM FAAP
1      MD      yes      FHM FACP
1      MD      yes      PHD MD
1      MD      yes      MPH MD
1      MD      yes      PC MD
1      MD      yes      PA MD
1      MD      yes      MD DDS
1      MD      yes      MDPHD
1      MBBS      yes      MBBS
1      MD      yes      MD DMD
1      MD      yes      DR
1      MD      yes      MS MD
1      MD      yes      FACS MD
1      MD      yes      DDS MD
1      MD      yes      MBA MD
1      MD      yes      MDMPH
1      MD      yes      FACP MD
1      MD      yes      MBBS MD
1      MD      yes      LTD MD
1      MD      yes      DDSMD
1      MD      yes      FACC MD
1      MD      yes      MD MBBS
1      MD      yes      MSC MD
1      MD      yes      LLC MD
1      MD      yes      MD-PHD
1      MD      yes      DMDMD
1      MD      yes      DOCTOR
1      MD      yes      PLLC MD
1      MD      yes      FAAP MD
1      MD      yes      MD MD
1      MD      yes      CM MD
1      MD      yes      MSPH MD
1      MD      yes      MD DO
1      MD      yes      JD MD
1      MD      yes      MDPC
1      MD      yes      MD MA
1      MD      yes      MDMBA
1      MD      yes      MHS MD
1      MD      yes      PS MD
1      MD      yes      DO MD
1      MD      yes      MA MD
1      MD      yes      MD MS
1      MD      yes      PSC MD
1      MD      yes      MD BA
1      MD      yes      MD MI
1      MD      yes      MED MD
1      MD      yes      MD DR
1      MD      yes      MD DVM
1      MD      yes      MD KY
1      MD      yes      FAAFP MD
1      MD      yes      MDFACS
1      MD      yes      MD BS
1      MD      yes      APC MD
1      MD      yes      PHARMD MD
1      MD      yes      MBBSMD
1      MD      yes      MD MPH
1      MD      yes      MDFACP
1      MD      yes      MDMBBS
1      MD      yes      MHA MD
1      MD      yes      MPP MD
1      MD      yes      APMC MD
1      MBBS      yes      MPH MBBS
1      MD      yes      FACS PHD
1      MD      yes      DVM MD
1      MD      yes      MD DS
1      MD      yes      MD FORBES
1      MD      yes      MD PA
1      MD      yes      MDDMD
1      MD      yes      MDJD
1      MD      yes      MDMD
1      MBBS      yes      PHD MBBS
1      MD      yes      FACP MPH
1      MD      yes      JDMD
1      MD      yes      MBCHB MD
1      MD      yes      MD CS
1      MD      yes      MD DPM
1      MD      yes      MD MP
1      MD      yes      MD PECK
1      MD      yes      MD PS
1      MD      yes      MDFCCP
1      MD      yes      MDINC
1      MD      yes      RPH MD
1      MD      yes      DR MD
1      MD      yes      ND MD
1      MD      yes      DPM MD
1      MD      yes      MBBCH MD
1      MD      yes      MD JD
1      MD      yes      MD LR
1      MD      yes      MD MF
1      MD      yes      MD PHUOC
1      MD      yes      MICHAELMD
1      MD      yes      MMSC MD
1      MD      yes      MPA MD
1      MD      yes      BS MD
1      MD      yes      MD CM
1      MD      yes      MD FM
1      MD      yes      MD LD
1      MD      yes      MD MBBCH
1      MD      yes      MD MBCHB
1      MD      yes      MD PC
1      MD      yes      MDDO
1      MD      yes      MDFAAFP
1      MD      yes      MDFACC
1      MD      yes      MDFACEP
1      MD      yes      MDLLC
1      MD      yes      MDMHS
1      MD      yes      MDPM
1      MD      yes      MFA MD
1      MD      yes      MHSA MD
1      MD      yes      MSCI MD
1      MD      yes      MSHP MD
1      MD      yes      SR MD
1      MD      yes      PROF MD
1      MD      yes      RDMS MD
1      NP      yes      MSN PMHNP-BC
1      MD      yes      PHDMD
1      MD      yes      PHYSICIAN
1      MD      yes      CMD MD
1      MD      yes      DVMMD
1      MD      yes      MBE MD
1      MD      yes      MDPHDMBA
1      MD      yes      MHSC MD
1      MD      yes      MSCR MD
1      MD      yes      MSCS MD
1      MD      yes      -MD
1      MD      yes      11MD
1      MD      yes      MD LK
1      MD      yes      MD ND
1      MD      yes      MD RN
1      MD      yes      MD RPH
1      MD      yes      MD111
1      MD      yes      MDFRCA
1      MD      yes      MDFRCS
1      MD      yes      MDIV MD
1      MD      yes      PLC MD
1      MBBS      yes      MHA MBBS
1      UNK      yes      LLC FACP
1*      MD      yes      MSHS MD
1      MD      yes      JOYCEMD
1      MD      yes      JRDMD
1      MD      yes      OD MD
1      MD      yes      PA-C MD
1      MD      yes      RNC MD
1      MD      yes      HMD MD
1      MD      yes      MBA MBBSMD
1      MD      yes      MD DM
1      MD      yes      MD DOCTOR
1      MD      yes      MD JDMD
1      MD      yes      MD MASTERS
1      MD      yes      MD MDH
1      MD      yes      MD MN
1      MD      yes      MD MSD
1      MD      yes      MD MSN
1      MD      yes      MD NP
1      MD      yes      MD PHARMD
1      MD      yes      MD VMD
1      MD      yes      MDCM MS
1      MD      yes      MDH MD
1      MD      yes      MDPHD LR
1      MD      yes      MED DR
1      MD      yes      MMS MD
1      MBBS      yes      MA MBBS
1      MBBS      yes      MBBS BS
1      MBBS      yes      MBBS MA
1      MBBS      yes      MHS MBBS
1      MBBS      yes      MSC MBBS
1      UNK      yes      CMD FACP
1      MD      yes      CPE MD
1      MD      yes      MPAS MD
1      MD      yes      MS MDMPH
1      MD      yes      MSA MD
1      MD      yes      PLLC DR
1      MD      yes      DM MD
1      MD      yes      FHM MD
1      MD      yes      LTD DR
1      MD      yes      MED MBCHB
1      MD      yes      MPH MBCHB
1            MD  UNK     MDPA
1      MD      UNK      MD PHD
1      MD      UNK      DMD MD
2      DO      yes      RDMS DO
2      DO      yes      DO
2      DO      yes      FACS DO
2      DO      yes      FAAFP DO
2      DO      yes      FAAP DO
2      DO      yes      FACP DO
2      DO      yes      MPH DO
2      DO      yes      PHD DO
2      DO      yes      PC DO
2      DO      yes      PA DO
2      DO      yes      MS DO
2      DO      yes      MBA DO
2      DO      yes      DO SR
2      DO      yes      LLC DO
2      DO      yes      CMD DO
2      DO      yes      DOMPH
2      DO      yes      PHARMD DO
2      DO      yes      DO PHD
2      DO      yes      LTD DO
2      DO      yes      PS DO
2      DO      yes      DO DVM
2      DO      yes      DO MS
2      DO      yes      DPM DO
2      DO      yes      PLLC DO
2      DO      yes      DDS DO
2      DO      yes      DO DPM
2      DO      yes      DO MPH
2      DO      yes      FACC DO
2      DO      yes      JD DO
2      DO      yes      MA DO
2      DO      yes      MDH DO
2      DO      yes      MED DO
2      DO      yes      MHA DO
2      DO      yes      MPS DO
2      DO      yes      PLC DO
2      DO      yes      MSC DO
3      dentist      yes      DMSC MS
3      Dentist      yes      DDS
3      Dentist      yes      DMD
3      Dentist      yes      MS DDS
3      Dentist      yes      PC DDS
3      Dentist      yes      PA DDS
3      Dentist      yes      MSD DDS
3      Dentist      yes      PC DMD
3      Dentist      yes      MS DMD
3      Dentist       yes      PA DMD
3      Dentist      yes      DDSMS
3      Dentist      yes      PHD DDS
3      Dentist      yes      LTD DDS
3      Dentist      yes      MSD DMD
3      Dentist      yes      PS DDS
3      Dentist      yes      MPH DDS
3      Dentist      yes      LLC DDS
3      Dentist      yes      PLLC DDS
3      Dentist      yes      DDS SR
3      dentist      yes      LLC DMD
3      Dentist      yes      MDS DDS
3      dentist      yes      DDM
3      Dentist      yes      DDSMSD
3      Dentist      yes      DDSPC
3      Dentist      yes      MPH DMD
3      Dentist      yes      PHD DMD
3      Dentist      yes      MDDDS
3      dentist      yes      PSC DMD
3      Dentist      yes      DMDMS
3      Dentist      yes      MMSC DMD
3      Dentist      yes      APC DDS
3      Dentist      yes      DDS DR
3      Dentist      yes      DDSINC
3      dentist      yes      DDS MS
3      dentist      yes      DMD DDS
3      dentist      yes      DDS DMD
3      dentist      yes      DMD SR
3      Dentist      yes      MDS DMD
3      dentist      yes      PLLC DMD
3      dentist      yes      DDS MI
3      Dentist      yes      DMDPC
3      Dentist      yes      LTD DMD
3      dentist      yes      PLC DDS
3      dentist      yes      DDS MA
3      dentist      yes      DMSC DDS
3      Dentist      yes      MA DDS
3      Dentist      yes      MMSC DDS
3      Dentist      yes      PS DMD
3      Dentist      yes      DDS KY
3      Dentist      yes      DMD DR
3      dentist       yes      DDDS
3      dentist       yes      DDMD
3      dentist       yes      DMD MS
3      dentist       yes      DMDPA
3      dentist      yes      MSC DMD
3      dentist      yes      DDSPHD
3      dentist      yes      DDS BA
3      dentist      yes      DDS PHD
3      dentist      yes      DENTIST
3      dentist      yes      MSCD DMD
3      Dentist      yes      DMD DMD
3      Dentist      yes      DMDLLC
3      dentist      yes      MHS DMD
3      dentist      yes      MSC DDS
3      dentist      yes      MSCD DDS
3      dentist      yes      MSED DMD
3      dentist      yes      DDS BDS
3      dentist      yes      DDSDMDMS
3      dentist      yes      DDSLTD
3      dentist      yes      DDSPS
3      Dentist      yes      BDS DDS
3      dentist      yes      DDS LK
3      dentist      yes      DDS PA
3      dentist      yes      DDS PHUOC
3      dentist      yes      DMD BA
3      dentist      yes      DMDINC
3      dentist      yes      DMDMPH
3      dentist      yes      DMDMSD
3      dentist      yes      DMDPHD
3      dentist      yes      DMDPSC
3      dentist      yes      DMSC DMD
3      dentist      yes      FACS DDS
3      dentist      yes      MBA DDS
3      dentist      yes      MBE DMD
3      dentist      yes      MDSC DMD
3      dentist      yes      -DDS
3      dentist      yes      ANNDDS
3      dentist      yes      RPH DDS
3      dentist      yes      MPA DDS
3      Dentist      yes      PDC DDS
3      Dentist      yes      PHARMD DDS
3      Dentist      yes      RPH DMD
3      Dentist      yes      SR DDS
3      Dentist      yes      SR DMD
3      dentist      yes      DDM DENTIST
3      dentist      yes      DDS BS
3      dentist      yes      DDS DDS
3      dentist      yes      DDS DENTIST
3      dentist      yes      DDS DVM
3      dentist      yes      DDS LD
3      dentist      yes      DDS MPH
3      dentist      yes      DDS MSD
3      dentist      yes      DDS MSN
3      dentist      yes      DDS ND
3      dentist      yes      DDS PC
3      dentist      yes      DDS RN
3      dentist      yes      DDS RPH
3      dentist      yes      DDSMD DDS
3      dentist      yes      DMD BDS
3      dentist      yes      DMD BS
3      dentist      yes      DMD CM
3      dentist      yes      DMD DM
3      dentist      yes      DMD DO
3      dentist      yes      DMD FORBES
3      dentist      yes      DMD MF
3      dentist      yes      DMD MI
3      dentist      yes      DMD PA
3      dentist      yes      DR DDS
3      dentist      yes      MDSC DDS
3      dentist      yes      MHA DDS
3      dentist      yes      MMS DDS
3      dentist      yes      APC DMD
3      dentist      yes      PLC DMD
3      dentist      yes      MSPA DDS
3      dentist      yes      ND DMD
3      Dentist      yes      PROF DDS
3      dentist      yes      MSHS DDS
3      dentist      yes      DO DMD
3      dentist      yes      LTD DDSMS
3      dentist      maybe      MSC BDS
4      NP      yes      PNP
4      NP      yes      NP
4      NP      yes      MNNP
4      NP      yes      FNP-BC
4      NP      yes      FNP
4      NP      yes      FNP APRN
4      NP      yes      FNP MSN
4      NP      yes      MSN-FNP
4      NP      yes      DNP
4      NP      yes      CNP
4      NP      yes      NP-C
4      NP      yes      NPC
4      NP      yes      CNNP
4      NP      yes      FNP-C
4      NP      yes      FNP-C MSN
4      NP      yes      CRNP
4      NP      yes      CPNP
4      NP      yes      ARNP
4      NP      yes      ANP
4      NP      yes      ACNP
4      NP      yes      FNP-BC MSN
4      NP      yes      NP MSN
4      NP      yes      APNP
4      NP      yes      PMHNP
4      NP      yes      NP-C MSN
4      NP      yes      CRNP MSN
4      NP      yes      ANP-BC
4      NP      yes      MSN NP
4      NP      yes      CFNP
4      NP      yes      ACNP-BC
4      NP      yes      NNP
4      NP      yes      WHNP
4      NP      yes      CPNP MSN
4      NP      yes      CNP MSN
4      NP      yes      MSNFNP
4      NP      yes      PMHNP-BC
4      NP      yes      APN NP
4      NP      yes      FNP RN
4      NP      yes      CNP RN
4      NP      yes      RNP
4      NP      yes      FNP MS
4      NP      yes      FNP-BC APRN
4      NP      yes      FNP-C APRN
4      NP      yes      ANP-C
4      NP      yes      GNP
4      NP      yes      ARNP MSN
4      NP      yes      NP MS
4      NP      yes      NPP
4      NP      yes      ANP-BC MSN
4      NP      yes      ANP MSN
4      NP      yes      APN MSN
4      NP      yes      NP APRN
4      NP      yes      CNM NP
4      NP      yes      FNP-C RN
4      NP      yes      NNP-BC
4      NP      yes      NP CNM
4      NP      yes      NP RN
4      NP      yes      ACNP MSN
4      NP      yes      WHNP-BC
4      NP      yes      ACNP-BC MSN
4      NP      yes      CPNP RN
4      NP      yes      FNP-BC RN
4      NP      yes      APRN NP
4      NP      yes      FNP-BC DNP
4      NP      yes      NNP-BC MSN
4      NP      yes      FNP-BC MS
4      NP      yes      PMHNP APRN
4      NP      yes      NP-C APRN
4      NP      yes      CRNA NP
4      NP      yes      FNP DNP
4      NP      yes      MSN FNP
4      NP      yes      CNP APRN
4      NP      yes      CPNP MS
4      NP      yes      CRNP MS
4      NP      yes      AGACNP
4      NP      yes      AGNP
4      NP      yes      ANP MS
4      NP      yes      ARNP MN
4      NP      yes      AGPCNP-BC
4      NP      yes      MSN-NP
4      NP      yes      NP PHD
4      NP      yes      PMHNP MSN
4      NP      yes      AG-ACNP
4      NP      yes      AGACNP-BC
4      NP      yes      APRN-NP
4      NP      yes      MSNNP
4      NP      yes      FNP CNM
4      NP      yes      NP-C RN
4      NP      yes      CPNP APRN
4      NP      yes      ANP RN
4      NP      yes      WHNP CNM
4      NP      yes      APRN-CNP
4      NP      yes      FNP-BC APN
4      NP      yes      MHNP APRN
4      NP      yes      CRNP DNP
4      NP      yes      FNP-C MS
4      NP      yes      FNPC
4      NP      yes      CPNP-PC
4      NP      yes      MSNFNP-BC
4      NP      yes      CPNP-AC
4      NP      yes      APRN DNP
4      NP      yes      FNP-C DNP
4      NP      yes      NP-BC
4      NP      yes      ACNP APRN
4      NP      yes      WHNP-BC MSN
4      NP      yes      RNNP
4      NP      yes      MSNCRNP
4      NP      yes      CFNP MSN
4      NP      yes      FPMHNP
4      NP      yes      MSN FNP-BC
4      NP      yes      MSNFNP-C
4      NP      yes      PMH-NP
4      NP      yes      PMHNP-BC MSN
4      NP      yes      WHNP MSN
4      NP      yes      ANP-C MSN
4      NP      yes      ARNP-C
4      NP      yes      FNP PHD
4      NP      yes      NP-CNM
4      NP      yes      AGPCNP
4      NP      yes      FNP NP
4      NP      yes      CNP APN
4      NP      yes      CNP MS
4      NP      yes      MSN-FNP-C
4      NP      yes      PNP MSN
4      NP      yes      CNM FNP
4      NP      yes      APNP MSN
4      NP      yes      GNP-BC
4      NP      yes      APRN FNP
4      NP      yes      MSN ARNP
4      NP      yes      NNP MSN
4      NP      yes      NP RNC
4      NP      yes      NP-C MS
4      NP      yes      PMHNP FNP
4      NP      yes      WHNP APRN
4      NP      yes      APRNFNP
4      NP      yes      ARNP DNP
4      NP      yes      CNM ARNP
4      NP      yes      CNS NP
4      NP      yes      MS NP
4      NP      yes      MSNP
4      NP      yes      WHCNP
4      NP      yes      AGNP-C
4      NP      yes      FNP APN
4      NP      yes      FNP ARNP
4      NP      yes      FNP-BC PHD
4      NP      yes      FNP MN
4      NP      yes      ARNP-BC
4      NP      yes      DNP NP
4      NP      yes      APNP FNP-BC
4      NP      yes      PMHNP-BC APRN
4      NP      yes      ENP
4      NP      yes      ANP-BC MS
4      NP      yes      ANP-BC RN
4      NP      yes      ARNP CNM
4      NP      yes      PHD NP
4      NP      yes      APN-C NP
4      NP      yes      CNMNP
4      NP      yes      DNP FNP
4      NP      yes      FNP-BC ARNP
4      NP      yes      FNP-C ARNP
4      NP      yes      MSFNP
4      NP      yes      NP DNP
4      NP      yes      ACNP MS
4      NP      yes      FNPBC
4      NP      yes      PMHNP-BC RN
4      NP      yes      PNP APRN
4      NP      yes      MS-FNP
4      NP      yes      MSNCNP
4      NP      yes      APN DNP
4      NP      yes      CPNP-AC MSN
4      NP      yes      CRNP NP
4      NP      yes      FNP RNC
4      NP      yes      PNP MS
4      NP      yes      PNP-BC
4      NP      yes      ARNP PHD
4      NP      yes      CNM DNP
4      NP      yes      MSN CRNP
4      NP      yes      MSN-ACNP
4      NP      yes      MSNARNP
4      NP      yes      NP-C DNP
4      NP      yes      ACNP-BC MS
4      NP      yes      NPMSN
4      NP      yes      ACNP-C
4      NP      yes      ANP-BC DNP
4      NP      yes      APNCNP
4      NP      yes      C-FNP
4      NP      yes      CFNP RN
4      NP      yes      CRNP PHD
4      NP      yes      FNP-BC APNP
4      NP      yes      FNPC MSN
4      NP      yes      MSN DNP
4      NP      yes      MSN NP-C
4      NP      yes      MSN-FNP-BC
4      NP      yes      MSNNP-C
4      NP      yes      NP CNS
4      NP      yes      NP-C APN
4      NP      yes      NP-C FNP
4      NP      yes      PMHNP RN
4      NP      yes      DNP MSN
4      NP      yes      ACNP-BC RN
4      NP      yes      AGACNP APRN
4      NP      yes      AGACNP-BC MSN
4      NP      yes      ARNP CRNA
4      NP      yes      C-NP
4      NP      yes      DNPFNP
4      NP      yes      FNPMSN
4      NP      yes      FPMHNP-BC
4      NP      yes      MN ARNP
4      NP      yes      MSN FNP-C
4      NP      yes      MSN-CRNP
4      NP      yes      RN-CNP
4      NP      yes      RNCPNP
4      NP      yes      NP APN
4      NP      yes      NP-CNS
4      NP      yes      PNP-AC
4      NP      yes      APRN-FNP
4      NP      yes      APRNNP
4      NP      yes      BC-FNP
4      NP      yes      CNP DNP
4      NP      yes      CRNP-F
4      NP      yes      FNP-C APN
4      NP      yes      ANP RNC
4      NP      yes      ARNP MS
4      NP      yes      NNP-BC RN
4      NP      yes      NP PMH
4      NP      yes      NP-C FNP-BC
4      NP      yes      PNP-BC MSN
4      NP      yes      RNCNP
4      NP      yes      MSNANP
4      NP      yes      DNP CRNP
4      NP      yes      DNPFNP-BC
4      NP      yes      DRNP
4      NP      yes      FNP APRN-BC
4      NP      yes      FNP-APRN
4      NP      yes      FNP-BC CRNP
4      NP      yes      MSN CNP
4      NP      yes      MSN-ANP
4      NP      yes      MSN-NNP
4      NP      yes      MSN-PMHNP
4      NP      yes      MSNCPNP
4      NP      yes      NP CS
4      NP      yes      NP MN
4      NP      yes      NP-BC MSN
4      NP      yes      ANP APRN
4      NP      yes      ANP PHD
4      NP      yes      ANP-BC APRN
4      NP      yes      ANP-C MS
4      NP      yes      ANP-C RN
4      NP      yes      APNP CRNA
4      NP      yes      APNP FNP
4      NP      yes      APNP MS
4      NP      yes      APRN-FNP-BC
4      NP      yes      APRNFNP-C
4      NP      yes      CRNA ARNP
4      NP      yes      PNP RN
4      NP      yes      RNFNP
4      NP      yes      WHNP RNC
4      NP      yes      ARNP RN
4      NP      yes      CPNP APN
4      NP      yes      NNP-BC APRN
4      NP      yes      NNP-BC MS
4      NP      yes      FNP-BC NP
4      NP      yes      FNP-C CRNP
4      NP      yes      GNP ANP
4      NP      yes      GNP MSN
4      NP      yes      GNP RN
4      NP      yes      GNP-BC MSN
4      NP      yes      NNP APRN
4      NP      yes      NP CRNA
4      NP      yes      NP FNP-BC
4      NP      yes      NP NP
4      NP      yes      ACNP-BC APRN
4      NP      yes      ACNP-BC DNP
4      NP      yes      AGPCNP-BC MSN
4      NP      yes      APNC NP
4      NP      yes      CNM WHNP
4      NP      yes      CRNP RN
4      NP      yes      DNP APRN
4      NP      yes      MSN WHNP
4      NP      yes      MSN WHNP-BC
4      NP      yes      PC NP
4      NP      yes      APRNFNP-BC
4      NP      yes      PMHNP-BC PHD
4      NP      yes      ACNP DNP
4      NP      yes      ACNP FNP
4      NP      yes      ACNP RN
4      NP      yes      ACNP-BC APN
4      NP      yes      AFNP
4      NP      yes      AG-ACNP MS
4      NP      yes      AGNP MSN
4      NP      yes      AGNP-BC MSN
4      NP      yes      AGNP-C MSN
4      NP      yes      AGPCNP MSN
4      NP      yes      AHNP APRN
4      NP      yes      APN-A NP
4      NP      yes      APN-BC NP
4      NP      yes      APNNP
4      NP      yes      APNP-BC
4      NP      yes      APRN CPNP
4      NP      yes      APRNCPNP
4      NP      yes      CNP CNM
4      NP      yes      CNSNP
4      NP      yes      CPNP-AC APRN
4      NP      yes      DNP-FNP
4      NP      yes      DNPFNP-C
4      NP      yes      FNP-C APNP
4      NP      yes      FNP-MSN
4      NP      yes      GNP APRN
4      NP      yes      GNP-BC ANP-BC
4      NP      yes      GNP-BC APRN
4      NP      yes      GNP-BC RN
4      NP      yes      MS FNP
4      NP      yes      MSN CPNP
4      NP      yes      MSNACNP
4      NP      yes      MSNPNP
4      NP      yes      NP CRNP
4      NP      yes      NP-C CRNP
4      NP      yes      NP-P
4      NP      yes      NPA
4      NP      yes      OGNP
4      NP      yes      RN NP
4      NP      yes      WHNP RN
4      NP      yes      WHNP-BC APRN
4      NP      yes      WHNP-BC CNM
4      NP      yes      MSN MPH
4      NP      yes      PA NP
4      NP      yes      PMHNP-BC DNP
4      NP      yes      PPCNP-BC
4      NP      yes      MSN-AGACNP
4      NP      yes      ANP DNP
4      NP      yes      ANPGNP
4      NP      yes      APN-CNP
4      NP      yes      APN-FNP
4      NP      yes      APNCRNA
4      NP      yes      APNP ANP-BC
4      NP      yes      APNP CNM
4      NP      yes      APNP CPNP
4      NP      yes      CPNP DNP
4      NP      yes      CPNP-ACPC
4      NP      yes      CPNP-PC MSN
4      NP      yes      CPNP-PC RN
4      NP      yes      CRNAARNP
4      NP      yes      CRNP-A
4      NP      yes      DNPAPRN
4      NP      yes      FNP CNS
4      NP      yes      FNP-BC MN
4      NP      yes      FNP-BC RNMSN
4      NP      yes      FNP-PP
4      NP      yes      FNPAPRN
4      NP      yes      FNPC RN
4      NP      yes      FNPPMHNP
4      NP      yes      GNP FNP
4      NP      yes      MHNP FNP
4      NP      yes      MN-FNP
4      NP      yes      MS ANP
4      NP       yes      PMHNP DNP
4      NP       yes      PMHNP MS
4      NP       yes      PMHNP-BC MS
4      NP       yes      PNP-AC MSN
4      NP       yes      RN FNP
4      NP       yes      RN FNP-BC
4      NP       yes      RN NP-C
4      NP       yes      RN-FNP
4      NP       yes      WHCNP CNM
4      NP       yes      WHNP-BC ANP-BC
4      NP       yes      WHNP-BC RN
4      NP      yes      GNP MS
4      NP      yes      MSN-ARNP
4      NP      yes      MSN-CNP
4      NP      yes      MSN-PNP
4      NP      yes      MSNANP-BC
4      NP      yes      NP BSN
4      NP      yes      NP MI
4      NP      yes      NP-C APNP
4      NP      yes      NP-C ARNP
4      NP      yes      NP-C MN
4      NP      yes      NP-CRNA
4      NP      yes      MSNCFNP
4      NP      yes      MSNNNP-BC
4      NP      yes      MSNPMHNP
4      NP      yes      NNP RNC
4      NP      yes      PHD ARNP
4      NP      yes      PHD FNP
4      NP      yes      PHD FNP-BC
4      NP      yes      RNMSNFNP-BC
4      NP      yes      AG-ACNP-BC
4      NP      yes      AGACNP-BC DNP
4      NP      yes      AGNP-BC
4      NP      yes      APRN NP-C
4      NP      yes      ARNPCNM
4      NP      yes      C-FNP MSN
4      NP      yes      CFNP MS
4      NP      yes      CNP RNC
4      NP      yes      MSFNP-BC
4      NP      yes      DSS
4      NP      yes      ACNPC-AG
4      NP      yes      ECRNP
4      NP       yes      ACNP-BC CRNP
4      NP       yes      ACNP-BC NP
4      NP       yes      ACNP-C RN
4      NP       yes      AGACNP RN
4      NP       yes      AGNP-C APRN
4      NP       yes      AGPCNP-BC RN
4      NP       yes      ANP CNS
4      NP       yes      ANP CS
4      NP       yes      ANP NP
4      NP       yes      ANP-BC APN
4      NP       yes      ANP-BC NP
4      NP       yes      AOCNP
4      NP       yes      APMHNP
4      NP       yes      APNFNP-BC
4      NP       yes      APNP FNP-C
4      NP       yes      APNP NP-C
4      NP       yes      APNP RN
4      NP       yes      APRN FNP-BC
4      NP       yes      APRN-BC FNP
4      NP       yes      APRN-NP MSN
4      NP       yes      ARNP NP
4      NP       yes      ARNP-C MSN
4      NP       yes      CNM ANP
4      NP       yes      CNMFNP
4      NP       yes      CNP FNP
4      NP       yes      CPNP NP
4      NP       yes      CPNP-AC RN
4      NP       yes      CPNP-PC APRN
4      NP       yes      DNP ARNP
4      NP       yes      DNP CNM
4      NP       yes      DNP FNP-BC
4      NP       yes      DNP FNP-C
4      NP       yes      DNP PNP
4      NP       yes      DNPCRNP
4      NP       yes      FNP PA
4      NP       yes      FNP PNP
4      NP       yes      FNP-BC ANP-BC
4      NP       yes      FNP-BC CNM
4      NP       yes      FNPBC MSN
4      NP       yes      GNP RNC
4      NP       yes      GNP-BC ANP-C
4      NP       yes      GNP-BC MS
4      NP       yes      MPH FNP-BC
4      NP       yes      MS ARNP
4      NP       yes      MS-NP
4      NP       yes      MSN ACNP
4      NP       yes      MSN APNP
4      NP       yes      MSN RNP
4      NP       yes      MSN-ACNP-BC
4      NP       yes      MSN-AGNP
4      NP       yes      MSN-APNP
4      NP       yes      MSN-FNP NP
4      NP       yes      MSN-WHNP
4      NP       yes      MSNAPRNFNP
4      NP       yes      MSNNNP
4      NP       yes      MSNRNFNP-BC
4      NP       yes      NNP MS
4      NP       yes      NNP-BC CRNP
4      NP       yes      NNP-BC PHD
4      NP       yes      NP MA
4      NP       yes      NPCNS
4      NP       yes      RN ANP
4      NP       yes      RN PMHNP-BC
4      NP       yes      RNC NP
4      NP       yes      RNC-FNP
4      NP       yes      RNCNNP
4      NP       yes      RNMSNCPNP
4      NP       yes      RNMSNFNP
4      NP       yes      RNMSNFNP-C
4      NP       yes      RNMSNNP
4      NP       yes      RNMSNP
4      NP       yes      WHNP-BC NP
4      NP      yes      FNP MASTERS
4      NP      yes      CRNP-F MSN
4      NP      yes      CRNPMSN
4      NP      yes      CNNP RNC
4      NP      yes      CNP-BC
4      NP      yes      CNPMSN
4      NP      yes      MFNP
4      NP      yes      PMHNP-BC APN
4      NP      yes      PMHS CPNP
4      NP      yes      PNP FNP
4      NP      yes      PNP-C
4      NP      yes      RNP MS
4      NP      yes      RNP MSN
4      NP      yes      PHMNP-BC
4      NP      yes      ACHPN FNP-BC
4      NP      yes      ACHPN GNP-BC
4      NP      yes      ACNP ANP
4      NP      yes      ACNP-BC FNP-BC
4      NP      yes      ACNP-BC FNP-C
4      NP      yes      ACNP-BC PHD
4      NP      yes      ACNP-BC RNMSN
4      NP      yes      ACPNP
4      NP      yes      ACRNP
4      NP      yes      AG-ACNP MSN
4      NP      yes      AGACNP DNP
4      NP      yes      AGNP-BC RN
4      NP      yes      AGPCNP APRN
4      NP      yes      AGPCNP-BC MS
4      NP      yes      AGPCNP-C
4      NP      yes      ANP APN
4      NP      yes      ANP BSN
4      NP      yes      ANP CNM
4      NP      yes      ANP MN
4      NP      yes      ANP-BC CRNP
4      NP      yes      ANP-BC PHD
4      NP      yes      ANP-C PHD
4      NP      yes      ANPBC
4      NP      yes      ANPC MSN
4      NP      yes      ANPMS
4      NP      yes      APN FNP
4      NP      yes      APN NP-C
4      NP      yes      APN-NP
4      NP      yes      APNP CNS
4      NP      yes      APNP DNP
4      NP      yes      APNP-C
4      NP      yes      APRN PMHNP
4      NP      yes      APRN-BC NP
4      NP      yes      APRN-FNP-C
4      NP      yes      APRN-NNP
4      NP      yes      APRN-NNP-BC
4      NP      yes      APRNCNP
4      NP      yes      APRNCRNP
4      NP      yes      ARNP FNP
4      NP      yes      ARNP MSN-FNP
4      NP      yes      ARNP-BC MS
4      NP      yes      ARNP-BC MSN
4      NP      yes      ARNP-FNP
4      NP      yes      ARNP-FNP-BC
4      NP      yes      ARNP-FNP-C
4      NP      yes      BC-ANP
4      NP      yes      BC-FNP APRN
4      NP      yes      BC-FNP MSN
4      NP      yes      C-ANP
4      NP      yes      C-PNP
4      NP      yes      C-PNP MSN
4      NP      yes      C-RNP
4      NP      yes      CFNP APRN
4      NP      yes      CFNP-BC
4      NP      yes      CGNP
4      NP      yes      CNM CNP
4      NP      yes      CNP ARNP
4      NP      yes      CNP BSN
4      NP      yes      CNP CNS
4      NP      yes      CNP MPH
4      NP      yes      CNP PHD
4      NP      yes      CNP-FNP
4      NP      yes      CPNP ARNP
4      NP      yes      CPNP BSN
4      NP      yes      CPNP FNP
4      NP      yes      CPNP PHD
4      NP      yes      CPNP-AC MS
4      NP      yes      CPNP-BC
4      NP      yes      CPNP-PCAC
4      NP      yes      CRNA DNP
4      NP      yes      CRNP APRN
4      NP      yes      CRNP CNM
4      NP      yes      CRNP FNP-BC
4      NP      yes      CRNP-AC
4      NP      yes      CRNP-F MS
4      NP      yes      CRNP-FAMILY
4      NP      yes      CS NP
4      NP      yes      DNPCNP
4      NP      yes      DNPNP
4      NP      yes      FNP ACNP
4      NP      yes      FNP ANP
4      NP      yes      FNP BSN
4      NP      yes      FNP DNSC
4      NP      yes      FNP GNP
4      NP      yes      FNP MNSC
4      NP      yes      FNP MPH
4      NP      yes      FNP PMHNP
4      NP      yes      FNP RNMSN
4      NP      yes      FNP SR
4      NP      yes      FNP WHNP
4      NP      yes      FNP-BC ACNP-BC
4      NP      yes      FNP-BC ANP
4      NP      yes      FNP-BC BSN
4      NP      yes      FNP-BC CNP
4      NP      yes      FNP-BC DRNP
4      NP      yes      FNP-C CNM
4      NP      yes      FNP-C CNS
4      NP      yes      FNP-C MN
4      NP      yes      FNP-C RNMSN
4      NP      yes      FNP-DNP
4      NP      yes      FNPC APRN
4      NP      yes      FNPC MN
4      NP      yes      FNPPMHNP-BC
4      NP      yes      FPMHNP APRN
4      NP      yes      FPMHNP-BC ARNP
4      NP      yes      FPMHNP-BC MSN
4      NP      yes      GNP-C
4      NP      yes      GNP-C ANP-C
4      NP      yes      MASTERS NP
4      NP      yes      MCRNP
4      NP      yes      MPH DNP
4      NP      yes      MPH FNP
4      NP      yes      MPH NP
4      NP      yes      MS RNP
4      NP      yes      MS-ACNP
4      NP      yes      MS-ARNP
4      NP      yes      MSCNP
4      NP      yes      MSCRNP
4      NP       yes      A-GNP
4      NP       yes      AGACNP MSN
4      NP       yes      AGACNP-BC APRN
4      NP       yes      APMHNP-BC
4      NP       yes      APNCRNA NP
4      NP       yes      CNM WHNP-BC
4      NP       yes      CNMCNP
4      NP       yes      DNP APN
4      NP       yes      DNP CRNA
4      NP       yes      DNP-CRNP
4      NP       yes      MSN-NP-C
4      NP       yes      MSNANP-C
4      NP       yes      MSNAPNFNP-BC
4      NP       yes      MSNAPNP
4      NP       yes      MSNCRNA NP
4      NP       yes      MSNRNCPNP
4      NP       yes      MSNRNNNP-BC
4      NP       yes      NNP BSN
4      NP       yes      NNP RN
4      NP       yes      NNP-BC APN
4      NP       yes      NNP-BC ARNP
4      NP       yes      NP APN-BC
4      NP       yes      NP CM
4      NP       yes      NP MD
4      NP       yes      NP MLP
4      NP       yes      NP-C ANP-BC
4      NP       yes      NP-C APRN-BC
4      NP       yes      NP-C CNM
4      NP       yes      NP-C NP
4      NP       yes      NP-C PHD
4      NP       yes      NP-F
4      NP       yes      NP-PP
4      NP       yes      NPC MSN
4      NP       yes      NPP ANP
4      NP       yes      NPP CPNP
4      NP       yes      NPP PHD
4      NP       yes      OGNP RN
4      NP      yes      PMHNP ANP
4      NP      yes      PMHNP APN
4      NP      yes      PMHNP CNM
4      NP      yes      PMHNP MN
4      NP      yes      PMHNP-BC MN
4      NP      yes      PMHNP-BC NP
4      NP      yes      PMHNP-BC RNNP
4      NP      yes      PMHNP-C
4      NP      yes      PMNHP
4      NP      yes      PNP MN
4      NP      yes      PNP RNC
4      NP      yes      PNP-BC MS
4      NP      yes      RN ACNP-BC
4      NP      yes      RN CPNP
4      NP      yes      RN FNP-C
4      NP      yes      RNCCNNP
4      NP      yes      RNCSNP
4      NP      yes      WHCNP APRN
4      NP      yes      WHCNP MSN
4      NP      yes      WHNP ANP
4      NP      yes      WHNP MS
4      NP      yes      WHNP-BC APN
4      NP      yes      WHNP-BC CRNP
4      NP      yes      WHNP-BC DNP
4      NP      yes      WHNP-BC FNP-BC
4      NP      yes      WHNP-BC FNP-C
4      NP      yes      WHNP-BC MS
4      NP      yes      MSN ANP-BC
4      NP      yes      MSN C-NP
4      NP      yes      MSNGNP
4      NP      yes      MSNPMHNP-BC
4      NP      yes      PC FNP-C
4      NP      yes      PHD ANP
4      NP      yes      PHD PMHNP
4      NP      yes      PHMNP-BC MSN
4      NP      yes      RNCPNPMSN
4      NP      yes      MS APNP
4      NP      yes      MSNACNP-BC
4      NP      yes      MSNCPNP RN
4      NP      yes      MSNFNPC
4      NP      yes      MN NP
4      NP      yes      PMHNP ARNP
4      NP      yes      PMHNP FNP-BC
4      NP      yes      PMHNP GNP
4      NP      yes      PMHNP NP
4      NP      yes      PMHNP-BC ANP-BC
4      NP      yes      PMHNP-BC ARNP
4      NP      yes      PMHNP-BC CRNP
4      NP      yes      PMHNP-BC CRNP-BC
4      NP      yes      PMHNP-BC CS
4      NP      yes      PMHNP-BC FNP
4      NP      yes      PMHNP-BC FNP-BC
4      NP      yes      PMHNP-BC FNP-C
4      NP      yes      PMHNP-BC GNP-BC
4      NP      yes      PMHNP-BC MA
4      NP      yes      PMHNP-BC PNP
4      NP      yes      PMHNP-BC RNMSN
4      NP      yes      PMHNP-C FNP-C
4      NP      yes      PMNHP APRN
4      NP      yes      PNP ANP
4      NP      yes      PNP APN
4      NP      yes      PNP DNP
4      NP      yes      PNP NNP
4      NP      yes      PNP PHD
4      NP      yes      PNP PMHNP
4      NP      yes      PNP RNCS
4      NP      yes      PNP-AC BSNMSN
4      NP      yes      PNP-AC MS
4      NP      yes      PNP-BC APN
4      NP      yes      PNP-BC APRN
4      NP      yes      PNP-BC DNP
4      NP      yes      PNP-BC MNSC
4      NP      yes      PNP-BC NP
4      NP      yes      PNP-BC PHD
4      NP      yes      PNP-BC RN
4      NP      yes      PNP-C APRN
4      NP      yes      PPCNP-BC APRN
4      NP      yes      PPCNP-BC MS
4      NP      yes      PPCNP-BC MSN
4      NP      yes      PPCNP-BC NP
4      NP      yes      RN CNP
4      NP      yes      RN DNP
4      NP      yes      RN GNP
4      NP      yes      RN MSNFNP-BC
4      NP      yes      RN PMHNP
4      NP      yes      RN-CNP MS
4      NP      yes      RNC ARNP
4      NP      yes      RNC-ANP
4      NP      yes      RNC-ANP MSN
4      NP      yes      RNCNP MN
4      NP      yes      RNFA ANP
4      NP      yes      RNFA CRNP
4      NP      yes      RNFA FNP-C
4      NP      yes      RNMSNCPNP NP
4      NP      yes      RNNP MSN
4      NP      yes      RNP CNM
4      NP      yes      RNP RN
4      NP      yes      RNPC MS
4      NP      yes      WHCNP MN
4      NP      yes      WHCNP RN
4      NP      yes      WHNP APN
4      NP      yes      WHNP BSN
4      NP      yes      WHNP FNP
4      NP      yes      WHNP FNP-C
4      NP      yes      WHNP NP
4      NP      yes      WHNP PHD
4      NP      yes      WHNP-BC BSN
4      NP      yes      WHNP-BC MN
4      NP      yes      WHNP-BC NP-C
4      NP      yes      DNAP
4      NP      yes      DNP ANP-BC
4      NP      yes      DNP ARNP-BC
4      NP      yes      DNP CNP
4      NP      yes      DNP CNS
4      NP      yes      DNP MP
4      NP      yes      DNP MS
4      NP      yes      DNP NNP
4      NP      yes      DNP PHD
4      NP      yes      DNP PMHNP-BC
4      NP      yes      DNP RN
4      NP      yes      DNP-FNP MS
4      NP      yes      DNP-FNP-C
4      NP      yes      DNP-FNP-C ARNP
4      NP      yes      DNPARNPFNP-C
4      NP      yes      FNP ACNP-BC
4      NP      yes      FNP ANP-BC
4      NP      yes      FNP APN-C
4      NP      yes      FNP APRN-CRNA
4      NP      yes      FNP APRNBC
4      NP      yes      FNP APRNMSN
4      NP      yes      FNP BSMS
4      NP      yes      FNP CRN
4      NP      yes      FNP CRNA
4      NP      yes      FNP CRNP
4      NP      yes      FNP CS
4      NP      yes      FNP ENP
4      NP      yes      FNP LR
4      NP      yes      FNP MSN-APRN
4      NP      yes      FNP MSN-RN
4      NP      yes      FNP NNP
4      NP      yes      FNP NP-C
4      NP      yes      FNP NPP
4      NP      yes      FNP RNCS
4      NP      yes      FNP-BC AGACNP-BC
4      NP      yes      FNP-BC APRN-C
4      NP      yes      FNP-BC APRN-NP
4      NP      yes      FNP-BC CNS-BC
4      NP      yes      FNP-BC CPN
4      NP      yes      FNP-BC CPNP
4      NP      yes      FNP-BC DNPAPRN
4      NP      yes      FNP-BC FORBES
4      NP      yes      FNP-BC MPH
4      NP      yes      FNP-BC MSC
4      NP      yes      FNP-BC MSNCRNP
4      NP      yes      FNP-BC NP-C
4      NP      yes      FNP-BC NPP
4      NP      yes      FNP-BC PCNS-BC
4      NP      yes      FNP-BC RNC
4      NP      yes      FNP-C AGNP-C
4      NP      yes      FNP-C ANP-BC
4      NP      yes      FNP-C ANP-C
4      NP      yes      FNP-C APRN-NP
4      NP      yes      FNP-C BSN
4      NP      yes      FNP-C CPNP
4      NP      yes      FNP-C MA
4      NP      yes      FNP-C MSN-APRN
4      NP      yes      FNP-C ND
4      NP      yes      FNP-C NP
4      NP      yes      FNP-C PA-C
4      NP      yes      FNPACNP
4      NP      yes      FNPACNP MSN
4      NP      yes      FNPBC APN
4      NP      yes      FNPBC APRN
4      NP      yes      FNPBC DNP
4      NP      yes      FNPBC RN
4      NP      yes      FNPC MS
4      NP      yes      FPMHNP FNP
4      NP      yes      FPMHNP MSN
4      NP      yes      FPMHNP-BC DNP
4      NP      yes      FPMHNP-BC FNP
4      NP      yes      FPMHNP-BC RN
4      NP      yes      GNP ACNP
4      NP      yes      GNP ANP-BC
4      NP      yes      GNP APRN-BC
4      NP      yes      GNP ARNP
4      NP      yes      GNP DNP
4      NP      yes      GNP MSNAPRN-BC
4      NP      yes      GNP-BC DNPCRNP
4      NP      yes      GNP-BC NP
4      NP      yes      GNP-BC PHD
4      NP      yes      GNP-C APN-C
4      NP      yes      GNP-C RN
4      NP      yes      LLC APNP
4      NP      yes      MBA FNP
4      NP      yes      MHNP APNP
4      NP      yes      MHNP CNS
4      NP      yes      MLP ARNP
4      NP      yes      MN FNP
4      NP      yes      MPH ANP
4      NP      yes      MPH CNP
4      NP      yes      MPH CRNP
4      NP      yes      MPH RNP
4      NP      yes      -FNP
4      NP      yes      ACNP APRN-BC
4      NP      yes      ACNP MI
4      NP      yes      ACNP NP
4      NP      yes      ACNP PHD
4      NP      yes      ACNP-BC ANP
4      NP      yes      ACNP-BC ARNP
4      NP      yes      ACNP-BC CNP
4      NP      yes      ACNP-BC FNP
4      NP      yes      ACNP-BC MBE
4      NP      yes      ACNP-BC MNSC
4      NP      yes      ACNP-BC NP-C
4      NP      yes      ACNP-C MSN
4      NP      yes      ACNPBC
4      NP      yes      ACNPBC MSN
4      NP      yes      AG-ACNP RN
4      NP      yes      AG-ACNP-BC MS
4      NP      yes      AG-ACNP-BC MSN
4      NP      yes      AG-ACNP-BC RN
4      NP      yes      AGACNP CFNP
4      NP      yes      AGACNP-BC RN
4      NP      yes      AGNP APN
4      NP      yes      AGNP APRN
4      NP      yes      AGNP MA
4      NP      yes      AGNP MN
4      NP      yes      AGNP MS
4      NP      yes      AGNP NP
4      NP      yes      AGNP-BC DNP
4      NP      yes      AGNP-C BSN
4      NP      yes      AGNP-C FNP-BC
4      NP      yes      AGNP-C MS
4      NP      yes      AGPCNP-BC APN
4      NP      yes      AGPCNP-BC APNP
4      NP      yes      AGPCNP-BC GNP-BC
4      NP      yes      AGPCNP-C MSN
4      NP      yes      AHNP
4      NP      yes      AHNP GNP
4      NP      yes      ANP ACNP
4      NP      yes      ANP ACNS
4      NP      yes      ANP APRN-BC
4      NP      yes      ANP CRN
4      NP      yes      ANP FNP
4      NP      yes      ANP GNP
4      NP      yes      ANP MA
4      NP      yes      ANP NP-C
4      NP      yes      ANP RNCS
4      NP      yes      ANP-BC ARNP
4      NP      yes      ANP-BC BSN
4      NP      yes      ANP-BC GNP-BC
4      NP      yes      ANP-C APN
4      NP      yes      ANP-C APRN
4      NP      yes      ANP-C CNS
4      NP      yes      ANP-C DNP
4      NP      yes      ANP-C FNP
4      NP      yes      ANP-C FNP-C
4      NP      yes      ANP-C GNP
4      NP      yes      ANP-C MN
4      NP      yes      ANP-C NP
4      NP      yes      ANPC FNP
4      NP      yes      ANPC MS
4      NP      yes      ANPGNP-BC
4      NP      yes      ANPGNP-BC APN
4      NP      yes      AOCNP APN-C
4      NP      yes      AOCNP CRNP
4      NP      yes      AOCNP DNP
4      NP      yes      AOCNP MSNFNP-BC
4      NP      yes      AOCNP PHD
4      NP      yes      AOCNP WHNP-BC
4      NP      yes      APMHNP APRN
4      NP      yes      APN CNP
4      NP      yes      APN CPNP
4      NP      yes      APN FNP-BC
4      NP      yes      APN GNP
4      NP      yes      APN MSN-FNP
4      NP      yes      APN PMHNP
4      NP      yes      APN-BC ACNP
4      NP      yes      APN-BC APNP
4      NP      yes      APN-BC DNP
4      NP      yes      APN-BC FNP
4      NP      yes      APN-C DNP
4      NP      yes      APN-C DRNP
4      NP      yes      APN-C FNP
4      NP      yes      APN-CNP MSN
4      NP      yes      APN-CNP PHD
4      NP      yes      APNCNP AGACNP-BC
4      NP      yes      APNCNP MS
4      NP      yes      APNP ACNPC-AG
4      NP      yes      APNP ACNS-BC
4      NP      yes      APNP APN-BC
4      NP      yes      APNP APRN-BC
4      NP      yes      APNP NNP
4      NP      yes      APNP PHD
4      NP      yes      APNP RNC
4      NP      yes      APNP RNMSN
4      NP      yes      APNP WHNP
4      NP      yes      APNP WHNP-BC
4      NP      yes      APNP-BC DNP
4      NP      yes      APNP-BC MS
4      NP      yes      APNP-BC MSN
4      NP      yes      APRN FNP-C
4      NP      yes      APRN MSNFNP-BC
4      NP      yes      APRN PNP
4      NP      yes      APRN WHNP-BC
4      NP      yes      APRN-C DNP
4      NP      yes      APRN-C FNP-BC
4      NP      yes      APRN-FNP MSN
4      NP      yes      APRN-FNP-C MSN
4      NP      yes      APRN-NP PHD
4      NP      yes      APRN-NP PHDC
4      NP      yes      APRNBC DNP
4      NP      yes      APRNFNP-BC DNP
4      NP      yes      APRNFNP-BC NP
4      NP      yes      APRNNP-C MSN
4      NP      yes      ARNP ACNP-BC
4      NP      yes      ARNP ANP-BC
4      NP      yes      ARNP CNP
4      NP      yes      ARNP DRNP
4      NP      yes      ARNP FNP-BC
4      NP      yes      ARNP FNP-C
4      NP      yes      ARNP MASTERS
4      NP      yes      ARNP MPH
4      NP      yes      ARNP-BC RN
4      NP      yes      ARNP-C PHD
4      NP      yes      ARNP-C RN
4      NP      yes      BC-ANP APRN
4      NP      yes      BC-ANP BC-FNP
4      NP      yes      BC-FNP ARNP
4      NP      yes      BC-FNP RNMSN
4      NP      yes      BS PMHNP
4      NP      yes      BS RNP
4      NP      yes      BSN DNP
4      NP      yes      C-GNP APNP
4      NP      yes      C-GNP APRN
4      NP      yes      C-NP APRN
4      NP      yes      C-NP RN
4      NP      yes      C-PNP NP
4      NP      yes      C-PNP RN
4      NP      yes      CCNS ACNP-BC
4      NP      yes      CCNS APNP
4      NP      yes      CCNS CPNP
4      NP      yes      CCNS CRNP
4      NP      yes      CFNP CPNP
4      NP      yes      CNM CRNP
4      NP      yes      CNM FNP-C
4      NP      yes      CNM FNPC
4      NP      yes      CNM RNP
4      NP      yes      CNP MA
4      NP      yes      CNP MHA
4      NP      yes      CNP NP
4      NP      yes      CNP-BC APRN
4      NP      yes      CNP-BC MSRN
4      NP      yes      CPNP AGPCNP-BC
4      NP      yes      CPNP APRNMSN
4      NP      yes      CPNP CRNP
4      NP      yes      CPNP CS
4      NP      yes      CPNP MN
4      NP      yes      CPNP MPH
4      NP      yes      CPNP NNP-BC
4      NP      yes      CPNP-AC APN
4      NP      yes      CPNP-AC CRNP
4      NP      yes      CPNP-AC NP
4      NP      yes      CPNP-ACPC DNP
4      NP      yes      CPNP-PC BSN
4      NP      yes      CPNP-PCAC RN
4      NP      yes      CRNA APNP
4      NP      yes      CRNP ANP-BC
4      NP      yes      CRNP BSN
4      NP      yes      CRNP FNP
4      NP      yes      CRNP MPH
4      NP      yes      CRNP MSNMPH
4      NP      yes      CRNP PS
4      NP      yes      CRNP-AC MS
4      NP      yes      CRNP-BC
4      NP      yes      CRNP-BC FNP
4      NP      yes      CRNP-BC MSN
4      NP      yes      CRNP-F PHD
4      NP      yes      CS ARNP
4      NP      yes      CS FNP
4      NP      yes      CS NP-C
4      NP      yes      CS PMH-NP
4      NP      yes      CWCN FNP
4      NP      yes      CWON FNP-BC
4      NP      yes      CWON GNP-BC
4      NP      yes      CWS ANP-C
4      NP      yes      NNP ARNP
4      NP      yes      NNP CRN
4      NP      yes      NNP DNP
4      NP      yes      NNP FNP-BC
4      NP      yes      NNP PNP
4      NP      yes      NNP-BC BSN
4      NP      yes      NNP-BC DNP
4      NP      yes      NNP-BC MN
4      NP      yes      NNP-BC RNC
4      NP      yes      NP ACNP
4      NP      yes      NP ACNP-BC
4      NP      yes      NP AGPCNP-BC
4      NP      yes      NP APRN-BC
4      NP      yes      NP APRNBC
4      NP      yes      NP APRNMSN
4      NP      yes      NP ARNP
4      NP      yes      NP CRN
4      NP      yes      NP KY
4      NP      yes      NP LD
4      NP      yes      NP MASTERS
4      NP      yes      NP NNP-BC
4      NP      yes      NP PAC
4      NP      yes      NP PC
4      NP      yes      NP PMHNP
4      NP      yes      NP PMHNP-BC
4      NP      yes      NP RNCS
4      NP      yes      NP-BC APN
4      NP      yes      NP-BC APRN
4      NP      yes      NP-BC DNSC
4      NP      yes      NP-BC PC
4      NP      yes      NP-BC PMH
4      NP      yes      NP-C CNS
4      NP      yes      NP-C MBA
4      NP      yes      NP-C PMHNP-BC
4      NP      yes      NP-PP FNP
4      NP      yes      NPC MS
4      NP      yes      NPC NP
4      NP      yes      NPP DNP
4      NP      yes      NPP RN
4      NP      yes      OGNP RNC
4      NP      yes      PAC FNP
4      NP      yes      PC CRNP
4      NP      yes      PC PMHNP
4      NP      yes      PC PNP-AC
4      NP      yes      PCNS-BC DNP
4      NP      yes      PHD AGPCNP-BC
4      NP      yes      PHD CNP
4      NP      yes      PHD FNP-C
4      NP      yes      PHD NP-C
4      NP      yes      PHD PNP-BC
4      NP      yes      PHD RNP
4      NP      yes      PHD WHNP-BC
4      NP      yes      PHMNP-BC APRN
4      NP      yes      PLLC ARNP
4      NP      yes      PMH APRN-NP
4      NP      yes      PMH FNP
4      NP      yes      PMH NP
4      NP      yes      PMH-NP APRN
4      NP      yes      PMH-NP APRN-BC
4      NP      yes      PMH-NP MSN
4      NP      yes      PMHCNS-BC ANP
4      NP      yes      PMHCNS-BC APN
4      NP      yes      PMHCNS-BC ARNP
4      NP      yes      PMHCNS-BC NP
4      NP      yes      PMHCNS-BC PMHNP-BC
4      NP      yes      PMHNP APRN-BC
4      NP      yes      PMHNP PHD
4      NP      yes      PS ARNP
4      NP      yes      RN ACNP
4      NP      yes      RN ARNP
4      NP      yes      RNAPNC NP
4      NP      yes      MSNCNP RN
4      NP      yes      MSNFNP RN
4      NP      yes      MSNFNP-BC APRN
4      NP      yes      MSNFNP-BC NP
4      NP      yes      MSNFNP-BC RN
4      NP      yes      MSNNP-C NP
4      NP      yes      MSNNP-C RN
4      NP      yes      ND APN-FNP
4      NP      yes      ND ARNP
4      NP      yes      ND FNP-BC
4      NP      yes      NP ANP-BC
4      NP      yes      PHD GNP-BC
4      NP      yes      PHD PMHNP-BC
4      NP      yes      RN PNP-BC
4      NP      yes      MSN ACNP-BC
4      NP      yes      MSN ACNP-C
4      NP      yes      MSN AGNP
4      NP      yes      MSN AGNP-C
4      NP      yes      MSN ANP
4      NP      yes      MSN CFNP
4      NP      yes      MSN CNNP
4      NP      yes      MSN CPNP-AC
4      NP      yes      MSN FPMHNP
4      NP      yes      MSN NP-BC
4      NP      yes      MSN PMHNP
4      NP      yes      MSN PNP
4      NP      yes      MSN PNP-AC
4      NP      yes      MSN RNCNP
4      NP      yes      MSN-AGNP MSN-FNP
4      NP      yes      MSN-CRNA NP
4      NP      yes      MSN-FNP MS
4      NP      yes      MSN-FNP RN
4      NP      yes      MSN-FNP-C RN
4      NP      yes      MSN-NNP APRN
4      NP      yes      MSNA ARNP
4      NP      yes      MSNA NP
4      NP      yes      MSNAPN-C NP
4      NP      yes      MSNAPRN NP
4      NP      yes      MSNAPRNFNP-C
4      NP      yes      -FNP APRN
4      NP      yes      A-GNP-C
4      NP      yes      A-GNP-C ACNS-BC
4      NP      yes      A-GNP-C APNP
4      NP      yes      ACHPN ANP-BC
4      NP      yes      ACNS-BC DNP
4      NP      yes      ACNS-BC NP-C
4      NP      yes      APNFNP-BC MSN
4      NP      yes      APRN CFNP
4      NP      yes      APRN CNP
4      NP      yes      APRN-BC DNP
4      NP      yes      APRN-CNP MSN
4      NP      yes      APRN-PMH CRNP
4      NP      yes      APRNFNP MSN
4      NP      yes      C-FNP APRN
4      NP      yes      C-FNP MS
4      NP      yes      CFNP APN
4      NP      yes      CFNP BSN
4      NP      yes      CFNP CNM
4      NP      yes      CFNP NP
4      NP      yes      CNM CFNP
4      NP      yes      CNS-BC PMHNP
4      NP      yes      CNS-BC PMHNP-BC
4      NP      yes      CNS-MS FNP-BC
4      NP      yes      LLC PMHNP
4      NP      yes      BS FNP-C
4      NP      yes      CNMNP MS
4      NP      yes      CNNP MSRN
4      NP      yes      CNS ACNP
4      NP      yes      CNS ACNP-BC
4      NP      yes      CNS ANP
4      NP      yes      CNS ARNP
4      NP      yes      CNS CNP
4      NP      yes      CNS-BC FPMHNP-BC
4      NP      yes      MHS FNP
4      NP      yes      MSCPNP
4      NP      yes      MSCPNP RN
4      NP      yes      MSCS RN
4      NP      yes      MS ACNP
4      NP      yes      MS AGACNP-BC
4      NP      yes      MS CPNP
4      NP      yes      MS CRNP
4      NP      yes      MS GNP
4      NP      yes      MS WHNP-BC
4      NP      yes      MSC NP
4      NP      yes      MSFNP PHD
4      NP      yes      MASTERS PMHNP
4      NP      yes      MS CFNP
4      NP      yes      ENP FNP
4      NP      yes      ENP MSN
4      NP      yes      MN ANP
4      NP      yes      MN ANPC
5      PA      yes      RPA-C
5      PA      yes      RPA
5      PA      yes      PA
5      PA      yes      NCCPA
5      PA      yes      MPAS
5      PA      yes      MPAP
5      PA      yes      PA-C
5      PA      yes      PAC
5      PA      yes      PA-C MS
5      PA      yes      PA-C MPAS
5      PA      yes      PA-C MMS
5      PA      yes      MSPAS
5      PA      yes      MPA
5      PA      yes      MSPA
5      PA      yes      MPAS PA-C
5      PA      yes      PA-C PA
5      PA      yes      PA MS
5      PA      yes      RPAC
5      PA      yes      PA-C MSPAS
5      PA      yes      PA-C MPA
5      PA      yes      PA MPAS
5      PA      yes      MSPA-C
5      PA      yes      MMS PA-C
5      PA      yes      PA-C MMSC
5      PA      yes      MS PA-C
5      PA      yes      MPH PA-C
5      PA      yes      PA-C MPH
5      PA      yes      MPAS PA
5      PA      yes      PA MMS
5      PA      yes      PA-C MPAP
5      PA      yes      PA-C MSPA
5      PA      yes      MPA-C
5      PA      yes      PA DPM
5      PA      yes      PA PA
5      PA      yes      MS PA
5      PA      yes      PAC MS
5      PA      yes      MHS PA-C
5      PA      yes      PA-C BS
5      PA      yes      PA-C MSBS
5      PA      yes      MPASPA-C
5      PA      yes      PA DVM
5      PA      yes      PA OD
5      PA      yes      MMSC PA
5      PA      yes      MSPAS PA-C
5      PA      yes      PA-C MSM
5      PA      yes      MPH MSPAS
5      PA      yes      PA MMSC
5      PA      yes      PA PHD
5      PA      yes      PA-CMPAS
5      PA      yes      RPA-C MS
5      PA      yes      MMSC PA-C
5      PA      yes      MS-PAS
5      PA      yes      PA-C MSHS
5      PA      yes      PA SR
5      PA      yes      PA BS
5      PA      yes      PA-C PHD
5      PA      yes      MPAS PAC
5      PA      yes      MS-PA-C
5      PA      yes      PA MPH
5      PA      yes      R-PAC
5      PA      yes      MPASPA
5      PA      yes      MHSPA-C
5      PA      yes      MPAP PA-C
5      PA      yes      MPH PA
5      PA      yes      MS-PA
5      PA      yes      MS-PAC
5      PA      yes      PA-C MASTERS
5      PA      yes      PHD PA
5      PA      yes      MSPASMPH
5      PA      yes      MSPAC
5      PA      yes      MMS PA
5      PA      yes      BS PA-C
5      PA      yes      MPAC
5      PA      yes      MPAS BS
5      PA      yes      MPAS-C
5      PA      yes      MPH MPAS
5      PA      yes      MSHS PA-C
5      PA      yes      PA MSPAS
5      PA      yes      RPA-C PA
5      PA      yes      MMSPA-C
5      PA      yes      MHS PA
5      PA      yes      MSPA PA-C
5      PA      yes      PA MSHS
5      PA      yes      PA-C MCMSC
5      PA      yes      PA-CMPH
5      PA      yes      MPA PA-C
5      PA      yes      MPA-S
5      PA      yes      MS PAC
5      PA      yes      NCCPA PA
5      PA      yes      NPPA
5      PA      yes      PA FACS
5      PA      yes      PA MASTERS
5      PA      yes      PA-
5      PA      yes      PA-C NP
5      PA      yes      PA-C SR
5      PA      yes      PAC MPAS
5      PA      yes      PAC PA
5      PA      yes      PAS
5      PA      yes      PAS MS
5      PA      yes      PHD PA-C
5      PA      yes      RPA PA
5      PA      yes      RPA-C MPAS
5      PA      yes      RPAC MS
5      PA      yes      R-PA
5      PA      yes      BS PA
5      PA      yes      BSPA-C
5      PA      yes      M-PAS
5      PA      yes      MASTERS PA-C
5      PA      yes      MBA PA-C
5      PA      yes      MHP PA-C
5      PA      yes      MPAS RPA
5      PA      yes      MPAS RPA-C
5      PA      yes      MPHPA-C
5      PA      yes      MS MPAS
5      PA      yes      MS RPA-C
5      PA      yes      MA PA
5      PA      yes      PA MBA
5      PA      yes      PA MCMSC
5      PA      yes      PA MPA
5      PA      yes      PA MSPA
5      PA      yes      PA--C
5      PA      yes      PA-C BA
5      PA      yes      PA-C MHP
5      PA      yes      PA-C MHSC
5      PA      yes      PA-C MS-PAS
5      PA      yes      PA-C PHARMD
5      PA      yes      PA-CMMS
5      PA      yes      PA-CMS
5      PA      yes      PAC MMS
5      PA      yes      PAC MPA
5      PA      yes      RPA MPAS
5      PA      yes      RPA MS
5      PA      yes      NP PA
5      PA      yes      NP PA-C
5      PA      yes      PHARMD PA-C
5      PA      yes      MPAS PHD
5      PA      yes      MPAS-PAC
5      PA      yes      MSPASPA
5      PA      yes      MSBSPA-C
5      PA      yes      MSRPA-C
5      PA      yes      PA BDS
5      PA      yes      PA BSC
5      PA      yes      PA BSMS
5      PA      yes      PA CM
5      PA      yes      PA CNP
5      PA      yes      PA DDSMD
5      PA      yes      PA FAAP
5      PA      yes      PA FACC
5      PA      yes      PA FACP
5      PA      yes      PA FNP
5      PA      yes      PA FNP-C
5      PA      yes      PA FORBES
5      PA      yes      PA KY
5      PA      yes      PA LD
5      PA      yes      PA LR
5      PA      yes      PA MF
5      PA      yes      PA MI
5      PA      yes      PA MP
5      PA      yes      PA MPAP
5      PA      yes      PA MSBS
5      PA      yes      PA MSM
5      PA      yes      PA PAS
5      PA      yes      PA PECK
5      PA      yes      PA PHUOC
5      PA      yes      PA RPAC
5      PA      yes      PA VMD
5      PA      yes      PA-C ARNP
5      PA      yes      PA-C BSHS
5      PA      yes      PA-C BSMS
5      PA      yes      PA-C BSN
5      PA      yes      PA-C JD
5      PA      yes      PA-C MA
5      PA      yes      PA-C MBA
5      PA      yes      PA-C MED
5      PA      yes      PA-C MLP
5      PA      yes      PA-C MMA
5      PA      yes      PA-C MPS
5      PA      yes      PA-C MSPH
5      PA      yes      PA-C NMD
5      PA      yes      RPA-C BS
5      PA      yes      RPA-C BSC
5      PA      yes      RPA-C MASTERS
5      PA      yes      RPA-C MPH
5      PA      yes      RPA-C MPS
5      PA      yes      RPA-C MSHS
5      PA      yes      MCMSC PA
5      PA      yes      MPH MSPA
5      PA      yes      APA-C
5      PA      yes      APA-C MPAS
5      PA      yes      BS-PA-C
5      PA      yes      BSBA PA-C
5      PA      yes      BSHS PA-C
5      PA      yes      CNM PA
5      PA      yes      CNM PA-C
5      PA      yes      PHD MPAS
5      PA      yes      PHD PAC
5      PA      yes      PLLC PA-C
5      PA      yes      R-PAC MS
5      PA      yes      RN-PA-C
5      PA      yes      MSPAS PAC
5      PA      yes      MSPAS PHD
5      PA      yes      MSPASMPH PA
5      PA      yes      PAC PHD
5      PA      yes      PAC RN
5      PA      yes      MSN PA
5      PA      yes      MSN PA-C
5      PA      yes      APRN PA
5      PA      yes      BS MPAS
5      PA      yes      BSPA MPAS
5      PA      yes      MCMSC PA-C
5      PA      yes      MSHS PA
5      PA      yes      MSHS RPA-C
5      PA      yes      MSM PA-C
5      PA      yes      MPA PA
5      PA      yes      MPA RPA-C
5      PA      yes      MPA-C PA
5      PA      yes      MPAS MS
5      PA      yes      MPH PAC
5      PA      yes      MS MPA
5      PA      yes      MS-PA-C PA
5      PA      yes      MSC PA
5      PA      yes      MED MPAS
5      PA      yes      MHS PAC
5      PA      yes      MS RPAC
5      PA      yes      MMS PAC
5      PA      yes      MPA MPH
5      PA      yes      MHP PA
5      PA      yes      MPH MPA
5      PA      yes      MPH MPAP
5      PA      yes      AAHIVS PA
6      DPM      yes       MPH DPM
6      DPM      yes      DPM
6      DPM      yes      PC DPM
6      DPM      yes      MS DPM
6      DPM      yes      DPM SR
6      DPM      yes      PHD DPM
6      DPM      yes      PLLC DPM
6      DPM      yes      PS DPM
6      DPM      yes      LTD DPM
6      DPM      yes      PROF DPM
6      DPM      yes      DPM DR
6      DPM      yes      DPM DS
6      DPM      yes      DPM KY
6      DPM      yes      DPM MS
6      DPM      yes      DPM PA
6      DPM      yes      DPM PHD
6      DPM      yes      DR DPM
6      DPM      yes      LLC DPM
6      DPM      yes      MA DPM
6      DPM      yes      MED DPM
6      DPM      yes      MHA DPM
6      DPM      yes      ND DPM
6      DPM      yes      PLC DPM
7      OD      yes       OPTOMETRIST
7      OD      yes      OD
7      OD      yes      PC OD
7      OD      yes      MS OD
7      OD      yes      PHD OD
7      OD      yes      OPTOMETRY
7      OD      yes      OD SR
7      OD      yes      OD MS
7      OD      yes      LLC OD
7      OD      yes      DOCTOR OPTOMETRY
7      OD      yes      OD DR
7      OD      yes      OD FORBES
7      OD      yes      OD DVM
7      OD      yes      OD JD
7      OD      yes      OD MP
7      OD      yes      OD PS
7      OD      yes      MED OD
7      OD      yes      MPH OD
8      DVM      yes       PC DVM
8      DVM      yes       MSPH DVM
8      DVM      yes      DVM
8      DVM      yes      VMD
8      DVM      yes      PHD VMD
8      DVM      yes      MS VMD
8      DVM      yes      VMD MS
8      DVM      yes      PC VMD
8      DVM      yes      LLC VMD
8      DVM      yes      MPH VMD
8      DVM      yes      CVMA VMD
8      DVM      yes      MSC VMD
8      DVM      yes      ACVS
8      DVM      yes      MS DVM
8      DVM      yes      PHD DVM
8      DVM      yes      MPH DVM
8      DVM      yes      DVM MS
8      DVM      yes      DVM PHD
8      DVM      yes      CVA DVM
8      DVM      yes      MPVM DVM
8      DVM      yes      DVM DR
8      DVM      yes      DVM SR
8      DVM      yes      DVMMS
8      DVM      yes      DVMPHD
8      DVM      yes      EDVM
8      DVM      yes      MBA DVM
8      DVM      yes      MRCVS DVM
8      DVM      yes      BVMS DVM
8      DVM      yes      DDVM
8      DVM      yes      BVSC DVM
8      DVM      yes      DVM ARN
8      DVM      yes      DVM BS
8      DVM      yes      DVM MRCVS
8      DVM      yes      DVMDACVIM
8      DVM      yes      DVMMPH
8      DVM      yes      ACVS DVM
8      DVM      yes      PSC DVM
8      DVM      yes      MSC DVM
8      DVM      yes      PS DVM
8      DVM      yes      RPH DVM
8      DVM      yes      DR DVM
8      DVM      yes      DVM BSC
8      DVM      yes      DVM BVSC
8      DVM      yes      DVM CM
8      DVM      yes      DVM DO
8      DVM      yes      DVM DPM
8      DVM      yes      DVM KY
8      DVM      yes      DVM LR
8      DVM      yes      DVM MED
8      DVM      yes      DVM MP
8      DVM      yes      DVM PA
8      DVM      yes      DVM RN
8      DVM      yes      DVM VMD
8      DVM      yes      LLC DVM
8      DVM      yes      MMS DVM
8      DVM      yes      MPA DVM
8      DVM      yes      JD DVM
8      DVM      yes      BS DVM
6      DPM      yes      MBA DPM
8      DVM      yes      MRCVS
1b      MD      maybe      MDMS
1b      MD      maybe      MED
1b      UNK      maybe      PC DR
1b      MD      maybe      MSM MED
2b      DO      maybe      DO BA
2b      DO      maybe      DO BS
2b      DO      maybe      DO CM
2b      DO      maybe      DO FM
2b      DO      maybe      DO JD
2b      DO      maybe      DO MA
2b      DO      maybe      DO PECK
2b      DO      maybe      DO PS
3b      dentist      maybe      MDS
3b      dentist      maybe      PC MSD
3b      dentist      maybe      MDSC
3b      dentist      maybe      PS MSD
3b      dentist      maybe      MPH MSD
3b      dentist      maybe      MSD
3b      dentist      maybe      MS MDS
3b      dentist      maybe      PHD MDS
3b      dentist      maybe      MDM
3b      dentist      maybe      MDMPM
3b      dentist      maybe      MDMSC
3b      Dentist       maybe      MSD BDS
3b      dentist      maybe      CDDS
4b      nurse      maybe      RN
4b      nurse      maybe      PCNS-BC
4b      nurse      maybe      NMW
4b      nurse      maybe      APRN MSN
4b      nurse      maybe      MNMPH
4b      nurse      maybe      MNSC APN
4b      nurse      maybe      MSN
4b      nurse      maybe      MNSC
4b      nurse      maybe      MPH MSN
4b      nurse      maybe      RNCS
4b      nurse      maybe      DNSC
4b      nurse      maybe      CNS
4b      nurse      maybe      CRNA
4b      nurse      maybe      CPN
4b      nurse      maybe      CNM
4b      nurse      maybe      CNM MS
4b      nurse      maybe      MS CNM
4b      nurse      maybe      CNM RN
4b      nurse      maybe      CNW
4b      nurse      maybe      BS CNM
4b      nurse      maybe      CM
4b      Nurse      maybe      NPCNM
4b      nurse      maybe      CMW
4b      nurse      maybe      MS CM
4b      nurse      maybe      CWCN
4b      nurse      maybe      MN CNM
4b      nurse      maybe      MPH CNM
4b      Nurse      maybe      MS-CNM
4b      nurse      maybe      PHD CNM
4b      nurse     maybe      APRN
4b      nurse      maybe      APN
4b      nurse      maybe      MSN
4b      Nurse      maybe      AGCNS-BC
4b      nurse      maybe      APRN-CRNA
4b      nurse      maybe      APRN-BC
4b      nurse       maybe      CNM MSN
4b      nurse      maybe      MSN CNM
4b      nurse      maybe      CRNA APRN
4b      nurse      maybe      APRNMSN
4b      nurse      maybe      CNM APRN
4b      nurse      maybe      MSN APRN
4b      nurse      maybe      APN-C
4b      nurse      maybe      MSN RN
4b      nurse      maybe      CRNA MSN
4b      nurse      maybe      APRN-BC MSN
4b      nurse      maybe      APN-BC
4b      nurse      maybe      CS RN
4b      nurse      maybe      MSN BSN
4b      nurse      maybe      CRNA APN
4b      nurse      maybe      APN-C MSN
4b      nurse      maybe      APRN MS
4b      nurse      maybe      PMHCNS-BC
4b      nurse      maybe      MSN CRNA
4b      nurse      maybe      APRNBC
4b      nurse      maybe      MSNA
4b      nurse      maybe      APRN CRNA
4b      nurse      maybe      RN MSN
4b      nurse      maybe      CNS MSN
4b      nurse      maybe      APRN-C
4b      nurse      maybe      MS CRNA
4b      nurse      maybe      APNC
4b      nurse      maybe      APRNCNSPMH
4b      nurse      maybe      MSNAPRN
4b      nurse      maybe      APRN CNM
4b      nurse      maybe      APN-BC MSN
4b      nurse      maybe      CNS APRN
4b      nurse      maybe      CNS RN
4b      nurse      maybe      MSN-APRN
4b      nurse      maybe      MSNAPN
4b      nurse      maybe      MSNCNM
4b      nurse      maybe      RNC
4b      nurse      maybe      APN CRNA
4b      nurse      maybe      CRNA MS
4b      nurse      maybe      MS RN
4b      nurse      maybe      MSN PHD
4b      nurse      maybe      APN MS
4b      nurse      maybe      PHD MSN
4b      nurse      maybe      PCNS
4b      nurse      maybe      RN MS
4b      nurse      maybe      NURSE
4b      nurse      maybe      ACNS-BC MSN
4b      nurse      maybe      APRN PHD
4b      nurse      maybe      BSN MSN
4b      nurse      maybe      CNM APN
4b      Nurse      maybe      RNPC
4b      nurse      maybe      MIDWIFE NURSE
4b      nurse      maybe      APN RN
4b      nurse      maybe      APRN-C MSN
4b      nurse      maybe      MSNMPH
4b      nurse      maybe      APRN RN
4b      nurse      maybe      CNS APN
4b      nurse      maybe      CRN
4b      nurse      maybe      MSNCRNA
4b      nurse      maybe      APRN-BC RN
4b      nurse      maybe      BSNMSN
4b      nurse      maybe      BSN MSN
4b      nurse      maybe      APN CNM
4b      nurse      maybe      APN MNSC
4b      nurse      maybe      APN PHD
4b      nurse      maybe      APRN-CNM
4b      nurse      maybe      ARPN
4b      nurse      maybe      MSAPRN
4b      nurse      maybe      PMHCNS-BC APRN
4b      nurse      maybe      RNC MSN
4b      nurse      maybe      CNS MS
4b      nurse      maybe      CNM PHD
4b      nurse      maybe      CRNA BSN
4b      nurse      maybe      CRNA DNAP
4b      nurse      maybe      MSN-CRNA
4b      nurse      maybe      MSNAPRN-BC
4b      nurse      maybe      APRN CNS
4b      nurse      maybe      APRN MN
4b      nurse      maybe      APRN-BC MS
4b      nurse      maybe      MS APRN
4b      nurse       maybe      MSN MS
4b      nurse       maybe      PMHCNS-BC MS
4b      nurse       maybe      PMHCNS-BC MSN
4b      nurse       maybe      RN PHD
4b      nurse      maybe      ACNS
4b      nurse      maybe      ACNS-BC RN
4b      nurse      maybe      APRN MNSC
4b      nurse      maybe      CCNS
4b      nurse      maybe      CNS-BC
4b      nurse      maybe      MSNC
4b      nurse      maybe      MIDWIFE
4b      nurse      maybe      MN BSN
4b      nurse      maybe      NURSE-MIDWIFE
4b      nurse      maybe      CRNA BS
4b      nurse      maybe      CRNA MSNA
4b      nurse      maybe      DNAP CRNA
4b      nurse      maybe      MSNA CRNA
4b      nurse      maybe      APN-A
4b      nurse      maybe      APN-C MS
4b      nurse      maybe      APNC MSN
4b      nurse      maybe      APNCNS
4b      nurse      maybe      APRN-CNS
4b      nurse      maybe      APRNBC MSN
4b      nurse      maybe      CNS MN
4b      nurse      maybe      CNS PMH
4b      nurse      maybe      CS MSN
4b      nurse       maybe      MS MSN
4b      nurse       maybe      MSN APN
4b      nurse       maybe      MSN APRN-BC
4b      nurse       maybe      ACNS-BC MS
4b      nurse       maybe      ENP RN
4b      nurse      maybe      RNCS MSN
4b      nurse      maybe      RNMSN
4b      nurse      maybe      DMSN
4b      nurse      maybe      MS RNC
4b      nurse      maybe      MSRN
4b      nurse      maybe      APRNCRNA
4b      nurse      maybe      CNSPMH APRN
4b      nurse      maybe      CS APRN
4b      nurse      maybe      MHS CRNA
4b      nurse      maybe      PHD CRNA
4b      nurse       maybe      MSN RNC
4b      nurse       maybe      MSN-ANESTHESIA
4b      nurse       maybe      MSN-APN
4b      nurse       maybe      MSN-RN
4b      nurse       maybe      MSNCNS
4b      nurse      maybe      ND MSN
4b      nurse      maybe      PHD APRN
4b      nurse      maybe      RN BSN
4b      nurse      maybe      APRN CS
4b      nurse      maybe      APRN-BC PHD
4b      nurse      maybe      APRNNM
4b      nurse      maybe      LLC APRN
4b      nurse      maybe      MSN NNP
4b      nurse      maybe      APN CNS
4b      nurse      maybe      APN-BC RN
4b      nurse      maybe      APNBC
4b      nurse      maybe      APNC RN
4b      nurse      maybe      APNMSN
4b      nurse      maybe      APPN MS
4b      nurse      maybe      APRNCNS
4b      nurse      maybe      ARN
4b      nurse      maybe      CNS PHD
4b      nurse      maybe      CNS-BC MSN
4b      nurse      maybe      CNS-MS
4b      nurse      maybe      CNS-PP
4b      nurse      maybe      CS ANP
4b      Nurse      maybe      MN RN
4b      Nurse      maybe      MS CNS
4b      nurse      maybe      CNMAPRN
4b      nurse      maybe      PC RN
4b      nurse      maybe      PMH CNS
4b      nurse      maybe      PMH-CNS
4b      nurse      maybe      PMHCNS-BC PHD
4b      nurse      maybe      RNAPN-C
4b      nurse      maybe      RNCMS
4b      nurse      maybe      RNCNM
4b      nurse      maybe      RNCNS
4b      nurse      maybe      CNM MN
4b      nurse      maybe      CNM MSM
4b      nurse      maybe      MMSN
4b      Nurse      maybe      MSNRNCS
4b      Nurse      maybe      MSRNCS
4b      nurse      maybe      CRNA MA
4b      nurse      maybe      CRNA MN
4b      nurse      maybe      CRNA PHD
4b      nurse      maybe      NURSE MS
4b      nurse      maybe      RNC APRN
4b      nurse      maybe      MSNMPH APRN
4b      nurse       maybe      ND APRN
4b      nurse       maybe      PC APRN
4b      nurse       maybe      PC MSN
4b      nurse       maybe      PCNS-BC APRN
4b      nurse       maybe      RN APN
4b      nurse       maybe      RN APRN-BC
4b      nurse       maybe      RN BS
4b      nurse       maybe      RN CNM
4b      nurse       maybe      RN CNS-BC
4b      nurse       maybe      RN CRNA
4b      nurse       maybe      RN MN
4b      nurse       maybe      RNAPNC
4b      nurse       maybe      RNC BSN
4b      nurse       maybe      RNC MS
4b      nurse       maybe      RNCS MS
4b      nurse      maybe      MSN JD
4b      nurse      maybe      MSN LR
4b      nurse      maybe      MSN MI
4b      nurse      maybe      MSN PC
4b      nurse       maybe      ACNS-BC APRN
4b      nurse       maybe      AGCNS-BC MSN
4b      nurse       maybe      APN RNC
4b      nurse       maybe      APN RNFA
4b      nurse       maybe      APN-A MSN
4b      nurse       maybe      APN-BC APRN
4b      nurse       maybe      APN-BC MS
4b      nurse       maybe      APN-BC RNC
4b      nurse       maybe      APN-C RN
4b      nurse       maybe      APNCNS MS
4b      nurse       maybe      APNCNS MSN
4b      nurse       maybe      APRN
4b      nurse       maybe      CRNA
4b      nurse       maybe      APN
4b      nurse       maybe      CNM
4b      nurse       maybe      APRN PC
4b      nurse       maybe      APRN-BC MBA
4b      nurse       maybe      APRN-BC PMH-CNS
4b      nurse       maybe      APRN-BC RNCS
4b      nurse       maybe      APRN-C PHD
4b      nurse       maybe      APRN-C RN
4b      nurse       maybe      APRN-CNM MSN
4b      nurse       maybe      APRN-CNS MSN
4b      nurse       maybe      APRN-PMH
4b      nurse       maybe      ARPN MSN
4b      nurse       maybe      BS CRNA
4b      Nurse      maybe      CNS APRN-BC
4b      Nurse      maybe      CNS APRNMSN
4b      Nurse      maybe      CNS-BC APN
4b      Nurse      maybe      CNS-BC APRN
4b      Nurse      maybe      CNS-PP RN
4b      Nurse      maybe      CRN MSN
4b      Nurse      maybe      CRNA RN
4b      Nurse      maybe      CS MSRN
4b      nurse       maybe      MSN BS
4b      nurse       maybe      MSN CM
4b      nurse       maybe      MSN CNS
4b      nurse       maybe      MSN RNCS
4b      nurse       maybe      MSN-APRN MA
4b      nurse       maybe      MSNA BSN
4b      nurse       maybe      MSNC RN
4b      nurse       maybe      MSPA BA
4b      nurse       maybe      MSPH MSN
4b      nurse       maybe      BSN RN
4b      nurse      maybe      PHD RN
4b      nurse      maybe      MMA APRN
4b      nurse      maybe      MN APRN
4b      nurse      maybe      MS APN
4b      nurse      maybe      MS APN-A
4b      nurse      maybe      MS APN-BC
4b      nurse      maybe      MSN ACNS-BC
4b      nurse      maybe      PCNS APN
4b      nurse      maybe      PCNS MS
4b      nurse      maybe      PHD ACNS
4b      nurse      maybe      PMH-CNS APRN
4b      nurse      maybe      PMHCNS-BC RN
4b      nurse      maybe      PMHCNS-BC RNPC
4b      nurse      maybe      RDMS CNM
4b      nurse      maybe      MA CRNA
4b      nurse      maybe      PHD APN
4b      nurse      maybe      MA MSN
4b      nurse      maybe      MSN BA
4b      nurse      maybe      APN ACNS-BC
4b      nurse      maybe      APRNCNSPMH MS
4b      nurse      maybe      CCNS MS
4b      nurse      maybe      CCNS MSN
4b      nurse      maybe      CNS-BC PMH
4b      nurse      maybe      CS RNC
4b      nurse       maybe       ACNS-BC
4b      nurse       maybe       APRN CNS-BC
4b      nurse       maybe       APRN CNSPMH
4b      nurse       maybe       APRN DM
4b      nurse       maybe       APRN DNAP
4b      nurse       maybe       APRN DNSC
4b      nurse       maybe       APRN RNC
4b      nurse       maybe       APRNBC MA
4b      nurse       maybe       CNM APRN-BC
4b      nurse       maybe       CNM APRNMSN
4b      nurse       maybe       CNM BSN
4b      nurse       maybe       CNM CNM
4b      nurse       maybe       CNM DR
4b      nurse       maybe       CNM FORBES
5b      PA      maybe      MHSPA
5b      PA      maybe      BSPA
6b      DPM      maybe      DPMPC
6b      DPM      maybe      PDPM
8b      DVM      maybe      MPVM MPH
8b      veterinarian      maybe      PHD MPVM
8b      DVM      maybe      ADVM
8b      DVM      maybe      LDVM
8b      DVM      maybe      MDVM
8b      UNK      maybe      CDVM
8b      DVM?      maybe      FDVM
8b      DVM?      maybe      HDVM
8b      DVM      maybe      PDVM
9b      Pharmacist      maybe      RPH
9b      Pharmacist      maybe      PHC RPH
9b      Pharmacist      maybe      PHARMD
9b      pharmacist      maybe      CPP PHARMD
9b      Pharmacist      maybe      CPP
9b      pharmacist      maybe      CPP RPH
9b      pharmacist      maybe      DO PHARMD
9b      pharmacist      maybe      PHARMD PHC
no  no          no?      CS MS
no  no          no?      PHD SMD
no  no          no?      PHD AMD
no  no          no       ND
no  no          no       MSC
no  no          no       BS
no  no          no       MSBS
no  no          no       MBA MS
no  no          no      BVMS BSC
no  no          no      MS BVMS
no  no          no      NPP MS
no  no          no      NMD
no  no    nurse       no      MN
no  no          no      MPHMMS
no  no          no      MSPH MMS
no  no          no      MMSCPA
no  no          no      MMS
no  no          no      MHS
no  no          no      MSCP
no  no          no      MSCP PHD
no  no          no      MSA
no  no          no      MSM
no  no          no      MPH MMSC
no  no          no      MMSC
no  no          no      PC MMSC
no  no          no      MLP
no  no          no      DC-APC
no  no          no      APC MS
no  no          no      AAHIVS MS
no  no          no      CPE MBA
no  no          no      CWS
no  no          no      BVMS
no  no          no      BDS
no  no          no      MS BDS
no  no          no      MDS BDS
no  no          no      PHD BDS
no  no          no      BDS MPH
no  no          no      BDS MS
no  no          no      BVSC
no  no          no      BSC
no  no          no      PHD BVSC
no  no          no      PCS
no  no          no      APC
no  no          no      PC CS
no  no          no      PHD CS
no  no          no      CVMA
no  no          no      BSHS
no  no          no      MS CS
no  no          no      MS
no  no          no      PHD_2
no  no          no      JMD
no  no          no      MASTERS
no  no          no      PC
no  no          no      MA
no  no          nurse      BSN
no  no          no      MP PHD
no  no          no      MPH PHD
no  no          no      PC MS
no      MasterofScienceinHealthSciences       no      MSHS
no  no          no      PHD MS
no  no          no      MRCVS BVMS
no  no          no      MPH
no  no          no      MPH MS
no  no          no      JDVM
no  no          no      LLC
no  no          nurse      BSN MS
no  no          no      MBA MPH
no  no          no      MPH MMS
no  no          no      PHD MPH
no  no          no      BSMS
no  no          no      MBA MSN
no  no          no      MPH MN
no  no          no      MRS
no  no          no      MS MPH
no  no          no      MS PHD
no  no          No      BA
no  no          no      MS BSN
no  no          no      PHD MSC
no  no          no      MBA PHD
no  no          no      LLC MS
no  no          no      MPH MSHS
no  no          no      MS BS
no  no          no      MA MPH
no  no          no      PLLC MS
no  no          no      ND PHD
no  no          no      MPH ND
no  no          no      PHD MSD
no  no          no      DOCTORATE
no  no          no      ND MS
no  no          no      MPH BS
no  no          no      MPH MBA
no  no          no      MS MA
no  no          no      MS MS
no  no          no      MSC PHD
no  no          no      JD
no  no          no      MBA
no  no          no      MHS MPH
no  no          no      PHD BS
no  no          no      LTD
no  no          no      JD MPH
no  no          no      JD PHD
no  no          no      LLC ND
no  no          no      LLC PROF
no  no          no      PROF
no  no          no      MPH JD
no  no    veterinarian      no      MRCVS BVSC
no  no          no      MS MBA
no  no          no      PS MPH
no  no          no      PS MS
no  no          no      PC MPH
no  no          no      PC ND
no  no          no      PC PHD
no  no          no      PDC MS
no  no          no      LTD MS
no  no          no      MA BSN
no  no          no      MA MA
no  no          no      MASTERS BSN
no  no          no      MN MPH
no  no          no      MN MSC
no  no          no      MN PHD
no  no          no      MPH MSC
no  no          no      MSC MPH
no  no          no      MSC MS
no  no          no      ND DOCTOR
no  no          no      ND MPH
no  no          no      NMD ND
no  no          nurse      BSN MA
no  no          nurse      BSN MHA
no  no          nurse      BSN MN
no  no          nurse      BSN PHD
no  no          no      BS JD
no  no          no      MS ND
no  no          no      MED PROF
no  no          no      MHA MS
no  no          no      MSPH PHD
no  no          no      APMC
no  no          no      BSBA
no  no          no      MBA MMD
no  no          no      MCMSC
no  no          no      MHP
no  no          no      MHS PHD
no  no          no      MHSC
no  no          no      MMA
no  no          no      MPH MHA
no   no  no               RAMON
no   no  no               ALEX
no   no  no               MOHAN
no   no  no               BOYD
no   no  no               MOORE
no   no  no               BLAINE
no   no  no               ROLAND
no   no  no               MONIQUE
no   no  no               OMAR
no   no  no               ANGELICA
no   no  no               FLORENCE
no   no  no               BECK
no   no  no               EDMUNDO
no   no  no               FLETCHER
no   no  no               KY
no   no  no               LD
no   no  no               LK
no   no  no               ABEL
no   no  no               MEHDI
no   no  no               PHUOC
no   no  no               ARTA-LUANA ARTA-LUANA
no   no  no               FORBES
no   no  no               PECK
no   no  no               ALEXDUP
no   no  no               FLORENCE MA
no   no  no               MI MI
no   no  no               SR
no   no  no             MP
no   no  no             APR
no   no   DMD            IIIDMD
no   no   no            MIA
no   no   no            MF
no   no   MD            AMD
no   no   MD            MMD
no   no   no            NPF
no   no   MD            RMD
no   no   MD            CMD
no   no   MD            SMD
no   no   DDS             MDDS
no   no   no            DMV
no   no   DDS             SDDS
no   no   no            RNA
no   no   DDS             RDDS
no   no   MD            SDMD
no  no  no                ADPM
no  no  no                DDO
no  no  no                DDSP
no  no  no                KPA
no  no  no                MDO
no  no  no                MDP
no  no  no                PHC
no  no    MD            ZMD
no  no    MD            FDMD
no  no    DO            D0
no  no  no                LN
no  no  no                LR
no  no  no                MDD
no  no    DO            SDO
no  no    no                PHDC
no  no    DDS             IDDS
no  no    DDS             IIDDS
no  no    DO            IIDO
no  no    MD            FMD
no  no    MD            PMD
no  no    MD            GMD
no  no    MD            HMD
no  no    MD            IMD
no  no    MD            BMD
no  no    MD            JRMD
no  no    MD            KMD
no  no    MD            TMD
no  no    MD            OMD
no  no    MD            ADMD
no  no    MD            IIIMD
no  no    MD            MDPH
no  no  no                PS
no  no  no                CS
no  no  no                DS
no  no  no                FM
no  no  no                FPA
no  no  no                MPH MMD
no  no  no                DVN
no  no  no                DVN DM
;;;;
;run;quit;

proc sort data=phy.&pgm._edddoc force
   out=PHY.&pgm._profPre(index=(edd_sufix/unique)) nodupkey;
by edd_sufix;
run;quit;

data &pgm._ctl;
  retain fmtname "$&pgm._cred2prof";
  set PHY.&pgm._profPre;
  start=edd_sufix;
  end=start;
  label=edd_professions;
  keep fmtname start end label;
run;quit;

proc format lib=phy.phy_formats cntlin=&pgm._ctl;
run;quit;


proc freq data=phy.&pgm._cut noprint order=freq;
tables NPPES_CREDENTIALS/out=&pgm._pro;
run;quit;

$PHY_100CMS_CRED2PROF
data &pgm._mddo &pgm._nonmddo;

  set phy.&pgm._cut(keep=npi NPPES_CREDENTIALS where=(NPPES_CREDENTIALS ne "") );


  If strip(NPPES_CREDENTIALS) =: 'NURSE PRACTITIONER'  then do;CREDENTIALS='NP';
  If strip(NPPES_CREDENTIALS) =: 'PHYSICIAN ASSISTANT' then do;CREDENTIALS='PA';
  If strip(NPPES_CREDENTIALS) =: 'PHYSICIANS ASSISTANT' then do;CREDENTIALS='PA';
  If strip(NPPES_CREDENTIALS) =: 'MEDICAL DOCTOR'      then do;CREDENTIALS='MD';
  If strip(NPPES_CREDENTIALS) =: 'PHYSICAL THERAPIST'  then do;CREDENTIALS='PT';

  if substr(left(compress(NPPES_CREDENTIALS,' ,')),1,4) in ('CRNA' ,'ARNP' ,'APRN' ,'CRNP' ,'FNPC' ,'LCSW')
  else if substr(left(compress(NPPES_CREDENTIALS,' ,')),1,3) in ('FNP' ,'DPT' ,'DPM' ,'PHD' ,'NPC' ,'CNP' ,'APN' ,'MPT')
  else if substr(left(compress(NPPES_CREDENTIALS,' ,')),1,2) in ('DC' ,'MD' ,'DO' ,'PAC' ,'OD' ,'PT' ,'PA' ,'NP')
  else output &pgm._nonmddo;

run;quit;













%utl_submit_wps64('
  libname sd1 "d:/sd1";
  options set=R_HOME "C:/Program Files/R/R-3.3.2";
  libname wrk "%sysfunc(pathname(work))";
  proc r;
  submit;
  source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
  library(haven);
  have<-read_sas("d:/sd1/have.sas7bdat");
  write_xpt(have,"d:/xpt/have8.xpt",version=8);
  endsubmit;
  run;quit;
  ');



%MACRO DO_OVER(arraypos, array=,
               values=, delim=%STR( ),
               phrase=?, escape=?, between=,
               macro=, keyword=);

 /*  Last modified: 8/4/2006
                                                           72nd col -->|
  Function: Loop over one or more arrays of macro variables
           substituting values into a phrase or macro.

  Authors: Ted Clay, M.S.
              Clay Software & Statistics
              tclay@ashlandhome.net  (541) 482-6435
           David Katz, M.S. www.davidkatzconsulting.com
         "Please keep, use and pass on the ARRAY and DO_OVER macros with
               this authorship note.  -Thanks "
          Send any improvements, fixes or comments to Ted Clay.

  Full documentation with examples appears in
     "Tight Looping with Macro Arrays".SUGI Proceedings 2006,
       The keyword parameter was added after the SUGI article was written.

  REQUIRED OTHER MACROS:
        NUMLIST -- if using numbered lists in VALUES parameter.
        ARRAY   -- if using macro arrays.

  Parameters:

     ARRAYPOS and
     ARRAY are equivalent parameters.  One or the other, but not both,
             is required.  ARRAYPOS is the only position parameter.
           = Identifier(s) for the macro array(s) to iterate over.
             Up to 9 array names are allowed. If multiple macro arrays
             are given, they must have the same length, that is,
             contain the same number of macro variables.

     VALUES = An explicit list of character strings to put in an
             internal macro array, VALUES may be a numbered lists of
             the form 3-15, 03-15, xx3-xx15, etc.

     DELIM = Character used to separate values in VALUES parameter.
             Blank is default.

     PHRASE = SAS code into which to substitute the values of the
             macro variable array, replacing the ESCAPE
             character with each value in turn.  The default
             value of PHRASE is a single <?> which is equivalent to
             simply the values of the macro variable array.
             The PHRASE parameter may contain semicolons and extend to
             multiple lines.
             NOTE: The text "?_I_", where ? is the ESCAPE character,
                   will be replaced with the value of the index variable
                   values, e.g. 1, 2, 3, etc.
             Note: Any portion of the PHRASE parameter enclosed in
               single quotes will not be scanned for the ESCAPE.
               So, use double quotes within the PHRASE parameter.

             If more than one array name is given in the ARRAY= or
             ARRAYPOS parameter, in the PHRASE parameter the ESCAPE
             character must be immediately followed by the name of one
             of the macro arrays, using the same case.

     ESCAPE = A single character to be replaced by macro array values.
             Default is "?".

     BETWEEN = code to generate between iterations of the main
             phrase or macro.  The most frequent need for this is to
             place a comma between elements of an array, so the special
             argument COMMA is provided for programming convenience.
             BETWEEN=COMMA is equivalent to BETWEEN=%STR(,).

     MACRO = Name of an externally-defined macro to execute on each
             value of the array. It overrides the PHRASE parameter.
             The parameters of this macro may be a combination of
             positional or keyword parameters, but keyword parameters
             on the external macro require the use of the KEYWORD=
             parameter in DO_OVER.  Normally, the macro would have
             only positional parameters and these would be defined in
             in the same order and meaning as the macro arrays specified
             in the ARRAY or ARRAYPOS parameter.
             For example, to execute the macro DOIT with one positional
             parameter, separately define
                      %MACRO DOIT(STRING1);
                          <statements>
                      %MEND;
             and give the parameter MACRO=DOIT.  The values of AAA1,
             AAA2, etc. would be substituted for STRING.
             MACRO=DOIT is equivalent to PHRASE=%NRQUOTE(%DOIT(?)).
             Note: Within an externally defined macro, the value of the
             macro index variable would be coded as "&I".  This is
             comparable to "?_I_" within the PHRASE parameter.

    KEYWORD = Name(s) of keyword parameters used in the definition of
             the macro refered to in the MACRO= parameter. Optional.
             This parameter controls how DO_OVER passes macro array
             values to specific keyword parameters on the macro.
             This allows DO_OVER to execute a legacy or standard macro.
             The number of keywords listed in the KEYWORD= parameter
             must be less than or equal to the number of macro arrays
             listed in the ARRAYPOS or ARRAY parameter.  Macro array
             names are matched with keywords proceeding from right
             to left.  If there are fewer keywords than macro array
             names, the remaining array names are passed as positional
             parameters to the external macro.  See Example 6.

  Rules:
      Exactly one of ARRAYPOS or ARRAY or VALUES is required.
      PHRASE or MACRO is required.  MACRO overrides PHRASE.
      ESCAPE is used when PHRASE is used, but is ignored with MACRO.
      If ARRAY or ARRAYPOS have multiple array names, these must exist
          and have the same length.  If used with externally defined
          MACRO, the macro must have positional parameters that
          correspond 1-for-1 with the array names.  Alternatively, one
          can specify keywords which tell DO_OVER the names of keyword
          parameters of the external macro.

  Examples:
     Assume macro array AAA has been created with
             %ARRAY(AAA,VALUES=x y z)
      (1) %DO_OVER(AAA) generates: x y z;
      (2) %DO_OVER(AAA,phrase="?",between=comma) generates: "x","y","z"
      (3) %DO_OVER(AAA,phrase=if L="?" then ?=1;,between=else) generates:
                    if L="x" then x=1;
               else if L="y" then y=1;
               else if L="z" then z=1;

      (4) %DO_OVER(AAA,macro=DOIT) generates:
                %DOIT(x)
                %DOIT(y)
                %DOIT(z)
          which assumes %DOIT has a single positional parameter.
          It is equivalent to:
          %DO_OVER(AAA,PHRASE=%NRSTR(%DOIT(?)))

      (5) %DO_OVER(AAA,phrase=?pct=?/tot*100; format ?pct 4.1;)
            generates:
                xpct=x/tot*100; format xpct 4.1;
                ypct=y/tot*100; format ypct 4.1;
                zpct=z/tot*100; format zpct 4.1;
      (6) %DO_OVER(aa bb cc,MACRO=doit,KEYWORD=borders columns)
         is equivalent to %DO_OVER(aa,bb,cc,
                  PHRASE=%NRSTR(%doit(?aa,borders=?bb,columns=?cc)))
         Either example would generate the following internal do-loop:
         %DO I=1 %to &AAN;
           %doit(&&aa&I,borders=&&bb&I,columns=&&cc&I)
         %END;
         Because we are giving three macro array names, the macro DOIT
         must have three parameters.  Since there are only two keyword
         parameters listed, the third parameter is assumed to be
         positional.  Positional parameters always preceed keyword
         parameters in SAS macro definitions, so the first parameter
         a positional parameter, which is given the values of first
         macro array "aa".  The second is keyword parameter "borders="
         which is fed the values of the second array "bb".  The third
         is a keyword parameter "columns=" which is fed the values of
         the third array "cc".

  History
    7/15/05 changed %str(&VAL) to %quote(&VAL).
    4/1/06 added KEYWORD parameter
    4/9/06 declared "_Intrnl" array variables local to remove problems
            with nesting with VALUES=.
    8/4/06 made lines 72 characters or less to be mainframe compatible
*/

%LOCAL
  _IntrnlN
  _Intrnl1  _Intrnl2  _Intrnl3  _Intrnl4  _Intrnl5
  _Intrnl6  _Intrnl7  _Intrnl8  _Intrnl9  _Intrnl10
  _Intrnl11 _Intrnl12 _Intrnl13 _Intrnl14 _Intrnl15
  _Intrnl16 _Intrnl17 _Intrnl18 _Intrnl19 _Intrnl20
  _Intrnl21 _Intrnl22 _Intrnl23 _Intrnl24 _Intrnl25
  _Intrnl26 _Intrnl27 _Intrnl28 _Intrnl29 _Intrnl30
  _Intrnl31 _Intrnl32 _Intrnl33 _Intrnl34 _Intrnl35
  _Intrnl36 _Intrnl37 _Intrnl38 _Intrnl39 _Intrnl40
  _Intrnl41 _Intrnl42 _Intrnl43 _Intrnl44 _Intrnl45
  _Intrnl46 _Intrnl47 _Intrnl48 _Intrnl49 _Intrnl50
  _Intrnl51 _Intrnl52 _Intrnl53 _Intrnl54 _Intrnl55
  _Intrnl56 _Intrnl57 _Intrnl58 _Intrnl59 _Intrnl60
  _Intrnl61 _Intrnl62 _Intrnl63 _Intrnl64 _Intrnl65
  _Intrnl66 _Intrnl67 _Intrnl68 _Intrnl69 _Intrnl70
  _Intrnl71 _Intrnl72 _Intrnl73 _Intrnl74 _Intrnl75
  _Intrnl76 _Intrnl77 _Intrnl78 _Intrnl79 _Intrnl80
  _Intrnl81 _Intrnl82 _Intrnl83 _Intrnl84 _Intrnl85
  _Intrnl86 _Intrnl87 _Intrnl88 _Intrnl89 _Intrnl90
  _Intrnl91 _Intrnl92 _Intrnl93 _Intrnl94 _Intrnl95
  _Intrnl96 _Intrnl97 _Intrnl98 _Intrnl99 _Intrnl100
 _KEYWRDN _KEYWRD1 _KEYWRD2 _KEYWRD3 _KEYWRD4 _KEYWRD5
 _KEYWRD6 _KEYWRD7 _KEYWRD8 _KEYWRD9
 _KWRDI
 ARRAYNOTFOUND CRC CURRPREFIX DELIMI DID FRC I ITER J KWRDINDEX MANUM
 PREFIXES PREFIXN PREFIX1 PREFIX2 PREFIX3 PREFIX4 PREFIX5
 PREFIX6 PREFIX7 PREFIX8 PREFIX9
 SOMETHINGTODO TP VAL VALUESGIVEN
 ;

%let somethingtodo=Y;

%* Get macro array name(s) from either keyword or positional parameter;
%if       %str(&arraypos) ne %then %let prefixes=&arraypos;
%else %if %str(&array)    ne %then %let prefixes=&array;
%else %if %quote(&values) ne %then %let prefixes=_Intrnl;
%else %let Somethingtodo=N;

%if &somethingtodo=Y %then
%do;

%* Parse the macro array names;
%let PREFIXN=0;
%do MAnum = 1 %to 999;
 %let prefix&MANUM=%scan(&prefixes,&MAnum,' ');
 %if &&prefix&MAnum ne %then %let PREFIXN=&MAnum;
 %else %goto out1;
%end;
%out1:

%* Parse the keywords;
%let _KEYWRDN=0;
%do _KWRDI = 1 %to 999;
 %let _KEYWRD&_KWRDI=%scan(&KEYWORD,&_KWRDI,' ');
 %if &&_KEYWRD&_KWRDI ne %then %let _KEYWRDN=&_KWRDI;
 %else %goto out2;
%end;
%out2:

%* Load the VALUES into macro array 1 (only one is permitted);
%if %length(%str(&VALUES)) >0 %then %let VALUESGIVEN=1;
%else %let VALUESGIVEN=0;
%if &VALUESGIVEN=1 %THEN
%do;
         %* Check for numbered list of form xxx-xxx and expand it
            using NUMLIST macro.;
         %IF (%INDEX(%STR(&VALUES),-) GT 0) and
             (%SCAN(%str(&VALUES),2,-) NE ) and
             (%SCAN(%str(&VALUES),3,-) EQ )
           %THEN %LET VALUES=%NUMLIST(&VALUES);

%do iter=1 %TO 9999;
  %let val=%scan(%str(&VALUES),&iter,%str(&DELIM));
  %if %quote(&VAL) ne %then
    %do;
      %let &PREFIX1&ITER=&VAL;
      %let &PREFIX1.N=&ITER;
    %end;
  %else %goto out3;
%end;
%out3:
%end;

%let ArrayNotFound=0;
%do j=1 %to &PREFIXN;
  %*put prefix &j is &&prefix&j;
  %LET did=%sysfunc(open(sashelp.vmacro
                    (where=(name eq "%upcase(&&PREFIX&J..N)")) ));
  %LET frc=%sysfunc(fetchobs(&did,1));
  %LET crc=%sysfunc(close(&did));
  %IF &FRC ne 0 %then
    %do;
       %PUT Macro Array with Prefix &&PREFIX&J does not exist;
       %let ArrayNotFound=1;
    %end;
%end;

%if &ArrayNotFound=0 %then %do;

%if %quote(%upcase(&BETWEEN))=COMMA %then %let BETWEEN=%str(,);

%if %length(%str(&MACRO)) ne 0 %then
  %do;
     %let TP = %nrstr(%&MACRO)(;
     %do J=1 %to &PREFIXN;
         %let currprefix=&&prefix&J;
         %IF &J>1 %then %let TP=&TP%str(,);
            %* Write out macro keywords followed by equals.
               If fewer keywords than macro arrays, assume parameter
               is positional and do not write keyword=;
            %let kwrdindex=%eval(&_KEYWRDN-&PREFIXN+&J);
            %IF &KWRDINDEX>0 %then %let TP=&TP&&_KEYWRD&KWRDINDEX=;
         %LET TP=&TP%nrstr(&&)&currprefix%nrstr(&I);
     %END;
     %let TP=&TP);  %* close parenthesis on external macro call;
  %end;
%else
  %do;
     %let TP=&PHRASE;
     %let TP = %qsysfunc(tranwrd(&TP,&ESCAPE._I_,%nrstr(&I.)));
     %let TP = %qsysfunc(tranwrd(&TP,&ESCAPE._i_,%nrstr(&I.)));
     %do J=1 %to &PREFIXN;
         %let currprefix=&&prefix&J;
         %LET TP = %qsysfunc(tranwrd(&TP,&ESCAPE&currprefix,
                                 %nrstr(&&)&currprefix%nrstr(&I..)));
         %if &PREFIXN=1 %then %let TP = %qsysfunc(tranwrd(&TP,&ESCAPE,
                                 %nrstr(&&)&currprefix%nrstr(&I..)));
     %end;
  %end;

%* resolve TP (the translated phrase) and perform the looping;
%do I=1 %to &&&prefix1.n;
%if &I>1 and %length(%str(&between))>0 %then &BETWEEN;
%unquote(&TP)
%end;

%end;
%end;

%MEND;
