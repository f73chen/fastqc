version 1.0

# ======================================================
# Workflow accepts two fastq files, with R1 and R2 reads
# ======================================================
workflow fastQC {
input {
        File fastqR1 
        File? fastqR2
        String outputFileNamePrefix = ""
        String r1Suffix = "_R1"
        String r2Suffix = "_R2"
		String docker = "quay.io/biocontainers/fastqc:0.11.9--0"
}
Array[File] inputFastqs = select_all([fastqR1,fastqR2])
String outputPrefixOne = if outputFileNamePrefix == "" then basename(inputFastqs[0], '.fastq.gz') + "_fastqc"
                                                       else outputFileNamePrefix + r1Suffix

call runFastQC as firstMateFastQC { input: inputFastq = inputFastqs[0], docker = docker }
call renameOutput as firstMateHtml { input: inputFile = firstMateFastQC.html_report_file, extension = "html", customPrefix = outputPrefixOne, docker = docker }
call renameOutput as firstMateZip { input: inputFile = firstMateFastQC.zip_bundle_file, extension = "zip", customPrefix = outputPrefixOne, docker = docker }

if (length(inputFastqs) > 1) {
 String outputPrefixTwo = if outputFileNamePrefix=="" then basename(inputFastqs[1], '.fastq.gz') + "_fastqc"
                                                      else outputFileNamePrefix + r2Suffix
 call runFastQC as secondMateFastQC { input: inputFastq = inputFastqs[1], docker = docker }
 call renameOutput as secondMateHtml { input: inputFile = secondMateFastQC.html_report_file, extension = "html", customPrefix = outputPrefixTwo, docker = docker }
 call renameOutput as secondMateZip { input: inputFile = secondMateFastQC.zip_bundle_file, extension = "zip", customPrefix = outputPrefixTwo, docker = docker }
}

parameter_meta {
  fastqR1: "Input file with the first mate reads."
  fastqR2: " Input file with the second mate reads (if not set the experiments will be regarded as single-end)."
  outputFileNamePrefix: "Output prefix, customizable. Default is the first file's basename."
  r1Suffix: "Suffix for R1 file."
  r2Suffix: "Suffix for R2 file."
}

meta {
    author: "Peter Ruzanov"
    email: "peter.ruzanov@oicr.on.ca"
    description: "Niassa-wrapped Cromwell (widdle) workflow for running FastQC tools on paired or unpaired reads."
    dependencies: [
      {
        name: "fastqc/0.11.8",
        url: "https://www.bioinformatics.babraham.ac.uk/projects/fastqc/"
      }
    ]
    output_meta: {
      html_report_R1: "HTML report for the first mate fastq file.",
      zip_bundle_R1: "zipped report from FastQC for the first mate reads.",
      html_report_R2: "HTML report for read second mate fastq file.",
      zip_bundle_R2: "zipped report from FastQC for the second mate reads."
    }
}

output {
 File? html_report_R1  = firstMateHtml.renamedOutput
 File? zip_bundle_R1   = firstMateZip.renamedOutput
 File? html_report_R2 = secondMateHtml.renamedOutput
 File? zip_bundle_R2  = secondMateZip.renamedOutput
}

}

# ===================================
#            MAIN STEP
# ===================================
task runFastQC {
input {
        Int    jobMemory = 6
        Int    timeout   = 20
        File   inputFastq
        String modules = "perl/5.28 java/8 fastqc/0.11.8"
		String docker
}

command <<<
 set -euo pipefail
 FASTQC=$(which fastqc)
 JAVA=$(which java)
 perl $FASTQC ~{inputFastq} --java=$JAVA --noextract --outdir "."
>>>

parameter_meta {
 docker: "Docker container to run the workflow in"
 jobMemory: "Memory allocated to fastqc."
 inputFastq: "Input fastq file, gzipped."
 modules: "Names and versions of required modules."
 timeout: "Timeout in hours, needed to override imposed limits."
}

runtime {
  docker:  "~{docker}"
  memory:  "~{jobMemory} GB"
  modules: "~{modules}"
  timeout: "~{timeout}"
}

output {
  File html_report_file = "~{basename(inputFastq, '.fastq.gz')}_fastqc.html"
  File zip_bundle_file  = "~{basename(inputFastq, '.fastq.gz')}_fastqc.zip"
}
}

# =================================================
#      RENAMING STEP - IF WE HAVE CUSTOM PREFIX
# =================================================
task renameOutput {
input {
  Int  jobMemory = 2
  File inputFile
  String extension
  String customPrefix
  Int timeout    = 1
  String docker
}

parameter_meta {
 docker: "Docker container to run the workflow in"
 inputFile: "Input file, html or zip."
 extension: "Extension for a file (without leading dot)."
 customPrefix: "Prefix for making a file."
 jobMemory: "Memory allocated to this task."
 timeout: "Timeout, in hours, needed to override imposed limits."
}

command <<<
 set -euo pipefail
 if [[ ~{basename(inputFile)} != "~{customPrefix}.~{extension}" ]];then 
   ln -s ~{inputFile} "~{customPrefix}.~{extension}"
 else
   ln -s ~{inputFile}
 fi
>>>

runtime {
  docker:  "~{docker}"
  memory:  "~{jobMemory} GB"
  timeout: "~{timeout}"
}


output {
  File? renamedOutput = "~{customPrefix}.~{extension}"
}
}
