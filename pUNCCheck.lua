-- ============================================================================
-- pUNC - Polytoria Unified Naming Convention (UNC) Compliance Test Suite
-- ============================================================================

local Suite = {
    Total = 0,
    Passed = 0,
    Failed = 0,
    Categories = {}
}

local currentCategory = nil

local function setCategory(name)
    currentCategory = {
        name = name,
        total = 0,
        passed = 0,
        failed = 0,
        tests = {}
    }
    table.insert(Suite.Categories, currentCategory)
    print(string.format("\n[%s]", name))
end

local function test(name, fn)
    Suite.Total = Suite.Total + 1
    currentCategory.total = currentCategory.total + 1

    local success, err = pcall(fn)

    if success then
        Suite.Passed = Suite.Passed + 1
        currentCategory.passed = currentCategory.passed + 1
        table.insert(currentCategory.tests, { name = name, passed = true })
        print(string.format("  ✔ [PASS] %s", name))
    else
        Suite.Failed = Suite.Failed + 1
        currentCategory.failed = currentCategory.failed + 1
        local errMsg = tostring(err or "Assertion failed")
        table.insert(currentCategory.tests, { name = name, passed = false, error = errMsg })
        print(string.format("  ✘ [FAIL] %s: %s", name, errMsg))
    end
end

local function assertEqual(actual, expected, message)
    if actual ~= expected then
        error(string.format("%s (expected: %s, got: %s)", message or "Values not equal", tostring(expected), tostring(actual)), 2)
    end
end

local function assertType(val, expectedType, message)
    local t = type(val)
    if t ~= expectedType then
        error(string.format("%s (expected type: %s, got: %s)", message or "Type mismatch", expectedType, t), 2)
    end
end

print("==========================================================")
print("     pUNC - Unified Naming Convention Test Suite          ")
print("==========================================================")

-- ============================================================================
-- 1. System
-- ============================================================================
setCategory("System")

