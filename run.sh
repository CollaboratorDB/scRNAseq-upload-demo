#!/usr/bin/bash
#SBATCH --mem=50000
#SBATCH -c 1
#SBATCH -o log.out
#SBATCH -e log.err

ml R/dev
R -f stage.R
