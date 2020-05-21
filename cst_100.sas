*****************************************************************************************************************;
*                                                                                                               *;
*; %let pgm=cst_100;  * first module in Cost Report Table Schema */                                             *;
*                                                                                                               *;
*  OPSYS  WIN 10 64bit SAS 9.4M6(64bit)  (This code will not run in lockdown)                                   *;
*                                                                                                               *;
*  %let purpose=Copy cost report zip files to local drive and unzip;                                            *;
*                                                                                                               *;
*  Github repository (sample input, output and code is at)                                                      *;
*                                                                                                               *;
*  https://github.com/rogerjdeangelis/CostReports                                                               *;
*                                                                                                               *;
*  PROJECT TOKEN = cst                                                                                          *;
*                                                                                                               *;
*  Run the code below once to create the folder structure                                                       *;
*                                                                                                               *;
*; %let _r=d; * home directory;                                                                                ;*;
*                                                                                                               *;
*  This is the first module in the Cost Report Project                                                          *;
*                                                                                                               *;
*  A single shema will have all cost reports for all years, starting in 2011.                                   *;
*                                                                                                               *;
*   Cost Reports                                                                                                *;
                                                                                                                *;
*     1. SNF Skilled Nursing Facilities                                                                         *;
*     2. Home Health Agencies                                                                                   *;
*     3. Renal Facilities                                                                                       *;
*     4  Hospice                                                                                                *;
*     5. Rural Health                                                                                           *;
*     6. Comunity Health Centers                                                                                *;
*     7. Federally Qualified Health Centers                                                                     *;
*                                                                                                               *;
*  The code below will create the directory stucture you need                                                   *;
*                                                                                                               *;
*  * JUST RUN THIS TO CREATE DIRECTORIES;                                                                       *;
*  data _null_;                                                                                                 *;
*                                                                                                               *;
*     newdir=dcreate('utl',"&_r/");                                                                             *;
*     newdir=dcreate('ver',"&_r/");                                                                             *;
*     newdir=dcreate('oto',"&_r/");                                                                             *;
*     newdir=dcreate('xls',"&_r:/cst/");                                                                        *;
*     newdir=dcreate('csv',"&_r:/cst/");                                                                        *;
*     newdir=dcreate('fmt',"&_r:/cst/");                                                                        *;
*     newdir=dcreate('pdf',"&_r:/cst/");                                                                        *;
*     newdir=dcreate('zip',"&_r:/cst/");                                                                        *;
*     newdir=dcreate('doc',"&_r:/cst/");                                                                        *;
*     newdir=dcreate('ppt',"&_r:/cst/");                                                                        *;
*     newdir=dcreate('log',"&_r:/cst/");                                                                        *;
*     newdir=dcreate('lst',"&_r:/cst/");                                                                        *;
*                                                                                                               *;
*  run;quit;                                                                                                    *;
*                                                                                                               *;
*                                                                                                               *;
*  PROGRAM LOCATION in &_r:\utl                                                                                 *;
*  PROGRAM VERSIONS in &_r:\ver                                                                                 *;
*  AUTOCALL LIBRARY in &_r:\oto                                                                                 *;
*                                                                                                               *;
*  Schema Location  &_r:/cst      * Stem                                                                        *;
*  Scema Excel      &_r:/cst/xls  * DYNANIC FINAL PUFS (simple pivot)                                           *;
*  Scema CSV files  &_r:/cst/csv  * SOURCE CSV FILES                                                            *;
*  Schema Formats   &_r:/cst/fmt  * SAS FORMATS                                                                 *;
*  Documentation    &_r:/cst/pdf  * PDF SLIDES                                                                  *;
*  Zip Files        &_r:/cst/zip  * DOWNLOADED ZIP FILES                                                        *;
*  MS Docs          &_r:/cst/doc  * MS DOCS                                                                     *;
*  MS Powerpoint    &_r:/cst/ppt  * POWERPOINT                                                                  *;
*  Log batch runs   &_r:/cst/log  * LOGS                                                                        *;
*  lists batch runs &_r:/cst/lst  * LIST OUTPUT                                                                 *;
*                                                                                                               *;
* LOCATION OF EXTERNAL RAW ZIPPED COST REPORTS ON WEB                                                           *;
* ===================================================                                                           *;
* https://tinyurl.com/uwztyu2                                                                                   *;
* https://www.cms.gov/Research-Statistics-Data-and-Systems/Downloadable-Public-Use-Files/Cost-Reports           *;
*                                                                                                               *;
* Libname you will eventuall need not needed here                                                               *;
*                                                                                                               *;
* Libaname cst "&_r:/cst" Where the schema tables and intermediary tables is stored                             *;
* libname  cstfmt "&r:/cst/fmt";                                                                                *;
*                                                                                                               *;
* Options (fmtsearch=work.formats cst.cst_fmtV1A sasautos="&_r:/oto");                                          *;
*                                                                                                               *;
* INTERNAL MACROS                                                                                               *;
* ===============                                                                                               *;
*                                                                                                               *;
*  cst_100 - first module in cost report analysis                                                               *;
*                                                                                                               *;
* EXTERNAL MACROS IN AUTOCALL LIBRARY                                                                           *;
* ====================================                                                                          *;
*                                                                                                               *;
*  utl_submit_r64   * drop down to R processing                                                                 *;
*  utlfkil          * delete file                                                                               *;
*  array            * builds a macro array                                                                      *;
*  utlnopts         * minimal options                                                                           *;
*  utlopts          * debugging options;                                                                        *;
*                                                                                                               *;
*                                                                                                               *;
*  EXTERNAL INPUTS ( This data is outside this project )                                                        *;
*  ==================================================================                                           *;
*                                                                                                               *;
*  Web zip files for snf (download if you don't have R or lockdown conditions)                                  *;
*                                                                                                               *;
*            OUTPATIENT SERVICE COST CENTERc@Reclass Balance@A000000_06000_00500_N                              *;
*                                                                                                               *;
*  &_r:\cst.col_coldescribe.sas7bdat                                                                            *;
*                                                                                                               *;
*  Sample Record                                                                                                *;
*                                                                                                               *;
*      col_cel_name       col_description                                                                       *;
*                                                                                                               *;
*  A000000_04800_00100_N  OUTPATIENT SERVICE COST CENTERc@Reclass Balance@A000000_06000_00500_N                 *;
*  A000000_04800_00200_N  OUTPATIENT SERVICE COST CENTERc@Reclass Totale@A000000_06000_00500_N                  *;
*                                                                                                               *;
*  Web zip files for automatic download                                                                         *;
*                                                                                                               *;
*  https://downloads.cms.gov/files/hcris/snf11fy2011.zip                                                        *;
*  https://downloads.cms.gov/files/hcris/snf12fy2012.zip                                                        *;
*  https://downloads.cms.gov/files/hcris/snf13fy2013.zip                                                        *;
*  https://downloads.cms.gov/files/hcris/snf14fy2014.zip                                                        *;
*  https://downloads.cms.gov/files/hcris/snf15fy2015.zip                                                        *;
*  https://downloads.cms.gov/files/hcris/snf16fy2016.zip                                                        *;
*  https://downloads.cms.gov/files/hcris/snf17fy2017.zip                                                        *;
*  https://downloads.cms.gov/files/hcris/snf18fy2018.zip                                                        *;
*  https://downloads.cms.gov/files/hcris/snf19fy2019.zip                                                        *;
*                                                                                                               *;
*                                                                                                               *;
*  PROCESS                                                                                                      *;
*  =======                                                                                                      *;
*                                                                                                               *;
*  Sample call (this will create csvs for SNF Skilled Nursing Facitity                                          *;
*  Copy cost report zip files to local drive and unzip";                                                        *;
*                                                                                                               *;
*    Call the macro below                                                                                       *;
*                                                                                                               *;
/*    %cst_100(                                                                                                 */;
*        cst=snf                                                                                                *;
*       ,yrs=2010                                                                                               *;
*     );                                                                                                        *;
*                                                                                                               *;
*  If you cannot run the automated code you will need to                                                        *;
*  download and unzip manually, just go to                                                                      *;
*                                                                                                               *;
*  https://tinyurl.com/uwztyu2                                                                                  *;
*                                                                                                               *;
*    click on the year you want                                                                                 *;
*    download to &_r:/cst/zip                                                                                   *;
*    unzip and place the csv in &_r:/csv                                                                        *;
*                                                                                                               *;
*                                                                                                               *;
*  OUTPUTS (works for all cost reports here is input for SNF)                                                   *;
*  =========================================================                                                    *;
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
*                                                                                                               *;
*  Sample csv output for SNF reports (unzipped down automaticall download                                       *;
*                                                                                                               *;
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
*                                                                                                               *;
*****************************************************************************************************************;
*                                                                                                               *;
* CHANGE HISTORY                                                                                                *;
*                                                                                                               *;
*  1. Roger Deangelis              19JMAY2019   Creation                                                        *;
*     rogerjdeangelis@gamil.com                                                                                 *;
*                                                                                                               *;
*****************************************************************************************************************;


%macro cst_100(
       cst=snf
      ,yr=2019
       );

     %local dwnlod zip alpha nmrc rpt;

     /* for checking without macro
        %let cst=snf;
        %let yr=2019;
     */

     %utlnopts;
     %let dwnlod = https://downloads.cms.gov/files/hcris/&cst.10fy&yr..zip;
     %let zip    = &_r:/cst/zip/&cst.10fy&yr..zip;
     %let alpha  = &_r:/cst/csv/&cst.10_&yr._alpha.csv;;
     %let nmrc   = &_r:/cst/csv/&cst.10_&yr._nmrc.csv;
     %let rpt    = &_r:/cst/csv/&cst.10_&yr._rpt.csv;

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

     %utl_submit_r64("
     activity_url <- '&dwnlod';
     download.file(activity_url, '&zip');
     unzip('&zip',exdir='&_r:/cst/csv');
     ");

      * check to make sure files were created;
      %utlfkil(&_r:/cst/log/&pgm.&cst.&yr.csv.log);

      data _null_;
         length zipchk $64;
         file   "&_r:/cst/log/&pgm.&cst.&yr.csv.log";
         put    "&sysday &sysdate &systime &sysuserid &SYSPROCESSMODE";
         putlog "&sysday &sysdate &systime &sysuserid &SYSPROCESSMODE";
         zipchk   = ifc(fileexist("&zip")  , "Created &zip"   , "Failed &zip");
         alphachk = ifc(fileexist("&alpha"), "Created &alpha" , "Failed &alpha");
         nmrcchk  = ifc(fileexist("&nmrc") , "Created &nmrc"  , "Failed &nmrc");
         rptchk   = ifc(fileexist("&rpt")  , "Created &rpt"   , "Failed &rpt");
         putlog
            (
            zipchk
            alphachk
            nmrcchk
            rptchk
           )  (/);;
         put
            (
            zipchk
            alphachk
            nmrcchk
            rptchk
           )  (= /);

        if  Sum(
            fileexist("&zip")   +
            fileexist("&alpha") +
            fileexist("&nmrc")  +
            fileexist("&rpt"))=4 then do;
               put   /  "#CONTINUE#";
               putlog / "#CONTINUE#";
         end;
         else do;
            put    / "#STOP#";
            putlog / "#STOP#";
         end;
      run;quit;


%mend cst_100;

%utlopts;
%cst_100(yr=2011);
%cst_100(yr=2012);
%cst_100(yr=2013);
%cst_100(yr=2014);
%cst_100(yr=2015);
%cst_100(yr=2016);
%cst_100(yr=2017);
%cst_100(yr=2018);
%cst_100(yr=2019);

































%put _automatic_;

data why;
  length x $8;
  x=ifc(fileexist("&zip"),"Y","N");
  put x=;
run;quit;

      %put %sysfunc(fileexist("&rpt"));


%macro cst_100(
       cst=snf
      ,yr=2019
       );

      * delete old data;
      %utlfkil(d:/snf/zip/snf10fy&yr..zip);
      %utlfkil(d:/snf/csv/snf10_&yr._alpha.csv);
      %utlfkil(d:/snf/csv/snf10_&yr._nmrc.csv);
      %utlfkil(d:/snf/csv/snf10_&yr._rpt.csv);

      %utl_submit_r64('
      activity_url <- "https://downloads.cms.gov/files/hcris/snf10fy&yr..zip";
      download.file(activity_url, "d:/snf/zip/snf10fy&yr..zip");
      unzip("d:/snf/zip/snf10fy&yr..zip",exdir="d:/snf/csv");
      ');

      * check to make sure files were created;

      data "&_r:/










      end;

      stop;

   run;quit;

%mend cst_100;

     ;;;;/*'*/ *);*};*];*/;/*"*/;%mend;run;quit;%end;end;run;endcomp;%utlfix;


%utl_submit_r64('
activity_url <- "https://downloads.cms.gov/files/hcris/snf10fy2019.zip";
download.file(activity_url, "d:/snf/zip/snf10fy2019.zip");
unzip("d:/snf/zip/snf10fy2019.zip",exdir="d:/snf/csv");
');

%let yr=2019;

%utl_submit_r64('
activity_url <- "https://downloads.cms.gov/files/hcris/snf10fy&yr..zip";
download.file(activity_url, "d:/snf/zip/snf10fy&yr..zip");
unzip("d:/snf/zip/snf10fy&yr..zip",exdir="d:/snf/csv");
');



    * add commas;

    /* for testing %let yrs=2010 2011 2012;  */

    data _null_;
       retain lst "&yrs";
       lst=translate(lst,',',' ');
       call symputx('lst',lst);
    run;quit;

   %put &=lst;



      do yr=2019;













           %let yr=2010;

           %utlfkil(d:/snf/zip/snf10fy&yr..zip);



               ;;;;/*'*/ *);*};*];*/;/*"*/;%mend;run;quit;%end;end;run;endcomp;%utlfix;

















