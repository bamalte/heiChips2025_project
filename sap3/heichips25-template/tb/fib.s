mvi a, $0
out
mvi a, $1
out
mvi a, $0
mvi b, $1
mvi c, $12
mvi d, $1

loop:
add b
mov b, d
dcr c
mov d, a
out
jz done 
jmp loop

done:
hlt