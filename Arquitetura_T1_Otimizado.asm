# Versão não recursiva com memoria da função
# Muito mais eficiente, pois não recalcula o que já foi calculado antes

.data
request: .asciiz "Digite o valor de max de N: "
preN:    .asciiz "a("
posN:    .asciiz ") = "
endline: .asciiz "\n"
result: .space 101

.text
.globl main

main: la $a0, request
      li $v0, 4
      syscall # print string pedindo N 
      
      li $s1, 1 # $s1 = 1
      li $v0, 5 
      syscall # ler n
      move $s0, $v0 # $s0 = n
      
loop: bgt, $s1, $s0, exit # if $s1 <= n ... else exit
      
      # resolve a(n)
      move $a0, $s1
      jal a
      move $s2, $v0 # $s2 = a(n)
      
      # print "a("
      la $a0, preN
      li $v0, 4
      syscall
      
      #print current n
      move $a0, $s1
      li $v0, 1
      syscall
      
      #print ") = "
      la $a0, posN
      li $v0, 4
      syscall
      
      #print a(n)
      move $a0, $s2
      li $v0, 1
      syscall
      
      #print endline
      la $a0, endline
      li $v0, 4
      syscall
      
      addi $s1, $s1, 1 # $s1++
      j loop
      
exit: li $v0, 10
      syscall
      
# parametro recebido $a0 = n
a:    la $t0, result # $t0 = &result[0]
      bgt $a0, 2, else # if n <= 2
      sll $t1, $a0, 2 # $t1 = n*4
      add $t1, $t1, $t0 # $t1 = &result[n]
      li $v0, 1 # a(n) = 1
      sb $v0, 0($t1) # result[n] = 1
      jr $ra # retorna com valor 1
      
# if n > 2
      # resolve a(n-1)
else: addi $t1, $a0, -1 # $t1 = n-1
      sll $t1, $t1, 2 # $t1 = (n-1)*4
      add $t1, $t1, $t0 # $t1 = &result[n-1]
      lb $t1, 0($t1) # t1 = result[n-1] = a(n-1)

      # resolve a(n-a(n-1))
      sub $t2, $a0, $t1 # $t2 = n-a(n-1)
      sll $t2, $t2, 2 # $t2 = (n-a(n-1))*4
      add $t2, $t2, $t0 # $t2 = &result[n-a(n-1)]
      lb $t1, 0($t2) # $t1 = result[n-a(n-1)] = a(n-a(n-1))

      # resolve a(n-2)
      addi $t2, $a0, -2 # $t2 = n-2
      sll $t2, $t2, 2 # $t2 = (n-2)*4
      add $t2, $t2, $t0 # $t2 = &result[n-2]
      lb $t2, 0($t2) # $t2 = result[n-2] = a(n-2)

      # resolve a(n-a(n-2))
      sub $t3, $a0, $t2 # $t3 = n-a(n-2)
      sll $t3, $t3, 2 # $t3 = (n-a(n-2))*4
      add $t3, $t3, $t0 # $t3 = &result[n-a(n-2)]
      lb $t2, 0($t3) # $t3 = result[n-a(n-1)] = a(n-a(n-1))

      add $v0, $t1, $t2 # $v0 = a(n) = a(n-a(n-1)) + a(n-a(n-2))
      
      # armazena a(n) em result[n]
      sll $t3, $a0, 2 # $t3 = n*4
      add $t3, $t3, $t0, # $t3 = &result[n]
      sb $v0, 0($t3) # result[n] = a(n)

      jr $ra
