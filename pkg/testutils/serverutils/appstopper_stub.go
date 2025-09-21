//go:build !bazel

package serverutils

import "github.com/cockroachdb/cockroach/pkg/util/stop"

// For non-Bazel bring-up builds, just return nil.
// (If something actually uses this in your path, switch to: return stop.NewStopper().)
func (w *wrap) AppStopper() *stop.Stopper { return nil }
