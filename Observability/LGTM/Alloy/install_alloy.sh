#!/bin/bash
exit 0
# -------------

### ===================== 編譯安裝 =====================
export TAG=v1.9.0
REVISION=$(git rev-parse --short HEAD)
git checkout $TAG

make generate-ui
GO_TAGS="builtinassets" GOOS=darwin GOARCH=arm64 GOARM= make alloy

go build -ldflags "-w -s -X 'github.com/hashicorp/terraform/version.dev=no'" -o ~/bin/

go build -ldflags "-s -w -X github.com/grafana/alloy/internal/build.Branch=$TAG -X github.com/grafana/alloy/internal/build.Version=$TAG -X github.com/grafana/alloy/syntax/stdlib.Version=$TAG -X github.com/grafana/alloy/internal/build.Revision=$REVISION -X github.com/grafana/alloy/internal/build.BuildUser=weibyapps@Atlantis -X github.com/grafana/alloy/internal/build.BuildDate=2025-06-03T06:33:25Z" -tags "$TAG" -o build/alloy .
