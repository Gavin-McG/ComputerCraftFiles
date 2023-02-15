--digs out a 16 x 16 hole
--doesnt keep any resources
--first parameter is depth to dig

--start turtle next to storage block with fuel
--starting layer should be cleared
--initial position will be the front-right block when facing the fuel storage

--help command
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

--confirm parameters
if arg[1]==nil or arg[2]==nil or arg[3]==nil then
    print("Usage: ./dig.lua [width] [length] [depth]")
    print("or")
    print("Usage: ./dig.lua help")
    return nil
end

local width = tonumber(arg[1])
local length = tonumber(arg[2])
local depth = tonumber(arg[3])

--comfirm invetory is empty
for i=1,16 do
    turtle.select(1);
    if turtle.getItemCount~=0 then
        print("inventory must be empty to start")
        return nil
    end
end

local function refuelToCapacity()
    print("refueling...")
    --slot 1 prioritized for fuel
    turtle.select(1)
    turtle.dropUp()

    --attempt to refuel until full
    while turtle.getFuelLevel() < turtle.getFuelLimit() do
        if turtle.suck() then
            if turtle.refuel() then
                print("Current fuel: "..turtle.getFuelLevel())
            elseif turtle.drop() then
                --non-fuel item deposited back into chest
                print("finished refueling - non-fuel item in chest")
                return true
            else
                --non-fuel item dropped upward
                turtle.dropUp()
                print("finished refueling - non-fuel item in chest")
                print("chest full - dropping items")
                return true
            end
        else
            --failed to get items from chest
            print("no more items to retrieve from chest")
            return true
        end
    end 

    print("turtle fueled to capacity")

    --drop any extra fuel
    if turtle.drop() then
        --extra fuel item deposited back into chest
        print("depositing extra fuel in chest")
    else
        --extra fuel item dropped upward
        turtle.dropUp()
        print("depositing extra fuel in chest")
        print("chest full - dropping items")
    end

    return true
end

--find direction of fuel chest

--turn to starting direction
turtle.turnLeft()
turtle.turnLeft()

--keep track of position
local x=0
local y=0
local z=0
local direction = 0
local nextSlot = 2
local items = {}

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

--moves item from slot 1 to next available slot
--drops if no space is avaiable
local function moveItem()
    turtle.select(1)
    local data = turtle.getItemDetail(1)
    --deposit iteem in first slot to known slots
    for i=2,(nextSlot-1) do
        if items[i]==data.name and turtle.transferTo(i) and turtle.getItemCount(1)==0 then
            break
        end
    end

    --if doesnt fit into know slots add a new slot
    --throw out if no spaces available
    if nextSlot<17 then
        turtle.transferTo(nextSlot)
        items[nextSlot] = data.name4
        nextSlot = nextSlot+1
    else
        turtle.dropUp()
    end
    return true
end

local function dig()
    if not turtle.dig() then return nil end
    moveItem()
    return true
end

local function digUp()
    if not turtle.digUp() then return nil end
    moveItem()
    return true
end

local function digDown()
    if not turtle.digDown() then return nil end
    moveItem()
    return true
end

local function forward()
    if turtle.detect() then
        if not dig() then return nil end
    end
    if not turtle.forward() then return nil end
    return true
end

local function upward()
    if turtle.detectUp() then
        if not digUp() then return nil end
    end
    if not turtle.up() then return nil end
    return true
end

local function downward()
    if turtle.detect() then
        if not digDown() then return nil end
    end
    if not turtle.down() then return nil end
    return true
end

