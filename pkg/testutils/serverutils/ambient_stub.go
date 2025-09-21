//go:build !bazel

package serverutils

import "github.com/cockroachdb/cockroach/pkg/util/log"

// TestServerInterface expects a value, not *AmbientContext.
func (w *wrap) AmbientCtx() log.AmbientContext { return log.AmbientContext{} }
