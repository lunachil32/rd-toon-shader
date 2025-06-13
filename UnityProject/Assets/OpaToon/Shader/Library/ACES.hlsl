#ifndef ACES_INCLUDED
#define ACES_INCLUDED

float RRTAndODTFit(float x)
{
    float a = 2.51;
    float b = 0.03;
    float c = 2.43;
    float d = 0.59;
    float e = 0.14;
    return saturate((x * (a * x + b)) / (x * (c * x + d) + e));
}

float InverseACES(float rowValue)
{
    float result = rowValue;
    for (int i = 0; i < 5; ++i)
    {
        float fx = RRTAndODTFit(result) - rowValue;
        float dfdx = (RRTAndODTFit(result + 0.01) - RRTAndODTFit(result - 0.01)) / 0.02;

        result -= fx / max(dfdx, 1e-6);
    }
    return result;
}

float3 InverseACES(float3 rowValue)
{
    rowValue.x = InverseACES(rowValue.x);
    rowValue.y = InverseACES(rowValue.y);
    rowValue.z = InverseACES(rowValue.z);
    return rowValue;
}

#endif