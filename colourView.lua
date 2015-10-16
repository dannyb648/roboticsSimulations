if (sim_call_type==sim_childscriptcall_initialization) then 
    -- This is executed exactly once, the first time this script is executed
    ultronBase=simGetObjectAssociatedWithScript(sim_handle_self) -- this is bubbleRob's handle
    -- following is the handle of bubbleRob's associated UI (user interface):
    ctrl=simGetUIHandle("ultronCtrl")
    -- Set the title of the user interface: 
    simSetUIButtonLabel(ctrl,0,simGetObjectName(ultronBase).." speed") 
    leftMotor1=simGetObjectHandle("leftMotor1") -- Handle of the left motor
    leftMotor2=simGetObjectHandle("leftMotor2") -- Handle of the left motor
    leftMotor3=simGetObjectHandle("leftMotor3") -- Handle of the left motor
    rightMotor1=simGetObjectHandle("rightMotor1") -- Handle of the right motor
    rightMotor2=simGetObjectHandle("rightMotor2") -- Handle of the right motor
    rightMotor3=simGetObjectHandle("rightMotor3") -- Handle of the right motor
    noseSensor=simGetObjectHandle("sensingNose") -- Handle of the proximity sensor
	visionSensor = simGetObjectHandle("Vision_sensor") -- Handle of the proximity sensor
	counter = 0
    minMaxSpeed={50*math.pi/180,300*math.pi/180} -- Min and max speeds for each motor
    backUntilTime=-1 -- Tells whether ultron is in forward or backward mode
	
end

if (sim_call_type==sim_childscriptcall_cleanup) then 
 
end 

if (sim_call_type==sim_childscriptcall_sensing) then 

end 

if (sim_call_type==sim_childscriptcall_actuation) then 
    -- Retrieve the desired speed from the user interface: 
    speed=minMaxSpeed[1]+(minMaxSpeed[2]-minMaxSpeed[1])/1000 

    result=simReadProximitySensor(noseSensor) -- Read the proximity sensor
    -- If we detected something, we set the backward mode:
    if (result>0) then 
	backUntilTime=simGetSimulationTime()+5 
	end 

    if (backUntilTime<simGetSimulationTime()) then
        -- When in forward mode, we simply move forward at the desired speed
        simSetJointTargetVelocity(leftMotor1,speed * 8)
        simSetJointTargetVelocity(leftMotor2,speed * 8)
        simSetJointTargetVelocity(leftMotor3,speed * 8)

        simSetJointTargetVelocity(rightMotor1,speed * 8)
        simSetJointTargetVelocity(rightMotor2,speed * 8)
        simSetJointTargetVelocity(rightMotor3,speed * 8)
    else
        -- When in backward mode, we simply backup in a curve at reduced speed
        simSetJointTargetVelocity(leftMotor1,-speed/1.25)
        simSetJointTargetVelocity(leftMotor2,-speed/1.25)
        simSetJointTargetVelocity(leftMotor3,-speed/1.25)

        simSetJointTargetVelocity(rightMotor1,-speed/2)
        simSetJointTargetVelocity(rightMotor2,-speed/2)
        simSetJointTargetVelocity(rightMotor3,-speed/2)

    end	
end
