//go:build !bazel

package serverutils

import "github.com/cockroachdb/cockroach/pkg/settings/cluster"

func (w *wrap) ClusterSettings() *cluster.Settings { return nil }
