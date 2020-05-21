# CostReports
Builds a Cost Report Table Schema that for Detailed Analysis
    Meta data driven conditional modular processing                                                                          
                                                                                                                             
    Untested code. Every thing is under development;                                                                         
                                                                                                                             
    This driver code is aided by the open code                                                                               
                                                                                                                             
    This repo is under deveopment. Non of the code has been run (in its present form+                                        
                                                                                                                             
    *                 __ _                                                                                                   
      ___ ___  _ __  / _(_) __ _                                                                                             
     / __/ _ \| '_ \| |_| |/ _` |                                                                                            
    | (_| (_) | | | |  _| | (_| |                                                                                            
     \___\___/|_| |_|_| |_|\__, |                                                                                            
                           |___/                                                                                             
    ;                                                                                                                        
                                                                                                                             
    %let gbl_tok   =  cst       ;                                                                                            
    %let gbl_typ   =  snf       ;   * skilled nursing facilities                                                             
    %let gbl_yrs   =  2011-2019 ;   * years to process;                                                                      
    %let gbl_root  =  /home/cst ;   * where things are;                                                                      
    %let gbl_oto   =  &gbl/oto  ;   * autocall library;                                                                      
    %let gll_sd1   =  &gbl/&tok ;   * schema for cost report tables;                                                         
                                                                                                                             
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
                                                                                                                             
    %mend cst_100(&gbl_tok,                                                                                                  
                                                                                                                             
                                                                                                                             
