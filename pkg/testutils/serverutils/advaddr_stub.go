//go:build !bazel

package serverutils

func (w *wrap) AdvRPCAddr() string { return "" }
func (w *wrap) AdvSQLAddr() string { return "" }
