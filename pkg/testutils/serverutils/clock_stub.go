//go:build !bazel

package serverutils

import "github.com/cockroachdb/cockroach/pkg/util/hlc"

func (w *wrap) Clock() *hlc.Clock { return nil }
