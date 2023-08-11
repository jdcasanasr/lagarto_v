#Codigo Burbuja
#Ordenamiento de n�meros

#Carga de datos
.text
li t0, 30
li t1, 15
li t2, 20
li t3, 7
li t4, 31
li t5, 3
li t6, 10

#Almacenar datos
sw t0, 0(x0)
sw t1, 4(x0)
sw t2, 8(x0)
sw t3, 12(x0)
sw t4, 16(x0)
sw t5, 20(x0)
sw t6, 24(x0)

#C�digo C => ensamblador
addi s0, x0, 0	#i = 0
addi s1, x0, 6	#n = 6    limite

for_i:
addi s2, x0, 0 #j = 0
for_j:
slli t0, s2, 2 #offset j
addi t1, t0, 4 #offser j + 1
lw   t2, 0(t0)
lw   t3, 0(t1)
slt  t4, t3, t2
beq  t4, x0, fin_if
sw   t3, 0(t0)
sw   t2, 0(t1)
fin_if:
addi s2, s2, 1	  #j = j + 1
bne  s2, s1, for_j
addi s0, s0, 1    #i = i + 1
bne  s0, s1, for_i
