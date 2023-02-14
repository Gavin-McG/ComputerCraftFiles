--digs out a 16 x 16 hole
--doesnt keep any resources
--first parameter is depth to dig

--start turtle next to storage block with fuel
--initial position will be the front-left block when facing the fuel storage

--confirm parameters
if arg[1]==nil then
    print("Usage: ./dig16x16.lua [depth]")
    return nil
end

local depth = tonumber(arg[1])
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

--start digging 
--+1 layer added for starting layer

--keep track of position
local x=0
local y=0
local z=0
local direction = 0

--returns amount to change x based on direction
local function xChange(dir)
    assert(dir<0 or dir>3, "Invalid input to xChange")
    if dir==0 or dir==2 then
        return 0
    elseif dir==1 then
        return -1
    elseif dir==3 then
        return 1
    end
    return nil
end

--returns amount to change y based on direction 
local function yChange(dir)
    assert(dir<0 or dir>3, "Invalid input to xChange")
    if dir==1 or dir==3 then
        return 0
    elseif dir==1 then
        return 1
    elseif dir==3 then
        return -1
    end
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
local function progressForward()
    if turtle.detect() then
        if not turtle.dig() then
            print("error digging block")
            print("exiting")
            return nil
        end
    end
    if turtle.forward() then
        x = x+xChange(direction)
        y = y+yChange(direction)
        return true
    else
        print("error moving forward")
        print("exiting")
        return nil
    end
end

--breaks block below the turtle and moves downward
local function progressDownward()
    if turtle.detectDown() then
        if not turtle.digDown() then
            print("error digging block")
            print("exiting")
            return nil
        end
    end
    if turtle.downward() then
        z = z-1
        return true
    else
        print("error moving downward")
        print("exiting")
        return nil
    end
end

--mine each layer
for i = 1,(depth+1) do
    --mine forward and back 8 times for a width of 16
    for j = 1,8 do

        for k = 1,15 do
            if not progressForward() then return nil end
        end

        leftDirection()
        if not progressForward() then return nil end
        leftDirection()

        for k = 1,15 do
            if not progressForward() then return nil end
        end

        if j~=8 then
            rightDirection()
            if not progressForward() then return nil end
            rightDirection()
        elseif i~=(depth+1) then
            if not progressDownward() then return nil end
            leftDirection()
        end
    end
end
print("mining completed")