local Everything = require( "lua-everything" )

Everything.SetSearch( "Program Files" )
Everything.SetRequestFlags( Everything.REQUEST_FILE_NAME, EVERYTHING_REQUEST_PATH )
Everything.Query( true )
local count = Everything.GetNumResults()
print( "flags: " .. Everything.GetRequestFlags() )

for filename = 1, count do
	print( Everything.GetResultFilename( filename ) )
end
-- print( "size: " .. tostring( Everything.GetResultSize( 2 ) ) )
print( Everything.IsFileResult( 1 ) )

function lovr.draw( pass )
	pass:setColor( 0.2, 0.3, 0.5 )
	pass:plane( 0, 0, 0, 6, 6, math.pi / 2, 1, 0, 0 )
end
