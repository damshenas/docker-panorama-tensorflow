
FROM public.ecr.aws/panorama/panorama-application

LABEL MAINTAINER=damshenas \
      ARCH=aarch64 \
      DEBIAN_FRONTEND=noninteractive
      
RUN apt-get -qq update && apt-get -qq -y install curl bzip2 python3 python3-pip \
    && curl -sSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm -rf /tmp/miniconda.sh \
    && conda update conda \
    && apt-get -qq -y remove curl bzip2 \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
    && conda clean --all --yes

ENV PATH /opt/conda/bin:$PATH

RUN pip3 install --no-cache-dir opencv-python-headless

RUN conda install tensorflow && conda clean -tipsy
# tensorflow version: 2.5.0
# tensorflow.test.is_built_with_cuda(): False
# tensorflow.test.is_gpu_available(): False

# COPY src /src
