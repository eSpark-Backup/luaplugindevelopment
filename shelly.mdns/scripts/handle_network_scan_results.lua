local logging = require ("logging")

local params = ... or {}
logging.info("Receiving Msgs = "..#params)
    
        for k,v in pairs(params)
         do
            if ( type(v) == "table" ) then 
               for s,t in pairs(v)
                  do
                     logging.info("Table Details:" .. tostring( s ) .. " And TableValuesssszzzz=" .. tostring( t ) )
                  end                        
            end

            logging.info("Keysssss#1:" .. tostring( k ) .. " And Valuesssss##=" .. tostring( v ) )
         end
        return 'OK'