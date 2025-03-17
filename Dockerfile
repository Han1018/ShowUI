# 選擇官方 nvidia/cuda 映像版本，可搭配 cudnn8
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# 切換時區、避免安裝時詢問互動
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Taipei

# 更新 apt，並安裝一些基本工具
RUN apt-get update && apt-get install -y --no-install-recommends \
    tzdata \
    wget \
    git \
    curl \
    ca-certificates \
    build-essential \
    libssl-dev \
    libgl1 \
    libglib2.0-0 \
    && ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime \  
    && echo "Asia/Taipei" > /etc/timezone \
    && rm -rf /var/lib/apt/lists/*

# 使用通用 Miniforge 安裝方式
RUN curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" \
    && bash Miniforge3-$(uname)-$(uname -m).sh -b -p /opt/conda \
    && rm Miniforge3-$(uname)-$(uname -m).sh

# 為了方便之後直接使用 conda/mamba 指令
ENV PATH=/opt/conda/bin:$PATH

# 建立一個新的 conda 環境 (例如 showui_docker)，並安裝必要套件
RUN mamba create -n showui_docker python=3.10.12 -y \
    && mamba install -n showui_docker pip -y

# 啟用 conda environment
SHELL ["conda", "run", "-n", "showui_docker", "/bin/bash", "-c"]

# 安裝 PyTorch、DeepSpeed、其他需求
# 注意：PyTorch CUDA 版本需對應 11.8 (或 11.7)，可在 PyTorch 官網查看最新安裝指令
# 這邊以 pytorch 2.x + cuda 11.8 + torchvision + torchaudio + deepspeed + transformers 為例
RUN pip install --no-cache-dir torch==2.1.2 torchvision==0.16.2 torchaudio==2.1.2 --index-url https://download.pytorch.org/whl/cu118
    # && pip install --no-cache-dir deepspeed transformers

# 設置工作目錄
WORKDIR /workspace

# 初始化 mamba 並在每次啟動容器時自動進入環境
RUN mamba init bash \
    && echo "mamba activate showui_docker" >> /root/.bashrc

# 預設啟動 shell，或是可以自行改 cmd
CMD ["/bin/bash", "--login"]