%let finvar=
S2_1_C1_3_0
S2_1_C1_4_0
S2_1_C1_1_0
S2_1_C1_2_0
S2_1_C4_2_0
S2_1_C2_2_0
S2_1_C3_2_0
S2_1_C1_26_0
S3_1_C10_14_0
S3_1_C9_27_0
S3_1_C2_14_0
S3_1_C3_14_0
S3_1_C13_14_0
S3_1_C14_14_0
S3_1_C15_14_0
S3_1_C6_14_0
S3_1_C7_14_0
S3_1_C5_14_0
S3_1_C6_14_0
S3_1_C7_14_0
G3_C1_1_0
G3_C1_26_0
S3_1_C15_14_0
G2_C1_28_0
G2_C2_28_0
G3_C1_1_0
G3_C1_2_0
G3_C1_3_0
G3_C1_25_0
G3_C1_4_0
G3_C1_5_0
S10_C1_22_0
S10_C3_20_0
S10_C3_21_0
G_C1_38_0
A7_3_C9_3_0
G_C1_28_0
G_C1_29_0
G_C1_1_0
G_C1_2_0
G_C1_4_0
G_C1_6_0
G_C1_7_0
G_C1_8_0
G_C1_9_0
G_C1_11_0
G_C1_12_0
G_C1_13_0
G_C1_14_0
G_C1_15_0
G_C1_16_0
G_C1_17_0
G_C1_18_0
G_C1_19_0
G_C1_20_0
G_C1_23_0
G_C1_24_0
G_C1_25_0
G_C1_26_0
G_C1_30_0
G_C1_31_0
G_C1_34_0
G_C1_35_0
G_C1_36_0
G_C1_37_0
G_C1_38_0
G_C1_39_0
G_C1_41_0
G_C1_44_0
G_C1_45_0
G_C1_49_0
G_C1_50_0
G_C1_51_0
G_C1_52_0
G_C1_59_0
G_C1_60_0
;

