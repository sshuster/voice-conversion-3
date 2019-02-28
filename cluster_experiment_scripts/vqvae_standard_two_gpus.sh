#!/bin/sh
#SBATCH -N 1	  # nodes requested
#SBATCH -n 1	  # tasks requested
#SBATCH --partition=Standard
#SBATCH --gres=gpu:2
#SBATCH --mem=12000  # memory in Mb
#SBATCH --time=0-08:00:00

export CUDA_HOME=/opt/cuda-9.0.176.1/

export CUDNN_HOME=/opt/cuDNN-7.0/

export STUDENT_ID=$(whoami)

export TEAM_ID=g086

export LD_LIBRARY_PATH=${CUDNN_HOME}/lib64:${CUDA_HOME}/lib64:$LD_LIBRARY_PATH

export LIBRARY_PATH=${CUDNN_HOME}/lib64:$LIBRARY_PATH

export CPATH=${CUDNN_HOME}/include:$CPATH

export PATH=${CUDA_HOME}/bin:${PATH}

export PYTHON_PATH=$PATH

mkdir -p /disk/scratch/${TEAM_ID}
export TMPDIR=/disk/scratch/${TEAM_ID}/
export TMP=/disk/scratch/${TEAM_ID}

mkdir -p ${TMP}/data/

rsync -ua --progress /home/${STUDENT_ID}/data/ ${TMP}/data/
unzip -u ${TMP}/data/processed_data.zip -d ${TMP}/data

export DATASET_DIR=${TMP}/data/processed_data/

# Activate the relevant virtual environment:
source /home/${STUDENT_ID}/miniconda3/bin/activate mlp
cd ..
echo "Starting train_evaluate_vqvae.py"
python train_evaluate_vqvae.py \
                --use_gpu=True \
                --gpu_id='0,1' \
                --experiment_name='vqvae_init_exp' \
                --filepath_to_arguments_json_file='experiment_configs/vqvae_architecture.json' \
                --dataset_root_path=${DATASET_DIR} 