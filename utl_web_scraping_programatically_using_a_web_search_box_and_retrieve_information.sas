Web scraping programatically using a web search box and retrieve information

github
https://tinyurl.com/y97nnwd8
https://github.com/rogerjdeangelis/utl_web_scraping_programatically_using_a_web_search_box_and_retrieve_information

WPS/Proc R

The following page, http://www.commonchemistry.org, has a search box.
I would like to see if information is available for the following drugs

       Acamol
       Panadol
       Valadol
       X123456


https://github.com/rogerjdeangelis/utl_web_scraping_programatically_using_a_web_search_box_and_retrieve_information

StackOverflow R
https://tinyurl.com/y9tgtpmh
https://stackoverflow.com/questions/51226255/how-to-send-search-term-and-retrieve-the-information-from-a-website-using-r

SpacedMan profile
https://stackoverflow.com/users/211116/spacedman

for more web scraping
https://tinyurl.com/yd7fyp6g
https://github.com/rogerjdeangelis?utf8=%E2%9C%93&tab=repositories&q=scrape&type=&language=


INPUT
=====

1. Web oage with search box

  http://www.commonchemistry.org
  Page
                                   _                    _     _
                               ___| |__   ___ _ __ ___ (_)___| |_ _ __ _   _
                              / __| '_ \ / _ \ '_ ` _ \| / __| __| '__| | | |
                             | (__| | | |  __/ | | | | | \__ \ |_| |  | |_| |
                              \___|_| |_|\___|_| |_| |_|_|___/\__|_|   \__, |
                                                                       |___/

                           +---------------------------------------------------+
     Enter Chemical Name   |                                                   |
                           +---------------------------------------------------+

2. Table with drubgs you are interested in

    WORK.HAVE total obs=3

        DRUG

       Acamol
       Panadol
       Valadol


3. Information we want to extract

    The node with drug group information before each drug

    <span id="registryNumberLabel">103-90-2</span>

    We want to extract the registry number for these drug classifications


EXAMPLE OUTPUT
==============

 WORK.WANT total obs=4

                           DRUG_
    DRUG      STATUS       GROUP                                     SEARCH

   Panadol    Found       103-90-2    http://www.commonchemistry.org//search.aspx?terms=Panadol&exact=true
   Acamol     Found       103-90-2    http://www.commonchemistry.org//search.aspx?terms=Acamol&exact=true
   Valadol    Found       103-90-2    http://www.commonchemistry.org//search.aspx?terms=Valadol&exact=true
   X123456    NotFound                http://www.commonchemistry.org//search.aspx?terms=X123456&exact=true


PROCESS (WORKING CODE)
======================

   txt <- vector(mode="character", length=nrow(have));
   for ( i in 1:nrow(have) ) {
   h = read_html(as.character(have[i,]));
   txt[i]<-html_text(html_node(h,"#registryNumberLabel"));};


OUTPUT
======

 WORK.WANT total obs=4

                           DRUG_
    DRUG      STATUS       GROUP                                     SEARCH

   Panadol    Found       103-90-2    http://www.commonchemistry.org//search.aspx?terms=Panadol&exact=true
   Acamol     Found       103-90-2    http://www.commonchemistry.org//search.aspx?terms=Acamol&exact=true
   Valadol    Found       103-90-2    http://www.commonchemistry.org//search.aspx?terms=Valadol&exact=true
   X123456    NotFound                http://www.commonchemistry.org//search.aspx?terms=X123456&exact=true

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
  input drug $80.;
  drug=cats('http://www.commonchemistry.org//search.aspx?terms=',drug','&exact=true');
cards4;
Panadol
Acamol
Valadol
X123456
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

 proc datasets lib=work kill;
 run;quit;

 %utl_submit_wps64('
 libname wrk  sas7bdat "%sysfunc(pathname(work))";
 options set=R_HOME "C:/Program Files/R/R-3.3.2";
 proc r;
 submit;
 source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
 library(haven);
 library(rvest);
 have<-read_sas("d:/sd1/have.sas7bdat");
 txt <- vector(mode="character", length=nrow(have));
 for ( i in 1:nrow(have) ) {
 h = read_html(as.character(have[i,]));
 txt[i]<-html_text(html_node(h,"#registryNumberLabel"));};
 endsubmit;
 import r=txt data=wrk.havwps;
 run;quit;
 ');

 data want(rename=txt=Drug_Group);
   retain drug status txt;
   merge sd1.have havwps;
   search=drug;
   drug=scan(drug,2,'&=');
   if missing(txt) then Status="NotFound";
   else Status="Found";
 run;quit;