data _null_;
  length str $32756;
  str=left(compbl("&finvar."));
  str=strip(tranwrd(strip(str),' ','","'));
  str=cats('"',str,'"');
  put str;
  call symputx('finquo',str);
run;quit;


****   ****   *****
*   *  *   *    *
*   *  *   *    *
****   ****     *
* *    *        *
*  *   *        *
*   *  *        *;

%macro snf_200webrpt(inp=,out=);

    data "&out";


    *hosp_dm.* files report lengths;
    *Using a length of 4 bytes retains 6 significant digits;
    *Largest integer represented exactly is 2,097,152;
    *Maximum values apply to 2002-09-30 data file;
    *max date is around 16000, do length of 4 should be fine for dates;
    *Variable           Maximum
    ---------           -------
    RPT_REC_NUM         64331     Primary Key / Unique ID
    PRVDR_CTRL_TYPE_CD  "13"
    PRVDR_NUM           "660001"
    RPT_STUS_CD         "4"
    INITL_RPT_SW        "Y"
    LAST_RPT_SW         "Y"
    TRNSMTL_NUM         "8"
    FI_NUM              "77002"
    ADR_VNDR_CD         "4"
    UTIL_CD             "F"
    SPEC_IND            "Y"
    ;

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
        rpt_rec_num="Report Record Number"
        prvdr_ctrl_type_cd ="Provider Control Type Code"
        prvdr_num ="Provider Number"
        npi="National Provider Identifier"
        rpt_stus_cd="Report Status Code"
        fy_bgn_dt="Fiscal Year Begin Date"
        fy_end_dt="Fiscal Year End Date"
        proc_dt  ="HCRIS Process Date"
        initl_rpt_sw="Initial Report Switch"
        last_rpt_sw="Last Report Switch"
        trnsmtl_num="Transmittal Number"
        fi_num ="Fiscal Intermediary Number"
        adr_vndr_cd="Automated Desk Review Vendor Code"
        fi_creat_dt="Fiscal Intermediary Create Date"
        util_cd    ="Utilization Code"
        npr_dt     ="Notice of Program Reimbursement Date"
        spec_ind="Special Indicator"
        fi_rcpt_dt="Fiscal Intermediary Receipt Date"
        yer="Year of CSV file from CMS wweb data"
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
      yer                 $2.
    ;

    infile "&inp" delimiter = ',' TRUNCOVER DSD lrecl=32767;

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
        yer
    ;

    run;

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

