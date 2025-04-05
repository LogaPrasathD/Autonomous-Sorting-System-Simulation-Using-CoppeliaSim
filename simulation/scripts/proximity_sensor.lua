sim = require 'sim'

function sysCall_init()
    -- Get the handle of the proximity sensor using the correct path
    proximitySensor = sim.getObject("/proximitySensor")  -- Update with the correct path
    
    -- Get the handle of the conveyor (adjust the path if needed)
    conveyorHandle = sim.getObject("/conveyorSystem")  

    -- Initially start the conveyor
    sim.setBufferProperty(conveyorHandle, 'customData.__ctrl__', sim.packTable({vel=0.1}))
    
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
end

function sysCall_sensing()
    -- Read proximity sensor state
    local detected = sim.readProximitySensor(proximitySensor)
    
    if detected > 0 then
    
            detectColor()
        -- Stop conveyor when object is detected
            if detectedColor == 'Undefined' then
                sim.setBufferProperty(conveyorHandle, 'customData.__ctrl__', sim.packTable({vel=0.1}))
                print("starting conveyor")
            else
                sim.setBufferProperty(conveyorHandle, 'customData.__ctrl__', sim.packTable({vel=0}))
                print("stopping conveyor")
            end
    else
        -- Start conveyor when no object is detected
        sim.setBufferProperty(conveyorHandle, 'customData.__ctrl__', sim.packTable({vel=0.1}))
        print("starting conveyor")
    end
end