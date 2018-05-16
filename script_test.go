package lua

import (
	"fmt"
	"github.com/lokhman/yams-lua/parse"
	"os"
	"testing"
)

const maxMemory = 40

var luaTests []string = []string{
	"attrib.lua",
	"calls.lua",
	"closure.lua",
	"constructs.lua",
	"events.lua",
	"literals.lua",
	"locals.lua",
	"math.lua",
	"sort.lua",
	"strings.lua",
	"vararg.lua",
	"pm.lua",
}

func testScriptCompile(t *testing.T, script string) {
	file, err := os.Open(script)
	if err != nil {
		t.Fatal(err)
		return
	}
	chunk, err2 := parse.Parse(file, script)
	if err2 != nil {
		t.Fatal(err2)
		return
	}
	parse.Dump(chunk)
	proto, err3 := Compile(chunk, script)
	if err3 != nil {
		t.Fatal(err3)
		return
	}
	proto.String()
}

func testScriptDir(t *testing.T, tests []string, directory string) {
	if err := os.Chdir(directory); err != nil {
		t.Error(err)
	}
	defer os.Chdir("..")
	for _, script := range tests {
		fmt.Printf("testing %s/%s\n", directory, script)
		testScriptCompile(t, script)
		L := NewState(Options{
			RegistrySize:        1024 * 20,
			CallStackSize:       1024,
			IncludeGoStackTrace: true,
		})
		L.SetMx(maxMemory)
		if err := L.DoFile(script); err != nil {
			t.Error(err)
		}
		L.Close()
	}
}

func TestLua(t *testing.T) {
	testScriptDir(t, luaTests, "_lua5.1-tests")
}