%mend snf_200webrpt;

%snf_200webrpt(inp=&inpsxx,out=&outryxx);


 *   *  *   *  ****    ***
 **  *  ** **  *   *  *   *
 * * *  * * *  *   *  *
 *  **  *   *  ****   *
 *   *  *   *  * *    *
 *   *  *   *  *  *   *   *
 *   *  *   *  *   *   ***;

/*
proc fslist file="&inpn14";
;run;quit;
data lstzro;
  set "&outny14";
  if substr(CLMN_NUM,5,1) ne '0';
;run;quit;
*/

%macro snf_300webnmrc(inp=,out=);

    /*
    CREATE TABLE <subsystem>_RPT_NMRC (
           RPT_REC_NUM          NUMBER NOT NULL,
           WKSHT_CD             CHAR(7) NOT NULL,
           LINE_NUM             CHAR(5) NOT NULL,
           CLMN_NUM             CHAR(5) NOT NULL for HOSP10
           ITM_VAL_NUM          NUMBER NOT NULL
    );
    */

    data "&out";
    length clmn_num $5;
    infile "&inp" delimiter = ',' TRUNCOVER DSD lrecl=32767 ;
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
          YER
     ;

     yer="&yr.";

    run;

%mend snf_300webnmrc;

%snf_300webnmrc(inp=&inpnxx,out=&outnyxx);

