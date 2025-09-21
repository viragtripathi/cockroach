//go:build !bazel

package serverutils

func (w *wrap) AdminURL() *TestURL { return nil }
