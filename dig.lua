--digs out a 16 x 16 hole
--doesnt keep any resources
--first parameter is depth to dig

--start turtle next to storage block with fuel
--starting layer should be cleared
--initial position will be the front-right block when facing the fuel storage

--confirm parameters
if arg[1]==nil or arg[2]==nil or arg[3]==nil then
    print("Usage: ./dig.lua [width] [length] [depth]")
    print("or")
    print("Usage: ./dig.lua help")
    return nil
end

if arg[1]=="help" then
    print("Usage: ./dig.lua [width] [length] [depth]")
    print("")
    print("Turtle should be placed next do a storage container with suitable fuel source.")
    print("The starting layer of the turtle should be clear.")
    print("The turtle will mine out forward and right when facing away from the storage container")
    print("Top-down example:")
    print("")
    print("- = block to be mined")
    print("+ = turtle")
    print("X = storage block")
    print("")
    print("------")
    print("------")
    print("------")
    print("+-----")
    print("X")
end

local width = tonumber(arg[1])
local length = tonumber(arg[2])
local depth = tonumber(arg[3])

--maximum size
if (depth+1)*width*length>turtle.getFuelLimit() then
    print("size of hole must not exceed fuel limit")
    print("fuel limit: "..turtle.getFuelLimit())
    return nil
end

local fuel_needed = 16*16*(depth+1)
local initial_fuel = turtle.getFuelLevel()

--check that invetory is empty
turtle.select(1)
for i = 1,16 do
    if turtle.getItemCount(i)~=0 then
        print("Inventory must be empty before beginning")
        return nil
    end
end
print("inventory is empty")

--look for direction of fuel storage
local turns = 0
print("Current fuel..."..tostring(turtle.getFuelLevel()))

while turns<3 and (turtle.getFuelLevel()<fuel_needed or turtle.getFuelLevel()==initial_fuel) do
    if turtle.suck() then
        if turtle.refuel() then
            print("Current fuel..."..tostring(turtle.getFuelLevel()))
        elseif turtle.drop() then
            print("non-fuel item found. depositing it back into chest")
            turns=turns+1;
            print("turning to side "..tostring(turns))
            turtle.turnLeft()
        else
            print("error re-depositing non-fuel item")
            print("exiting")
            return nil
        end
    else
        turns=turns+1;
        print("turning to side "..tostring(turns))
        turtle.turnLeft()
    end
end

if turns>=4 then
    if turtle.getFuelLevel()==initial_fuel then
        print("no fuel found in any of four directions")
    else
        print("insufficient fuel found in chests for given depth")
    end
    return nil
end

print("Fuel chest located on side "..tostring(turns))

--turn to starting direction
turtle.turnLeft()
turtle.turnLeft()

--keep track of position
local x=0
local y=0
local z=0
local direction = 0

--changes x value based on diection
local function xIncrement()
    if direction==0 or direction==2 then
        return true
    elseif direction==1 then

        return true
    elseif direction==3 then
        return 1
    end
    return nil
end

--changes y amount based on forward direction
local function yIncrement()
    if direction==1 or direction==3 then
        return 0
    elseif direction==0 then
        return 1
    elseif direction==2 then
        return -1
    end
    return nil
end

--change x and y values based on forward direction
local function Increment()
    if xIncrement() and yIncrement() then return true end
    return nil
end

--turns turtle to the right
local function rightDirection()
    if turtle.turnRight() then
        direction = (direction+1)%4
        return true
    end
    print("error turning")
    return nil
end

--turns turtle to the left
local function leftDirection()
    if turtle.turnLeft() then
        direction = (direction-1)%4
        return true
    end
    print("error turning")
    return nil
end

--breaks the block in front of the turtle and moves forward
--n number of blocks to travel
local function progressForward(n)
    for i=1,n do
        if turtle.detect() then
            if not turtle.dig() then
                print("error digging block")
                print("exiting")
                return nil
            end
        end
        if turtle.forward() then
            x = x+xChange()
            y = y+yChange()
            return true
        else
            print("error moving forward")
            print("exiting")
            return nil
        end
    end
end

--breaks block below the turtle and moves downward
--n number of blocks to travel
local function progressDownward(n)
    for i=1,n do
        if turtle.detectDown() then
            if not turtle.digDown() then
                print("error digging block")
                print("exiting")
                return nil
            end
        end
        if turtle.down() then
            z = z-1
            return true
        else
            print("error moving downward")
            print("exiting")
            return nil
        end
    end
end

