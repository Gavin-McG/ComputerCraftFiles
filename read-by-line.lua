local file = io.open("text2.txt","rb")
if not file then return nil end

local lines = {}

local index = 1;
local current_line = file:read('*l')
while current_line do
    lines[index] = current_line
    current_line = file:read('*l')
    index = index+1;
end

index=1;
while lines[index]~=nil do
    print(tostring(index)..": "..lines[index])
    index = index+1;
end