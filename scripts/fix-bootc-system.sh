#!/bin/bash

if ! grep -q "^#.* / /" /etc/fstab; then
  sed -i '/ \/ /s/^/#/' /etc/fstab
fi
