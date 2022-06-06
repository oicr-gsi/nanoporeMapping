version 1.0
import "imports/pull_smkConfig.wdl" as smkConfig

workflow nanoporeMapping {
    input {
        String sample
        String normal
        String tumor
        File samplefile  
    }
    parameter_meta {
        sample: "name of sample"
        normal: "name of the normal sample"
        tumor: "name of the tumor sample"
        samplefile: "sample file"
    }

    call smkConfig.smkConfig{
        input:
        sample=sample,
        normal = normal,
        tumor = tumor,
        samplefile = samplefile    
    }

    call mapping {
        input:
        config = smkConfig.config,
        sample = sample
    }

    output {
        File bAlleleFrequency = mapping.bAlleleFrequency 
        }

    meta {
     author: "Gavin Peng"
     email: "gpeng@oicr.on.ca"
     description: "nanoporMapping, workflow that generates b_allele_frequency.bed file from input of nanopore fastq files, a wrapper of the workflow https://github.com/mike-molnar/nanopore-SV-analysis"
     dependencies: [
      {
        name: "nanopore_sv_analysis/20220505",
        url: "https://gitlab.oicr.on.ca/ResearchIT/modulator/-/blob/master/code/gsi/70_nanopore_sv_analysis.yaml"
      }
     ]
     output_meta: {
       bAlleleFrequency: "output from rule mapping of the original workflow"
     }
    }
}

    # =======================================
    # run the nanopore workflow for mapping
    # =======================================
    task mapping {
        input {
        String sample
        File config  
        String modules
        Int jobMemory = 8
        Int timeout = 24
        }

        parameter_meta {
        jobMemory: "memory allocated for Job"
        modules: "Names and versions of modules"
        timeout: "Timeout in hours, needed to override imposed limits"
        }

        command <<<
        set -euo pipefail
        module load nanopore-sv-analysis
        unset LD_LIBRARY_PATH
        cp $NANOPORE_SV_ANALYSIS_ROOT/Snakefile .
        cp ~{config} .
        $NANOPORE_SV_ANALYSIS_ROOT/bin/snakemake --jobs 8 --rerun-incomplete --keep-going --latency-wait 60 --cluster "qsub -cwd -V -o snakemake.output.log -e snakemake.error.log  -P gsi -pe smp {threads} -l h_vmem={params.memory_per_thread} -l h_rt={params.run_time} -b y "  mapping

        >>> 

    runtime {
    memory:  "~{jobMemory} GB"
    modules: "~{modules}"
    timeout: "~{timeout}"
    }

    output {
    File bAlleleFrequency = "~{sample}/mapped/~{sample}.b_allele_frequency.bed"
    }
    }