%put &=inpnxx &=outnyxx;

/*
Up to 40 obs from "d:\snf\snf_web_nm10yer.sas7bdat total obs=19,643,511

                       RPT_REC_                            ITM_VAL_
    Obs    CLMN_NUM       NUM      WKSHT_CD    LINE_NUM       NUM

      1     00200       534105     A000000      00100       1494791
      2     00300       534105     A000000      00100       1494791
      3     00400       534105     A000000      00100       1128275
      4     00500       534105     A000000      00100       2623066
      5     00600       534105     A000000      00100         17295
      6     00700       534105     A000000      00100       2640361
      7     00400       534105     A000000      00200         16494
*/

  *    *      ****   *   *    *
 * *   *      *   *  *   *   * *
*   *  *      *   *  *   *  *   *
*****  *      ****   *****  *****
*   *  *      *      *   *  *   *
*   *  *      *      *   *  *   *
*   *  *****  *      *   *  *   *;

%macro snf_400webalpha(inp=,out=);

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

    data "&out";

    infile "&inp" delimiter = ',' TRUNCOVER DSD lrecl=32767 ;
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
     yer="&yr";
    run;

%mend snf_400webalpha;

%snf_400webalpha(inp=&inpbxx,out=&outayxx);

%macro snf_500weball(inp1=,inp2=,out=,outhdr=);

    /* for testing
      %let inp1=&outny10;
      %let inp2=&outay10;
      %let out=&outal10;
      %let out1=&outfin10;
    */

    data  &pgm._nrm (drop=itm_val_num alphnmrc_itm_txt);
      length RPT_REC_NUM 4;
      set
        "&inp1"(in=newn )
        "&inp2"(in=newc )
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

    run;

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
        table "&out" as
      select
        l.*
       ,r.*
      from
        &pgm._nrm as l, "&outhdr" as r
      where
        l.rpt_rec_num = r.rpt_rec_num
    ;quit;
  /*
    * finacial subset;
    data "&out1"(label="Finacial subset approx 70 cells");
      length key $32 celref $24;

      set "&out";

      key=catx('@', wksht_cd,clmn_num, line_num);
      if put(key,$csvcolrow_celref.) ne 'UNKNOWN';
      celref=put(key,$csvcolrow_celref.);
    ;run;quit;
  */

