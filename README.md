# nanoporeMapping

nanoporMapping, workflow that generates b_allele_frequency.bed file from input of nanopore fastq files, a wrapper of the workflow https://github.com/mike-molnar/nanopore-SV-analysis

## Overview

## Dependencies

* [nanopore_sv_analysis 20220505](https://gitlab.oicr.on.ca/ResearchIT/modulator/-/blob/master/code/gsi/70_nanopore_sv_analysis.yaml)
* [hg38-nanopore-sv-reference](https://gitlab.oicr.on.ca/ResearchIT/modulator/-/blob/master/data/gsi/50_hg38_nanopore_sv_reference.yaml)


## Usage

### Cromwell
```
java -jar cromwell.jar run nanoporeMapping.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`sample`|String|name of sample
`normal`|String|name of the normal sample
`tumor`|String|name of the tumor sample
`samplefile`|String|sample file
`mapping.modules`|String|Names and versions of modules


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`generateConfig.jobMemory`|Int|8|memory allocated for Job
`generateConfig.timeout`|Int|24|Timeout in hours, needed to override imposed limits
`mapping.jobMemory`|Int|8|memory allocated for Job
`mapping.timeout`|Int|24|Timeout in hours, needed to override imposed limits


### Outputs

Output | Type | Description
---|---|---
`bAlleleFrequency`|File|output from rule mapping of the original workflow


## Commands
 This section lists command(s) run by WORKFLOW workflow
 
 * Running WORKFLOW
 
 === Description here ===.
 
 <<<
         set -euo pipefail
         cat <<EOT >> config.yaml
         workflow_dir: "/.mounts/labs/gsi/modulator/sw/Ubuntu18.04/nanopore-sv-analysis-20220505"
         conda_dir: "/.mounts/labs/gsi/modulator/sw/Ubuntu18.04/nanopore-sv-analysis-20220505/bin"
         reference_dir: "/.mounts/labs/gsi/modulator/sw/data/hg38-nanopore-sv-reference-20220505"
         samples: [~{sample}]
         normals: [~{normal}]
         tumors: [~{tumor}]
         ~{sample}: ~{samplefile}
         EOT
         >>>
 <<<
         module load nanopore-sv-analysis
         unset LD_LIBRARY_PATH
         set -euo pipefail
         cp $NANOPORE_SV_ANALYSIS_ROOT/Snakefile .
         cp ~{config} .
         $NANOPORE_SV_ANALYSIS_ROOT/bin/snakemake --jobs 8 --rerun-incomplete --keep-going --latency-wait 60 --cluster "qsub -cwd -V -o snakemake.output.log -e snakemake.error.log  -P gsi -pe smp {threads} -l h_vmem={params.memory_per_thread} -l h_rt={params.run_time} -b y "  mapping
 
         >>>
 ## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
