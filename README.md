# gpu-smoke-nf

Minimal Nextflow pipeline that verifies an AWS GPU instance can run CUDA
containers through Nextflow. Used as the end-to-end test for the Seqera
GPU-enabled AMI built by [seqeralabs/optimised-vm](https://github.com/seqeralabs/optimised-vm)
(ticket COMP-1906).

## What it does

A single `GPU_CHECK` process pulls `nvidia/cuda:12.4.1-base-ubuntu22.04` and
captures `nvidia-smi` output to `gpu-report.txt`. A green run with a real
GPU listed (e.g. `Tesla T4`, `A10G`, `L4`) proves Nextflow tasks see the
GPU through Docker's `nvidia` runtime.

## Run via Seqera Platform (AWS Batch Forge)

1. Create a Batch Forge compute environment in `eu-west-2` (or `eu-west-1` /
   `us-east-1`) pointing at the Seqera GPU AMI under **Advanced options →
   AMI Id**, with `g4dn.xlarge` (or g5/g6/p4/p5) in **Compute instance types**.
2. Launch this pipeline against that compute environment.
3. Inspect `gpu-report.txt` in the task's output.

## Run locally on a GPU EC2 instance

On a `g4dn.xlarge` launched from the Seqera GPU AMI:

```bash
nextflow run https://github.com/munishchouhan/gpu-smoke-nf -with-docker
```

Expected output includes the `nvidia-smi` table, a CSV summary, and
`GPU devices visible`.
