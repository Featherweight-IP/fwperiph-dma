#!/bin/bash

script_dir=$(dirname $(realpath $0))
verif_dir=$(dirname $script_dir)

echo "verif_dir: $verif_dir"

${UVMF_HOME}/scripts/yaml2uvmf.py \
	-m ${verif_dir}/env \
	${verif_dir}/yaml/*.uvmf

