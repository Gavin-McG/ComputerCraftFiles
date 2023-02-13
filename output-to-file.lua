local file = io.open("text3.txt","w")

if not file then return nil end

for i = 1,200 do
    file:write(tostring(i*i).."\n")
end