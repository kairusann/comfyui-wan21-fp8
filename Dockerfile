FROM runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04

RUN apt-get update && \
    apt-get install dos2unix

# Clone ComfyUI
WORKDIR /workspace
RUN git clone https://github.com/comfyanonymous/ComfyUI.git
RUN git clone https://github.com/zanllp/sd-webui-infinite-image-browsing.git

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# Install ComfyUI requirements
WORKDIR /workspace/ComfyUI
RUN pip install --no-cache-dir -r requirements.txt

# Install sageattention
RUN pip install --no-cache-dir \
    triton \
    sageattention \
    accelerate

# Clone custom nodes
WORKDIR /workspace/ComfyUI/custom_nodes
RUN git clone https://github.com/chrisgoringe/cg-use-everywhere.git && \
    git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git && \
    git clone https://github.com/crystian/ComfyUI-Crystools.git && \
    git clone https://github.com/kijai/ComfyUI-KJNodes.git && \
    git clone https://github.com/rgthree/rgthree-comfy.git && \
    git clone https://github.com/WASasquatch/was-node-suite-comfyui.git && \
    git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git && \
    git clone https://github.com/yolain/ComfyUI-Easy-Use.git && \
    git clone https://github.com/cubiq/ComfyUI_essentials && \
    git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite && \
    git clone https://github.com/kijai/ComfyUI-HunyuanVideoWrapper.git && \
    git clone https://github.com/logtd/ComfyUI-HunyuanLoom.git && \
    git clone https://github.com/kijai/ComfyUI-WanVideoWrapper.git

# Install requirements for custom nodes (if any)
RUN for dir in */; do \
    if [ -f "${dir}requirements.txt" ]; then \
        echo "Installing requirements for ${dir}..." && \
        pip install --no-cache-dir -r "${dir}requirements.txt" || true; \
    fi \
    done

# Copy workflow files
COPY comfy-workflows/*.json /workspace/ComfyUI/user/default/workflows/

# Install sd-webui requirements
WORKDIR /workspace/sd-webui-infinite-image-browsing
RUN pip install --no-cache-dir -r requirements.txt

# Copy all scripts
COPY scripts/*.sh /

# Copy files to container root directory
COPY manage-files/download-files.sh /
COPY manage-files/files.txt /

# Copy files to container root directory
COPY manage-files/download-files.sh /workspace/
COPY manage-files/files.txt /workspace/

RUN dos2unix /*.sh && \
    dos2unix /workspace/*.sh && \
    chmod +x /*.sh && \
    chmod +x /workspace/*.sh

CMD ["/start.sh"]