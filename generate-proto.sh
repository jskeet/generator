#!/bin/sh
protoc -I=proto --go_out=internal/statepb --go_opt=paths=source_relative proto/*.proto
