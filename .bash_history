ls
cd ~
ls
cd /usr/local/bin/
ls
ls -l
cat calculate.sh 
cat compare.sh 
cd ~
cd ..
exit
which java
which fastqc
cd ~
ls
cd test_
cd test_data/
ls
cd input_data/
ls
cd ..
cd ..
set -euo pipefail                                                                                       FASTQC=$(which fastqc)
 JAVA=$(which java)
set -euo pipefail FASTQC=$(which fastqc) JAVA=$(which java) perl $FASTQC ~/test_data/input_data/adrenal_1.fastq.gz --java=$JAVA --noextract --outdir "."
which environment-modules
sudo apt-get install environment-modules
apt-get install environment-modules
exit
ls
cd ~
ls
which java
which fastqc
cat test.wdl.json 
cat Dockstore.wdl
exit
