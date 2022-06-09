run
 {
 delete noprompt expired archivelog all;
 delete noprompt expired backup;
 backup incremental level 0 database;
 backup current controlfile;
 }
