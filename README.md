# CostReports
Builds a Cost Report Table Schema that for Detailed Analysis
    Untested code. Every thing is under development;                                                                                    
                                                                                                                                        
    This driver code is aided by the open code                                                                                          
                                                                                                                                        
    This code supoorts self locating files and self sourced files                                                                       
                                                                                                                                        
    Output object                                                                                                                       
                                                                                                                                        
      cst_025snfrug.xlsx                                                                                                                
                                                                                                                                        
      Is located at           ./cst/xls/cst_025snfrug.xlsx                                                                              
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
                                                                                                                                        
    O01       ANALYSIS OF HOSPITAL-BASED HOSPICE COSTS                                                                                  
                                                                                                                                        
    S7        PROSPECTIVE PAYMENT FOR SNF STATISTICAL DATA                                                                              
    A0        RECLASSIFICATION AND ADJUSTMENT OF TRIAL BALANCE OF EXPENSES                                                              
                                                                                                                                        
    A7        RECONCILIATION OF CAPITAL COSTS CENTERS                                                                                   
                                                                                                                                        
    C0        COMPUTATION OF RATIO OF COSTS TO CHARGES                                                                                  
                                                                                                                                        
    E00A181   CALCULATION OF REIMBURSEMENT SETTLEMENT TITLE XVIII                                                                       
    E00A192   ANALYSIS OF PAYMENTS TO PROVIDERS FOR SERVICES RENDERED                                                                   
                                                                                                                                        
    G0        BALANCE SHEET                                                                                                             
    G2        STATEMENT OF PATIENT REVENUES AND OPERATING EXPENSES                                                                      
    G3        STATEMENT OF REVENUES AND EXPENSES                                                                                        
                                                                                                                                        
    *          _                        _    _                   _                                                                      
      _____  _| |_ ___ _ __ _ __   __ _| |  (_)_ __  _ __  _   _| |_ ___                                                                
     / _ \ \/ / __/ _ \ '__| '_ \ / _` | |  | | '_ \| '_ \| | | | __/ __|                                                               
    |  __/>  <| ||  __/ |  | | | | (_| | |  | | | | | |_) | |_| | |_\__ \                                                               
     \___/_/\_\\__\___|_|  |_| |_|\__,_|_|  |_|_| |_| .__/ \__,_|\__|___/                                                               
                                                    |_|                                                                                 
    ;                                                                                                                                   
                                                                                                                                        
    You need to have these files before running the project                                                                             
                                                                                                                                        
    Web zip files for automatic download (programatic download and unzip)                                                               
                                                                                                                                        
    https://downloads.cms.gov/files/hcris/snf11fy2011.zip                                                                               
    https://downloads.cms.gov/files/hcris/snf12fy2012.zip                                                                               
    https://downloads.cms.gov/files/hcris/snf13fy2013.zip                                                                               
    https://downloads.cms.gov/files/hcris/snf14fy2014.zip                                                                               
    https://downloads.cms.gov/files/hcris/snf15fy2015.zip                                                                               
    https://downloads.cms.gov/files/hcris/snf16fy2016.zip                                                                               
    https://downloads.cms.gov/files/hcris/snf17fy2017.zip                                                                               
    https://downloads.cms.gov/files/hcris/snf18fy2018.zip                                                                               
    https://downloads.cms.gov/files/hcris/snf19fy2019.zip                                                                               
                                                                                                                                        
    &_r:\cst\cst_025snfdescribe.sas7bdat  * descriptions for every cell in every worksheet above                                        
                                                                                                                                        
    &_r:\cst\cst_0025snfrug.xls            * list of snf rug codes and description;                                                     
                                                                                                                                        
    *          _                        _                _               _                                                              
      _____  _| |_ ___ _ __ _ __   __ _| |    ___  _   _| |_ _ __  _   _| |_ ___                                                        
     / _ \ \/ / __/ _ \ '__| '_ \ / _` | |   / _ \| | | | __| '_ \| | | | __/ __|                                                       
    |  __/>  <| ||  __/ |  | | | | (_| | |  | (_) | |_| | |_| |_) | |_| | |_\__ \                                                       
     \___/_/\_\\__\___|_|  |_| |_|\__,_|_|   \___/ \__,_|\__| .__/ \__,_|\__|___/                                                       
                                                            |_|                                                                         
    ;                                                                                                                                   
                                                                                                                                        
    TBD                                                                                                                                 
                                                                                                                                        
    simple snowflake schema                                                                                                             
    analytic tables                                                                                                                     
    analytic excel workbooks (simple pivot and report(report uses detail description in label)                                          
                                                                                                                                        
                                                                                                                                        
    *                 __ _                                                                                                              
      ___ ___  _ __  / _(_) __ _                                                                                                        
     / __/ _ \| '_ \| |_| |/ _` |                                                                                                       
    | (_| (_) | | | |  _| | (_| |                                                                                                       
     \___\___/|_| |_|_| |_|\__, |                                                                                                       
                           |___/                                                                                                        
    ;                                                                                                                                   
                                                                                                                                        
    %let gbl_tok   =  cst            ;                                                                                                  
    %let gbl_typ   =  snf            ;   * skilled nursing facilities                                                                   
    %let gbl_yrs   =  2011-2019      ;   * years to process;                                                                            
    %let gbl_root  =  /home/cst      ;   * where things are;                                                                            
    %let gbl_oto   =  &gbl_root/oto  ;   * autocall library;                                                                            
    %let gll_sd1   =  &gbl_root/&tok ;   * schema for cost report tables;                                                               
    %let gbl_exe   =  %sysfunc(compbl(&_r\PROGRA~1\SASHome\SASFoundation\9.4\sas.exe -sysin nul -log nul -work &_r\wrk                  
                      -rsasuser -autoexec &_r\oto\tut_Oto.sas -nosplash -sasautos &_r\oto -RLANG -config &_r\cfg\sasv9.cfg));           
                                                                                                                                        
    * gbl_exe is used with systask fro parallel processing;                                                                             
                                                                                                                                        
    options sasautos="&gbl_root./oto";                                                                                                  
    libname &tok "&gbl_root/&tok";                                                                                                      
                                                                                                                                        
    *    _      _                                                                                                                       
      __| |_ __(_)_   _____ _ __                                                                                                        
     / _` | '__| \ \ / / _ \ '__|                                                                                                       
    | (_| | |  | |\ V /  __/ |                                                                                                          
     \__,_|_|  |_| \_/ \___|_|                                                                                                          
                                                                                                                                        
    ;                                                                                                                                   
                                                                                                                                        
    %cst_100(root=&gbl_root); /* create directory structure for project */                                                              
                              /* if run without error the sas table &tok..cst_100.sas7bdat will exist */                                
                                                                                                                                        
    %if %sysfunc(mexist(&tok..cst_100)) %then %do;                                                                                      
                                                                                                                                        
        * report csv;                                                                                                                   
        %cst_150_1(                                                                                                                     
            cst=&gbl_typ                                                                                                                
           ,yrs=&gbl_yrs                                                                                                                
           ,out=cst_150_1&cst.rpt&yrs  /* delay util sysmacroname is populated?  - note the referback */                                
           );                                                                                                                           
                                                                                                                                        
        * numbers csvs;                                                                                                                 
        %cst_150_2(                                                                                                                     
            cst=&gbl_typ                                                                                                                
           ,yrs=&gbl_yrs                                                                                                                
           ,out=cst_150_1&cst.num&yrs /* delay util sysmacroname is populated? */                                                       
           );                                                                                                                           
                                                                                                                                        
       * strings csvs;                                                                                                                  
        %cst_150_3(                                                                                                                     
            cst=&gbl_typ                                                                                                                
           ,yrs=&gbl_yrs                                                                                                                
           ,out=cst_150_1&cst.alp&yrs /* delay util sysmacroname is populated? */                                                       
           );                                                                                                                           
                                                                                                                                        
        %cst_150_4(                                                                                                                     
            num   = cst_150_1&cst.rpt&yrs                                                                                               
           ,alpha = cst_150_1&cst.rpt&yrs                                                                                               
           ,rpt   = cst_150_1&cst.rpt&yrs                                                                                               
           ,out   = cst_150_1&cst.numalp&yrs                                                                                            
                 );                                                                                                                     
    %end;                                                                                                                               
    %else %abort return;                                                                                                                
                                                                                                                                        
    %if %sysfunc(mexist(&tok..cst_150_4)) %then %do;                                                                                    
                                                                                                                                        
           ....                                                                                                                         
                                                                                                                                        
    %end;                                                                                                                               
                                                                                                                                        
    *                               _                                                                                                   
      _____  ____ _ _ __ ___  _ __ | | ___   _ __ ___   __ _  ___ _ __ ___                                                              
     / _ \ \/ / _` | '_ ` _ \| '_ \| |/ _ \ | '_ ` _ \ / _` |/ __| '__/ _ \                                                             
    |  __/>  < (_| | | | | | | |_) | |  __/ | | | | | | (_| | (__| | | (_) |                                                            
     \___/_/\_\__,_|_| |_| |_| .__/|_|\___| |_| |_| |_|\__,_|\___|_|  \___/                                                             
                             |_|                                                                                                        
    ;                                                                                                                                   
                                                                                                                                        
    %macro cst_100(root=&gbl_root);                                                                                                     
                                                                                                                                        
      * delete statu dataset;                                                                                                           
      proc datasets lib=&tok nolist;                                                                                                    
         delete &sysmacroname;                                                                                                          
      run;quit;                                                                                                                         
                                                                                                                                        
      data _null_;                                                                                                                      
                                                                                                                                        
        newdir=dcreate('utl',"&root/");                                                                                                 
        newdir=dcreate('ver',"&root/");                                                                                                 
        newdir=dcreate('oto',"&root/");                                                                                                 
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
                                                                                                                                        
      run;quit;                                                                                                                         
                                                                                                                                        
      * if no error create create status dataset;                                                                                       
                                                                                                                                        
      %if &syserr=0 %then %do;                                                                                                          
          data &tot..&sysmacroname;                                                                                                     
          run;quit;                                                                                                                     
      %end;                                                                                                                             
                                                                                                                                        
    %mend cst_100;                                                                                                                      
                                                                                                                                        
                                                                                                                                        
                                                                                                                                        
                                                                                                                                        
                                                                                                                                        
                                                                                                                                        
