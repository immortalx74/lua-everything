local ffi = require( "ffi" )
local e = ffi.load( "Everything64.dll" )
local bit = require( "bit" )

ffi.cdef [[
	typedef unsigned int DWORD;
	typedef const char* LPCTSTR;
	typedef const int BOOL;
	typedef __int64 LONGLONG;
	typedef long LONG;
	typedef union _LARGE_INTEGER {
		struct {
		  DWORD LowPart;
		  LONG  HighPart;
		} DUMMYSTRUCTNAME;
		struct {
		  DWORD LowPart;
		  LONG  HighPart;
		} u;
		LONGLONG QuadPart;
	  } LARGE_INTEGER;

	void Everything_SetSearchA(LPCTSTR lpString);
	int Everything_QueryA(BOOL bWait);
	DWORD Everything_GetNumResults(void);
	LPCTSTR Everything_GetResultFileNameA(DWORD index);
	void Everything_SetRequestFlags(DWORD dwRequestFlags);
	DWORD Everything_GetRequestFlags(void);
	BOOL Everything_GetResultSize(DWORD dwIndex, LARGE_INTEGER *lpSize);
	DWORD Everything_GetNumFolderResults(void);
	DWORD Everything_GetNumFileResults(void);
	BOOL Everything_IsVolumeResult(DWORD index);
	BOOL Everything_IsFolderResult(DWORD index);
	BOOL Everything_IsFileResult(DWORD index);
]]

local m = {}
m.REQUEST_FILE_NAME = 0x00000001
m.REQUEST_PATH = 0x00000002
m.REQUEST_FULL_PATH_AND_FILE_NAME = 0x00000004
m.REQUEST_EXTENSION = 0x00000008
m.REQUEST_SIZE = 0x00000010
m.REQUEST_DATE_CREATED = 0x00000020
m.REQUEST_DATE_MODIFIED = 0x00000040
m.REQUEST_DATE_ACCESSED = 0x00000080
m.REQUEST_ATTRIBUTES = 0x00000100
m.REQUEST_FILE_LIST_FILE_NAME = 0x00000200
m.REQUEST_RUN_COUNT = 0x00000400
m.REQUEST_DATE_RUN = 0x00000800
m.REQUEST_DATE_RECENTLY_CHANGED = 0x00001000
m.REQUEST_HIGHLIGHTED_FILE_NAME = 0x00002000
m.REQUEST_HIGHLIGHTED_PATH = 0x00004000
m.REQUEST_HIGHLIGHTED_FULL_PATH_AND_FILE_NAME = 0x00008000

function m.GetNumResults()
	return e.Everything_GetNumResults()
end

function m.GetRequestFlags()
	return e.Everything_GetRequestFlags()
end

function m.SetSearch( query_string )
	e.Everything_SetSearchA( query_string )
end

function m.Query( wait )
	e.Everything_QueryA( wait )
end

function m.GetResultFilename( index )
	if index > e.Everything_GetNumResults() or index < 1 then
		return nil
	else
		return ffi.string( e.Everything_GetResultFileNameA( index - 1 ) )
	end
end

function m.SetRequestFlags( ... ) --NOTE Doesn't work
	local arg = { ... }
	local flags = bit.bor( unpack( arg ) )
	local res = string.format( "%x", flags )
	return e.Everything_SetRequestFlags( tonumber( res ) )
end

function m.GetResultSize( index ) --NOTE Doesn't work
	local sz = ffi.new( "LARGE_INTEGER[1]" )
	e.Everything_GetResultSize( index, sz[ 0 ] )
	local size = sz[ 0 ].QuadPart
	return size
end

function m.GetNumFolderResults()
	return e.Everything_GetNumFolderResults()
end

function m.GetNumFileResults()
	return e.Everything_GetNumFileResults()
end

function m.IsVolumeResult( index )
	local is_volume = false
	if e.Everything_IsVolumeResult( index - 1 ) ~= 0 then is_volume = true end
	return is_volume
end

function m.IsFolderResult( index )
	local is_folder = false
	if e.Everything_IsFolderResult( index - 1 ) ~= 0 then is_folder = true end
	return is_folder
end

function m.IsFileResult( index )
	local is_file = false
	if e.Everything_IsFileResult( index - 1 ) ~= 0 then is_file = true end
	return is_file
end

return m
