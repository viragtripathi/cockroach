//go:build !bazel

package serverutils

import "context"

func (w *wrap) Activate(ctx context.Context) error { return nil }
