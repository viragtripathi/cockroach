//go:build !bazel

package tspb

import (
	"context"

	"github.com/grpc-ecosystem/grpc-gateway/runtime" // v1 path
	"google.golang.org/grpc"
)

func RegisterTimeSeriesHandler(ctx context.Context, mux *runtime.ServeMux, conn *grpc.ClientConn) error { return nil }
