# CostReports
Builds a Cost Report Table Schema for Detailed Analysis of Cost Repoers
 
    Under Development
    
    Although not finished, I have tested the code on three systems, Win 7, my Win 10 Laptop and Work Laptop.
    
    EXCEL DELIVERABLES
    
    GOOGLE DRIVE
    
    Adding Google Drive links to deliverables (cannot keep track of Dropbox api changes)   
                                                                                       
    2019 in Google Drive 8mb                                                               
    https://tinyurl.com/ybhmxt3e                                                           
    https://drive.google.com/file/d/12a1E4iYwr6n8qL5we-ugNu4C5Cse7zKf/view?usp=sharing     
                                                                                                                    
    2011-2019 45mb                                                                         
    https://tinyurl.com/ycj5sc5f                                                           
    https://drive.google.com/file/d/1o6s5NSSwrGvM5hsOOlZr_G43cnEZCFSK/view?usp=sharing     
    
    
    DROPBOX
    
    Sample DRAFT output Skilled Nursing Facility 2011 to 2019 in one excel sheet 1,220 columns
    File is too large for gihub so here is the dropbox link (whole process takes less than 30 mins?
    
    Just 2019 8mb
    https://github.com/rogerjdeangelis/CostReports/blob/master/cst_300snfcst_300snfpuf20192019.xlsx
    
    2011-2019 (350mb)
    https://www.dropbox.com/s/qzocabam8hp5i7p/cst_300snfcst_300snfpuf20112019.xlsb?dl=0
  
    Installation (widows only-with xcmd option in SAS)
    
        Download cst_000makefile/sas
                 cst_005driver.sas
                 
        Open the classic SAS editor (if you want to use my performance macros-not tested in EG or EG Server)
       
        Run cst_000makefile.sas (compiles and automatically downloads all the input externals)
        
        Finally
        Run the module driver, cst_005.driver.sas (instead of the driver you can run each module in makefile just highlight and submit)
        
        I suggest you run the makefile with config option gbl_yrs=2011-2019, You can then
        select one year gbl_years=2019-2019 or any range of years for the driver.
     
    If you run                                                                                     
    cst_000Makefile.sas with these global variables;                                               
                                                                                                   
    %let gbl_tok   =  cst                 ;   * toten and part of root;                            
    %let gbl_typ   =  snf                 ;   * skilled nursing facilities;                        
    %let gbl_dir   =  1                   ;   * if 1 then build directory structure;               
    %let gbl_dirsub=  1                   ;   * if 1 then build sub directories;                   
    %let gbl_ext   =  1                   ;   * get externals;                                     
    %let gbl_yrs   =  2019-2019           ;   * years to process;                                  
    %let gbl_root  =  c                   ;   * where things are;                                  
    %let gbl_oto   =  &gbl_root:/cst/oto  ;   * autocall library;                                  
    %let gbl_sd1   =  &gbl_root:/cst      ;   * schema for cost report tables;                     
                                                                                                   
                                                                                                   
    You should get this output                                                                     
                                                                                                   
                                                                                                   
    c.\CST                                                                                         
       |   cst_025snfdescribe.sas7bdat                                                             
       |                                                                                           
       +---b64                                                                                     
       |       cst_025snfdescribe_sas7bdat.b64                                                     
       |                                                                                           
       +---csv                                                                                     
       +---doc                                                                                     
       +---fmt                                                                                     
       +---log                                                                                     
       +---lst                                                                                     
       +---oto                                                                                     
       |       cst_000makefile.sas                                                                 
       |       cst_005driver.sas                                                                   
       |       cst_010.sas                                                                         
       |       cst_050.sas                                                                         
       |                                                                                           
       +---pdf                                                                                     
       +---ppt                                                                                     
       +---ps1                                                                                     
       +---rda                                                                                     
       +---rtf                                                                                     
       +---sas                                                                                     
       +---vba                                                                                     
       +---vdo                                                                                     
       +---xls                                                                                     
    \---zip                                                                                        
                                                                                                   
                                                                                                   
    Then if you run                                                                                
                                                                                                   
    cst_000drover.sas with these global variables;                                                 
                                                                                                   
    %let gbl_tok    =  cst                 ;   * project token;                                    
    %let gbl_typ    =  snf                 ;   * skilled nursing facilities;                       
    %let gbl_yrs    =  2019-2019           ;   * years to process;                                 
    %let gbl_root   =  c                   ;   * where things are;                                 
    %let gbl_oto    =  &gbl_root.:/cst/oto ;   * autocall library;                                 
    %let gbl_sd1    =  &gbl_root.:/cst     ;   * schema for cost report tables;                    
                                                                                                   
    You should get this                                                                            
                                                                                                   
    C:\CST                                                                                         
    |   cst_025snfdescribe.sas7bdat                                                                
    |   cst_150snfalp20192019.sas7bdat                                                             
    |   cst_150snfnum20192019.sas7bdat                                                             
    |   cst_150snfnumalp20192019.sas7bdat                                                          
    |   cst_150snfrpt20192019.sas7bdat                                                             
    |   cst_200snffiv20192019.sas7bdat                                                             
    |   cst_250snffac20192019.sas7bdat                                                             
    |   cst_300snfmax20192019.sas7bdat                                                             
    |   cst_300snfxpo20192019.sas7bdat                                                             
    |                                                                                              
    +---b64                                                                                        
    |       cst_025snfdescribe_sas7bdat.b64                                                        
    |                                                                                              
    +---csv                                                                                        
    |       snf10_2019_ALPHA.CSV                                                                   
    |       snf10_2019_NMRC.CSV                                                                    
    |       snf10_2019_RPT.CSV                                                                     
    |                                                                                              
    +---doc                                                                                        
    +---fmt                                                                                        
    +---log                                                                                        
    +---lst                                                                                        
    +---oto                                                                                        
    |       cst_000makefile.sas                                                                    
    |       cst_005driver.sas                                                                      
    |       cst_010.sas                                                                            
    |       cst_050.sas                                                                            
    |       cst_100.sas                                                                            
    |       cst_150_1.sas                                                                          
    |       cst_150_2.sas                                                                          
    |       cst_150_3.sas                                                                          
    |       cst_150_4.sas                                                                          
    |       cst_200.sas                                                                            
    |       cst_250.sas                                                                            
    |       cst_300.sas                                                                            
    |                                                                                              
    +---pdf                                                                                        
    +---ppt                                                                                        
    +---ps1                                                                                        
    +---rda                                                                                        
    +---rtf                                                                                        
    +---sas                                                                                        
    +---vba                                                                                        
    +---vdo                                                                                        
    +---xls                                                                                        
    |       cst_300snfcst_300snfpuf20192019.xlsx  ** the deliverable;                              
    |                                                                                              
    \---zip                                                                                        
                                                                                                   
                                                                                                                                                                 

    Development system is now in pseudo production
    
    Please let me know if you have any problems. rogerjdeangelis@gmail.com
    
    Development folder
    
        ./dev/cst
        
    Production folder
    
        ./prd/cst
    
    Sample DRAFT output 2019 Skilled Nursing Facility 2011 to 2019 in one excel sheet 1,220 columns
    File is too large for gihub so here is the dropbox link (whole process takes less than 30 mins?
    
    Just 2019
    https://github.com/rogerjdeangelis/CostReports/blob/master/cst_300snfcst_300snfpuf20192019.xlsx
    
    2011-2019
    https://www.dropbox.com/s/qzocabam8hp5i7p/cst_300snfcst_300snfpuf20112019.xlsb?dl=0

                                                                                     
    Rough DRAFT design of Cost report schema
    https://github.com/rogerjdeangelis/CostReports/blob/master/cst_design.pdf
    
    This driver code below is aided by the open code '%if'                                                                                        
                                                                                                                                        
    This code supoorts self locating files and self sourced files                                                                       
                                                                                                                                        
    Output object                                                                                                                       
                                                                                                                                        
      cst_025snfrug.xlsx                                                                                                                
                                                                                                                                        
      Is located at           ./cst/xls/cst_025snfrug.xlsx  (stem is cst subfolder is xlsx ./cst/xls/cst_025snfrug.xlsx)                                                                            
      Was created by program  ./cst_025snfrug.sas                                                                                       
                                                                                                                                        
    This repo is under deveopment. None of the code has been run (in its present form)                                                  
                                                                                                                                        
    *    _      _        _ _   _        __                          _ _                                                                 
      __| | ___| |_ __ _(_) | (_)_ __  / _| ___     __ ___   ____ _(_) |                                                                
     / _` |/ _ \ __/ _` | | | | | '_ \| |_ / _ \   / _` \ \ / / _` | | |                                                                
    | (_| |  __/ || (_| | | | | | | | |  _| (_) | | (_| |\ V / (_| | | |                                                                
     \__,_|\___|\__\__,_|_|_| |_|_| |_|_|  \___/   \__,_| \_/ \__,_|_|_|                                                                
                                                                                                                                        
    ;                                                                                                                                   
                                                                                                                                        
    WorkSheets with additional descriptive information for every cell                                                                   
     ( all worksheets are in central fact table)                                                                                        
                                                                                                                                        
    S1,S2, S3 CERTIFICATION AND SETTLEMENT SUMMARY                                                                                      
                                                                                                                                        
    S41       SNF-BASED HOME HEALTH AGENCY                                                                                              
                                                                                                                                        
    O01       ANALYSIS OF HOSPITAL-BASED HOSPICE COSTS  (decided not to put in filal excel PUF)                                                                                
                                                                                                                                        
    S7        PROSPECTIVE PAYMENT FOR SNF STATISTICAL DATA                                                                              
    A0        RECLASSIFICATION AND ADJUSTMENT OF TRIAL BALANCE OF EXPENSES                                                              
                                                                                                                                        
    A7        RECONCILIATION OF CAPITAL COSTS CENTERS                                                                                   
                                                                                                                                        
    C0        COMPUTATION OF RATIO OF COSTS TO CHARGES                                                                                  
                                                                                                                                        
    E00A181   CALCULATION OF REIMBURSEMENT SETTLEMENT TITLE XVIII                                                                       
    E00A192   ANALYSIS OF PAYMENTS TO PROVIDERS FOR SERVICES RENDERED                                                                   
                                                                                                                                        
    G0        BALANCE SHEET                                                                                                             
    G2        STATEMENT OF PATIENT REVENUES AND OPERATING EXPENSES                                                                      
    G3        STATEMENT OF REVENUES AND EXPENSES  
    
    A key table
    https://github.com/rogerjdeangelis/CostReports/blob/master/cst_025snfdescribe.sas7bdat
    
    Contains detail descriptions for every cell in almost all worksheets. Just two columns
    
    cel_name                 cel_Description (fake data "@" is string split character)
    wks     line  column     Column description                    Row      Reoeat cell_name
    A000000_06000_00200_N    OUTPATIENT SERVICE COST CENTER Clinic@Salaries@A000000_06000_00200_N
                     _         __ _ _          
     _ __ ___   __ _| | _____ / _(_) | ___     
    | '_ ` _ \ / _` | |/ / _ \ |_| | |/ _ \    
    | | | | | | (_| |   <  __/  _| | |  __/    
    |_| |_| |_|\__,_|_|\_\___|_| |_|_|\___|    
                                               
                                                                                                                               
      Module cst_000makefile.sas is the SAS makefile                                                                                          
      It 'compiles' all the modules needed to run the driver program.                                                                
      Users need to run this first and then they can run a short list                                                                
      of modules using the 'module' driver.                                                                                          
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
                     Fianlly do a global collapse cell widths to optimum widths                                                      
                                                                                                                                     
    *          _                        _                                                                                            
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
                                                                                                                                     
         a. ./cst/oto/cat_010.sas  (package of utility macros                                                                        
                                                                                                                                     
         b. all post 2010 cost report (currently 2011-2019)                                                                          
            https://downloads.cms.gov/files/hcris/snf19fy2011-(curret year-1).zip (currently 9 years)                                
                                                                                                                                     
         c. .\cst\cst_025snfdescribe.sas7bdat  * descriptions for every cell in every worksheet below doe SNF                        
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
                                                                                                                                     
    *_                                                                                                                               
    (_)___ ___ _   _  ___  ___                                                                                                       
    | / __/ __| | | |/ _ \/ __|                                                                                                      
    | \__ \__ \ |_| |  __/\__ \                                                                                                      
    |_|___/___/\__,_|\___||___/                                                                                                      
    ;                                                                                                                                
                                                                                                                                     
      1. If a cell has not been poulated in the cost reports you select then                                                          
         it will not appear in the output excel puf. If you run all cost reports(currently 2011-2019), 
         the excel file will contain all cells that had at least one occurance.
         You may want to run all years, that way if a cell was not populated in a 
         in a given year it will appear as missing.
         This can be fixed because the                                                           
         col_describe table has the meta data on the missing cell.                                                                 
                                                                                                                                     
      2. Requires R (may chage this if I can get sas url engine to work,                                                             
                                                                                                                                     
      3. May require 1980s classic SAS. Will not run in EG?                                                                          
                                                                                                                                     
      4. I strongly suggest you put this string on a function key                                                                    
         ;;;;/*'*/ *);*};*];*/;/*"*/;%mend;run;quit;%end;end;run;endcomp;%utlfix;                                                    
         and highlight and run anytime SAS gets stuck (I have submit on left mouse button)  
         
      5. Code will not work with pre 2011 cost report. The cost report forms are different pre 2011.
     _           _ _     _                   _           _                                                                           
    | |__  _   _(_) | __| |  _ __  _ __ ___ (_) ___  ___| |_                                                                         
    | '_ \| | | | | |/ _` | | '_ \| '__/ _ \| |/ _ \/ __| __|                                                                        
    | |_) | |_| | | | (_| | | |_) | | | (_) | |  __/ (__| |_                                                                         
    |_.__/ \__,_|_|_|\__,_| | .__/|_|  \___// |\___|\___|\__|                                                                        
                            |_|           |__/                                                                                       
                      __ _                                                                                                           
      ___ ___  _ __  / _(_) __ _                                                                                                     
     / __/ _ \| '_ \| |_| |/ _` |                                                                                                    
    | (_| (_) | | | |  _| | (_| |                                                                                                    
     \___\___/|_| |_|_| |_|\__, |                                                                                                    
                           |___/                                                                                                     
    */                                                                                                                               
                                                                                                                                     
                                                                                                                                     
    %let gbl_tok   =  cst                         ;                                                                                  
    %let gbl_typ   =  snf                         ;   * skilled nursing facilities;                                                  
    %let gbl_dir   =  1                           ;   * if 1 then build directory structure;                                         
    %let gbl_yrs   =  2011-2019                   ;   * years to process;                                                            
    %let gbl_root  =  d                           ;   * where things are;                                                            
    %let gbl_oto   =  &gbl_root.:/cst/oto         ;   * autocall library;                                                            
    %let gll_sd1   =  &gbl_root.:/cst             ;   * schema for cost report tables;                                               
                                                                                                                                     
    * gbl_exe is used with systask fro parallel processing may be needed for slower laptops not need with my system;                 
    %let gbl_exe   =  %sysfunc(compbl(&_r\PROGRA~1\SASHome\SASFoundation\9.4\sas.exe -sysin nul -log nul -work &_r\wrk               
                      -rsasuser -autoexec &_r\oto\tut_Oto.sas -nosplash -sasautos &_r\oto -RLANG -config &_r\cfg\sasv9.cfg));        
                                                                                                                                     
    *_       _ _                                                                                                                     
    (_)_ __ (_) |_                                                                                                                   
    | | '_ \| | __|                                                                                                                  
    | | | | | | |_                                                                                                                   
    |_|_| |_|_|\__|                                                                                                                  
                                                                                                                                     
      1. create autocall folder                                                                                                      
      2. create location for snowflake schema                                                                                        
      3. assign sasautos                                                                                                             
    ;                                                                                                                                
                                                                                                                                     
                                                                                                                                     
    * create create autocall folder in .cst/oto;                                                                                     
                                                                                                                                     
    %if &gbl_dir %then %do;                                                                                                          
                                                                                                                                     
      data _null_;                                                                                                                   
                                                                                                                                     
          newdir=dcreate('cst',"&gbl_root:/");                                                                                       
          newdir=dcreate('oto',"&gbl_root:/cst");   * autocall folder;                                                               
                                                                                                                                     
      run;quit;                                                                                                                      
                                                                                                                                     
    %end /* create dir */;                                                                                                           
                                                                                                                                     
    %inc "d:/cst/oto/cst_010.sas";  /* utilities */                                                                                  
                                                                                                                                     
    libname cst "&gbl_root:/cst";             * location of snowflake schema;                                                        
    options sasautos=(sasautos,"&gbl_oto");   * autocall library;                                                                    
                                                                                                                                     
    * status switches these switches becore '1' if the corresponding module executed without error;                                  
    * I choose to leave of '%if &cst_050=1 %then execute module cst_100 fornow'                                                      
    %let cst_050   =0;                                                                                                               
    %let cst_100   =0;                                                                                                               
    %let cst_150   =0;                                                                                                               
    %let cst_150_1 =0;                                                                                                               
    %let cst_150_2 =0;                                                                                                               
    %let cst_150_3 =0;                                                                                                               
    %let cst_150_3 =0;                                                                                                               
    %let cst_150_4 =0;                                                                                                               
    %let cst_250   =0;                                                                                                               
    %let cst_300   =0;                                                                                                               
    %let cst_350   =0;                                                                                                               
                                                                                                                                     
    *         _       ___  ____   ___                                                                                                
      ___ ___| |_    / _ \| ___| / _ \                                                                                               
     / __/ __| __|  | | | |___ \| | | |                                                                                              
    | (__\__ \ |_   | |_| |___) | |_| |                                                                                              
     \___|___/\__|___\___/|____/ \___/                                                                                               
                |_____|                                                                                                              
                                                                                                                                     
    This copies the macro below to your autocall library.                                                                            
    Create directory structure for costreports                                                                                       
    ;                                                                                                                                
                                                                                                                                     
    * you need to do this if you want to make changes after compilingthe  macro                                                      
      and making change after the cards statement;                                                                                   
                                                                                                                                     
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
                                                                                                                                     
    * test;                                                                                                                          
                                                                                                                                     
    /*                                                                                                                               
    %cst_050(root=&gbl_root);                                                                                                        
    %put &=cst_050;                                                                                                                  
    */                                                                                                                               
                                                                                                                                     
    *         _       _  ___   ___                                                                                                   
      ___ ___| |_    / |/ _ \ / _ \                                                                                                  
     / __/ __| __|   | | | | | | | |                                                                                                 
    | (__\__ \ |_    | | |_| | |_| |                                                                                                 
     \___|___/\__|___|_|\___/ \___/                                                                                                  
                |_____|                                                                                                              
    ;                                                                                                                                
                                                                                                                                     
    .....                                                                                                                            
    .....                                                                                                                            
    .....                                                                                                                            
                                                                                                                                     
