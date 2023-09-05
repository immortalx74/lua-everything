local ffi = require( "ffi" )
local e = ffi.load( "Everything64.dll" )
local kernel32 = ffi.load( "kernel32.dll" )
local bit = require( "bit" )

ffi.cdef [[
	typedef unsigned int DWORD;
	typedef const char* LPCTSTR;
	typedef const int BOOL;
	typedef __int64 LONGLONG;
	typedef long LONG;
	typedef unsigned short WORD;
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

	  typedef struct _FILETIME {
		DWORD dwLowDateTime;
		DWORD dwHighDateTime;
	  } FILETIME, *PFILETIME, *LPFILETIME;

	  typedef struct _SYSTEMTIME {
		WORD wYear;
		WORD wMonth;
		WORD wDayOfWeek;
		WORD wDay;
		WORD wHour;
		WORD wMinute;
		WORD wSecond;
		WORD wMilliseconds;
	  } SYSTEMTIME, *PSYSTEMTIME, *LPSYSTEMTIME;

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
	LPCTSTR Everything_GetResultPathA(int index);
	LPCTSTR Everything_GetResultExtensionA(DWORD dwIndex);
	void Everything_Reset(void);
	void Everything_CleanUp(void);
	void Everything_SetMatchCase(BOOL bEnable);
	BOOL Everything_GetResultDateCreated(DWORD dwIndex, FILETIME *lpDateCreated);
	BOOL Everything_GetResultDateModified(DWORD dwIndex, FILETIME *lpDateModified);
	BOOL Everything_GetResultDateAccessed(DWORD dwIndex, FILETIME *lpDateAccessed);
	DWORD Everything_GetLastError(void);
	BOOL Everything_IsAdmin(void);
	void Everything_SetMax(DWORD dwMaxResults);
	void Everything_SetSort(DWORD dwSortType);
	void Everything_SetOffset(DWORD dwOffset);
	LPCTSTR Everything_GetSearchA(void);
	DWORD Everything_GetSort(void);
	DWORD Everything_GetTotFileResults(void);
	DWORD Everything_GetTotFolderResults(void);
	DWORD Everything_GetTotResults(void);

	BOOL FileTimeToSystemTime(const FILETIME *lpFileTime, LPSYSTEMTIME lpSystemTime);
]]

local m                                       = {}
m.REQUEST_FILE_NAME                           = 0x00000001
m.REQUEST_PATH                                = 0x00000002
m.REQUEST_FULL_PATH_AND_FILE_NAME             = 0x00000004
m.REQUEST_EXTENSION                           = 0x00000008
m.REQUEST_SIZE                                = 0x00000010
m.REQUEST_DATE_CREATED                        = 0x00000020
m.REQUEST_DATE_MODIFIED                       = 0x00000040
m.REQUEST_DATE_ACCESSED                       = 0x00000080
m.REQUEST_ATTRIBUTES                          = 0x00000100
m.REQUEST_FILE_LIST_FILE_NAME                 = 0x00000200
m.REQUEST_RUN_COUNT                           = 0x00000400
m.REQUEST_DATE_RUN                            = 0x00000800
m.REQUEST_DATE_RECENTLY_CHANGED               = 0x00001000
m.REQUEST_HIGHLIGHTED_FILE_NAME               = 0x00002000
m.REQUEST_HIGHLIGHTED_PATH                    = 0x00004000
m.REQUEST_HIGHLIGHTED_FULL_PATH_AND_FILE_NAME = 0x00008000

m.SORT_NAME_ASCENDING                         = 1
m.SORT_NAME_DESCENDING                        = 2
m.SORT_PATH_ASCENDING                         = 3
m.SORT_PATH_DESCENDING                        = 4
m.SORT_SIZE_ASCENDING                         = 5
m.SORT_SIZE_DESCENDING                        = 6
m.SORT_EXTENSION_ASCENDING                    = 7
m.SORT_EXTENSION_DESCENDING                   = 8
m.SORT_TYPE_NAME_ASCENDING                    = 9
m.SORT_TYPE_NAME_DESCENDING                   = 10
m.SORT_DATE_CREATED_ASCENDING                 = 11
m.SORT_DATE_CREATED_DESCENDING                = 12
m.SORT_DATE_MODIFIED_ASCENDING                = 13
m.SORT_DATE_MODIFIED_DESCENDING               = 14
m.SORT_ATTRIBUTES_ASCENDING                   = 15
m.SORT_ATTRIBUTES_DESCENDING                  = 16
m.SORT_FILE_LIST_FILENAME_ASCENDING           = 17
m.SORT_FILE_LIST_FILENAME_DESCENDING          = 18
m.SORT_RUN_COUNT_ASCENDING                    = 19
m.SORT_RUN_COUNT_DESCENDING                   = 20
m.SORT_DATE_RECENTLY_CHANGED_ASCENDING        = 21
m.SORT_DATE_RECENTLY_CHANGED_DESCENDING       = 22
m.SORT_DATE_ACCESSED_ASCENDING                = 23
m.SORT_DATE_ACCESSED_DESCENDING               = 24
m.SORT_DATE_RUN_ASCENDING                     = 25
m.SORT_DATE_RUN_DESCENDING                    = 26

