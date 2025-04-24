# Pytorch environment makefile
#
# https://swcarpentry.github.io/make-novice/reference.html
# https://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/
# https://www.gnu.org/software/make/manual/make.html
# https://www.gnu.org/software/make/manual/html_node/Special-Targets.html
# https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html

SHELL := /bin/bash
ROOT  := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

NB_HOST         ?= 0.0.0.0
NB_PORT_JUPYTER ?= 18888
NB_PORT_TBOARD  ?= 16006

CONDA_ENV_NAME = finetuningllms

export CUDA_VISIBLE_DEVICES=0

# -----------------------------------------------------------------------------
# notebook
# -----------------------------------------------------------------------------

.DEFAULT_GOAL = notebook

.PHONY: notebook
notebook:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" \
		jupyter notebook \
			--ServerApp.open_browser False \
			--ServerApp.use_redirect_file True \
			--ServerApp.disable_check_xsrf True \
			--ip "$(NB_HOST)" \
			--port $(NB_PORT_JUPYTER) \
			--notebook-dir "$(ROOT)/book"

.PHONY: notebook-password
notebook-password:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" \
		jupyter notebook password

.PHONY: notebook-list
notebook-list:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" \
		jupyter notebook list

# -----------------------------------------------------------------------------
# conda environment
# -----------------------------------------------------------------------------

.PHONY: env-init-conda
env-init-conda:
	@conda create --yes --copy --name "$(CONDA_ENV_NAME)" \
		python=3.10.16 \
		nvidia::cuda-toolkit=12.4.1 \
		conda-forge::poetry=1.8.5

.PHONY: env-init-poetry
env-init-poetry:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" \
		poetry install --no-root --no-directory

.PHONY: env-init-pip
env-init-pip:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" \
		pip install --no-build-isolation flash-attn==2.7.3

.PHONY: env-update
env-update:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" \
		poetry update

.PHONY: env-list
env-list:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" \
		poetry show

.PHONY: env-remove
env-remove:
	@conda env remove --yes --name "$(CONDA_ENV_NAME)"

.PHONY: env-shell
env-shell:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" \
		bash

.PHONY: env-info
env-info:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" \
		conda info

# -----------------------------------------------------------------------------
# util
# -----------------------------------------------------------------------------

.PHONY: clean-data
clean-data:
	@find . -name '*.gz' -type f -delete

.PHONY: clean-logs
clean-logs:
	@find . -name '*.log' -type f -delete

.PHONY: clean-book
clean-book:
	@cd "$(ROOT)/book" && git clean -d --force && git reset --hard

.PHONY: clean
clean: clean-logs clean-data

# -----------------------------------------------------------------------------
# tensorboard
# -----------------------------------------------------------------------------

.PHONY: tensorboard
tensorboard:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" \
		tensorboard \
			--logdir "$(ROOT)/tensorboard" \
			--samples_per_plugin "images=1024,scalars=8096" \
			--host "$(NB_HOST)" \
			--port "$(NB_PORT_TBOARD)"

.PHONY: tensorboard-clean
tensorboard-clean:
	@rm -rf "$(ROOT)/notebooks/tensorboard/"
