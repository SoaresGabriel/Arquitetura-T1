# Trabalho 1 - Arquitetura de Computadores - UFPB
# Alunos: Gabriel Soares e Luan Lima

.data
request: .asciiz "Digite o valor de max de N: "
preN:    .asciiz "a("
posN:    .asciiz ") = "
endline: .asciiz "\n"

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
      


a:    bgt $a0, 2, else # if n <= 2 
      add $v0, $zero, 1 # a(n) = 1
      jr $ra # retorna com valor 1
# if n > 2
else: addi $sp, $sp, -20 # aloca espaço para 5 itens na pilha
      sw $ra, 16($sp) # salva endereco de retorno na pilha
      sw $s0, 12($sp)
      sw $s1, 8($sp)
      sw $s2, 4($sp)
      sw $a0, 0($sp) # salva argumento na pilha

      move $s0, $a0 # $s0 armazena o valor de n (argumento ao qual a funcao foi chamada)

      # resolve a(n-1)
      addi $a0, $a0, -1 # $a0 = n-1
      jal a
      move $s1, $v0 # $s1 = a(n-1)

      # resolve a(n-a(n-1))
      sub $a0, $s0, $s1 # $a0 = n-a(n-1)
      jal a
      move $s1, $v0 # $s1 = a(n-a(n-1))

      # resolve a(n-2)
      addi $a0, $s0, -2 # $a0 = n-2
      jal a
      move $s2, $v0 # $s2 = a(n-2)

      # resolve a(n-a(n-2))
      sub $a0, $s0, $s2 # $a0 = n-a(n-2)
      jal a
      move $s2, $v0 # $s2 = a(n-a(n-2))

      add $v0, $s1, $s2 # a(n) = a(n-a(n-1)) + a(n-a(n-2))

      # restaura pilha e retorna
      lw $a0, 0($sp) # restaura valor do resgistrador a0
      lw $s2, 4($sp)
      lw $s1, 8($sp)
      lw $s0, 12($sp)
      lw $ra, 16($sp) # restaura valor do registrador de retorno
      addi $sp, $sp, 20 # restaura pointeiro da pilha
      jr $ra
