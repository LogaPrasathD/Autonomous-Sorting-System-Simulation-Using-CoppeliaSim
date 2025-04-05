function sysCall_init()
    sim = require('sim')
    
    -- Get the vision sensor handle
    visionSensorHandle = sim.getObjectHandle('camera')
end

function sysCall_actuation()
    -- Capture image from vision sensor
    local result, resolution, image = sim.getVisionSensorImage(visionSensorHandle)
    
    if result == 1 then  -- If image is successfully captured
        local totalR, totalG, totalB = 0, 0, 0
        local pixelCount = resolution[1] * resolution[2]
        
        for i = 0, pixelCount - 1 do
            local r = image[3 * i + 1]
            local g = image[3 * i + 2]
            local b = image[3 * i + 3]
            totalR = totalR + r
            totalG = totalG + g
            totalB = totalB + b
        end
        
        -- Calculate average color
        avgR = totalR / pixelCount
        avgG = totalG / pixelCount
        avgB = totalB / pixelCount
        
        -- Determine the dominant color
        if avgR > avgG and avgR > avgB then
            detectedColor = 'Red'
        elseif avgG > avgR and avgG > avgB then
            detectedColor = 'Green'
        elseif avgB > avgR and avgB > avgG then
            detectedColor = 'Blue'
        else
            detectedColor = 'Undefined'
        end
        
        print('Detected Color: ' .. detectedColor)
    end
end

function sysCall_sensing()
    -- Can add additional processing if needed
end

function sysCall_cleanup()
    -- Clean-up operations
end