m.OK                                          = 0
m.ERROR_MEMORY                                = 1
m.ERROR_IPC                                   = 2
m.ERROR_REGISTERCLASSEX                       = 3
m.ERROR_CREATEWINDOW                          = 4
m.ERROR_CREATETHREAD                          = 5
m.ERROR_INVALIDINDEX                          = 6
m.ERROR_INVALIDCALL                           = 7

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

function m.SetRequestFlags( ... )
	local arg = { ... }
	local flags = bit.bor( unpack( arg ) )
	return e.Everything_SetRequestFlags( flags )
end

function m.GetResultSize( index )
	local sz = ffi.new( "LARGE_INTEGER[1]" )
	e.Everything_GetResultSize( index - 1, sz )
	local size = sz[ 0 ].QuadPart
	return tonumber( size )
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

function m.GetResultPath( index )
	if index > e.Everything_GetNumResults() or index < 1 then
		return nil
	else
		return ffi.string( e.Everything_GetResultPathA( index - 1 ) )
	end
end

function m.GetResultExtension( index )
	if index > e.Everything_GetNumResults() or index < 1 then
		return nil
	else
		return ffi.string( e.Everything_GetResultExtensionA( index - 1 ) )
	end
end

function m.Reset()
	e.Everything_Reset()
end

function m.GetResultDateCreated( index )
	local ft = ffi.new( "FILETIME[1]" )
	local st = ffi.new( "SYSTEMTIME[1]" )
	local res = e.Everything_GetResultDateCreated( index - 1, ft )
	kernel32.FileTimeToSystemTime( ft, st )
	return st[ 0 ].wYear, st[ 0 ].wMonth, st[ 0 ].wDayOfWeek, st[ 0 ].wDay, st[ 0 ].wHour, st[ 0 ].wMinute, st[ 0 ].wSecond, st[ 0 ].wMilliseconds
end

function m.GetResultDateModified( index )
	local ft = ffi.new( "FILETIME[1]" )
	local st = ffi.new( "SYSTEMTIME[1]" )
	local res = e.Everything_GetResultDateModified( index - 1, ft )
	kernel32.FileTimeToSystemTime( ft, st )
	return st[ 0 ].wYear, st[ 0 ].wMonth, st[ 0 ].wDayOfWeek, st[ 0 ].wDay, st[ 0 ].wHour, st[ 0 ].wMinute, st[ 0 ].wSecond, st[ 0 ].wMilliseconds
end

function m.GetResultDateAccessed( index )
	local ft = ffi.new( "FILETIME[1]" )
	local st = ffi.new( "SYSTEMTIME[1]" )
	local res = e.Everything_GetResultDateAccessed( index - 1, ft )
	kernel32.FileTimeToSystemTime( ft, st )
	return st[ 0 ].wYear, st[ 0 ].wMonth, st[ 0 ].wDayOfWeek, st[ 0 ].wDay, st[ 0 ].wHour, st[ 0 ].wMinute, st[ 0 ].wSecond, st[ 0 ].wMilliseconds
end

function m.CleanUp()
	e.Everything_CleanUp();
end

function m.IsAdmin()
	local is_admin = false
	if e.Everything_IsAdmin() ~= 0 then is_admin = true end
	return is_admin;
end

function m.SetMatchCase( enable )
	if enable then
		e.Everything_SetMatchCase( 1 )
	else
		e.Everything_SetMatchCase( 0 )
	end
end

function m.SetMax( num_results )
	e.Everything_SetMax( num_results )
end

function m.SetSort( sort )
	e.Everything_SetSort( sort )
end

function m.GetLastError()
	return e.Everything_GetLastError()
end

function m.SetOffset( offset )
	e.Everything_SetOffset( offset )
end

function m.GetSearch()
	return ffi.string( e.Everything_GetSearchA() )
end

function m.GetSort()
	return e.Everything_GetSort()
end

function m.GetTotFileResults()
	return e.Everything_GetTotFileResults()
end

function m.GetTotFolderResults()
	return e.Everything_GetTotFolderResults()
end

function m.GetTotResults()
	return e.Everything_GetTotResults()
end

return m
