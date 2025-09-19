
package main

// bzltestutil may change the current directory in its init function to emulate
// 'go test' behavior. It must be initialized before user packages.
// In Go 1.20 and earlier, this import declaration must appear before
// imports of user packages. See comment in bzltestutil/init.go.
import "github.com/bazelbuild/rules_go/go/tools/bzltestutil"

import (
	"flag"
	"log"
	"os"
	"os/exec"

	"strconv"
	"strings"
	"testing"
	"testing/internal/testdeps"




	_ "github.com/cockroachdb/cockroach/pkg/util/quantile_test"

	l "github.com/cockroachdb/cockroach/pkg/util/quantile"

)

var allTests = []testing.InternalTest{

	{"TestTargetedQuery", l.TestTargetedQuery },

	{"TestTargetedQuerySmallSampleSize", l.TestTargetedQuerySmallSampleSize },

	{"TestLowBiasedQuery", l.TestLowBiasedQuery },

	{"TestHighBiasedQuery", l.TestHighBiasedQuery },

	{"TestUncompressed", l.TestUncompressed },

	{"TestUncompressedSamples", l.TestUncompressedSamples },

	{"TestUncompressedOne", l.TestUncompressedOne },

	{"TestDefaults", l.TestDefaults },

	{"TestQueryFlush", l.TestQueryFlush },

	{"TestByteSize", l.TestByteSize },

}

var benchmarks = []testing.InternalBenchmark{

}


var fuzzTargets = []testing.InternalFuzzTarget{

}


var examples = []testing.InternalExample{

}

func testsInShard() []testing.InternalTest {
	totalShards, err := strconv.Atoi(os.Getenv("TEST_TOTAL_SHARDS"))
	if err != nil || totalShards <= 1 {
		return allTests
	}
	file, err := os.Create(os.Getenv("TEST_SHARD_STATUS_FILE"))
	if err != nil {
		log.Fatalf("Failed to touch TEST_SHARD_STATUS_FILE: %v", err)
	}
	_ = file.Close()
	shardIndex, err := strconv.Atoi(os.Getenv("TEST_SHARD_INDEX"))
	if err != nil || shardIndex < 0 {
		return allTests
	}
	tests := []testing.InternalTest{}
	for i, t := range allTests {
		if i % totalShards == shardIndex {
			tests = append(tests, t)
		}
	}
	return tests
}

func main() {
	// NOTE(ricky): Bazel sets the TEST_TMPDIR env variable, but Cockroach
	// tests generally consult TMPDIR.
	err := os.Setenv("TMPDIR", os.Getenv("TEST_TMPDIR"))
	if err != nil {
		panic(err)
	}
	if bzltestutil.ShouldWrap() {
		err := bzltestutil.Wrap("github.com/cockroachdb/cockroach/pkg/util/quantile")
		exitCode := 0
		if xerr, ok := err.(*exec.ExitError); ok {
			exitCode = xerr.ExitCode()
			log.Printf("Test %v exited with error code %v", os.Getenv("TEST_TARGET"), exitCode)
		} else if err != nil {
			log.Print(err)
			exitCode = bzltestutil.TestWrapperAbnormalExit
		}
		os.Exit(exitCode)
	}

	testDeps :=
  
		testdeps.TestDeps{}
  
  
	m := testing.MainStart(testDeps, testsInShard(), benchmarks, fuzzTargets, examples)
  

	if filter := os.Getenv("TESTBRIDGE_TEST_ONLY"); filter != "" {
		filters := strings.Split(filter, ",")
		var runTests []string
		var skipTests []string

		for _, f := range filters {
			if strings.HasPrefix(f, "-") {
				skipTests = append(skipTests, f[1:])
			} else {
				runTests = append(runTests, f)
			}
		}
		if len(runTests) > 0 {
			flag.Lookup("test.run").Value.Set(strings.Join(runTests, "|"))
		}
		if len(skipTests) > 0 {
			flag.Lookup("test.skip").Value.Set(strings.Join(skipTests, "|"))
		}
	}

	if failfast := os.Getenv("TESTBRIDGE_TEST_RUNNER_FAIL_FAST"); failfast != "" {
		flag.Lookup("test.failfast").Value.Set("true")
	}



	testTimeout := os.Getenv("TEST_TIMEOUT")
	if testTimeout != "" {
		flag.Lookup("test.timeout").Value.Set(testTimeout+"s")
		bzltestutil.RegisterTimeoutHandler()
	}

	
	res := m.Run()
	
	os.Exit(res)
}
