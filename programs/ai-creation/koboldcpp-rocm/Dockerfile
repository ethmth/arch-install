FROM archlinux:base-20240101.0.204074

RUN \
    pacman -Sy --noconfirm && \
    pacman -S --noconfirm \
      python \
      python-pip \
      git \
      wget \
      cmake \
      vim \
      radeontop \
      make \
      miopen-hip \
      rocm-hip-sdk \
      rocminfo \
      gcc && \
    pacman -Scc --noconfirm

RUN git clone https://github.com/YellowRoseCx/koboldcpp-rocm.git -b main --depth 1 /usr/local/koboldcpp-rocm && \
    cd /usr/local/koboldcpp-rocm && \
    make LLAMA_HIPBLAS=1 -j4

RUN cp /opt/rocm/bin/rocminfo /usr/bin/rocminfo

COPY entrypoint.sh /opt/entrypoint.sh

RUN chmod +x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]