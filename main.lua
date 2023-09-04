local Everything = require( "lua-everything" )

Everything.SetSearch( "my_n" )
Everything.SetRequestFlags( Everything.REQUEST_FILE_NAME, Everything.REQUEST_PATH,  Everything.REQUEST_EXTENSION, Everything.REQUEST_SIZE)
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

function lovr.draw( pass )
	pass:setColor( 0.2, 0.3, 0.5 )
	pass:plane( 0, 0, 0, 6, 6, math.pi / 2, 1, 0, 0 )
end
