#define abc

#ifdef abc

println 123

#else

println 456

#endif

#undef abc

#ifdef abc

println 123

#else

println 456

#endif

