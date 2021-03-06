; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; Check the libcall and the intrinsic for each case with differing FMF.

; The transform to sqrt is allowed as long as we deal with -0.0 and -INF.

define double @pow_libcall_half_no_FMF(double %x) {
; CHECK-LABEL: @pow_libcall_half_no_FMF(
; CHECK-NEXT:    [[SQRT:%.*]] = call double @sqrt(double [[X:%.*]])
; CHECK-NEXT:    [[ABS:%.*]] = call double @llvm.fabs.f64(double [[SQRT]])
; CHECK-NEXT:    [[ISINF:%.*]] = fcmp oeq double [[X]], 0xFFF0000000000000
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[ISINF]], double 0x7FF0000000000000, double [[ABS]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %pow = call double @pow(double %x, double 5.0e-01)
  ret double %pow
}

define double @pow_intrinsic_half_no_FMF(double %x) {
; CHECK-LABEL: @pow_intrinsic_half_no_FMF(
; CHECK-NEXT:    [[SQRT:%.*]] = call double @sqrt(double [[X:%.*]]) #1
; CHECK-NEXT:    [[ABS:%.*]] = call double @llvm.fabs.f64(double [[SQRT]])
; CHECK-NEXT:    [[ISINF:%.*]] = fcmp oeq double [[X]], 0xFFF0000000000000
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[ISINF]], double 0x7FF0000000000000, double [[ABS]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %pow = call double @llvm.pow.f64(double %x, double 5.0e-01)
  ret double %pow
}

; This makes no difference, but FMF are propagated.

define double @pow_libcall_half_approx(double %x) {
; CHECK-LABEL: @pow_libcall_half_approx(
; CHECK-NEXT:    [[SQRT:%.*]] = call afn double @sqrt(double [[X:%.*]])
; CHECK-NEXT:    [[ABS:%.*]] = call afn double @llvm.fabs.f64(double [[SQRT]])
; CHECK-NEXT:    [[ISINF:%.*]] = fcmp afn oeq double [[X]], 0xFFF0000000000000
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[ISINF]], double 0x7FF0000000000000, double [[ABS]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %pow = call afn double @pow(double %x, double 5.0e-01)
  ret double %pow
}

; FIXME

define <2 x double> @pow_intrinsic_half_approx(<2 x double> %x) {
; CHECK-LABEL: @pow_intrinsic_half_approx(
; CHECK-NEXT:    [[POW:%.*]] = call afn <2 x double> @llvm.pow.v2f64(<2 x double> [[X:%.*]], <2 x double> <double 5.000000e-01, double 5.000000e-01>)
; CHECK-NEXT:    ret <2 x double> [[POW]]
;
  %pow = call afn <2 x double> @llvm.pow.v2f64(<2 x double> %x, <2 x double> <double 5.0e-01, double 5.0e-01>)
  ret <2 x double> %pow
}

; FIXME:
; If we can disregard INFs, no need for a select.

define double @pow_libcall_half_ninf(double %x) {
; CHECK-LABEL: @pow_libcall_half_ninf(
; CHECK-NEXT:    [[SQRT:%.*]] = call ninf double @sqrt(double [[X:%.*]])
; CHECK-NEXT:    [[ABS:%.*]] = call ninf double @llvm.fabs.f64(double [[SQRT]])
; CHECK-NEXT:    [[ISINF:%.*]] = fcmp ninf oeq double [[X]], 0xFFF0000000000000
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[ISINF]], double 0x7FF0000000000000, double [[ABS]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %pow = call ninf double @pow(double %x, double 5.0e-01)
  ret double %pow
}

; FIXME:

define <2 x double> @pow_intrinsic_half_ninf(<2 x double> %x) {
; CHECK-LABEL: @pow_intrinsic_half_ninf(
; CHECK-NEXT:    [[POW:%.*]] = call ninf <2 x double> @llvm.pow.v2f64(<2 x double> [[X:%.*]], <2 x double> <double 5.000000e-01, double 5.000000e-01>)
; CHECK-NEXT:    ret <2 x double> [[POW]]
;
  %pow = call ninf <2 x double> @llvm.pow.v2f64(<2 x double> %x, <2 x double> <double 5.0e-01, double 5.0e-01>)
  ret <2 x double> %pow
}

; FIXME:
; If we can disregard -0.0, no need for fabs.

define double @pow_libcall_half_nsz(double %x) {
; CHECK-LABEL: @pow_libcall_half_nsz(
; CHECK-NEXT:    [[SQRT:%.*]] = call nsz double @sqrt(double [[X:%.*]])
; CHECK-NEXT:    [[ABS:%.*]] = call nsz double @llvm.fabs.f64(double [[SQRT]])
; CHECK-NEXT:    [[ISINF:%.*]] = fcmp nsz oeq double [[X]], 0xFFF0000000000000
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[ISINF]], double 0x7FF0000000000000, double [[ABS]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %pow = call nsz double @pow(double %x, double 5.0e-01)
  ret double %pow
}

; FIXME:

define double @pow_intrinsic_half_nsz(double %x) {
; CHECK-LABEL: @pow_intrinsic_half_nsz(
; CHECK-NEXT:    [[SQRT:%.*]] = call nsz double @sqrt(double [[X:%.*]]) #1
; CHECK-NEXT:    [[ABS:%.*]] = call nsz double @llvm.fabs.f64(double [[SQRT]])
; CHECK-NEXT:    [[ISINF:%.*]] = fcmp nsz oeq double [[X]], 0xFFF0000000000000
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[ISINF]], double 0x7FF0000000000000, double [[ABS]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %pow = call nsz double @llvm.pow.f64(double %x, double 5.0e-01)
  ret double %pow
}

; FIXME:
; This is just sqrt.

define float @pow_libcall_half_ninf_nsz(float %x) {
; CHECK-LABEL: @pow_libcall_half_ninf_nsz(
; CHECK-NEXT:    [[SQRTF:%.*]] = call ninf nsz float @sqrtf(float [[X:%.*]])
; CHECK-NEXT:    [[ABS:%.*]] = call ninf nsz float @llvm.fabs.f32(float [[SQRTF]])
; CHECK-NEXT:    [[ISINF:%.*]] = fcmp ninf nsz oeq float [[X]], 0xFFF0000000000000
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[ISINF]], float 0x7FF0000000000000, float [[ABS]]
; CHECK-NEXT:    ret float [[TMP1]]
;
  %pow = call ninf nsz float @powf(float %x, float 5.0e-01)
  ret float %pow
}

; FIXME:

define double @pow_intrinsic_half_ninf_nsz(double %x) {
; CHECK-LABEL: @pow_intrinsic_half_ninf_nsz(
; CHECK-NEXT:    [[SQRT:%.*]] = call ninf nsz double @sqrt(double [[X:%.*]]) #1
; CHECK-NEXT:    [[ABS:%.*]] = call ninf nsz double @llvm.fabs.f64(double [[SQRT]])
; CHECK-NEXT:    [[ISINF:%.*]] = fcmp ninf nsz oeq double [[X]], 0xFFF0000000000000
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[ISINF]], double 0x7FF0000000000000, double [[ABS]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %pow = call ninf nsz double @llvm.pow.f64(double %x, double 5.0e-01)
  ret double %pow
}

; Overspecified FMF to test propagation to the new op(s).

define float @pow_libcall_half_fast(float %x) {
; CHECK-LABEL: @pow_libcall_half_fast(
; CHECK-NEXT:    [[SQRTF:%.*]] = call fast float @sqrtf(float [[X:%.*]])
; CHECK-NEXT:    ret float [[SQRTF]]
;
  %pow = call fast float @powf(float %x, float 5.0e-01)
  ret float %pow
}

define double @pow_intrinsic_half_fast(double %x) {
; CHECK-LABEL: @pow_intrinsic_half_fast(
; CHECK-NEXT:    [[TMP1:%.*]] = call fast double @llvm.sqrt.f64(double [[X:%.*]])
; CHECK-NEXT:    ret double [[TMP1]]
;
  %pow = call fast double @llvm.pow.f64(double %x, double 5.0e-01)
  ret double %pow
}

; FIXME:
; -0.5 means take the reciprocal.

define float @pow_libcall_neghalf_no_FMF(float %x) {
; CHECK-LABEL: @pow_libcall_neghalf_no_FMF(
; CHECK-NEXT:    [[POW:%.*]] = call float @powf(float [[X:%.*]], float -5.000000e-01)
; CHECK-NEXT:    ret float [[POW]]
;
  %pow = call float @powf(float %x, float -5.0e-01)
  ret float %pow
}

; FIXME:

define <2 x double> @pow_intrinsic_neghalf_no_FMF(<2 x double> %x) {
; CHECK-LABEL: @pow_intrinsic_neghalf_no_FMF(
; CHECK-NEXT:    [[POW:%.*]] = call <2 x double> @llvm.pow.v2f64(<2 x double> [[X:%.*]], <2 x double> <double -5.000000e-01, double -5.000000e-01>)
; CHECK-NEXT:    ret <2 x double> [[POW]]
;
  %pow = call <2 x double> @llvm.pow.v2f64(<2 x double> %x, <2 x double> <double -5.0e-01, double -5.0e-01>)
  ret <2 x double> %pow
}

; FIXME:
; If we can disregard INFs, no need for a select.

define double @pow_libcall_neghalf_ninf(double %x) {
; CHECK-LABEL: @pow_libcall_neghalf_ninf(
; CHECK-NEXT:    [[POW:%.*]] = call ninf double @pow(double [[X:%.*]], double -5.000000e-01)
; CHECK-NEXT:    ret double [[POW]]
;
  %pow = call ninf double @pow(double %x, double -5.0e-01)
  ret double %pow
}

; FIXME:

define <2 x double> @pow_intrinsic_neghalf_ninf(<2 x double> %x) {
; CHECK-LABEL: @pow_intrinsic_neghalf_ninf(
; CHECK-NEXT:    [[POW:%.*]] = call ninf <2 x double> @llvm.pow.v2f64(<2 x double> [[X:%.*]], <2 x double> <double -5.000000e-01, double -5.000000e-01>)
; CHECK-NEXT:    ret <2 x double> [[POW]]
;
  %pow = call ninf <2 x double> @llvm.pow.v2f64(<2 x double> %x, <2 x double> <double -5.0e-01, double -5.0e-01>)
  ret <2 x double> %pow
}

; FIXME:
; If we can disregard -0.0, no need for fabs.

define double @pow_libcall_neghalf_nsz(double %x) {
; CHECK-LABEL: @pow_libcall_neghalf_nsz(
; CHECK-NEXT:    [[POW:%.*]] = call nsz double @pow(double [[X:%.*]], double -5.000000e-01)
; CHECK-NEXT:    ret double [[POW]]
;
  %pow = call nsz double @pow(double %x, double -5.0e-01)
  ret double %pow
}

; FIXME:

define double @pow_intrinsic_neghalf_nsz(double %x) {
; CHECK-LABEL: @pow_intrinsic_neghalf_nsz(
; CHECK-NEXT:    [[POW:%.*]] = call nsz double @llvm.pow.f64(double [[X:%.*]], double -5.000000e-01)
; CHECK-NEXT:    ret double [[POW]]
;
  %pow = call nsz double @llvm.pow.f64(double %x, double -5.0e-01)
  ret double %pow
}

; FIXME:
; This is just recip-sqrt.

define double @pow_intrinsic_neghalf_ninf_nsz(double %x) {
; CHECK-LABEL: @pow_intrinsic_neghalf_ninf_nsz(
; CHECK-NEXT:    [[POW:%.*]] = call ninf nsz double @llvm.pow.f64(double [[X:%.*]], double -5.000000e-01)
; CHECK-NEXT:    ret double [[POW]]
;
  %pow = call ninf nsz double @llvm.pow.f64(double %x, double -5.0e-01)
  ret double %pow
}

; FIXME:

define float @pow_libcall_neghalf_ninf_nsz(float %x) {
; CHECK-LABEL: @pow_libcall_neghalf_ninf_nsz(
; CHECK-NEXT:    [[POW:%.*]] = call ninf nsz float @powf(float [[X:%.*]], float -5.000000e-01)
; CHECK-NEXT:    ret float [[POW]]
;
  %pow = call ninf nsz float @powf(float %x, float -5.0e-01)
  ret float %pow
}

; Overspecified FMF to test propagation to the new op(s).

define float @pow_libcall_neghalf_fast(float %x) {
; CHECK-LABEL: @pow_libcall_neghalf_fast(
; CHECK-NEXT:    [[SQRTF:%.*]] = call fast float @sqrtf(float [[X:%.*]])
; CHECK-NEXT:    [[RECIPROCAL:%.*]] = fdiv fast float 1.000000e+00, [[SQRTF]]
; CHECK-NEXT:    ret float [[RECIPROCAL]]
;
  %pow = call fast float @powf(float %x, float -5.0e-01)
  ret float %pow
}

define double @pow_intrinsic_neghalf_fast(double %x) {
; CHECK-LABEL: @pow_intrinsic_neghalf_fast(
; CHECK-NEXT:    [[TMP1:%.*]] = call fast double @llvm.sqrt.f64(double [[X:%.*]])
; CHECK-NEXT:    [[RECIPROCAL:%.*]] = fdiv fast double 1.000000e+00, [[TMP1]]
; CHECK-NEXT:    ret double [[RECIPROCAL]]
;
  %pow = call fast double @llvm.pow.f64(double %x, double -5.0e-01)
  ret double %pow
}

declare double @llvm.pow.f64(double, double) #0
declare <2 x double> @llvm.pow.v2f64(<2 x double>, <2 x double>) #0
declare double @pow(double, double)
declare float @powf(float, float)

attributes #0 = { nounwind readnone speculatable }
attributes #1 = { nounwind readnone }

