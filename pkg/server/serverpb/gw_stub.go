//go:build !bazel

package serverpb

import (
	"context"

	"github.com/grpc-ecosystem/grpc-gateway/runtime" // v1 path
	"google.golang.org/grpc"
)

// No-op handlers so non-Bazel 'go build' links cleanly.
func RegisterAdminHandler(ctx context.Context, mux *runtime.ServeMux, conn *grpc.ClientConn) error  { return nil }
func RegisterStatusHandler(ctx context.Context, mux *runtime.ServeMux, conn *grpc.ClientConn) error { return nil }
func RegisterLogInHandler(ctx context.Context, mux *runtime.ServeMux, conn *grpc.ClientConn) error  { return nil }
func RegisterLogOutHandler(ctx context.Context, mux *runtime.ServeMux, conn *grpc.ClientConn) error { return nil }
