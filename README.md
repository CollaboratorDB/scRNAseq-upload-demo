# scRNAseq to CollaboratorDB

This repository contains a little script to stage and upload all datasets in the **scRNAseq** package to the **CollaboratorDB** instance.
For simplicity, we'll just consider the default state of each dataset, without the extra stuff like Ensembl and multi-part components.

The [`stage.R`](stage.R) script does most of the work with respect to loading **scRNAseq** objects and preparing them for upload.
This is facilitated by [`run.sh`](run.sh) to execute the staging inside a Slurm job.
The [`upload.R`](upload.R) script then uploads it to **CollaboratorDB** (assuming appropriate permissions are given).

