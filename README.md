# FastQC
This repo is configured as a [Dockstore](https://dockstore.org/) workflow.

Click [here](https://dockstore.org/workflows/github.com/g3chen/fastqc/fastqc_imported:master?tab=info) for its info page.

### To Run:
Make a runtime JSON template and fill in desired inputs, outputs, and other parameters
    
    dockstore workflow convert entry2json --entry github.com/g3chen/fastqc/fastqc_imported:master > Dockstore.json
    
    vim Dockstore.json
    
Run locally with the Dockstore CLI, with working directory in this repo
    
    dockstore workflow launch --entry github.com/g3chen/fastqc/fastqc_imported:master --json Dockstore.json
