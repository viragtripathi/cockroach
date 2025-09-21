package serverutils

// Minimal test helper used by a few serverutils helpers in non-test builds.
// This file is intentionally unconditional (no build tags) so plain `go build` sees it.
type TestFataler interface {
	Fatal(...interface{})
	Fatalf(string, ...interface{})
	Error(...interface{})
	Errorf(string, ...interface{})
	Helper()
}
