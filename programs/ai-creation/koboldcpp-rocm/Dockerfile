# FROM debian:bookworm
FROM ubuntu:24.04

RUN \
    apt-get update && \
    apt-get --no-install-recommends -y install \
      python3 \
      python3-pip \
      git \
      wget \
      cmake \
      vim \
      radeontop \
      make \
      hipcc \
      rocm-cmake \
    #   rocm-device-libs \
      rocm-smi \
      rocminfo \
      g++ && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clone the repository and build the project
RUN git clone https://github.com/YellowRoseCx/koboldcpp-rocm.git -b main --depth 1 /usr/local/koboldcpp-rocm && \
    cd /usr/local/koboldcpp-rocm && \
    make LLAMA_HIPBLAS=1 -j4

COPY entrypoint.sh /opt/entrypoint.sh

RUN chmod +x /opt/entrypoint.sh

# Run the koboldcpp.py script
ENTRYPOINT ["/opt/entrypoint.sh"]