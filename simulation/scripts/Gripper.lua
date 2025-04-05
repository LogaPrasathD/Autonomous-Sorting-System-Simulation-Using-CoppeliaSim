sim = require 'sim'

function sysCall_init() 
    s = sim.getObject('../Sensor')
    l = sim.getObject('../LoopClosureDummy1')
    l2 = sim.getObject('../LoopClosureDummy2')
    b = sim.getObject('..')
    suctionPadLink = sim.getObject('../Link')

    infiniteStrength = true
    maxPullForce = 3
    maxShearForce = 1
    maxPeelTorque = 0.1
    enabled = true

    sim.setLinkDummy(l, -1)
    sim.setObjectParent(l, b, true)
    m = sim.getObjectMatrix(l2)
    sim.setObjectMatrix(l, m)

    suctionStartTime = nil  -- Timer variable
end

function sysCall_cleanup() 
    sim.setLinkDummy(l, -1)
    sim.setObjectParent(l, b, true)
    m = sim.getObjectMatrix(l2)
    sim.setObjectMatrix(l, m)
end 

function sysCall_sensing() 
    parent = sim.getObjectParent(l)

    if not enabled then
        if parent ~= b then
            sim.setLinkDummy(l, -1)
            sim.setObjectParent(l, b, true)
            m = sim.getObjectMatrix(l2)
            sim.setObjectMatrix(l, m)
        end
    else
        if parent == b then
            -- Detect and attach object
            index = 0
            while true do
                shape = sim.getObjects(index, sim.sceneobject_shape)
                if shape == -1 then break end
                if shape ~= b and sim.getBoolProperty(shape, 'respondable') and sim.checkProximitySensor(s, shape) == 1 then
                    sim.setObjectParent(l, b, true)
                    m = sim.getObjectMatrix(l2)
                    sim.setObjectMatrix(l, m)
                    sim.setObjectParent(l, shape, true)
                    sim.setLinkDummy(l, l2)

                    -- Start the timer when object is attached
                    suctionStartTime = sim.getSimulationTime()

                    break
                end
                index = index + 1
            end
        else
            -- Handle force breaking conditions
            if infiniteStrength == false then
                result, force, torque = sim.readForceSensor(suctionPadLink)
                if result > 0 then
                    breakIt = false
                    if force[3] > maxPullForce then breakIt = true end
                    sf = math.sqrt(force[1]^2 + force[2]^2)
                    if sf > maxShearForce then breakIt = true end
                    if torque[1] > maxPeelTorque then breakIt = true end
                    if torque[2] > maxPeelTorque then breakIt = true end
                    if breakIt then
                        releaseObject()
                    end
                end
            end

            -- **Stop suction after 3 seconds**
            if suctionStartTime and (sim.getSimulationTime() - suctionStartTime) >= 6 then
                releaseObject()
            end
        end
    end
end

-- Function to release the object
function releaseObject()
    sim.setLinkDummy(l, -1)
    sim.setObjectParent(l, b, true)
    m = sim.getObjectMatrix(l2)
    sim.setObjectMatrix(l, m)
    suctionStartTime = nil  -- Reset timer
end
