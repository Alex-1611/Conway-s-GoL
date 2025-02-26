.bss
m: .word 0
n: .word 0
p: .long 0
k: .word 0
i: .long 0
j: .long 0
mat1: .space 400 #matrice curenta
mat2: .space 400 #matrice anterioara

.data
formatScanW: .asciz "%hu"
formatScanL: .asciz "%ld"
formatPrintW: .asciz "%hu "
formatPrintENDL: .asciz "\n"
fopenR: .asciz "r"
fopenW: .asciz "w"
filenameR: .asciz "in.txt"
filenameW: .asciz "out.txt"

.text
.global main

main:

    push $fopenR
    push $filenameR
    call fopen
    mov %eax, %esi
    add $8, %esp
    
    pushl $m
    pushl $formatScanW
    pushl %esi
    call fscanf
    add $12, %esp

    pushl $n
    pushl $formatScanW
    pushl %esi
    call fscanf
    add $12, %esp

    pushl $p
    pushl $formatScanL
    pushl %esi
    call fscanf
    add $12, %esp

    xor %ecx, %ecx
    lea mat1, %eax
    lea mat2, %ebx

    initializare_matrice:
        movl $0, (%eax, %ecx, 4)
        movl $0, (%ebx, %ecx, 4)
        add $1, %ecx
        cmp $100, %ecx
    jne initializare_matrice
    
    mov p, %ecx
    cmp $0, %ecx
    je matrice0
    citire_celule:
        pushl %ecx

        pushl $i
        pushl $formatScanL
        pushl %esi
        call fscanf
        add $12, %esp
        mov i, %eax
        add $1, %eax
        mov %eax, i

        pushl $j    
        pushl $formatScanL
        pushl %esi
        call fscanf
        add $12, %esp
        mov j, %eax
        add $1, %eax
        mov %eax, j

        xor %eax, %eax
        movw n, %ax
        add $1, %eax
        mul i
        add j, %eax
        movb $1, (%ebx, %eax)

        pop %ecx
        subl $1, %ecx
    jnz citire_celule
    matrice0:

    pushl $k
    pushl $formatScanW
    pushl %esi
    call fscanf
    add $12, %esp

    push %esi
    call fclose
    pop %eax

    xor %ecx, %ecx
    cmp p, %ecx
    je matrice0evolutii
    movw k, %cx
    cmp $0, %ecx
    je matrice0evolutii
    pasi_evolutie:
        push %ecx
        mov $mat2, %esi
        mov $mat1, %edi
        mov $1, %ecx
        loopI_evolutie:
            mov %ecx, i
            push %ecx
            mov $1, %ecx
            loopJ_evolutie:
                mov %ecx, j
                push %ecx

                xor %ecx, %ecx
                xor %eax, %eax
                movw n, %ax
                add $1, %eax
                mov i, %edx
                sub $1, %edx
                mul %edx
                add j, %eax
                sub $1, %eax
                addb (%esi, %eax), %cl
                addb 1(%esi, %eax), %cl
                addb 2(%esi, %eax), %cl

                xor %eax, %eax
                movw n, %ax
                add $1, %eax
                mov i, %edx
                add $1, %edx
                mul %edx
                add j, %eax
                sub $1, %eax
                addb (%esi, %eax), %cl
                addb 1(%esi, %eax), %cl
                addb 2(%esi, %eax), %cl

                xor %eax, %eax
                movw n, %ax
                add $1, %eax
                mul i
                add j, %eax
                sub $1, %eax
                addb (%esi, %eax), %cl
                addb 2(%esi, %eax), %cl
                test_eax:
                add $1, %eax
                cmpb $0, (%esi, %eax)
                je if_celulacurenta

                    cmpb $2, %cl
                    je celula1
                    cmpb $3, %cl
                    je celula1
                    jmp celula0

                if_celulacurenta:

                    cmpb $3, %cl
                    je celula1
                    jmp celula0
            
                celula1:
                    movb $1, (%edi, %eax)
                    jmp endif_celulacurenta
                celula0:
                    movb $0, (%edi, %eax)
                endif_celulacurenta:

                pop %ecx
                add $1, %ecx
                cmpw n, %cx
            jle loopJ_evolutie
            pop %ecx
            add $1, %ecx
            cmpw m, %cx
        jle loopI_evolutie
        test:
        lea mat1, %esi
        lea mat2, %edi
        mov $400, %ecx
        rep movsb
        
        pop %ecx
        sub $1, %ecx
    jnz pasi_evolutie

    matrice0evolutii:

    push $fopenW
    push $filenameW
    call fopen
    add $8, %esp
    mov %eax, %edi

    xor %ebx, %ebx
    xor %ecx, %ecx
    movw m, %cx
    movw n, %bx
    add $1, %ebx
    lea mat2, %esi
    afisareI:

        push %ecx
        movw n, %cx
        sub $1, %ecx
        jz J1
        afisareJ:
            push %ecx

            add $1, %ebx
            xor %eax, %eax
            movb (%esi, %ebx), %al
            pushw %ax
            pushl $formatPrintW
            pushl %edi
            call fprintf
            add $10, %esp

            pushl $0
            call fflush
            popl %edx

            pop %ecx
            sub $1, %ecx
        jnz afisareJ
        J1:

        add $1, %ebx
        xor %eax, %eax
        movb (%esi, %ebx), %al
        pushw %ax
        pushl $formatPrintW 
        pushl %edi
        call fprintf
        add $10, %esp

        push $formatPrintENDL
        push %edi
        call fprintf
        add $8, %esp

        pushl $0
        call fflush
        popl %edx

        add $1, %ebx

        pop %ecx
        sub $1, %ecx
    jnz afisareI

    push %edi
    call fclose
    pop %eax

exit:
mov $1, %eax
mov $0, %ebx
int $0x80



