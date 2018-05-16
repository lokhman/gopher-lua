package lua

import (
	"strings"
	"time"
)

var startedAt time.Time

func init() {
	startedAt = time.Now()
}

func getIntField(L *LState, tb *LTable, key string, v int) int {
	ret := tb.RawGetString(key)
	if ln, ok := ret.(LNumber); ok {
		return int(ln)
	}
	return v
}

func getBoolField(L *LState, tb *LTable, key string, v bool) bool {
	ret := tb.RawGetString(key)
	if lb, ok := ret.(LBool); ok {
		return bool(lb)
	}
	return v
}

func OpenOs(L *LState) int {
	osmod := L.RegisterModule(OsLibName, osFuncs)
	L.Push(osmod)
	return 1
}

var osFuncs = map[string]LGFunction{
	"clock":     osClock,
	"difftime":  osDiffTime,
	"date":      osDate,
	"time":      osTime,
}

func osClock(L *LState) int {
	L.Push(LNumber(float64(time.Now().Sub(startedAt)) / float64(time.Second)))
	return 1
}

func osDiffTime(L *LState) int {
	L.Push(LNumber(L.CheckInt64(1) - L.CheckInt64(2)))
	return 1
}

func osDate(L *LState) int {
	t := time.Now()
	cfmt := "%c"
	if L.GetTop() >= 1 {
		cfmt = L.CheckString(1)
		if strings.HasPrefix(cfmt, "!") {
			t = time.Now().UTC()
			cfmt = strings.TrimLeft(cfmt, "!")
		}
		if L.GetTop() >= 2 {
			t = time.Unix(L.CheckInt64(2), 0)
		}
		if strings.HasPrefix(cfmt, "*t") {
			ret := L.NewTable()
			ret.RawSetString("year", LNumber(t.Year()))
			ret.RawSetString("month", LNumber(t.Month()))
			ret.RawSetString("day", LNumber(t.Day()))
			ret.RawSetString("hour", LNumber(t.Hour()))
			ret.RawSetString("min", LNumber(t.Minute()))
			ret.RawSetString("sec", LNumber(t.Second()))
			ret.RawSetString("wday", LNumber(t.Weekday()+1))
			// TODO yday & dst
			ret.RawSetString("yday", LNumber(0))
			ret.RawSetString("isdst", LFalse)
			L.Push(ret)
			return 1
		}
	}
	L.Push(LString(strftime(t, cfmt)))
	return 1
}

func osTime(L *LState) int {
	if L.GetTop() == 0 {
		L.Push(LNumber(time.Now().Unix()))
	} else {
		tbl := L.CheckTable(1)
		sec := getIntField(L, tbl, "sec", 0)
		min := getIntField(L, tbl, "min", 0)
		hour := getIntField(L, tbl, "hour", 12)
		day := getIntField(L, tbl, "day", -1)
		month := getIntField(L, tbl, "month", -1)
		year := getIntField(L, tbl, "year", -1)
		isdst := getBoolField(L, tbl, "isdst", false)
		t := time.Date(year, time.Month(month), day, hour, min, sec, 0, time.Local)
		// TODO dst
		if false {
			print(isdst)
		}
		L.Push(LNumber(t.Unix()))
	}
	return 1
}

//
