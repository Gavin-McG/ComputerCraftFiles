local function readfile(path)
    local file = io.open(path,"rb")
    if not file then return nil end
    local content = file:read("a")

    file:close()
    return content
end


local output = readfile("text1.txt")
print(output)
