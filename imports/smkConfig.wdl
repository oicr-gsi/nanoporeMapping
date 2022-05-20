version 1.0
workflow smkConfig {
    input {
        String sample
        String normal
        String tumor
        String samplefile
        String generateConfig_modules
    }
    parameter_meta {
        sample: "name of all sample"
        normal: "name of the normal sample"
        tumor: "name of the tumor sample"
        samplefile: "sample file"
        generateConfig_modules: "modules needed to run generateConfig"
    }

    call generateConfig{
        input:
        sample = sample,
        normal = normal,
        tumor = tumor,
        samplefile = samplefile,
        modules = generateConfig_modules
           
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
        String samplefile      
        String modules
        Int jobMemory = 8
        Int timeout = 24     
   }

        parameter_meta {
        sample: "name of all sample"
        normal: "name of the normal sample"
        tumor: "name of the tumor sample"
        samplefile: "sample file"
        jobMemory: "memory allocated for Job"
        modules: "Names and versions of modules"
        timeout: "Timeout in hours, needed to override imposed limits"
        }
 
        command <<<
        set -euo pipefail
        cat <<EOT >> config.yaml
        workflow_dir: "$NANOPORE_SV_ANALYSIS_ROOT"
        conda_dir: "$NANOPORE_SV_ANALYSIS_ROOT/bin"
        samples: [~{sample}]
        normals: [~{normal}]
        tumors: [~{tumor}]
        ~{sample}: ~{samplefile}
        EOT
        >>>  
    runtime {
    memory:  "~{jobMemory} GB"
    modules: "~{modules}"
    timeout: "~{timeout}"
    }
    output {
    File config = "config.yaml"
    }

}
