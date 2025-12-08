#!/bin/bash

set -e

OUTPUT_DIR="dependencies"

mkdir -p $OUTPUT_DIR

BP_URL='https://tachyon-ci.particle.io/release/tachyon-bp-fw-${VERSION}.zip'
# Using headless, as it contains everything we need already
UBUNTU_20_04_URL='https://linux-dist.particle.io/release/tachyon-ubuntu-20.04-${REGION}-headless-formfactor_dvt-${VERSION}.zip'

BP_DIR=$OUTPUT_DIR/tachyon-bp-fw
mkdir -p $BP_DIR
export VERSION=$(jq -r '.sources["particle-iot-inc/tachyon-quectel-bp-fw"].param' versions.json)
BP_URL=$(echo "$BP_URL" | envsubst)
wget -P $BP_DIR "$BP_URL"
unzip -d $BP_DIR $BP_DIR/$(basename "$BP_URL")

for region in NA RoW; do
    IMG_DIR=$OUTPUT_DIR/tachyon-ubuntu-20.04
    mkdir -p $IMG_DIR
    export VERSION=$(jq -r '.sources["particle-iot-inc/tachyon-release-builder"].param' versions.json)
    export REGION="$region"
    UNPACK_DIR="$IMG_DIR/${region,,}"
    URL=$(echo "$UBUNTU_20_04_URL" | envsubst)
    wget -P $IMG_DIR "$URL"
    mkdir -p $UNPACK_DIR
    unzip -d $UNPACK_DIR $IMG_DIR/$(basename "$URL")
    fakeroot debugfs -R "rdump /lib/firmware $UNPACK_DIR" "$UNPACK_DIR/images/qcm6490/edl/qti-ubuntu-robotics-image-qcs6490-odk-sysfs_1.ext4"
    mkdir -p $UNPACK_DIR/hlos
    # Extract cdsp firmware files from NON-HLOS.bin, symlink the rest of the files
    mcopy -s -i "$UNPACK_DIR/images/qcm6490/edl/NON-HLOS.bin" '::/image/*' $UNPACK_DIR/hlos
done

exit 0
