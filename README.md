# FastQC
This repo is configured as a [Dockstore](https://dockstore.org/) workflow.

Click [here](https://dockstore.org/workflows/github.com/f73chen/fastqc/FastQC:master?tab=info) for its info page.

### To Run:
Make a runtime JSON template and fill in desired inputs, outputs, and other parameters
    
    dockstore workflow convert entry2json --entry github.com/f73chen/fastqc/FastQC:master > Dockstore.json
    
    vim Dockstore.json
    
Run locally with the Dockstore CLI
    
    dockstore workflow launch --entry github.com/f73chen/fastqc/FastQC:master --json Dockstore.json
