#!/bin/bash

OUTPUT="instances_details.yml"

echo "instances:" > "$OUTPUT"

for f in data_*; do
    [ -f "$f" ] || continue

    NAME=$(grep '^name:' "$f" | cut -d':' -f2 | xargs)
    INSTANCE=$(grep '^instance:' "$f" | cut -d':' -f2 | xargs)
    DEVICE=$(grep '^device:' "$f" | cut -d':' -f2 | xargs)
    FSTYPE=$(grep '^fstype:' "$f" | cut -d':' -f2 | xargs)
    IMAGEID=$(grep '^imageid:' "$f" | cut -d':' -f2 | xargs)

    echo "  - name: $NAME" >> "$OUTPUT"
    echo "    instance: $INSTANCE" >> "$OUTPUT"
    echo "    device: $DEVICE" >> "$OUTPUT"
    echo "    fstype: $FSTYPE" >> "$OUTPUT"
    echo "    imageid: $IMAGEID" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
done
