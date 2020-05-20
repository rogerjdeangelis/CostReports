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
*  INPUTS (works for all cost reports here is input for SNF)                                                    *;
*  =========================================================                                                    *;
*                                                                                                               *;
*  Web zip files for snf (download if you don't have R or lockdown conditions)                                  *;
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
*  #CONTINUE#    ==> Important if CONTINUE THE MODULE 2 cst_150 can be run  #STOP# is other possibility         *;
*                                                                                                               *;
* --------------------------------------------------------------------------------------------------------------*;
*                                                                                                               *;
*  set of csv output for SNF reports                                                                            *;
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
