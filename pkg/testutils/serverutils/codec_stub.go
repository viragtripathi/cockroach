//go:build !bazel

package serverutils

import "github.com/cockroachdb/cockroach/pkg/keys"

// Return a reasonable default codec so callers won't NPE.
func (w *wrap) Codec() keys.SQLCodec { return keys.SystemSQLCodec }
