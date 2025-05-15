#!/bin/bash
set -e  # Exit on error

export PYTHONUNBUFFERED=1
export PATH="/workspace/bin:$PATH"

echo "**** CHECK NODES AND INSTALL IF NOT FOUND ****"
if [ "${SKIP_NODES}" == "true" ]; then
    echo "**** SKIPPING NODE INSTALLATION (SKIP_NODES=true) ****"
else
    /install_nodes.sh install_only
fi

# Check if downloads should be skipped
if [ "${SKIP_DOWNLOADS}" == "true" ]; then
    echo "**** SKIPPING MODEL DOWNLOADS (SKIP_DOWNLOADS=true) ****"
else
    echo "**** DOWNLOADING - INSTALLING MODELS ****"
    /download_models.sh
fi

# Create symlink
ln -sf /workspace/ComfyUI /ComfyUI
ln -sf /workspace/sd-webui-infinite-image-browsing /sd-webui-infinite-image-browsing

echo "✨ Pre-start completed successfully ✨"