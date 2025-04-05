sim = require 'sim'

-- Function to move UR3 to target joint configuration
function moveToConfig(handles, maxVel, maxAccel, maxJerk, targetConf)
    local params = {
        joints = handles,
        targetPos = targetConf,
        maxVel = maxVel,
        maxAccel = maxAccel,
        maxJerk = maxJerk,
    }
    sim.moveToConfig(params)
end

-- Function to detect object and get its position
function detectObjectPosition()
    local proximitySensor = sim.getObject('/proximitySensor') -- Ensure correct name
    local detected, objectHandle = sim.readProximitySensor(proximitySensor)

    if detected == 1 then
        local objectPos = {-0.025, -1.19511, 0.170} -- Manually set coordinates
        print("? Detected Object at: x =", objectPos[1], "y =", objectPos[2], "z =", objectPos[3])
        return objectHandle, objectPos
    end

    print("? No object detected")
    return -1, nil
end

function sysCall_init()
    sim = require('sim')
    visionSensorHandle = sim.getObjectHandle('camera')
end

function detectColor()
    local result, packet1, packet2 = sim.readVisionSensor(visionSensorHandle)
        avg_red = packet1[12]
        avg_green = packet1[13]
        avg_blue = packet1[14]
        print(avg_red, avg_green, avg_blue)

        if avg_red > avg_green and avg_red > avg_blue then
            detectedColor = 'Red'
        elseif avg_green > avg_red and avg_green > avg_blue then
            detectedColor = 'Green'
        elseif avg_blue > avg_red and avg_blue > avg_green then
            detectedColor = 'Blue'
        else
            detectedColor = 'Undefined'
        end

        print('Detected Color: ' .. detectedColor)
        sim.setStringSignal("CuboidColor", detectedColor)
end

-- Main thread
function sysCall_thread()
    local jointHandles = {}
    for i = 1, 6 do
        jointHandles[i] = sim.getObject('../joint', { index = i - 1 })
    end

    local vel, accel, jerk = 40, 30, 60
    local maxVel = {vel, vel, vel, vel, vel, vel}
    local maxAccel = {accel, accel, accel, accel, accel, accel}
    local maxJerk = {jerk, jerk, jerk, jerk, jerk, jerk}

    local positions = {
        binRed = {math.rad(90), math.rad(-50), math.rad(-10), math.rad(-20), math.rad(90), math.rad(0)},
        binGreen = {math.rad(-05), math.rad(63), math.rad(-20), math.rad(30), math.rad(-80), math.rad(0)},
        binBlue = {math.rad(-90), math.rad(-50), math.rad(-10), math.rad(-10), math.rad(90), math.rad(0)},
        inter1 = {math.rad(0), math.rad(-45), math.rad(-20), math.rad(-20), math.rad(100), math.rad(0)},
        inter2 = {math.rad(0), math.rad(-45), math.rad(-20), math.rad(-20), math.rad(100), math.rad(0)},
        inter3 = {math.rad(0), math.rad(-40), math.rad(-20), math.rad(-20), math.rad(100), math.rad(0)},
        home = {math.rad(0), math.rad(0), math.rad(0), math.rad(0), math.rad(0), math.rad(0)}
    }

    while true do
        local detectedObject, objectPosition = detectObjectPosition()

        if detectedObject == -1 then
            print("?? No object found. Returning home.")
            moveToConfig(jointHandles, maxVel, maxAccel, maxJerk, positions.home)
            sim.wait(2)
            goto continue
        end

        detectColor() -- Detect color only if an object is found
        
        if detectedColor == 'Undefined' then 
            local pickPosition = {math.rad(0), math.rad(0), math.rad(0), math.rad(0), math.rad(0), math.rad(0)}
            sim.wait(2)
        else
            local pickPosition = {math.rad(0), math.rad(-58), math.rad(-20), math.rad(-20), math.rad(100), math.rad(0)}
            print("?? Moving to pick position at: x = -0.025, y = -1.19511, z = 0.170")
            moveToConfig(jointHandles, maxVel, maxAccel, maxJerk, pickPosition)
            sim.wait(2)
        end

        local detectedColor = sim.getStringSignal("CuboidColor")
        print("?? Detected Object Color:", detectedColor)

        local assignedBin = "Unknown"
        if detectedColor == "Red" then
            assignedBin = {"inter1", "binRed"}
        elseif detectedColor == "Green" then
            assignedBin = {"inter2","binGreen"}
        elseif detectedColor == "Blue" then
            assignedBin = {"inter3", "binBlue"}
        end

        for _, bin in ipairs(assignedBin) do
            print("?? Moving to:", bin)
            moveToConfig(jointHandles, maxVel, maxAccel, maxJerk, positions[bin])
            sim.wait(2)
        end

        print("?? Returning to home position")
        moveToConfig(jointHandles, maxVel, maxAccel, maxJerk, positions.home)
        sim.wait(2)

        ::continue::
    end
end
