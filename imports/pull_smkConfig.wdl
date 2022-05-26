version 1.0
workflow smkConfig {
    input {
        Int generateConfig_timeout = 24
        Int generateConfig_jobMemory = 8
        String sample
        String normal
        String tumor
        File samplefile
    }
    parameter_meta {
        generateConfig_timeout: "Timeout in hours, needed to override imposed limits"
        generateConfig_jobMemory: "memory allocated for Job"
        sample: "name of all sample"
        normal: "name of the normal sample"
        tumor: "name of the tumor sample"
        samplefile: "sample file path"
    }

    call generateConfig{
        input:
        timeout = generateConfig_timeout,
        jobMemory = generateConfig_jobMemory,
        sample = sample,
        normal = normal,
        tumor = tumor,
        samplefile = samplefile 
    }

    output {
        File config  = generateConfig.config
        }

    meta {
     author: "Gavin Peng"
     email: "gpeng@oicr.on.ca"
     description: "smkConfig, workflow that generates config.yaml file for snakemake to run"
     dependencies: 
      {
        name: "nanopore_sv_analysis/20220505",
        url: "https://gitlab.oicr.on.ca/ResearchIT/modulator/-/blob/master/code/gsi/70_nanopore_sv_analysis.yaml"
      }

     output_meta: {
       config : "config.yaml file for snakemake to run"
     }
    }
}
    # ==========================================================
    #  generate the config.yaml file needed for running snakemake
    # ==========================================================
    task generateConfig {
        input {
        String sample
        String normal
        String tumor
        File samplefile      
        Int jobMemory = 8
        Int timeout = 24 
   }

        parameter_meta {
        sample: "name of all sample"
        normal: "name of the normal sample"
        tumor: "name of the tumor sample"
        samplefile: "sample file path"
        jobMemory: "memory allocated for Job"
        timeout: "Timeout in hours, needed to override imposed limits"
        }
 
        command <<<
        set -euo pipefail
        cat <<EOT >> config.yaml
        workflow_dir: "/.mounts/labs/gsi/modulator/sw/Ubuntu18.04/nanopore-sv-analysis-20220505"
        conda_dir: "/.mounts/labs/gsi/modulator/sw/Ubuntu18.04/nanopore-sv-analysis-20220505/bin"
        samples: [~{sample}]
        normals: [~{normal}]
        tumors: [~{tumor}]
        ~{sample}: ~{samplefile}
        EOT
        >>>  
    runtime {
    memory:  "~{jobMemory} GB"
    timeout: "~{timeout}"
    }
    output {
    File config = "config.yaml"
    }

}
