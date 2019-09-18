% Codigo de exemplo da comunicacao do MATLAB com o V-REP
% Autor: Filipe Rocha
% COPPE - agosto de 2018
clear all;
close all;
clc;

% Invoca a classe de conexao
VREP=remApi('remoteApi'); 

% Fechando possiveis comunicacoes existentes
VREP.simxFinish(-1);  

% Inicia a conexao
clientID=VREP.simxStart('127.0.0.1',19999,true,true,5000,5);

% Testa se a conexao foi bem sucedida
if clientID <= -1
    error('A conexao com o VREP nao pode ser estabelecida');
else
    disp('V-REP: >> Conexao realizada com sucesso!');
end

% Recebendo os handlers dos necessarios
for i=1:4
    [resp, handle_motor(i)] = VREP.simxGetObjectHandle(clientID,strcat('motor',int2str(i)),VREP.simx_opmode_blocking);
end

% Recebendo handler do robo
[resp,handle_robo] = VREP.simxGetObjectHandle(clientID,'roboBase',VREP.simx_opmode_blocking);

% --Iniciando o streaming das variaveis de interesse

% Orientacao do robo
VREP.simxGetObjectOrientation(clientID,handle_robo,-1,VREP.simx_opmode_streaming);

% Posicao do robo
VREP.simxGetObjectPosition(clientID,handle_robo,-1,VREP.simx_opmode_streaming);

% Pausa para garantir inicializacao
pause(0.5);

% Mensagem para o usuario
disp('V-REP: Handlers devidamente inicializados');

% Criando uma figura para plotar
figure;
hold on;

% Setando velocidade nos motores
[returnCode] = VREP.simxSetJointTargetVelocity(clientID,handle_motor(1), -1, VREP.simx_opmode_blocking);
[returnCode] = VREP.simxSetJointTargetVelocity(clientID,handle_motor(2), -1, VREP.simx_opmode_blocking);
[returnCode] = VREP.simxSetJointTargetVelocity(clientID,handle_motor(3), -2, VREP.simx_opmode_blocking);
[returnCode] = VREP.simxSetJointTargetVelocity(clientID,handle_motor(4), -2, VREP.simx_opmode_blocking);

% Loop para plotar a posicao do robo
i = 1;
pos = [];
tempo = [];
while true
    % Orientacao em angulos de euler
    [resp,eul_ang] = VREP.simxGetObjectOrientation(clientID,handle_robo,-1,VREP.simx_opmode_buffer);
    
    % Vetor de translacao
    [resp,posVREP] = VREP.simxGetObjectPosition(clientID,handle_robo,-1,VREP.simx_opmode_buffer);
    
    %Extraindo a posicao do robo
    pos(1:3,i) = posVREP.';
    
    % Recebe o tempo de simulacao do ultimo comando enviado. Divide
    % por 1000 pois esta em ms.
    tempo(i) = VREP.simxGetLastCmdTime(clientID)/1000;
    
    % Plotando a posicao do robo
    plot(pos(1,i),pos(2,i),'or');
    pause(0.1);
    
    % Incrementando o indice
    i = i+1;
end








