; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+sse2 | FileCheck %s --check-prefixes=SSE,SSE2
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+sse4.2 | FileCheck %s --check-prefixes=SSE,SSE42
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx | FileCheck %s --check-prefixes=AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx2 | FileCheck %s --check-prefixes=AVX,AVX2,AVX2-SLOW
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx2,+fast-variable-shuffle | FileCheck %s --check-prefixes=AVX,AVX2,AVX2-FAST
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx512f | FileCheck %s --check-prefixes=AVX512,AVX512-SLOW
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx512f,+fast-variable-shuffle | FileCheck %s --check-prefixes=AVX512,AVX512-FAST
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+xop | FileCheck %s --check-prefixes=AVX,XOP

define void @insert_v7i8_v2i16_2(<7 x i8> *%a0, <2 x i16> *%a1) nounwind {
; SSE2-LABEL: insert_v7i8_v2i16_2:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; SSE2-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1],xmm1[0,3]
; SSE2-NEXT:    shufps {{.*#+}} xmm0 = xmm0[2,0,1,3]
; SSE2-NEXT:    movaps {{.*#+}} xmm1 = [255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0]
; SSE2-NEXT:    andps %xmm0, %xmm1
; SSE2-NEXT:    packuswb %xmm1, %xmm1
; SSE2-NEXT:    movaps %xmm0, -{{[0-9]+}}(%rsp)
; SSE2-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; SSE2-NEXT:    movb %al, 6(%rdi)
; SSE2-NEXT:    movd %xmm1, (%rdi)
; SSE2-NEXT:    pextrw $2, %xmm1, %eax
; SSE2-NEXT:    movw %ax, 4(%rdi)
; SSE2-NEXT:    retq
;
; SSE42-LABEL: insert_v7i8_v2i16_2:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE42-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE42-NEXT:    pmovzxbw {{.*#+}} xmm2 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; SSE42-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[3],zero,zero,zero
; SSE42-NEXT:    pblendw {{.*#+}} xmm0 = xmm2[0,1],xmm0[2,3,4,5],xmm2[6,7]
; SSE42-NEXT:    packuswb %xmm0, %xmm0
; SSE42-NEXT:    pextrb $6, %xmm1, 6(%rdi)
; SSE42-NEXT:    pextrw $2, %xmm0, 4(%rdi)
; SSE42-NEXT:    movd %xmm0, (%rdi)
; SSE42-NEXT:    retq
;
; AVX1-LABEL: insert_v7i8_v2i16_2:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX1-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX1-NEXT:    vpmovzxbw {{.*#+}} xmm2 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; AVX1-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[3],zero,zero,zero
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm2[0,1],xmm0[2,3,4,5],xmm2[6,7]
; AVX1-NEXT:    vpackuswb %xmm0, %xmm0, %xmm0
; AVX1-NEXT:    vpextrb $6, %xmm1, 6(%rdi)
; AVX1-NEXT:    vpextrw $2, %xmm0, 4(%rdi)
; AVX1-NEXT:    vmovd %xmm0, (%rdi)
; AVX1-NEXT:    retq
;
; AVX2-LABEL: insert_v7i8_v2i16_2:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX2-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX2-NEXT:    vpmovzxbw {{.*#+}} xmm2 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; AVX2-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[3],zero,zero,zero
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm2[0],xmm0[1,2],xmm2[3]
; AVX2-NEXT:    vpackuswb %xmm0, %xmm0, %xmm0
; AVX2-NEXT:    vpextrb $6, %xmm1, 6(%rdi)
; AVX2-NEXT:    vpextrw $2, %xmm0, 4(%rdi)
; AVX2-NEXT:    vmovd %xmm0, (%rdi)
; AVX2-NEXT:    retq
;
; AVX512-LABEL: insert_v7i8_v2i16_2:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX512-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX512-NEXT:    vpmovzxbw {{.*#+}} xmm2 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; AVX512-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[3],zero,zero,zero
; AVX512-NEXT:    vpblendd {{.*#+}} xmm0 = xmm2[0],xmm0[1,2],xmm2[3]
; AVX512-NEXT:    vpackuswb %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vpextrb $6, %xmm1, 6(%rdi)
; AVX512-NEXT:    vpextrw $2, %xmm0, 4(%rdi)
; AVX512-NEXT:    vmovd %xmm0, (%rdi)
; AVX512-NEXT:    retq
;
; XOP-LABEL: insert_v7i8_v2i16_2:
; XOP:       # %bb.0:
; XOP-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; XOP-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; XOP-NEXT:    vpextrb $6, %xmm1, 6(%rdi)
; XOP-NEXT:    insertq {{.*#+}} xmm1 = xmm1[0,1],xmm0[0,1,2,3],xmm1[6,7,u,u,u,u,u,u,u,u]
; XOP-NEXT:    vpextrw $1, %xmm0, 4(%rdi)
; XOP-NEXT:    vmovd %xmm1, (%rdi)
; XOP-NEXT:    retq
  %1 = load <2 x i16>, <2 x i16> *%a1
  %2 = bitcast <2 x i16> %1 to <4 x i8>
  %3 = shufflevector <4 x i8> %2, <4 x i8> undef, <7 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef>
  %4 = load <7 x i8>, <7 x i8> *%a0
  %5 = shufflevector <7 x i8> %4, <7 x i8> %3, <7 x i32> <i32 0, i32 1, i32 7, i32 8, i32 9, i32 10, i32 6>
  store <7 x i8> %5, <7 x i8>* %a0
  ret void
}

%struct.Mat4 = type { %struct.storage }
%struct.storage = type { [16 x float] }

define void @PR40815(%struct.Mat4* nocapture readonly dereferenceable(64), %struct.Mat4* nocapture dereferenceable(64)) {
; SSE-LABEL: PR40815:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps (%rdi), %xmm0
; SSE-NEXT:    movaps 16(%rdi), %xmm1
; SSE-NEXT:    movaps 32(%rdi), %xmm2
; SSE-NEXT:    movaps 48(%rdi), %xmm3
; SSE-NEXT:    movaps %xmm3, (%rsi)
; SSE-NEXT:    movaps %xmm2, 16(%rsi)
; SSE-NEXT:    movaps %xmm1, 32(%rsi)
; SSE-NEXT:    movaps %xmm0, 48(%rsi)
; SSE-NEXT:    retq
;
; AVX-LABEL: PR40815:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps (%rdi), %xmm0
; AVX-NEXT:    vmovaps 16(%rdi), %xmm1
; AVX-NEXT:    vmovaps 32(%rdi), %xmm2
; AVX-NEXT:    vmovaps 48(%rdi), %xmm3
; AVX-NEXT:    vmovaps %xmm2, 16(%rsi)
; AVX-NEXT:    vmovaps %xmm3, (%rsi)
; AVX-NEXT:    vmovaps %xmm0, 48(%rsi)
; AVX-NEXT:    vmovaps %xmm1, 32(%rsi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: PR40815:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovaps 16(%rdi), %xmm0
; AVX512-NEXT:    vmovaps 48(%rdi), %xmm1
; AVX512-NEXT:    vinsertf128 $1, (%rdi), %ymm0, %ymm0
; AVX512-NEXT:    vinsertf128 $1, 32(%rdi), %ymm1, %ymm1
; AVX512-NEXT:    vinsertf64x4 $1, %ymm0, %zmm1, %zmm0
; AVX512-NEXT:    vmovups %zmm0, (%rsi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
  %3 = bitcast %struct.Mat4* %0 to <16 x float>*
  %4 = load <16 x float>, <16 x float>* %3, align 64
  %5 = shufflevector <16 x float> %4, <16 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %6 = getelementptr inbounds %struct.Mat4, %struct.Mat4* %1, i64 0, i32 0, i32 0, i64 4
  %7 = bitcast <16 x float> %4 to <4 x i128>
  %8 = extractelement <4 x i128> %7, i32 1
  %9 = getelementptr inbounds %struct.Mat4, %struct.Mat4* %1, i64 0, i32 0, i32 0, i64 8
  %10 = bitcast <16 x float> %4 to <4 x i128>
  %11 = extractelement <4 x i128> %10, i32 2
  %12 = getelementptr inbounds %struct.Mat4, %struct.Mat4* %1, i64 0, i32 0, i32 0, i64 12
  %13 = bitcast float* %12 to <4 x float>*
  %14 = bitcast <16 x float> %4 to <4 x i128>
  %15 = extractelement <4 x i128> %14, i32 3
  %16 = bitcast %struct.Mat4* %1 to i128*
  store i128 %15, i128* %16, align 16
  %17 = bitcast float* %6 to i128*
  store i128 %11, i128* %17, align 16
  %18 = bitcast float* %9 to i128*
  store i128 %8, i128* %18, align 16
  store <4 x float> %5, <4 x float>* %13, align 16
  ret void
}

define <16 x i32> @PR42819(<8 x i32>* %a0) {
; SSE-LABEL: PR42819:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqu (%rdi), %xmm3
; SSE-NEXT:    pslldq {{.*#+}} xmm3 = zero,zero,zero,zero,xmm3[0,1,2,3,4,5,6,7,8,9,10,11]
; SSE-NEXT:    xorps %xmm0, %xmm0
; SSE-NEXT:    xorps %xmm1, %xmm1
; SSE-NEXT:    xorps %xmm2, %xmm2
; SSE-NEXT:    retq
;
; AVX-LABEL: PR42819:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = mem[0,0,1,2]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vblendps {{.*#+}} ymm1 = ymm1[0,1,2,3,4],ymm0[5,6,7]
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: PR42819:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmovdqu (%rdi), %xmm0
; AVX512-NEXT:    movw $-8192, %ax # imm = 0xE000
; AVX512-NEXT:    kmovw %eax, %k1
; AVX512-NEXT:    vpexpandd %zmm0, %zmm0 {%k1} {z}
; AVX512-NEXT:    retq
  %1 = load <8 x i32>, <8 x i32>* %a0, align 4
  %2 = shufflevector <8 x i32> %1, <8 x i32> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %3 = shufflevector <16 x i32> zeroinitializer, <16 x i32> %2, <16 x i32> <i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18>
  ret <16 x i32> %3
}
