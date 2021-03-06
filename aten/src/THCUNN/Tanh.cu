#include "THCUNN.h"
#include "TH/THHalf.h"
#include "THCHalfAutoNumerics.cuh"
#include <THC/THCApply.cuh>

template <typename T>
struct tanh_updateGradInput_functor
{
  __device__ __forceinline__ void operator()(T *gradInput,
          const T *output, const T *gradOutput) const {
    *gradInput = *gradOutput * (1.f - *output * *output);
  }
};

template <>
struct tanh_updateGradInput_functor<half>
{
  __device__ __forceinline__ void operator()(half *gradInput,
          const half *output, const half *gradOutput) const {
    const float out = __half2float(*output);
    const float go = __half2float(*gradOutput);
    *gradInput = __float2half(go * (1.f - out * out));
  }
};

#include "generic/Tanh.cu"
#include "THCGenerateFloatTypes.h"
