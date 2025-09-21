package scanner

// Minimal compile-only stub so non-Bazel builds succeed.
// It implements the symbol expected by the PL/pgSQL parser but always returns EOF.
type PLpgSQLScanner struct{ Scanner }

func (s *PLpgSQLScanner) Scan(lval ScanSymType) {
	// 0 is EOF for goyacc parsers.
	lval.SetID(0)
}
