-- For ROS teleoperation, consider ros-<$ROS_DISTRO>-key-teleop package for control
-- https://github.com/ros-teleop/teleop_tools
-- rosrun key_teleop key_teleop.py

function sysCall_init()
   
    -- Pegando o handler do robo
    robotHandle = sim.getObjectAssociatedWithScript(sim.handle_self)

    -- Pegando o handler dos motores
    mot = {}
    for i=1,4 do
        mot[i] = sim.getObjectHandle("motor"..i)
    end

    -- Iniciando a API de comunicacao com o MATLAB
     simRemoteApi.start(19999)

    -- Inicializando a conexao com o ROS
    moduleName=0
    moduleVersion=0
    index=0
    pluginNotFound=true
    while moduleName do
        moduleName,moduleVersion=sim.getModuleName(index)
        if (moduleName=='RosInterface') then
            pluginNotFound=false
        end
        index=index+1
    end

    -- chamando inicializacao
    if (not pluginNotFound) then
        local sysTime=sim.getSystemTimeInMs(-1) 
        local MotorSpeedTopicName='velMotores' -- we add a random component so that we can have several instances of this robot running
       
        pubPosicao = simROS.advertise('/roboPosicao','geometry_msgs/Point')
        subComandoVel = simROS.subscribe('/key_vel','geometry_msgs/Twist','setMotorsVelocity_cb')

    end


    print("=== Inicializacao pronta. Iniciando atuacao ===")

end

function sysCall_actuation()

    -- Obtem a posicao do robo
        getPos = {}
        getPos = sim.getObjectPosition(robotHandle, -1)

    -- Publica a posicao do robo
        tabela_pos = {}
        tabela_pos["x"] = getPos[1]
        tabela_pos["y"] = getPos[2]
        tabela_pos["z"] = getPos[3]

        simROS.publish(pubPosicao, tabela_pos)

end

function sysCall_sensing()
    -- put your sensing code here
end

function sysCall_cleanup()
    -- do some clean-up here
end

-- Callback do ROS
function setMotorsVelocity_cb(msg)
    
    -- matematica de padaria para setar as velocidades dos motores
    vel_left = 3 * (0.6 * -msg.linear.x - 0.4 * msg.angular.z) 
    vel_right = 3 * (0.6 * -msg.linear.x + 0.4 * msg.angular.z)

    -- setando as velocidades dos motores
    sim.setJointTargetVelocity(mot[1],vel_right)
    sim.setJointTargetVelocity(mot[2],vel_right)
    sim.setJointTargetVelocity(mot[3],vel_left)
    sim.setJointTargetVelocity(mot[4],vel_left)

end

-- You can define additional system calls here:
--[[
function sysCall_suspend()
end

function sysCall_resume()
end

function sysCall_jointCallback(inData)
    return outData
end

function sysCall_contactCallback(inData)
    return outData
end

function sysCall_beforeCopy(inData)
    for key,value in pairs(inData.objectHandles) do
        print("Object with handle "..key.." will be copied")
    end
end

function sysCall_afterCopy(inData)
    for key,value in pairs(inData.objectHandles) do
        print("Object with handle "..key.." was copied")
    end
end

function sysCall_beforeDelete(inData)
    for key,value in pairs(inData.objectHandles) do
        print("Object with handle "..key.." will be deleted")
    end
    -- inData.allObjects indicates if all objects in the scene will be deleted
end

function sysCall_afterDelete(inData)
    for key,value in pairs(inData.objectHandles) do
        print("Object with handle "..key.." was deleted")
    end
    -- inData.allObjects indicates if all objects in the scene were deleted
end
--]]