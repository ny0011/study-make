#include <stdio.h>

#include <add.h>
#ifdef CONFIG_SUB
#include <sub.h>
#endif
#ifdef CONFIG_MUL
#include <mul.h>
int internalMul(int a, int b)
{
    return a * b;
}
#endif

int (*pfnAdd)(int, int);
#ifdef CONFIG_SUB
int (*pfnSub)(int, int);
#endif
#ifdef CONFIG_MUL
#if (CONFIG_MUL == EXT)
int (*pfnMul)(int, int);
#else
int (*pfnInternalMul)(int, int);
#endif
#endif

int main(void)
{
    pfnAdd = add;
    printf("pfnAdd = %p\n", pfnAdd);
#ifdef CONFIG_SUB
    pfnSub = sub;
    printf("pfnSub = %p\n", pfnSub);
#endif

#ifdef CONFIG_MUL
#if (CONFIG_MUL == EXT)
    pfnMul = mul;
    printf("pfnMul = %p\n", pfnMul);
#else
    pfnInternalMul = internalMul;
    printf("pfnInternalMul = %p\n", pfnInternalMul);
#endif
#endif
    return 0;
}
