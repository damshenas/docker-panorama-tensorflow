# This Dockerfile fetches the image tagged latest by default
# To use a specific version of the image, refer to https://gallery.ecr.aws/panorama/panorama-application
# and tag the image in the Dockerfile with the version you're planning to use.
FROM public.ecr.aws/panorama/panorama-application

RUN apt-get update && apt-get install -y ffmpeg pkg-config zip g++ zlib1g-dev unzip wget curl build-essential openjdk-8-jdk && apt-get autoremove -y

COPY step1.sh /opt
RUN chmod +x /opt/step1.sh && ./opt/step1.sh

ENV PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=cpp
COPY step2.sh /opt
RUN chmod +x /opt/step2.sh && ./opt/step2.sh

RUN apt-get install -y git
ENV TMP=/tmp
COPY step3.sh /opt
RUN chmod +x /opt/step3.sh && ./opt/step3.sh

# RUN pip3 install wheel/tensorflow_pkg/tensorflow-2.3.0-cp36-cp36m-linux_aarch64.whl
# RUN pip3 install wheel/tensorflow_pkg/tensorflow-2.3.0-*.whl
RUN ./.env && TF_CPP_MIN_LOG_LEVEL=3 python3 -c "import tensorflow as tf; tf.compat.v1.logging.set_verbosity(tf.compat.v1.logging.ERROR); print('tensorflow version: %s' % tf.__version__); print('tensorflow.test.is_built_with_cuda(): %s' % tf.test.is_built_with_cuda()); print('tensorflow.test.is_gpu_available(): %s' % tf.test.is_gpu_available(cuda_only=False, min_cuda_compute_capability=None))"
