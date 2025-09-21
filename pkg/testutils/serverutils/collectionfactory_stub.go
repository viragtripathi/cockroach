//go:build !bazel

package serverutils

import "github.com/cockroachdb/cockroach/pkg/sql/catalog/descs"

func (w *wrap) CollectionFactory() *descs.CollectionFactory { return nil }
