nextflow.enable.dsl=2

/*
 * GPU smoke-test pipeline for the Seqera GPU-enabled AMI
 * (built by https://github.com/seqeralabs/optimised-vm, COMP-1906 / COMP-880).
 *
 * Launches a CUDA base container inside the AMI's nvidia-runtime Docker and
 * captures nvidia-smi output. A green run with `Tesla T4` (or equivalent)
 * in gpu-report.txt proves Nextflow tasks see the GPU end-to-end.
 *
 * The AMI's Docker `default-runtime` is `nvidia`, so containers see the GPU
 * without an explicit `--gpus all` flag from the launcher.
 */

process GPU_CHECK {
    tag "gpu-smoke"
    container 'nvidia/cuda:12.4.1-base-ubuntu22.04'
    cpus 1
    memory '2.GB'
    accelerator 1

    output:
    path 'gpu-report.txt'

    script:
    """
    {
      echo '=== nvidia-smi ==='
      nvidia-smi
      echo
      echo '=== driver/device summary ==='
      nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv
      echo
      echo '=== devices visible ==='
      ls /dev/nvidia* 2>/dev/null && echo 'GPU devices visible' || echo 'NO GPU devices'
    } | tee gpu-report.txt
    """
}

workflow {
    GPU_CHECK()
}
