.data

formatScanW: .asciz "%hu"
formatScanL: .asciz "%ld"
formatScanS: .asciz "%s"
formatPrintX: .asciz "%X"
formatPrint0X: .asciz "02x"
formatPrintN: .asciz "\n"
formatHexa: .asciz "ab"
formatScanD: .asciz "%d"


.bss
aux: .long 0
parola: .asciz "\0\0\0\0\0\0\0\0\0\0"
cript: .asciz "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
mat1: .space 400
mat2: .space 400
m: .word 0
n: .word 0
p: .long 0
i: .long 0
j: .long 0
k: .word 0
o: .word 0
len: .long 0
lencript: .long 0

.text

.global main
main:

    pushl $m
    pushl $formatScanW
    call scanf
    add $8, %esp

    pushl $n
    pushl $formatScanW
    call scanf
    add $8, %esp

    pushl $p
    pushl $formatScanL
    call scanf
    add $8, %esp

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
        call scanf
        add $8, %esp
        mov i, %eax
        add $1, %eax
        mov %eax, i

        pushl $j    
        pushl $formatScanL
        call scanf
        add $8, %esp
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
    call scanf
    add $8, %esp

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

    xor %eax, %eax
    xor %ebx, %ebx
    movw n, %ax
    add $1, %eax
    movw m, %bx
    add $1, %ebx
    mulw %bx
    xor %ecx, %ecx
    lea mat2, %esi
    lea mat1, %edi
    matrice_extinsa:
        push %eax

        movb (%esi), %bl
        movb %bl, (%edi)
        add $1, %edi
        add $1, %esi

        mov %ecx, %eax
        push %ecx
        xor %ecx, %ecx
        movw n, %cx
        add $1, %ecx
        xor %edx, %edx
        div %ecx
        cmpw n, %dx
        jne next
            movb $0, (%edi)
            add $1, %edi
        next:

        pop %ecx
        add $1, %ecx
        pop %eax
        cmp %ecx, %eax  
    jne matrice_extinsa
    
    pushl $o
    pushl $formatScanW
    call scanf
    add $8, %esp

    xor %eax, %eax
    movw o, %ax
    cmp $0, %eax
    je criptare
        decriptare:

        push $cript
        push $formatScanS
        call scanf
        add $8, %esp
        
        push $cript
        call strlen
        add $4, %esp
        sub $2, %eax
        mov %eax, lencript
        mov $2, %ecx
        xor %edx, %edx
        div %ecx

        lea cript, %esi
        add $2, %esi
        lea parola, %edi
        xor %ecx, %ecx
        char_hex:
            movw (%esi), %bx
            movw %bx, formatHexa
            push %ecx
            push %eax
            movl $0, aux
            push $aux
            push $formatPrintX
            push $formatHexa
            call sscanf
            add $12, %esp
            pop %eax
            char:
            mov aux, %ebx
            movb %bl, (%edi)
            add $1, %edi
            add $2, %esi


            pop %ecx
            add $1, %ecx
            cmp %ecx, %eax
        jne char_hex
        test_hex:

        push $parola
        call strlen
        add $4, %esp
        mov $8, %ecx
        mul %ecx
        mov %eax, len
        mov %eax, %ebx
        test_strlen:
        movw m, %ax
        movw n, %cx
        addw $2, %cx
        addw $2, %ax
        mulw %cx
        cmp %eax, %ebx

        jle if_lungimeparola1

            lea mat1, %esi
            mov %esi, %edi
            add %eax, %edi
            mov %ebx, %ecx
            sub %eax, %ecx
            rep movsb

        if_lungimeparola1:

        lea mat1, %esi
        lea parola, %edi
        mov $0, %ecx
        push %dx
        decriptarexor:

            mov %ecx, %eax
            push %ecx
            mov $8, %ecx
            xor %edx, %edx
            div %ecx
            pop %ecx
            cmp $0, %edx
            jne sfarsit_byte1
                movb (%edi, %eax), %dl
                xor %ebx, %ebx
                add $2, %esp
                push %dx
            sfarsit_byte1:

            pop %dx
            shl $1, %edx
            xorb (%esi, %ecx), %dh
            shl $1, %ebx    
            addb %dh, %bl
            xorb %dh, %dh
            push %dx

            mov %ecx, %eax
            push %ecx
            mov $8, %ecx
            xor %edx, %edx
            div %ecx
            pop %ecx
            cmp $7, %edx
            jne in_byte1
                movb %bl, (%edi, %eax)
            in_byte1:

            add $1, %ecx
            cmp %ecx, len
        jne decriptarexor
        test_decript:
        push $parola
        push $formatScanS
        call printf
        add $8, %esp

        push $0
        call fflush
        add $4, %esp

        push $formatPrintN
        call printf
        add $4, %esp

        push $0
        call fflush
        add $4, %esp

        jmp exit
    criptare:

        push $parola
        push $formatScanS
        call scanf
        add $8, %esp

        push $parola
        call strlen
        add $4, %esp
        mov $8, %ecx
        mul %ecx
        mov %eax, len
        mov %eax, %ebx
    
        movw m, %ax
        movw n, %cx
        addw $2, %cx
        addw $2, %ax
        mulw %cx
        cmp %eax, %ebx
        jle if_lungimeparola

            lea mat1, %esi
            mov %esi, %edi
            add %eax, %edi
            mov %ebx, %ecx
            sub %eax, %ecx
            rep movsb

        if_lungimeparola:

        lea mat1, %esi
        lea parola, %edi
        mov $0, %ecx
        push %dx
        criptarexor:

            mov %ecx, %eax
            push %ecx
            mov $8, %ecx
            xor %edx, %edx
            div %ecx
            pop %ecx
            cmp $0, %edx
            jne sfarsit_byte
                movb (%edi, %eax), %dl
                xor %ebx, %ebx
                add $2, %esp
                push %dx
            sfarsit_byte:

            pop %dx
            shl $1, %edx
            xorb (%esi, %ecx), %dh
            shl $1, %ebx    
            addb %dh, %bl
            xorb %dh, %dh
            push %dx

            mov %ecx, %eax
            push %ecx
            mov $8, %ecx
            xor %edx, %edx
            div %ecx
            pop %ecx
            cmp $7, %edx
            jne in_byte
                movb %bl, (%edi, %eax)
            in_byte:

            add $1, %ecx
            cmp %ecx, len
        jne criptarexor

        push $formatPrint0X
        call printf
        add $4, %esp

        push $0
        call fflush
        add $4, %esp

        mov len, %eax
        mov $8, %ecx
        xor %edx, %edx
        div %ecx
        mov %eax, %edi
        xor %ebx, %ebx
        lea parola, %esi
        xor %ecx, %ecx
        afisare_criptat:
            push %ecx

            movb (%esi), %bl
            push %ebx
            push $formatPrintX
            call printf
            add $8, %esp
            push $0
            call fflush
            add $4, %esp

            pop %ecx
            add $1, %esi
            add $1, %ecx
        cmp %ecx, %edi
        jne afisare_criptat

    push $formatPrintN
    call printf
    add $4, %esp
    push $0
    call fflush
    add $4, %esp

exit:
mov $1, %eax
mov $0, %ebx
int $0x80