%mend snf_500weball;

%snf_500weball(inp1=&outnyxx,inp2=&outayxx,out=&outalxx,outhdr=&outryxx);


/*

data &pgm._S200001;
  set
     SNF.SNF_WEBYER_NUMALP11YER(where=(wksht_cd in ("S200001")))
     SNF.SNF_WEBYER_NUMALP12YER(where=(wksht_cd in ("S200001")))
     SNF.SNF_WEBYER_NUMALP13YER(where=(wksht_cd in ("S200001")))
     SNF.SNF_WEBYER_NUMALP14YER(where=(wksht_cd in ("S200001")))
     SNF.SNF_WEBYER_NUMALP15YER(where=(wksht_cd in ("S200001")))
     SNF.SNF_WEBYER_NUMALP16YER(where=(wksht_cd in ("S200001")))
     SNF.SNF_WEBYER_NUMALP17YER(where=(wksht_cd in ("S200001")));
run;quit;

* provider number where SNF is selected;
data &pgm._S200001x(rename=itm_txt=ccn);
  set &pgm._S200001(keep=rpt_rec_num itm_txt yer prvdr_num line_num clmn_num
        where=( clmn_num in ( '00200') and line_num in ('00400')));
  keep itm_txt yer prvdr_num rpt_rec_num;
run;quit;

proc sql;
  create
     table keyunq as
  select
     yer
    ,count(distinct(prvdr_num))  as unq_prvdr_num
    ,count(distinct(ccn))         as unq_ccn
    ,count(distinct(rpt_rec_num)) as unq_rpt_rec_num
  from
     &pgm._S200001x
  group
     by yer
;quit;





*/



/*




d:\snf\snf_web_nm11yer.sas7bdat
d:\snf\snf_web_al11yer.sas7bdat
*


****   ****   *****  *   *  *****  ****
 *  *  *   *    *    *   *  *      *   *
 *  *  *   *    *    *   *  *      *   *
 *  *  ****     *    *   *  ****   ****
 *  *  * *      *    *   *  *      * *
 *  *  *  *     *     * *   *      *  *
****   *   *  *****    *    *****  *   *

#! DRIVER ;

%*snf_100webmap;

proc datasets kill;
run;quit;

%*snf_200webrpt(inp=&inpsxx,out=&outryxx);
%*snf_300webnmrc(inp=&inpnxx,out=&outnyxx);
%*snf_400webalpha(inp=&inpbxx,out=&outayxx);
%snf_500weball(inp1=&outnyxx,inp2=&outayxx,out=&outalxx,outhdr=&outryxx);
*/
1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 12345678901234567890 1234567890 1234567890 1234567890 12345678901234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 12345678901234567890 1234567890 1234567890 1234567890 12345678901234567890 1234567890 1234567890 1234567890 123









































                                                         *
