_print("testing numbers and math lib")

do
  local a,b,c = "2", " 3e0 ", " 10  "
  assert(a+b == 5 and -b == -3 and b+"2" == 5 and "10"-c == 0)
  assert(type(a) == 'string' and type(b) == 'string' and type(c) == 'string')
  assert(a == "2" and b == " 3e0 " and c == " 10  " and -c == -"  10 ")
  assert(c%a == 0 and a^b == 8)
end


do
  local a,b = math.modf(3.5)
  assert(a == 3 and b == 0.5)
  assert(math.huge > 10e30)
  assert(-math.huge < -10e30)
end

function f(...)
  if select('#', ...) == 1 then
    return (...)
  else
    return "***"
  end
end

assert(tonumber{} == nil)
assert(tonumber'+0.01' == 1/100 and tonumber'+.01' == 0.01 and
       tonumber'.01' == 0.01    and tonumber'-1.' == -1 and
       tonumber'+1.' == 1)
assert(tonumber'+ 0.01' == nil and tonumber'+.e1' == nil and
       tonumber'1e' == nil     and tonumber'1.0e+' == nil and
       tonumber'.' == nil)
assert(tonumber('-12') == -10-2)
assert(tonumber('-1.2e2') == - - -120)
assert(f(tonumber('1  a')) == nil)
assert(f(tonumber('e1')) == nil)
assert(f(tonumber('e  1')) == nil)
assert(f(tonumber(' 3.4.5 ')) == nil)
assert(f(tonumber('')) == nil)
assert(f(tonumber('', 8)) == nil)
assert(f(tonumber('  ')) == nil)
assert(f(tonumber('  ', 9)) == nil)
assert(f(tonumber('99', 8)) == nil)
assert(tonumber('  1010  ', 2) == 10)
assert(tonumber('10', 36) == 36)
assert(tonumber('\n  -10  \n', 36) == -36)
assert(tonumber('-fFfa', 16) == -(10+(16*(15+(16*(15+(16*15)))))))
assert(tonumber('fFfa', 15) == nil)
assert(tonumber(string.rep('1', 42), 2) + 1 == 2^42)
assert(tonumber(string.rep('1', 32), 2) + 1 == 2^32)
assert(tonumber('-fffffFFFFF', 16)-1 == -2^40)
assert(tonumber('ffffFFFF', 16)+1 == 2^32)
assert(tonumber('0xF') == 15)

assert(1.1 == 1.+.1)
_print(100.0, 1E2, .01)
assert(100.0 == 1E2 and .01 == 1e-2)
assert(1111111111111111-1111111111111110== 1000.00e-03)
--     1234567890123456
assert(1.1 == '1.'+'.1')
assert('1111111111111111'-'1111111111111110' == tonumber"  +0.001e+3 \n\t")

function eq (a,b,limit)
  if not limit then limit = 10E-10 end
  return math.abs(a-b) <= limit
end

assert(0.1e-30 > 0.9E-31 and 0.9E30 < 0.1e31)

assert(0.123456 > 0.123455)

assert(tonumber('+1.23E30') == 1.23*10^30)

-- testing order operators
assert(not(1<1) and (1<2) and not(2<1))
assert(not('a'<'a') and ('a'<'b') and not('b'<'a'))
assert((1<=1) and (1<=2) and not(2<=1))
assert(('a'<='a') and ('a'<='b') and not('b'<='a'))
assert(not(1>1) and not(1>2) and (2>1))
assert(not('a'>'a') and not('a'>'b') and ('b'>'a'))
assert((1>=1) and not(1>=2) and (2>=1))
assert(('a'>='a') and not('a'>='b') and ('b'>='a'))

-- testing mod operator
assert(-4%3 == 2)
assert(4%-3 == -2)
assert(math.pi - math.pi % 1 == 3)
assert(math.pi - math.pi % 0.001 == 3.141)

local function testbit(a, n)
  return a/2^n % 2 >= 1
end

assert(eq(math.sin(-9.8)^2 + math.cos(-9.8)^2, 1))
assert(eq(math.tan(math.pi/4), 1))
assert(eq(math.sin(math.pi/2), 1) and eq(math.cos(math.pi/2), 0))
assert(eq(math.atan(1), math.pi/4) and eq(math.acos(0), math.pi/2) and
       eq(math.asin(1), math.pi/2))
