  //go:build !bazel

  // Re-export token IDs from the generated JSONPath parser so the scanner and
  // parser agree in non-Bazel builds.
  package lexbase

  import jp "github.com/cockroachdb/cockroach/pkg/util/jsonpath/parser"

  const (
    ROOT          = jp.ROOT
    VARIABLE      = jp.VARIABLE
    STR           = jp.STR
    EQUAL         = jp.EQUAL
    NOT_EQUAL     = jp.NOT_EQUAL
    NOT           = jp.NOT
    GREATER_EQUAL = jp.GREATER_EQUAL
    GREATER       = jp.GREATER
    LESS_EQUAL    = jp.LESS_EQUAL
    LESS          = jp.LESS
    AND           = jp.AND
    OR            = jp.OR
    CURRENT       = jp.CURRENT
    ANY           = jp.ANY
  )
