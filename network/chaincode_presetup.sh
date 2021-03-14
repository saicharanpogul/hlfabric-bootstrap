#!/bin/bash
source ../terminal_control.sh

presetup() {
  print Green "========== Vendoring Go Dependencies =========="
  pushd ../chaincode/supplychain/go/
  GO111MODULE=on go mod vendor
  popd
  print Green "========== Finished Vendoring Go Dependencies =========="
}

presetup