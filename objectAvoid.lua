if (sim_call_type==sim_childscriptcall_initialization) then 
    -- This is executed exactly once, the first time this script is executed
    bubbleRobBase=simGetObjectAssociatedWithScript(sim_handle_self) -- this is bubbleRob's handle
    -- following is the handle of bubbleRob's associated UI (user interface):
    ctrl=simGetUIHandle("bubbleCtrl")
    -- Set the title of the user interface: 
    simSetUIButtonLabel(ctrl,0,simGetObjectName(bubbleRobBase).." speed") 
    leftMotor=simGetObjectHandle("leftMotor") -- Handle of the left motor
    rightMotor=simGetObjectHandle("rightMotor") -- Handle of the right motor
    noseSensor=simGetObjectHandle("sensingNose") -- Handle of the proximity sensor
    minMaxSpeed={50*math.pi/180,300*math.pi/180} -- Min and max speeds for each motor
    backUntilTime=-1 -- Tells whether bubbleRob is in forward or backward mode
end

if (sim_call_type==sim_childscriptcall_cleanup) then 
 
end 

if (sim_call_type==sim_childscriptcall_sensing) then 

end 

if (sim_call_type==sim_childscriptcall_actuation) then 
    -- Retrieve the desired speed from the user interface: 
    speed=minMaxSpeed[1]+(minMaxSpeed[2]-minMaxSpeed[1])*simGetUISlider(ctrl,3)/1000 

    result=simReadProximitySensor(noseSensor) -- Read the proximity sensor
    -- If we detected something, we set the backward mode:
    if (result>0) then backUntilTime=simGetSimulationTime()+4 end 

    if (backUntilTime<simGetSimulationTime()) then
        -- When in forward mode, we simply move forward at the desired speed
        simSetJointTargetVelocity(leftMotor,speed)
        simSetJointTargetVelocity(rightMotor,speed)
    else
        -- When in backward mode, we simply backup in a curve at reduced speed
        simSetJointTargetVelocity(leftMotor,-speed/2)
        simSetJointTargetVelocity(rightMotor,-speed/8)
    end
end
