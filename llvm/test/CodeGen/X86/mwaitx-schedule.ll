; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=x86-64 -mattr=+mwaitx | FileCheck %s --check-prefix=GENERIC
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=bdver4 | FileCheck %s --check-prefix=BDVER4
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=znver1 | FileCheck %s --check-prefix=ZNVER1

define void @foo(i8* %P, i32 %E, i32 %H) nounwind {
; GENERIC-LABEL: foo:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    movl %esi, %ecx # sched: [1:0.33]
; GENERIC-NEXT:    leaq (%rdi), %rax # sched: [1:0.50]
; GENERIC-NEXT:    monitorx # sched: [100:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER4-LABEL: foo:
; BDVER4:       # %bb.0:
; BDVER4-NEXT:    movl %esi, %ecx
; BDVER4-NEXT:    leaq (%rdi), %rax
; BDVER4-NEXT:    monitorx
; BDVER4-NEXT:    retq
;
; ZNVER1-LABEL: foo:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    movl %esi, %ecx # sched: [1:0.25]
; ZNVER1-NEXT:    leaq (%rdi), %rax # sched: [1:0.25]
; ZNVER1-NEXT:    monitorx # sched: [100:0.25]
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  tail call void @llvm.x86.monitorx(i8* %P, i32 %E, i32 %H)
  ret void
}
declare void @llvm.x86.monitorx(i8*, i32, i32) nounwind

define void @bar(i32 %E, i32 %H, i32 %C) nounwind {
; GENERIC-LABEL: bar:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    pushq %rbx # sched: [5:1.00]
; GENERIC-NEXT:    movl %edx, %ebx # sched: [1:0.33]
; GENERIC-NEXT:    movl %esi, %eax # sched: [1:0.33]
; GENERIC-NEXT:    movl %edi, %ecx # sched: [1:0.33]
; GENERIC-NEXT:    mwaitx # sched: [100:0.33]
; GENERIC-NEXT:    popq %rbx # sched: [6:0.50]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BDVER4-LABEL: bar:
; BDVER4:       # %bb.0:
; BDVER4-NEXT:    pushq %rbx
; BDVER4-NEXT:    movl %edx, %ebx
; BDVER4-NEXT:    movl %esi, %eax
; BDVER4-NEXT:    movl %edi, %ecx
; BDVER4-NEXT:    mwaitx
; BDVER4-NEXT:    popq %rbx
; BDVER4-NEXT:    retq
;
; ZNVER1-LABEL: bar:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    pushq %rbx # sched: [1:0.50]
; ZNVER1-NEXT:    movl %edx, %ebx # sched: [1:0.25]
; ZNVER1-NEXT:    movl %esi, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    movl %edi, %ecx # sched: [1:0.25]
; ZNVER1-NEXT:    mwaitx # sched: [100:0.25]
; ZNVER1-NEXT:    popq %rbx # sched: [8:0.50]
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  tail call void @llvm.x86.mwaitx(i32 %E, i32 %H, i32 %C)
  ret void
}
declare void @llvm.x86.mwaitx(i32, i32, i32) nounwind