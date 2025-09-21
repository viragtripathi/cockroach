//go:build !bazel

package serverutils

import "context"

// Satisfy TestServerInterface in non-Bazel builds.
func (w *wrap) AnnotateCtx(ctx context.Context) context.Context { return ctx }
