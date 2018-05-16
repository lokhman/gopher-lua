do --[

_print "testing require"

assert(require"string" == string)
assert(require"math" == math)
assert(require"table" == table)

assert(type(package.loaded) == "table")
assert(type(package.preload) == "table")

local function import(...)
  local f = {...}
  return function (m)
    for i=1, #f do m[f[i]] = _G[f[i]] end
  end
end

local assert, module, package = assert, module, package
X = nil; x = 0; assert(_G.x == 0)   -- `x' must be a global variable
module"X"; x = 1; assert(_M.x == 1)
module"X.a.b.c"; x = 2; assert(_M.x == 2)
module("X.a.b", package.seeall); x = 3
assert(X._NAME == "X" and X.a.b.c._NAME == "X.a.b.c" and X.a.b._NAME == "X.a.b")
assert(X._M == X and X.a.b.c._M == X.a.b.c and X.a.b._M == X.a.b)
assert(X.x == 1 and X.a.b.c.x == 2 and X.a.b.x == 3)
assert(X._PACKAGE == "" and X.a.b.c._PACKAGE == "X.a.b." and
       X.a.b._PACKAGE == "X.a.")
assert(_PACKAGE.."c" == "X.a.c")
assert(X.a._NAME == nil and X.a._M == nil)
module("X.a", import("X")) ; x = 4
assert(X.a._NAME == "X.a" and X.a.x == 4 and X.a._M == X.a)
module("X.a.b", package.seeall); assert(x == 3); x = 5
assert(_NAME == "X.a.b" and X.a.b.x == 5)

assert(X._G == nil and X.a._G == nil and X.a.b._G == _G and X.a.b.c._G == nil)

setfenv(1, _G)
assert(x == 0)

assert(not pcall(module, "x"))
assert(not pcall(module, "math.sin"))

end  --]

_print('+')

_print("testing assignments, logical operators, and constructors")

local res, res2 = 27

a, b = 1, 2+3
assert(a==1 and b==5)
a={}
function f() return 10, 11, 12 end
a.x, b, a[1] = 1, 2, f()
assert(a.x==1 and b==2 and a[1]==10)
a[f()], b, a[f()+3] = f(), a, 'x'
assert(a[10] == 10 and b == a and a[13] == 'x')

do
  local f = function (n) local x = {}; for i=1,n do x[i]=i end;
                         return unpack(x) end;
  local a,b,c
  a,b = 0, f(1)
  assert(a == 0 and b == 1)
  A,b = 0, f(1)
  assert(A == 0 and b == 1)
  a,b,c = 0,5,f(4)
  assert(a==0 and b==5 and c==1)
  a,b,c = 0,5,f(0)
  assert(a==0 and b==5 and c==nil)
end


a, b, c, d = 1 and nil, 1 or nil, (1 and (nil or 1)), 6
assert(not a and b and c and d==6)

d = 20
a, b, c, d = f()
assert(a==10 and b==11 and c==12 and d==nil)
a,b = f(), 1, 2, 3, f()
assert(a==10 and b==1)

assert(a<b == false and a>b == true)
assert((10 and 2) == 2)
assert((10 or 2) == 10)
assert((10 or assert(nil)) == 10)
assert(not (nil and assert(nil)))
assert((nil or "alo") == "alo")
assert((nil and 10) == nil)
assert((false and 10) == false)
assert((true or 10) == true)
assert((false or 10) == 10)
assert(false ~= nil)
assert(nil ~= false)
assert(not nil == true)
assert(not not nil == false)
assert(not not 1 == true)
assert(not not a == true)
assert(not not (6 or nil) == true)
assert(not not (nil and 56) == false)
assert(not not (nil and true) == false)
_print('+')

a = {}
a[true] = 20
a[false] = 10
assert(a[1<2] == 20 and a[1>2] == 10)

function f(a) return a end

local a = {}
for i=3000,-3000,-1 do a[i] = i; end
a[10e30] = "alo"; a[true] = 10; a[false] = 20
assert(a[10e30] == 'alo' and a[not 1] == 20 and a[10<20] == 10)
for i=3000,-3000,-1 do assert(a[i] == i); end
a[_print] = assert
a[f] = _print
a[a] = a
assert(a[a][a][a][a][_print] == assert)
a[_print](a[a[f]] == a[_print])
a = nil

a = {10,9,8,7,6,5,4,3,2; [-3]='a', [f]=_print, a='a', b='ab'}
a, a.x, a.y = a, a[-3]
assert(a[1]==10 and a[-3]==a.a and a[f]==_print and a.x=='a' and not a.y)
a[1], f(a)[2], b, c = {['alo']=assert}, 10, a[1], a[f], 6, 10, 23, f(a), 2
a[1].alo(a[2]==10 and b==10 and c==_print)

a[2^31] = 10; a[2^31+1] = 11; a[-2^31] = 12;
a[2^32] = 13; a[-2^32] = 14; a[2^32+1] = 15; a[10^33] = 16;

assert(a[2^31] == 10 and a[2^31+1] == 11 and a[-2^31] == 12 and
       a[2^32] == 13 and a[-2^32] == 14 and a[2^32+1] == 15 and
       a[10^33] == 16)

a = nil


-- do
--   local a,i,j,b
--   a = {'a', 'b'}; i=1; j=2; b=a
--   i, a[i], a, j, a[j], a[i+j] = j, i, i, b, j, i
--   assert(i == 2 and b[1] == 1 and a == 1 and j == b and b[2] == 2 and
--          b[3] == 1)
-- end

_print('OK')

return res