test("identifyexecutor", function()
    assertType(identifyexecutor, "function", "identifyexecutor must be a function")
    local name, version = identifyexecutor()
    assertType(name, "string", "executor name must be a string")
    assertType(version, "string", "executor version must be a string")
    assert(#name > 0, "executor name must not be empty")
    assert(#version > 0, "executor version must not be empty")
end)

test("gethui", function()
    assertType(gethui, "function", "gethui must be a function")
    local hui = gethui()
    if hui ~= nil then
        assertType(hui, "userdata", "gethui must return a userdata instance")
    end
end)

test("getcustomasset", function()
    assertType(getcustomasset, "function", "getcustomasset must be a function")
    local testFile = "punc_customasset_test.png"
    local samplePng = "\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x08\x06\x00\x00\x00\x1f\x15\xc4\x89\x00\x00\x00\nIDATx\x9cc\x00\x01\x00\x00\x05\x00\x01\r\n-\xb4\x00\x00\x00\x00IEND\xaeB`\x82"
    writefile(testFile, samplePng)

    local assetId = getcustomasset(testFile)
    assertType(assetId, "string", "getcustomasset must return a string asset ID")
    assert(#assetId > 0, "getcustomasset returned empty asset ID")

    local cachedId = getcustomasset(testFile)
    assertEqual(cachedId, assetId, "getcustomasset should return cached ID by default")

    local freshId = getcustomasset(testFile, true)
    assertType(freshId, "string", "getcustomasset with noCache must return a string asset ID")

    delfile(testFile)
end)

test("getclipboard", function()
    assertType(getclipboard, "function", "getclipboard must be a function")
    local clip = getclipboard()
    assertType(clip, "string", "getclipboard must return a string")
end)

test("setclipboard", function()
    assertType(setclipboard, "function", "setclipboard must be a function")
    local testToken = "pUNC_TOKEN_" .. tostring(os.time())
    local ok = setclipboard(testToken)
    assert(ok == true or ok == nil or type(ok) == "boolean", "setclipboard returned invalid status")
    assertEqual(getclipboard(), testToken, "setclipboard value was not reflected in getclipboard")
    setclipboard("") -- clear clipboard after test
end)

test("setfpscap", function()
    assertType(setfpscap, "function", "setfpscap must be a function")
    setfpscap(60)
    setfpscap(0) -- 0 removes the cap
end)

-- ============================================================================
-- 2. Environment
-- ============================================================================
setCategory("Environment")

test("getgenv", function()
    assertType(getgenv, "function", "getgenv must be a function")
    local genv = getgenv()
    assertType(genv, "table", "getgenv must return a table")

    local key = "__punc_test_key_" .. tostring(os.time())
    genv[key] = 1337
    assertEqual(getgenv()[key], 1337, "getgenv value was not persisted across calls")
    genv[key] = nil
end)

test("getdefaultenv", function()
    assertType(getdefaultenv, "function", "getdefaultenv must be a function")
    local renv = getdefaultenv()
    assertType(renv, "table", "getdefaultenv must return a table")
    assert(renv.print ~= nil or renv.type ~= nil, "getdefaultenv missing standard globals")
end)

test("getreg", function()
    assertType(getreg, "function", "getreg must be a function")
    local reg = getreg()
    assertType(reg, "table", "getreg must return a table")
end)

test("getgc", function()
    assertType(getgc, "function", "getgc must be a function")
    local gc = getgc()
    assertType(gc, "table", "getgc must return a table")
    assert(#gc > 0, "getgc returned empty list")

    local gcWithTables = getgc(true)
    assertType(gcWithTables, "table", "getgc(true) must return a table")
    assert(#gcWithTables >= #gc, "getgc(true) should contain at least as many objects as getgc()")
end)

test("getloadedmodules", function()
    assertType(getloadedmodules, "function", "getloadedmodules must be a function")
    local modules = getloadedmodules()
    assertType(modules, "table", "getloadedmodules must return a table")
end)

test("getscripts", function()
    assertType(getscripts, "function", "getscripts must be a function")
    local scripts = getscripts()
    assertType(scripts, "table", "getscripts must return a table")
end)

-- ============================================================================
-- 3. Metatable
-- ============================================================================
setCategory("Metatable")

test("getrawmetatable", function()
    assertType(getrawmetatable, "function", "getrawmetatable must be a function")
    local tbl = {}
    local realMt = { __metatable = "Protected Metatable", marker = 42 }
    setmetatable(tbl, realMt)

    assertEqual(getmetatable(tbl), "Protected Metatable", "getmetatable should return the guard")
    local rawMt = getrawmetatable(tbl)
    assertType(rawMt, "table", "getrawmetatable must return the raw metatable")
    assertEqual(rawMt.marker, 42, "getrawmetatable did not return the actual underlying metatable")
end)

test("setrawmetatable", function()
    assertType(setrawmetatable, "function", "setrawmetatable must be a function")
    local tbl = {}
    local originalMt = { __metatable = "Protected" }
    setmetatable(tbl, originalMt)

    local newMt = { customKey = "pUNC_OK" }
    local res = setrawmetatable(tbl, newMt)
    assertEqual(res, true, "setrawmetatable must return true on success")
    assertEqual(getrawmetatable(tbl).customKey, "pUNC_OK", "setrawmetatable failed to replace metatable")
end)

test("setreadonly", function()
    assertType(setreadonly, "function", "setreadonly must be a function")
    local tbl = { value = 10 }
    setreadonly(tbl, true)
    local writeOk = pcall(function() tbl.value = 20 end)
    assert(not writeOk, "writing to readonly table must throw error")
    setreadonly(tbl, false)
    tbl.value = 30
    assertEqual(tbl.value, 30, "modifying table after setreadonly(false) failed")
end)

test("isreadonly", function()
    assertType(isreadonly, "function", "isreadonly must be a function")
    local tbl = { value = 10 }
    assertEqual(isreadonly(tbl), false, "new table must not be readonly")
    setreadonly(tbl, true)
    assertEqual(isreadonly(tbl), true, "table must be readonly after setreadonly(true)")
    setreadonly(tbl, false)
    assertEqual(isreadonly(tbl), false, "table must be writable after setreadonly(false)")
end)

test("getnamecallmethod", function()
    assertType(getnamecallmethod, "function", "getnamecallmethod must be a function")
    local current = getnamecallmethod()
    assert(current == nil or type(current) == "string", "getnamecallmethod must return nil or string")
end)

test("setnamecallmethod", function()
    assertType(setnamecallmethod, "function", "setnamecallmethod must be a function")
    setnamecallmethod("CustomMethod")
end)

test("hookmetamethod", function()
    assertType(hookmetamethod, "function", "hookmetamethod must be a function")

    local tbl = {}
    local mt = {
        __index = function(_, key)
            return "orig_" .. tostring(key)
        end
    }
    setmetatable(tbl, mt)

    local originalIndex
    originalIndex = hookmetamethod(tbl, "__index", newcclosure(function(self, key)
        return "hooked_" .. originalIndex(self, key)
    end))

    assertType(originalIndex, "function", "hookmetamethod must return the original function")
    assertEqual(tbl.testKey, "hooked_orig_testKey", "hooked metamethod did not execute correctly")

    restorefunction(originalIndex)
end)

-- ============================================================================
-- 4. Closures
-- ============================================================================
setCategory("Closures")

test("newcclosure", function()
    assertType(newcclosure, "function", "newcclosure must be a function")
    local function add(a, b) return a + b end
    local cFn = newcclosure(add)

    assertType(cFn, "function", "newcclosure must return a function")
    assertEqual(iscclosure(cFn), true, "newcclosure result must be a C closure")
    assertEqual(cFn(15, 27), 42, "newcclosure result returned incorrect value")
end)

test("newlclosure", function()
    assertType(newlclosure, "function", "newlclosure must be a function")
    local function mult(a, b) return a * b end
    local lFn = newlclosure(mult)

    assertType(lFn, "function", "newlclosure must return a function")
    assertEqual(iscclosure(lFn), false, "newlclosure result must not be a C closure")
    assertEqual(lFn(6, 7), 42, "newlclosure result returned incorrect value")
end)

test("iscclosure", function()
    assertType(iscclosure, "function", "iscclosure must be a function")
    assertEqual(iscclosure(print), true, "print must be a C closure")
    local function luaFn() return 1 end
    assertEqual(iscclosure(luaFn), false, "lua function must not be a C closure")
end)

test("isexecutorclosure", function()
    assertType(isexecutorclosure, "function", "isexecutorclosure must be a function")
    assertEqual(isexecutorclosure(readfile), true, "readfile must be an executor closure")
    assertEqual(isexecutorclosure(print), false, "engine print must not be an executor closure")
end)

test("clonefunction", function()
    assertType(clonefunction, "function", "clonefunction must be a function")
    local function square(x) return x * x end
    local cloned = clonefunction(square)

    assertType(cloned, "function", "clonefunction must return a function")
    assert(cloned ~= square, "cloned function must have distinct identity")
    assertEqual(cloned(9), 81, "cloned function produced incorrect output")
end)

test("hookfunction", function()
    assertType(hookfunction, "function", "hookfunction must be a function")
    local function targetFunc() return "original_output" end
    local hookInvoked = false

    local originalBackup = hookfunction(targetFunc, function()
        hookInvoked = true
        return "hooked_output"
    end)

    assertType(originalBackup, "function", "hookfunction must return original function backup")
    assertEqual(targetFunc(), "hooked_output", "hooked function returned unexpected result")
    assertEqual(hookInvoked, true, "hook was not invoked")
    assertEqual(originalBackup(), "original_output", "original backup returned unexpected result")

    restorefunction(targetFunc)
    assertEqual(targetFunc(), "original_output", "restorefunction failed to restore original function")
end)

test("restorefunction", function()
    assertType(restorefunction, "function", "restorefunction must be a function")
    local function targetFunc() return "unmodified" end
    hookfunction(targetFunc, function() return "modified" end)
    assertEqual(targetFunc(), "modified", "hookfunction failed to detour")
    restorefunction(targetFunc)
    assertEqual(targetFunc(), "unmodified", "restorefunction failed to restore original function")
end)

-- ============================================================================
-- 5. Debug
-- ============================================================================
setCategory("Debug")

test("debug.getinfo", function()
    assertType(debug.getinfo, "function", "debug.getinfo must be a function")
    local function sampleFn(a, b, c) return a + b + c end
    local info = debug.getinfo(sampleFn)

    assertType(info, "table", "debug.getinfo must return a table")
    assertType(info.source, "string", "info.source must be a string")
    assertType(info.what, "string", "info.what must be a string")
    assertEqual(info.numparams, 3, "info.numparams mismatch")
    assertEqual(info.is_vararg, false, "info.is_vararg mismatch")
    assertEqual(info.func, sampleFn, "info.func must reference the queried function")

    local stackInfo = debug.getinfo(1)
    assertType(stackInfo, "table", "debug.getinfo(level) must return a table")
    assertType(stackInfo.currentline, "number", "stackInfo.currentline must be a number")
end)

test("debug.getupvalues", function()
    assertType(debug.getupvalues, "function", "debug.getupvalues must be a function")
    local captured = 100
    local function testUpval() return captured end

    local uvs = debug.getupvalues(testUpval)
    assertType(uvs, "table", "debug.getupvalues must return a table")
    assertEqual(uvs[1] or uvs.captured, 100, "debug.getupvalues returned incorrect value")
end)

test("debug.getupvalue", function()
    assertType(debug.getupvalue, "function", "debug.getupvalue must be a function")
    local captured = 100
    local function testUpval() return captured end

    local uvVal = debug.getupvalue(testUpval, 1)
    assertEqual(uvVal, 100, "debug.getupvalue returned incorrect value")
end)

test("debug.setupvalue", function()
    assertType(debug.setupvalue, "function", "debug.setupvalue must be a function")
    local captured = 100
    local function testUpval() return captured end

    debug.setupvalue(testUpval, 1, 999)
    assertEqual(testUpval(), 999, "debug.setupvalue failed to update upvalue")
end)

test("debug.getconstants", function()
    assertType(debug.getconstants, "function", "debug.getconstants must be a function")
    local function constTarget() return "original_constant" end

    local constants = debug.getconstants(constTarget)
    assertType(constants, "table", "debug.getconstants must return a table")

    local found = false
    for _, c in pairs(constants) do
        if c == "original_constant" then
            found = true
            break
        end
    end
    assert(found, "constant 'original_constant' not found in constants table")
end)

test("debug.getconstant", function()
    assertType(debug.getconstant, "function", "debug.getconstant must be a function")
    local function constTarget() return "original_constant" end

    local constants = debug.getconstants(constTarget)
    local targetIndex = nil
    for idx, c in pairs(constants) do
        if c == "original_constant" then
            targetIndex = idx
            break
        end
    end
    assert(targetIndex ~= nil, "constant 'original_constant' not found in constants table")
    assertEqual(debug.getconstant(constTarget, targetIndex), "original_constant", "debug.getconstant returned wrong value")
end)

test("debug.setconstant", function()
    assertType(debug.setconstant, "function", "debug.setconstant must be a function")
    local function constTarget() return "original_constant" end

    local constants = debug.getconstants(constTarget)
    local targetIndex = nil
    for idx, c in pairs(constants) do
        if c == "original_constant" then
            targetIndex = idx
            break
        end
    end
    assert(targetIndex ~= nil, "constant 'original_constant' not found in constants table")

    debug.setconstant(constTarget, targetIndex, "modified_constant")
    assertEqual(constTarget(), "modified_constant", "debug.setconstant failed to modify constant pool")
end)

test("debug.getprotos", function()
    assertType(debug.getprotos, "function", "debug.getprotos must be a function")
    local function parentFn()
        local function childFn() return "child_orig" end
        return childFn()
    end

    local protos = debug.getprotos(parentFn)
    assertType(protos, "table", "debug.getprotos must return a table")
    assert(#protos >= 1, "debug.getprotos returned empty array")
end)

test("debug.getproto", function()
    assertType(debug.getproto, "function", "debug.getproto must be a function")
    local function parentFn()
        local function childFn() return "child_orig" end
        return childFn()
    end

    local proto1 = debug.getproto(parentFn, 1)
    assertType(proto1, "function", "debug.getproto must return a function")
    assertEqual(proto1(), "child_orig", "retrieved proto returned unexpected value")
end)

test("debug.setproto", function()
    assertType(debug.setproto, "function", "debug.setproto must be a function")
    local function parentFn()
        local function childFn() return "child_orig" end
        return childFn()
    end

    local function replacement() return "child_replaced" end
    debug.setproto(parentFn, 1, replacement)
    assertEqual(parentFn(), "child_replaced", "debug.setproto failed to replace child proto")
end)

test("debug.getstack", function()
    assertType(debug.getstack, "function", "debug.getstack must be a function")
    local localVal = 555
    local stackTbl = debug.getstack(1)
    assertType(stackTbl, "table", "debug.getstack(1) must return a table of stack slots")

    local slotVal = debug.getstack(1, 1)
    assert(slotVal ~= nil or stackTbl[1] ~= nil, "debug.getstack failed to retrieve slot")
end)

test("debug.setstack", function()
    assertType(debug.setstack, "function", "debug.setstack must be a function")
    local x = 10
    debug.setstack(1, 1, 20)
    assert(x == 20 or debug.getstack(1, 1) == 20, "debug.setstack failed")
end)

-- ============================================================================
-- 6. Filesystem
-- ============================================================================
setCategory("Filesystem")

test("readfile", function()
    assertType(readfile, "function", "readfile must be a function")
    local testFile = "punc_readfile_test.txt"
    writefile(testFile, "pUNC_READ_CONTENT")
    local content = readfile(testFile)
    assertEqual(content, "pUNC_READ_CONTENT", "readfile content mismatch")
    delfile(testFile)
end)

test("writefile", function()
    assertType(writefile, "function", "writefile must be a function")
    local testFile = "punc_writefile_test.txt"
    writefile(testFile, "pUNC_WRITE_CONTENT")
    assertEqual(readfile(testFile), "pUNC_WRITE_CONTENT", "writefile content mismatch")
    delfile(testFile)
end)

test("appendfile", function()
    assertType(appendfile, "function", "appendfile must be a function")
    local testFile = "punc_appendfile_test.txt"
    writefile(testFile, "PART1")
    appendfile(testFile, "_PART2")
    assertEqual(readfile(testFile), "PART1_PART2", "appendfile content mismatch")
    delfile(testFile)
end)

test("loadfile", function()
    assertType(loadfile, "function", "loadfile must be a function")
    local scriptPath = "punc_loadfile_test.lua"
    writefile(scriptPath, "local a, b = ...; return (a or 10) * (b or 2)")

    local chunk, err = loadfile(scriptPath)
    assertType(chunk, "function", "loadfile must return function chunk, error: " .. tostring(err))
    assertEqual(chunk(6, 7), 42, "loadfile chunk execution returned wrong result")
    delfile(scriptPath)
end)

test("listfiles", function()
    assertType(listfiles, "function", "listfiles must be a function")
    local files = listfiles("")
    assertType(files, "table", "listfiles must return a table")
end)

test("isfile", function()
    assertType(isfile, "function", "isfile must be a function")
    local testFile = "punc_isfile_test.txt"
    writefile(testFile, "exists")
    assertEqual(isfile(testFile), true, "isfile must return true for existing file")
    assertEqual(isfile("punc_nonexistent_xyz.txt"), false, "isfile must return false for missing file")
    delfile(testFile)
end)

test("isfolder", function()
    assertType(isfolder, "function", "isfolder must be a function")
    local testDir = "punc_isfolder_test"
    makefolder(testDir)
    assertEqual(isfolder(testDir), true, "isfolder must return true after makefolder")
    assertEqual(isfolder("punc_nonexistent_dir_xyz"), false, "isfolder must return false for missing folder")
    delfolder(testDir)
end)

test("makefolder", function()
    assertType(makefolder, "function", "makefolder must be a function")
    local testDir = "punc_makefolder_test"
    makefolder(testDir)
    assertEqual(isfolder(testDir), true, "makefolder failed to create folder")
    delfolder(testDir)
end)

test("delfile", function()
    assertType(delfile, "function", "delfile must be a function")
    local testFile = "punc_delfile_test.txt"
    writefile(testFile, "delete_me")
    assertEqual(isfile(testFile), true)
    delfile(testFile)
    assertEqual(isfile(testFile), false, "delfile failed to remove file")
end)

test("delfolder", function()
    assertType(delfolder, "function", "delfolder must be a function")
    local testDir = "punc_delfolder_test"
    makefolder(testDir)
    assertEqual(isfolder(testDir), true)
    delfolder(testDir)
    assertEqual(isfolder(testDir), false, "delfolder failed to remove folder")
end)

-- ============================================================================
-- 7. Scripts
-- ============================================================================
setCategory("Scripts")

test("loadstring", function()
    assertType(loadstring, "function", "loadstring must be a function")
    local chunk, err = loadstring("local x, y = ...; return x + y", "=punc_chunk")
    assertType(chunk, "function", "loadstring failed: " .. tostring(err))
    assertEqual(chunk(18, 24), 42, "loadstring execution failed")

    local badChunk, badErr = loadstring("this is ! an invalid syntax !!")
    assertEqual(badChunk, nil, "loadstring must return nil on syntax error")
    assertType(badErr, "string", "loadstring must return error message string")
end)

test("checkcaller", function()
    assertType(checkcaller, "function", "checkcaller must be a function")
    assertEqual(checkcaller(), true, "checkcaller must return true inside executor scripts")
end)

test("getsenv", function()
    assertType(getsenv, "function", "getsenv must be a function")
    local scripts = getrunningscripts and getrunningscripts() or (getscripts and getscripts() or {})
    if #scripts > 0 then
        local env = getsenv(scripts[1])
        assert(env == nil or type(env) == "table", "getsenv must return table or nil")
    end
end)

test("getscriptbytecode", function()
    assertType(getscriptbytecode, "function", "getscriptbytecode must be a function")
    local scripts = getrunningscripts and getrunningscripts() or (getscripts and getscripts() or {})
    if #scripts > 0 then
        local target = scripts[1]
        local bc = getscriptbytecode(target)
        if bc ~= nil then
            assertType(bc, "string", "getscriptbytecode must return a string")
            assert(#bc > 0, "bytecode string must not be empty")
        end
    end
end)

test("getscripthash", function()
    assertType(getscripthash, "function", "getscripthash must be a function")
    local scripts = getrunningscripts and getrunningscripts() or (getscripts and getscripts() or {})
    if #scripts > 0 then
        local target = scripts[1]
        local hash = getscripthash(target)
        if #hash > 0 then
            assertType(hash, "string", "getscripthash must return a string")
            assert(hash:match("^[0-9a-fA-F]+$"), "hash must be valid hex")
        end
    end
end)

test("getscriptclosure", function()
    assertType(getscriptclosure, "function", "getscriptclosure must be a function")
    local scripts = getrunningscripts and getrunningscripts() or (getscripts and getscripts() or {})
    if #scripts > 0 then
        local target = scripts[1]
        local closure = getscriptclosure(target)
        if closure ~= nil then
            assertType(closure, "function", "getscriptclosure must return a function")
        end
    end
end)

test("getcallingscript", function()
    assertType(getcallingscript, "function", "getcallingscript must be a function")
    local calling = getcallingscript()
    assert(calling == nil or type(calling) == "userdata", "getcallingscript must return nil or userdata")
end)

test("getrunningscripts", function()
    assertType(getrunningscripts, "function", "getrunningscripts must be a function")
    local running = getrunningscripts()
    assertType(running, "table", "getrunningscripts must return a table")
end)

-- ============================================================================
-- 8. Instances
-- ============================================================================
setCategory("Instances")

test("getinstances", function()
    assertType(getinstances, "function", "getinstances must be a function")
    local instances = getinstances()
    assertType(instances, "table", "getinstances must return a table")
    assert(#instances > 0, "getinstances must return at least one instance")

    local found = false
    for _, inst in ipairs(instances) do
        if type(inst) == "userdata" then
            found = true
            break
        end
    end
    assert(found, "getinstances must contain userdata instances")
end)

test("getnilinstances", function()
    assertType(getnilinstances, "function", "getnilinstances must be a function")
    local target = Instance.New("Part")
    local nilInstances = getnilinstances()
    assertType(nilInstances, "table", "getnilinstances must return a table")

    local found = false
    for _, inst in ipairs(nilInstances) do
        if inst == target then
            found = true
        end
        assertEqual(inst.Parent, nil, "all instances in getnilinstances must have Parent == nil")
    end
    assert(found, "getnilinstances must include newly created unparented instances")
end)

test("cloneref", function()
    assertType(cloneref, "function", "cloneref must be a function")
    local target = Instance.New("Part")
    local clone = cloneref(target)
    assertType(clone, "userdata", "cloneref must return userdata")
    assert(clone ~= target, "cloneref must return a distinct proxy object")
end)

test("compareinstances", function()
    assertType(compareinstances, "function", "compareinstances must be a function")
    local target = Instance.New("Part")
    local clone = cloneref(target)
    assertEqual(compareinstances(target, clone), true, "compareinstances must return true for clones of same instance")
    assertEqual(compareinstances(target, target), true, "compareinstances must return true for identical reference")
end)

test("cache.invalidate", function()
    assertType(cache, "table", "cache must be a table")
    assertType(cache.invalidate, "function", "cache.invalidate must be a function")
    local target = Instance.New("Part")
    cache.invalidate(target)
    assertEqual(cache.iscached(target), false, "cache.invalidate failed to remove entry")
end)

test("cache.iscached", function()
    assertType(cache, "table", "cache must be a table")
    assertType(cache.iscached, "function", "cache.iscached must be a function")
    local target = Instance.New("Part")
    assertEqual(cache.iscached(target), true, "target instance should initially be cached")
end)

test("cache.replace", function()
    assertType(cache, "table", "cache must be a table")
    assertType(cache.replace, "function", "cache.replace must be a function")
    local target1 = Instance.New("Part")
    local target2 = Instance.New("Part")
    cache.replace(target1, target2)
    assertEqual(cache.iscached(target2), true, "cache.replace failed to restore entry")
end)

test("firephysicaltouch", function()
    assertType(firephysicaltouch, "function", "firephysicaltouch must be a function")
end)

test("firephysicalclick", function()
    assertType(firephysicalclick, "function", "firephysicalclick must be a function")
end)

test("fireinteractionprompt", function()
    assertType(fireinteractionprompt, "function", "fireinteractionprompt must be a function")
end)

-- ============================================================================
-- 9. Signals
-- ============================================================================
setCategory("Signals")

test("firesignal", function()
    assertType(firesignal, "function", "firesignal must be a function")
    local part = Instance.New("Part")
    local received = nil
    local count = 0

    local conn = part.ChildAdded:Connect(function(...)
        count = count + 1
        received = { ... }
    end)

    firesignal(part.ChildAdded, "test_child", 42, true)
    assertEqual(count, 1, "firesignal did not trigger connected listener")
    assert(received ~= nil, "firesignal did not pass arguments")
    assertEqual(#received, 3, "firesignal did not forward all arguments")
    assertEqual(received[1], "test_child", "firesignal arg 1 mismatch")
    assertEqual(received[2], 42, "firesignal arg 2 mismatch")
    assertEqual(received[3], true, "firesignal arg 3 mismatch")

    conn:Disconnect()
end)

test("getconnections", function()
    assertType(getconnections, "function", "getconnections must be a function")
    local part = Instance.New("Part")
    local dummyFn = function() end
    local connRef = part.ChildAdded:Connect(dummyFn)

    local conns = getconnections(part.ChildAdded)
    assertType(conns, "table", "getconnections must return an array/table")
    assert(#conns >= 1, "getconnections must contain at least 1 connection")

    local conn = conns[1]
    assertType(conn, "table", "connection must be a table or object")
    assertType(conn.Enabled, "boolean", "conn.Enabled must be a boolean")
    assertEqual(conn.Enabled, true, "new connection should be enabled by default")
    assertType(conn.LuaConnection, "boolean", "conn.LuaConnection must be a boolean")
    assertEqual(conn.LuaConnection, true, "Lua callback must have LuaConnection = true")
    assertType(conn.Function, "function", "conn.Function must return the connected function")
    assertEqual(conn.Function, dummyFn, "conn.Function must match connected function")

    assertType(conn.Disconnect, "function", "conn:Disconnect must be a function")
    assertType(conn.Fire, "function", "conn:Fire must be a function")
    assertType(conn.Defer, "function", "conn:Defer must be a function")

    -- Enabled property toggling
    conn.Enabled = false
    assertEqual(conn.Enabled, false, "conn.Enabled must be false after disabling")
    conn.Enabled = true
    assertEqual(conn.Enabled, true, "conn.Enabled must be true after re-enabling")

    -- Disconnect lifecycle
    conn:Disconnect()
    assertEqual(conn.Enabled, false, "conn.Enabled must be false after disconnect")
end)

-- ============================================================================
-- 10. Input
-- ============================================================================
setCategory("Input")

test("keypress", function()
    assertType(keypress, "function", "keypress must be a function")
    keypress(0)
end)

test("keyrelease", function()
    assertType(keyrelease, "function", "keyrelease must be a function")
    keyrelease(0)
end)

test("mouse1press", function()
    assertType(mouse1press, "function", "mouse1press must be a function")
    mouse1press()
end)

test("mouse1release", function()
    assertType(mouse1release, "function", "mouse1release must be a function")
    mouse1release()
end)

test("mouse1click", function()
    assertType(mouse1click, "function", "mouse1click must be a function")
    mouse1click()
end)

test("mouse2press", function()
    assertType(mouse2press, "function", "mouse2press must be a function")
    mouse2press()
end)

test("mouse2release", function()
    assertType(mouse2release, "function", "mouse2release must be a function")
    mouse2release()
end)

test("mouse2click", function()
    assertType(mouse2click, "function", "mouse2click must be a function")
    mouse2click()
end)

test("mousemoveabs", function()
    assertType(mousemoveabs, "function", "mousemoveabs must be a function")
    mousemoveabs(0, 0)
end)

test("mousemoverel", function()
    assertType(mousemoverel, "function", "mousemoverel must be a function")
    mousemoverel(0, 0)
end)

test("mousescroll", function()
    assertType(mousescroll, "function", "mousescroll must be a function")
    mousescroll(0)
end)

-- ============================================================================
-- 11. Cryptography
-- ============================================================================
setCategory("Cryptography")

test("crypt.hash", function()
    assertType(crypt, "table", "crypt must be a table")
    assertType(crypt.hash, "function", "crypt.hash must be a function")
    local expectedSha256 = "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"
    local computedHash = crypt.hash("hello", "sha256")
    assertEqual(computedHash, expectedSha256, "crypt.hash sha256 mismatch")
end)

test("crypt.encrypt", function()
    assertType(crypt, "table", "crypt must be a table")
    assertType(crypt.encrypt, "function", "crypt.encrypt must be a function")
    local sampleData = "pUNC Test AES Payload"
    local key = crypt.generatekey()
    local cipher, iv = crypt.encrypt(sampleData, key, nil, "CBC")
    assertType(cipher, "string", "crypt.encrypt cipher must be string")
    assertType(iv, "string", "crypt.encrypt IV must be string")
    assert(#cipher > 0 and #iv > 0, "cipher and iv must not be empty")
end)

test("crypt.decrypt", function()
    assertType(crypt, "table", "crypt must be a table")
    assertType(crypt.decrypt, "function", "crypt.decrypt must be a function")
    local sampleData = "pUNC Test AES Payload"
    local key = crypt.generatekey()
    local cipher, iv = crypt.encrypt(sampleData, key, nil, "CBC")
    local decrypted = crypt.decrypt(cipher, key, iv, "CBC")
    assertEqual(decrypted, sampleData, "crypt.decrypt round-trip failed")
end)

test("crypt.generatebytes", function()
    assertType(crypt, "table", "crypt must be a table")
    assertType(crypt.generatebytes, "function", "crypt.generatebytes must be a function")
    local b16 = crypt.generatebytes(16)
    assertType(b16, "string", "generatebytes(16) must return string")
    assertEqual(#b16, 16, "generatebytes(16) length mismatch")
    local b32 = crypt.generatebytes(32)
    assertEqual(#b32, 32, "generatebytes(32) length mismatch")
end)

test("crypt.generatekey", function()
    assertType(crypt, "table", "crypt must be a table")
    assertType(crypt.generatekey, "function", "crypt.generatekey must be a function")
    local key = crypt.generatekey()
    assertType(key, "string", "generatekey must return string")
    assert(#key > 0, "generatekey returned empty string")
end)

-- ============================================================================
-- 12. Encoding
-- ============================================================================
setCategory("Encoding")

test("base64encode", function()
    assertType(base64encode, "function", "base64encode must be a function")
    local raw = "pUNC Base64 UNC Verification"
    local encoded = base64encode(raw)
    assertEqual(encoded, "cFVOQyBCYXNlNjQgVU5DIFZlcmlmaWNhdGlvbg==", "base64encode mismatch")
end)

test("base64decode", function()
    assertType(base64decode, "function", "base64decode must be a function")
    local raw = "pUNC Base64 UNC Verification"
    local encoded = "cFVOQyBCYXNlNjQgVU5DIFZlcmlmaWNhdGlvbg=="
    local decoded = base64decode(encoded)
    assertEqual(decoded, raw, "base64decode round-trip failed")
end)

test("lz4compress", function()
    assertType(lz4compress, "function", "lz4compress must be a function")
    local text = string.rep("pUNC-LZ4-Pattern-Test-String-", 64) .. "\0\1\2\3"
    local compressed = lz4compress(text)
    assertType(compressed, "string", "lz4compress must return a string")
    assert(#compressed > 0, "compressed data must not be empty")
    assert(#compressed < #text, "compressed size should be smaller than raw text")
end)

test("lz4decompress", function()
    assertType(lz4decompress, "function", "lz4decompress must be a function")
    local text = string.rep("pUNC-LZ4-Pattern-Test-String-", 64) .. "\0\1\2\3"
    local compressed = lz4compress(text)
    local decompressed = lz4decompress(compressed, #text)
    assertEqual(decompressed, text, "lz4decompress text round-trip failed")
end)

-- ============================================================================
-- 13. HTTP Networking
-- ============================================================================
setCategory("HTTP Networking")

test("request", function()
    assertType(request, "function", "request must be a function")
    local response = request({
        Url = "https://httpbin.org/get",
        Method = "GET"
    })
    assertType(response, "table", "request must return a table")
    assertType(response.StatusCode, "number", "response.StatusCode must be a number")
    assertEqual(response.StatusCode, 200, "response.StatusCode expected 200")
    assertType(response.Body, "string", "response.Body must be a string")
    assert(#response.Body > 0, "response.Body must not be empty")
    assertType(response.Headers, "table", "response.Headers must be a table")
end)

test("httpget", function()
    assertType(httpget, "function", "httpget must be a function")
    local body = httpget("https://httpbin.org/get")
    assertType(body, "string", "httpget must return a string")
    assert(#body > 0, "httpget body must not be empty")
end)

test("WebSocket", function()
    assertType(WebSocket, "table", "WebSocket must be a table")
    assertType(WebSocket.connect, "function", "WebSocket.connect must be a function")
    assertType(websocket, "table", "websocket must be a table")
    assertType(websocket.connect, "function", "websocket.connect must be a function")

    local ok, err = pcall(function()
        WebSocket.connect("invalid_url_format")
    end)
    assert(not ok, "WebSocket.connect should throw on invalid url format")
end)

-- ============================================================================
-- Final Summary & Compliance Report
-- ============================================================================
print("\n==========================================================")
print("             pUNC TEST SUITE SUMMARY                      ")
print("==========================================================")

for _, cat in ipairs(Suite.Categories) do
    local catPct = cat.total > 0 and math.floor((cat.passed / cat.total) * 1000) / 10 or 0
    print(string.format("  %-25s : %2d/%-2d passed  (%5.1f%%)", cat.name, cat.passed, cat.total, catPct))
end

local overallPct = Suite.Total > 0 and math.floor((Suite.Passed / Suite.Total) * 1000) / 10 or 0

print("----------------------------------------------------------")
print(string.format("  Total Tests Run : %d", Suite.Total))
print(string.format("  Passed Tests    : %d", Suite.Passed))
print(string.format("  Failed Tests    : %d", Suite.Failed))
print(string.format("  UNC Compliance  : %.1f%%", overallPct))
print("==========================================================")
