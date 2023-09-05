local Everything = require( "lua-everything" )

Everything.SetSearch( "Program Files" )
Everything.SetRequestFlags( Everything.REQUEST_FILE_NAME, Everything.REQUEST_PATH, Everything.REQUEST_EXTENSION, Everything.REQUEST_SIZE, Everything.REQUEST_DATE_CREATED,
	Everything.REQUEST_DATE_MODIFIED, Everything.REQUEST_DATE_ACCESSED )
Everything.Query( true )
local count = Everything.GetNumResults()
print( "flags: " .. Everything.GetRequestFlags() )

-- for filename = 1, count do
-- 	print( Everything.GetResultFilename( filename ) )
-- end

print( "size: " .. tostring( Everything.GetResultSize( 3 ) ) )
print( Everything.IsFileResult( 1 ) )
print( Everything.GetResultPath( 2 ) )
print( Everything.GetResultExtension( (3) ) )
print( Everything.GetResultDateAccessed( 4 ) )
