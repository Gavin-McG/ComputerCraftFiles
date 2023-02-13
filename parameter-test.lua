if arg[1]==nil or arg[2]==nil then
    print("USAGE: parameter-test.lua [WIDTH] [HEIGHT]")
else
    print("Width: "..tostring(arg[1]))
    print("Height: "..tostring(arg[2]))

    local width = tonumber(arg[1])
    local height = tonumber(arg[2])

    print("Area: "..tostring(width*height))
    print("Permimeter: "..tostring(2*width + 2*height))
end

