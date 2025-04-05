-- Get the handle for the proximity sensor
local sensorHandle
local detectionStartTime = nil
local spawnDelay = 15.0  -- Seconds

function sysCall_init()
    sensorHandle = sim.getObjectHandle('sensor2')  -- Replace with your sensor name
    prevDetection = false
end

-- 6-color cycle: 3 non-RGB, then 3 RGB
colors = {
    {1, 1, 0},  -- Yellow
    {0, 1, 1},  -- Cyan
    {1, 0, 1},  -- Magenta
    {1, 0, 0},  -- Red
    {0, 1, 0},  -- Green
    {0, 0, 1}   -- Blue
}
colorIndex = 1

-- Function to create and color a cube
function createCube(color)
    local size = {0.1, 0.1, 0.1}
    local position = {0.5, -2.0, 0.08}
    local options = 0
    local operation = 8
    local mass = 0.1

    local cube = sim.createPureShape(options, operation, size, mass, nil)
    sim.setObjectPosition(cube, -1, position)
    sim.setShapeColor(cube, nil, sim.colorcomponent_ambient_diffuse, color)

    local specialProps = sim.objectspecialproperty_collidable +
                         sim.objectspecialproperty_detectable_ultrasonic +
                         sim.objectspecialproperty_measurable
    sim.setObjectSpecialProperty(cube, specialProps)

    return cube
end

function sysCall_actuation()
    local detected, _, _, _, _ = sim.readProximitySensor(sensorHandle)
    local currentTime = sim.getSimulationTime()

    if detected then
        if detectionStartTime == nil then
            detectionStartTime = currentTime  -- Start timing
        elseif currentTime - detectionStartTime >= spawnDelay then
            -- 3 seconds of continuous detection ? spawn cube
            createCube(colors[colorIndex])
            colorIndex = colorIndex + 1
            if colorIndex > #colors then
                colorIndex = 1
            end
            detectionStartTime = nil  -- Reset timer after spawn
        end
    else
        detectionStartTime = nil  -- Reset timer if detection is lost
    end
end
