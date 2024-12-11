# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang:1.23 AS build

WORKDIR /src
COPY go.mod go.sum .
RUN go mod download
COPY cmd cmd
COPY internal internal
RUN CGO_ENABLED=0 GOOS=linux go build ./cmd/generator

# Using docker:dind so we can run docker from the CLI,
# while in Docker. Note that for this to work, *this*
# docker image should be run with
#  -v /var/run/docker.sock:/var/run/docker.sock
FROM docker:dind
WORKDIR /app

COPY --from=build /src/generator .
ENTRYPOINT ["/app/generator"]