assert(eq(math.deg(math.pi/2), 90) and eq(math.rad(90), math.pi/2))
assert(math.abs(-10) == 10)
assert(eq(math.atan2(1,0), math.pi/2))
assert(math.ceil(4.5) == 5.0)
assert(math.floor(4.5) == 4.0)
assert(math.mod(10,3) == 1)
assert(eq(math.sqrt(10)^2, 10))
assert(eq(math.log10(2), math.log(2)/math.log(10)))
assert(eq(math.exp(0), 1))
assert(eq(math.sin(10), math.sin(10%(2*math.pi))))
local v,e = math.frexp(math.pi)
assert(eq(math.ldexp(v,e), math.pi))

assert(eq(math.tanh(3.5), math.sinh(3.5)/math.cosh(3.5)))

assert(tonumber(' 1.3e-2 ') == 1.3e-2)
assert(tonumber(' -1.00000000000001 ') == -1.00000000000001)

-- testing constant limits
-- 2^23 = 8388608
assert(8388609 + -8388609 == 0)
assert(8388608 + -8388608 == 0)
assert(8388607 + -8388607 == 0)

if rawget(_G, "_soft") then return end

do   -- testing NaN
  local NaN = 10e500 - 10e400
  assert(NaN ~= NaN)
  assert(not (NaN < NaN))
  assert(not (NaN <= NaN))
  assert(not (NaN > NaN))
  assert(not (NaN >= NaN))
  assert(not (0 < NaN))
  assert(not (NaN < 0))
  local a = {}
  assert(not pcall(function () a[NaN] = 1 end))
  assert(a[NaN] == nil)
  a[1] = 1
  assert(not pcall(function () a[NaN] = 1 end))
  assert(a[NaN] == nil)
end

assert(rawget(_G, "stat") == nil)  -- module not loaded before

if T == nil then
  stat = function () _print"`querytab' nao ativo" end
  return
end


function checktable (t)
  local asize, hsize, ff = T.querytab(t)
  local l = {}
  for i=0,hsize-1 do
    local key,val,next = T.querytab(t, i + asize)
    if key == nil then
      assert(l[i] == nil and val==nil and next==nil)
    elseif key == "<undef>" then
      assert(val==nil)
    else
      assert(t[key] == val)
      local mp = T.hash(key, t)
      if l[i] then
        assert(l[i] == mp)
      elseif mp ~= i then
        l[i] = mp
      else  -- list head
        l[mp] = {mp}   -- first element
        while next do
          assert(ff <= next and next < hsize)
          if l[next] then assert(l[next] == mp) else l[next] = mp end
          table.insert(l[mp], next)
          key,val,next = T.querytab(t, next)
          assert(key)
        end
      end
    end
  end
  l.asize = asize; l.hsize = hsize; l.ff = ff
  return l
end

function mostra (t)
  local asize, hsize, ff = T.querytab(t)
  _print(asize, hsize, ff)
  _print'------'
  for i=0,asize-1 do
    local _, v = T.querytab(t, i)
    _print(string.format("[%d] -", i), v)
  end
  _print'------'
  for i=0,hsize-1 do
    _print(i, T.querytab(t, i+asize))
  end
  _print'-------------'
end

function stat (t)
  t = checktable(t)
  local nelem, nlist = 0, 0
  local maxlist = {}
  for i=0,t.hsize-1 do
    if type(t[i]) == 'table' then
      local n = table.getn(t[i])
      nlist = nlist+1
      nelem = nelem + n
      if not maxlist[n] then maxlist[n] = 0 end
      maxlist[n] = maxlist[n]+1
    end
  end
  _print(string.format("hsize=%d  elements=%d  load=%.2f  med.len=%.2f (asize=%d)",
    t.hsize, nelem, nelem/t.hsize, nelem/nlist, t.asize))
  for i=1,table.getn(maxlist) do
    local n = maxlist[i] or 0
    _print(string.format("%5d %10d %.2f%%", i, n, n*100/nlist))
  end
end

stat(a)

a = nil

-- testing implicit convertions

local a,b = '10', '20'
assert(a*b == 200 and a+b == 30 and a-b == -10 and a/b == 0.5 and -b == -20)
assert(a == '10' and b == '20')


math.randomseed(0)

local i = 0
local Max = 0
local Min = 2
repeat
  local t = math.random()
  Max = math.max(Max, t)
  Min = math.min(Min, t)
  i=i+1
  flag = eq(Max, 1, 0.001) and eq(Min, 0, 0.001)
until flag or i>10000
assert(0 <= Min and Max<1)
assert(flag);

for i=1,10 do
  local t = math.random(5)
  assert(1 <= t and t <= 5)
end

i = 0
Max = -200
Min = 200
repeat
  local t = math.random(-10,0)
  Max = math.max(Max, t)
  Min = math.min(Min, t)
  i=i+1
  flag = (Max == 0 and Min == -10)
until flag or i>10000
assert(-10 <= Min and Max<=0)
assert(flag);

_print('OK')
