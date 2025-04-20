# pytorch environment for the book "A Hands-On Guide to Fine-Tuning LLMs with PyTorch and Hugging Face"

https://github.com/dvgodoy/FineTuningLLMs/tree/main

```shell
git clone --recurse-submodules -j8 git@github.com:mazurkin/fine-tuning-llms.git
```

```shell
# first, make an isolated Conda environment with Python, Poetry and CUDA inside
$ make env-init-conda

# then install the most of the dependencies with Poetry
$ make env-init-poetry

# finally install the `flash-attn` package with Pip as it can not be installed with the Poetry
$ make env-init-pip
```

```shell
$ make notebook
```

```shell
$ make tensorboard
```

# pytorch

https://pytorch.org/get-started/locally/
