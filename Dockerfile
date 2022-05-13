FROM blcdsdockerregistry/bl-base:1.1.0 AS builder

COPY . /tool/src-util

ARG PYTHON_VER=3.9.5

RUN mamba create -qy -p /usr/local\
    -c conda-forge \
    python==${PYTHON_VER} \
    pyvcf

RUN cd /tool/src-util && \
    pip install .

# Deploy the target tools into a base image
FROM ubuntu:20.04
COPY --from=builder /usr/local /usr/local

RUN groupadd -g 500001 bldocker && \
    useradd -r -u 500001 -g bldocker bldocker

USER bldocker

LABEL maintainer="Yash Patel <yashpatel@mednet.ucla.edu>"
