
#ifndef SUNDIALS_EXPORT_H
#define SUNDIALS_EXPORT_H

//added to export symbols for Windows
#ifdef _MSC_VER
#ifdef PATCHED_SUNDIALS_EXPORTS
/* We are building this library */
#define SUNDIALS_EXPORT __declspec(dllexport)
#else
/* We are using this library */
#define SUNDIALS_EXPORT __declspec(dllimport)
#endif
#define SUNDIALS_NO_EXPORT
#define SUNDIALS_DEPRECATED __declspec(deprecated)
#else
#define SUNDIALS_EXPORT __attribute__((visibility("default")))
#define SUNDIALS_NO_EXPORT __attribute__((visibility("hidden")))
#define SUNDIALS_DEPRECATED __attribute__ ((__deprecated__))
#endif /* _MSC_VER */

#ifndef SUNDIALS_DEPRECATED_EXPORT
#  define SUNDIALS_DEPRECATED_EXPORT SUNDIALS_EXPORT SUNDIALS_DEPRECATED
#endif

#ifndef SUNDIALS_DEPRECATED_NO_EXPORT
#  define SUNDIALS_DEPRECATED_NO_EXPORT SUNDIALS_NO_EXPORT SUNDIALS_DEPRECATED
#endif

/* NOLINTNEXTLINE(readability-avoid-unconditional-preprocessor-if) */
#if 0 /* DEFINE_NO_DEPRECATED */
#  ifndef SUNDIALS_NO_DEPRECATED
#    define SUNDIALS_NO_DEPRECATED
#  endif
#endif

#endif /* SUNDIALS_EXPORT_H */
