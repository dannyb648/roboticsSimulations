simSetThreadSwitchTiming(2) -- Default timing for automatic thread switching
simDelegateChildScriptExecution()

lm=simGetObjectHandle('left_motor')
rm=simGetObjectHandle('right_motor')

pos_on_path = 0
robot_handle = simGetObjectHandle('Vehicle')
path_plan_handle = simGetPathPlanningHandle('PathPlanningTask')
planState = simSearchPath(path_plan_handle,105)
dis = 0
start_dummy_handle = simGetObjectHandle('Start')

while (simGetSimulationState()~=sim_simulation_advancing_abouttostop) do
	

	rob_pos = simGetObjectPosition(robot_handle,-1)
	path_pos = simGetPositionOnPath(path_handle, pos_on_path)
	simSetObjectPosition(start_dummy_handle, -1, path_pos)
	m = simGetObjectMatrix(robot_handle,-1)
	m = simGetInvertedMatrix(m)
	
	path_pos = simMultiplyVector(m,path_pos)
	dis = math.sqrt((path_pos[1])^2 + (path_pos[2])^ 2)
	phi = math.atan2(path_pos[2],path_pos[1])
	v_des = 0.8
	om_des = 6.4 * phi

	d = 0.06 -- wheel seperation
	v_r = (v_des + d * om_des)
	v_l = (v_des - d * om_des)
	
	r_w = 0.0275 -- wheel radius
	omega_right = v_r / r_w
	omega_left = v_l / r_w

	simSetJoinTargetVelocity(rm,-omega_right)
	simSetJoinTargetVelocity(lm,-omega_left)

end
