//go:build !bazel

package serverutils

import "github.com/cockroachdb/cockroach/pkg/roachpb"

func TestTenantID() roachpb.TenantID { return roachpb.SystemTenantID } // <-- no ()
