*****************************************************************************************************************;
*                                                                                                               *;
*; %let pgm=cst_150;  * Run this if #CONTINUE# was last line in module cst_100                                  *;
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
