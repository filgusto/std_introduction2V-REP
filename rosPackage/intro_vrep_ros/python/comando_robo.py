#!/usr/bin/env python

import rospy
from sensor_msgs.msg import Joy

def comando_robo():
	
	# Cria o publisher
	pub = rospy.Publisher('roboComandoVelocidade', Joy, queue_size=10)
	
	# Inicia o no
	rospy.init_node('comando_robo', anonymous=True)

	# Frequencia de envio dos comandos
	rate = rospy.Rate(10)

	# Loop inifinito para envio do comando
	while not rospy.is_shutdown():

		# Valores a serem enviados
		vel_left = 1
		vel_right = 2

		# montando o array com as velocidades para os quatro motores
		velocidades = [vel_left, vel_left, vel_right, vel_right]
		
		# Monta a mensagem a ser enviada
		mensagem=Joy()
		mensagem.axes = velocidades

		# Publica no no
		pub.publish(mensagem)

		# Envia uma mensagem ao usuario
		rospy.loginfo('Vel L: '+str(vel_left)+'  Vel R: '+str(vel_right))


		# Pausa o codigo pelo tempo especificado
		rate.sleep()



# Chama o no
if __name__ == '__main__':
	try:
		comando_robo()
	except	rospy.ROSInterruptException:
		pass




